namespace gdcapm1.cdsview;
 
using { gdcapm1.db.master, gdcapm1.db.transaction } from './datamodel';
 
context CDSViews {
   
    define view ![PurchaseOrderWorklist] as
        select from transaction.purchaseorder {
            key PO_ID as ![PurchaseOrderID],
            key Items.PO_ITEMS_POS as ![PurchaseItems],
            PARTNER_GUID.BP_ID as ![BusinessPartnerID],
            PARTNER_GUID.COMPNAY_NAME as ![CompanyName],
            GROSS_AMOUNT as ![GrossAmount],
            NET_AMOUNT as ![NetAmount],
            TAX_AMOUNT as ![TaxAmount],
            CURRENCY as ![Currency],
            LIFECYCLE_STATUS as ![LifecycleStatus],
            OVERALL_STATUS as ![OverallStatus],
            Items.PRODUCT_GUID.PRODUCT_ID as ![ProdcutID],
            Items.PRODUCT_GUID.DESCRIPTION as ![Description],
            PARTNER_GUID.ADDRESS_GUID.CITY as ![City],
            PARTNER_GUID.ADDRESS_GUID.COUNTRY as ![Country]
        }
   
    define view ![PurchaseItemView] as  
        select from transaction.purchaseitems {
            PARENT_KEY.PARTNER_GUID.NODE_KEY as ![CustomerKey],
            PRODUCT_GUID.NODE_KEY as ![ProductKey],
            CURRENCY as ![CurrencyCode],
            GROSS_AMOUNT as ![GrossAmount],
            NET_AMOUNT as ![NetAmount],
            TAX_AMOUNT as ![TaxAmount],
            PARENT_KEY.OVERALL_STATUS as ![Status]
        }
 
    define view ProductView as
        select from master.product
        // Mixin is a keyword which is to define the loose coupling
        // Items --> Loaded on demand
        mixin {
            PO_ITEM : Association[*] to PurchaseItemView on PO_ITEM.ProductKey = $projection.ProductKey
        } into {
            NODE_KEY as ![ProductKey],
            DESCRIPTION as ![Description],
            CATEGORY as ![Category],
            PRICE as ![Price],
            SUPPLIER_GUID.BP_ID as ![BusinessPartnerID],
            SUPPLIER_GUID.COMPNAY_NAME as ![CompnayName],
            SUPPLIER_GUID.ADDRESS_GUID.CITY as ![City],
            SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as ![Country],
            // Exposed association, at runtime in odata.s
            // Dependent data
            PO_ITEM as ![To_Items]
        }

          define view PruchaseAmountSum as
        select from ProductView {
            ProductKey,
            Country,
            round(sum(To_Items.GrossAmount),2) as ![TotalPurchaseAmount] : Decimal(10,2),
            To_Items.CurrencyCode as ![CurrencyCode]
        } group by ProductKey, Country, To_Items.CurrencyCode
 
}
