using { gdcapm1.db.master as master, gdcapm1.db.transaction } from '../db/datamodel';
using { gdcapm1.potypedef as common } from '../db/potypedef';  //use the aspect and types


service CatalogService @(path: 'CatalogService', requires: 'authenticated-user' ) {
    @Capabilities : { 
        InsertRestrictions : {
            $Type : 'Capabilities.InsertRestrictionsType',
            Insertable: true
        },
        UpdateRestrictions : {
            $Type : 'Capabilities.UpdateRestrictionsType',
            Updatable : true
        },
        DeleteRestrictions : {
            $Type : 'Capabilities.DeleteRestrictionsType',
            Deletable: true
        },
     }
    entity businesspartner as projection on master.businesspartner;
   // @readonly
    entity ProductDet as projection on master.product;

    entity EmployeeDetails @(restrict: [ 
        {
            grant :  ['READ'], to: 'Viewer', where : 'bankName = $user.bankName'
        },
        {
            grant :  ['WRITE'], to: 'Admin'
        }
    ]) as projection on master.employees;

    entity AddressDetail @(restrict: [ 
        {
            grant :  ['READ'], to: 'Viewer', where : 'COUNTRY = $user.mycountry'
        },
        {
            grant :  ['WRITE'], to: 'Admin'
        }
    ]) as projection on master.address;
    entity PODetails @( odata.draft.enabled : true)
    
     as projection on transaction.purchaseorder
    {
        *,
        case OVERALL_STATUS 
            WHEN 'N' then 'New'
            WHEN 'P' then 'Paid'
            WHEN 'B' then 'Blocked'
            WHEN 'R' then 'Returned'
            else 'Delivered'
            end as OverallStatus : String(20) @(title: '{i18n>OVERALL_STATUS}'),
        case OVERALL_STATUS 
            WHEN 'N' then 2
            WHEN 'P' then 3
            WHEN 'B' then 1
            WHEN 'R' then 3
            else 3
            end as OSCriticallity : Integer @(title: '{i18n>OVERALL_STATUS}'),
        case LIFECYCLE_STATUS 
            WHEN 'N' then 'New'
            WHEN 'I' then 'In progress'
            WHEN 'P' then 'Pending'
            WHEN 'C' then 'cancelled'
            else 'Done'
            end as Lifecyclestatus : String(20) @(title: '{i18n>LIFECYCLE_STATUS}'),
        case LIFECYCLE_STATUS 
            WHEN 'N' then 3
            WHEN 'I' then 2
            WHEN 'P' then 1
            WHEN 'C' then 1
            else 3
            end as LSCriticallity : Integer @(title: '{i18n>LIFECYCLE_STATUS}'),
        Items : redirected to POItems
    } actions {
         //Get the Updated amount immediately without refresh
        @cds.odata.bindingparameter.name : '_pricehike'
        @Common.SideEffects : {
            TargetProperties : [
                '_pricehike/GROSS_AMOUNT'
            ],
        }
        
        //Custom Action definition
        action increasedprice() returns array of  PODetails;
        //custom Function Definition
        function largestorder() returns array of PODetails;
    };
    entity POItems as projection on transaction.purchaseitems;
    
    action createEmployee(
        //Import parameter or the reuest payload details
        //field Name and its type should be same as the database table
        nameFirst : String(40),
        nameMiddle : String(40),
        nameLast : String(40),
        nameInitials : String(40),
        gender : common.Gender,  //Reference type can be either aspect or view
        language : String(2),
        phone : common.phoneNumber,
        email : common.Email,
        loginName : String(15),
        salaryAmount : common.AmountT,
        accountNumber : String(16),
        bankId : String(12),
        bankName : String(64)
    )
    //Exporting Parameter
    returns array of String;
function getProducts(CurrencyCode: String(3)) returns ProductDet;
}