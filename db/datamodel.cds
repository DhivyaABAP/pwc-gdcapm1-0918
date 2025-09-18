/*
namespace gdcapm1.db;  //<appname>.db
using { Country, managed} from '@sap/cds/common';

context school {
    //Entity name should be unique and should have an Key field
    entity student: managed  {
        key id : String(32);
        name : String(80);
        age : Int16;        
        class: Association to one class;  //Association to another entity
        country: Country
    }
    entity class  {  
        key id: String(32);
        classname: String(80);
        teacher: String(80);
        
    }
}
*/


/*namespace pocapapp.db;
//namespace <Company Name>.<Functional Team>.<Application name>.db
 
// Step-1 : Declare resue types here
using { managed } from '@sap/cds/common';
using { pocapapp.common as common  } from './common';
 
 
context school {
// 1. Each entity should have a unique name.
// 2. Each entity should have a primary key.
 
    // Create a db table - CDS ===> SQL Code
    // Actual Table : POCAPAPP_DB_SCHOOL_STUDENT
    // Foreign Key : CLASS_ID
    entity student : managed, common.Address {
        key id : common.guid;
        name : common.name;
        age : Int16;
        class: Association to one class; // One-to-One association between Student and Class entities
    }
 
    entity class : managed, common.Address{
        key id : common.guid;
        className : common.name;
        teacher : String(80);
    }
}*/
 
namespace gdcapm1.db;
using { gdcapm1.potypedef as c } from './potypedef';
using { cuid, Currency } from '@sap/cds/common';
 
 
context master {
    entity businesspartner {
        key NODE_KEY : c.Guid   @(title: '{i18n>NODE_KEY}');
        BP_ROLE : String(2)     @(title: '{i18n>BP_ROLE}');
        EMAIL : c.Email         @(title: '{i18n>EMAIL}');
        MOBILE : c.phoneNumber  @(title: '{i18n>MOBILE}');
        FAX : String(32)        @(title: '{i18n>FAX}');
        WEB : String(111)       @(title: '{i18n>WEB}');
        BP_ID : String(32)      @(title: '{i18n>BP_ID}');
        COMPNAY_NAME : String(250)  @(title: '{i18n>COMPNAY_NAME}');
        ADDRESS_GUID : Association to address   @(title: '{i18n>ADDRESS_GUID}');
    }
 
    entity address {
        key NODE_KEY : c.Guid   @(title: '{i18n>NODE_KEY}');
        CITY : String(111)      @(title: '{i18n>CITY}');
        POSTAL : String(12)     @(title: '{i18n>POSTAL}');
        BUILDING : String(111)  @(title: '{i18n>BUILDING}');
        STREET : String(44)     @(title: '{i18n>STREET}');
        COUNTRY : String(44)    @(title: '{i18n>COUNTRY}');
        ADDRESS_TYPE : String(44)   @(title: '{i18n>ADDRESS_TYPE}');
        VAL_START : Date        @(title: '{i18n>VAL_START}');
        VAL_END : Date          @(title: '{i18n>VAL_END}');
        LATITUDE : Decimal      @(title: '{i18n>LATITUDE}');
        LONGITUDE : Decimal     @(title: '{i18n>LONGITUDE}');
        // Unmanaged Association - Need to add condition externally
        businesspartner : Association to one master.businesspartner
                            on businesspartner.ADDRESS_GUID = $self;
    }
 
    entity product {
        key NODE_KEY  : c.Guid      @(title: '{i18n>NODE_KEY}');
        PRODUCT_ID : String(28)     @(title: '{i18n>PRODUCT_ID}');
        TYPE_CODE : String(2)       @(title: '{i18n>TYPE_CODE}');
        CATEGORY : String(32)       @(title: '{i18n>CATEGORY}');
        DESCRIPTION : String(255)   @(title: '{i18n>DESCRIPTION}');
        TAX_TARIF_CODE : Integer    @(title: '{i18n>TAX_TARIF_CODE}');
        MEASURE_UNIT : String(2)    @(title: '{i18n>MEASURE_UNIT}');
        WEIGHT_MEASURE : Decimal(5,2)   @(title: '{i18n>WEIGHT_MEASURE}');
        WEIGHT_UNIT : String(2)     @(title: '{i18n>WEIGHT_UNIT}');
        CURRENCY_CODE : String(4)   @(title: '{i18n>CURRENCY_CODE}');
        PRICE : Decimal(15,2)       @(title: '{i18n>PRICE}');
        WIDTH : Decimal(5,2)        @(title: '{i18n>WIDTH}');
        DEPTH : Decimal(5,2)        @(title: '{i18n>DEPTH}');
        HEIGHT : Decimal(5,2)       @(title: '{i18n>HEIGHT}');
        DIM_UNIT : String(2)        @(title: '{i18n>DIM_UNIT}');
        // Managed Association - No need to add any  external condition
        SUPPLIER_GUID : Association to master.businesspartner   @(title: '{i18n>NET_AMOUNT}');
 
    }
 
    entity employees : cuid {
        nameFirst : String(40);
        nameMiddle : String(40);
        nameLast : String(40);
        nameInitials : String(40);
        gender : c.Gender;
        language : String(2);
        phone : c.phoneNumber;
        email : c.Email;
        Currency  : Currency;
        loginName : String(15);
        salaryAmount : c.AmountT;
        accountNumber : String(16);
        bankId : String(12);
        bankName : String(64);
 
    }
 
    // Maintain the file with <your_namespace>.<your_context>-<entity_name>.csv
    entity student {
        key id : String(32);
        name : String(50);
        class : String(20);
    }
}
 
context transaction {
    entity purchaseorder : c.Amount {
        key NODE_KEY : c.Guid       @(title: '{i18n>NODE_KEY}');
        PO_ID : String(40)          @(title: '{i18n>PO_ID}');
        PARTNER_GUID : Association to master.businesspartner    @(title: '{i18n>PARTNER_GUID}');
        LIFECYCLE_STATUS : String(1)        @(title: '{i18n>LIFECYCLE_STATUS}');
        OVERALL_STATUS : String(1)          @(title: '{i18n>OVERALL_STATUS}');
        Items : Association to many purchaseitems on Items.PARENT_KEY = $self;
    }
    entity purchaseitems : c.Amount {
        key NODE_KEY : c.Guid   @(title: '{i18n>NODE_KEY}');
        PARENT_KEY : Association to purchaseorder   @(title: '{i18n>PARENT_KEY}');
        PO_ITEMS_POS : Int16    @(title: '{i18n>PO_ITEMS_POS}');
        PRODUCT_GUID : Association to master.product    @(title: '{i18n>PRODUCT_GUID}');
    }
}