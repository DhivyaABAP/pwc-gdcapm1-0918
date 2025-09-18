
/* namespace gdcapm1.potypedef;
 
// Reusable Types
type guid : String(32);
type name : String(80);
type street : String(50);
type landmark : String(50);
 
// Reusable Aspect - Structure(contains group of fields)
aspect Address {
    street : street;
    landmark : landmark;
    country : String(2);
    city : String(50);
} */
 
// purchaseorder --> Business Patner --> Address  , items --> Product
 
/* Master data
    Business Partner
    Address
    Product
    Employee
   Transactional data
    Purchase Order
    Purchase Items
 */
 
//
 
namespace gdcapm1.potypedef;
using { Currency } from '@sap/cds/common';
 
 
 
// Reusable Types
type Guid        : String(32);
type phoneNumber : String(30);
type Email       : String(255);
 
// Enumerator
type Gender      : String(1) enum {
    male = 'M';
    female = 'F';
    undisclosed = 'U'
}
 
// Providing SAP Unit for the Reuse Type
type AmountT : Decimal(10,2)@(
    Semantics.amount.currencyCode : 'CURRENCY_CODE',
    sap.unit: 'CURRENCY_CODE'
);
 
// Reusable Aspects - Asepcts
aspect Amount : {
    CURRENCY : Currency;
    GROSS_AMOUNT : AmountT  @(title: '{i18n>GROSS_AMOUNT}');
    NET_AMOUNT : AmountT    @(title: '{i18n>NET_AMOUNT}');
    TAX_AMOUNT : AmountT    @(title: '{i18n>TAX_AMOUNT}');
}
// Reusable Aspects - Address
aspect Addresss : {
    street : Guid;
    landmark : String(40);
    city : Guid;
    country : String(2);
}
 


