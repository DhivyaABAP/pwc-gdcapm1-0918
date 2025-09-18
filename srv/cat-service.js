const { default: cds, transaction } = require("@sap/cds");
const { request, response } = require("express");

module.exports = cds.service.impl( async function() {
    const{ EmployeeDetails, PODetails } = this.entities;
   

    this.before('UPDATE', EmployeeDetails, (request,response) =>{
        console.log("-----------Salary Amount-------" + request.data.salaryAmount);
        if(parseFloat(request.data.salaryAmount) >= 150000)
        {
            request.error(500, "Salary Must not be more than 150K");
            
        }
    });


    this.on('increasedprice', async( request, response) =>{
        try {
            //read the first parameter input value
            //If there are multiple parameters, it will be in array
            const ID = request.params[0];

            //Read the request details
            const transaction = cds.tx(request);

/* entity should be used here and this entity needs to be added at the
when the reading the entities*/
           response = await transaction.update(PODetails).with({
                GROSS_AMOUNT: { '+=' : 2200 },
                NET_AMOUNT: { '+=' : 2200 }
            }).where(ID);

            //Get the response from the Entities
            //Commenting the below one to use this action in the item column
           // response = await transaction.run(SELECT.from(PODetails).where(ID));
            
            //Return the response
            return response;

        } catch (error) {
            //Write the error message to the response
           return "Error:" + error.toString(); 
        }
    });

    this.on('largestorder', async( request, response ) =>{
        try {
          const key = request.params[0];
          const inputdata = cds.tx(request);
          
          //read the largest order from the PO details
          const response = await inputdata.read(PODetails).orderBy({
            //ORder the data based on the gross amount in descending Order
            GROSS_AMOUNT : 'desc' 
          }).limit(1); //limit the record to 1 to get only the largest order detail

          //return the response
          return response;

        } catch (error) {
            return "Error:" + error.toString();
        }
        
    });
 //Utility function to Generate the UUID
    const { uuid } = cds.utils;
    //Custom action call with Database update
    this.on('createEmployee', async (request, response) =>{
        try {
            //Read the data from the Request
            const inputdata = {
                nameFirst,
                nameMiddle,
                nameLast,
                nameInitials,
                gender,
                language,
                phone,
                email,
                loginName,
                salaryAmount,
                accountNumber,
                bankId,
                bankName
            } = request.data, 
            /*automatically generated UUID with CDS utility function
             To use this function, it needs to be defined at the top of the module*/
            id = uuid(); 
             
            //LET is used to define the variable
            let output = undefined;
            //Map the input data with the database structure
            //If there are no variant in the field name, then this mapping is not required 
            let employeetobecreated = {
                ID : id,
                nameFirst : inputdata.nameFirst,  /*Incase of multiple structure with same name, 
                                              it suggested to use with reference to the structure */
                nameMiddle : nameMiddle,
                nameLast : nameLast,
                nameInitials : nameInitials,
                gender : gender,
                language : language,
                phone : phone,
                email : email,
                loginName : loginName,
                salaryAmount : salaryAmount,
                accountNumber : accountNumber,
                bankId : bankId,
                bankName : bankName
            }
            //Insert the input data to database
              let insertedData = await cds.run(INSERT.into('GDCAPM1_DB_MASTER_EMPLOYEES').entries([employeetobecreated]));
            //Post the insertion, read the data from the database 
              let createdData = await cds.run(SELECT.from('GDCAPM1_DB_MASTER_EMPLOYEES').where({ ID : { '=' : id } }));
            //Display the inserted data
            finalResponse = {
                statusCode : '200',
                message : 'Employee record has been created',
                data : createdData
            } ;
            //Pass the inserted data to response
            return finalResponse;
            
            
        } catch (error) {
            return "Error:" + error.toString();
        }
    }
    );

    this.on('getProducts', async ( request, response ) =>{
        try {
            //Parameter will be in the format /getProducts('EUR')
            let lv_params = request.req.params[0];

            //Display the value it the console for our reference
            console.log(lv_params);
            //split the parameter at sinlge quote and get the second parameter which will be currency
            /*First param : /getProducts(
            second Param : EUR
            Third Param :  ) */
            lv_params = lv_params.split("'")[1];
            //Display the parameter the correct parameter in the consolde
            console.log(lv_params);
            //Define the output records
            let output = undefined;
            /*Read all the records where the currency is based on the parameter in URI
            and fetch only the specifc fields */
            output = await cds.run(SELECT.from('GDCAPM1_DB_MASTER_PRODUCT').columns('PRODUCT_ID','DESCRIPTION', 'CURRENCY_CODE').where({ CURRENCY_CODE : { '=' :lv_params } }));
            //Return the ouptut in the response structure to get all the records not only one
            return {
                respone : output
            }
        } catch (error) {
          return "Error: " + error.toString();  
        }
    })
})