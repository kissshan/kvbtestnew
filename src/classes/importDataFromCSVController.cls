public class importDataFromCSVController {
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public List<account> acclist{get;set;}
    public List<importDataFromCSVController.wrap> myWrapList{get;set;}
    public importDataFromCSVController(){
        csvFileLines = new String[]{};
        acclist = New List<Account>();
        myWrapList = new List<importDataFromCSVController.wrap>();
    }

    public void importCSVFile(){
        try{
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');

            for(Integer i=1;i<csvFileLines.size();i++){

                string[] csvRecordData = csvFileLines[i].split(',');
                /*System.debug(' csv'+csvRecordData+'@');
                System.debug(' csv Data'+csvRecordData[0].removeStart(' ')+'@');
                System.debug(' csv Data'+Decimal.valueOf(csvRecordData[1].removeStart(' '))+'@');
                System.debug(' csv Data'+Decimal.valueOf(csvRecordData[2].removeStart(' '))+'@');
                System.debug(' csv Data'+Boolean.valueOf(csvRecordData[3].removeStart(' '))+'@');
                System.debug(' csv Data'+Boolean.valueOf(csvRecordData[4].removeStart(' '))+'@');

                System.debug('@@@@@@@@'+csvRecordData[5].replaceAll(' ','')+'@');
                System.debug('@@@@@@@@'+csvRecordData[5].replaceAll('(\\s+)','')+'@');

                System.debug('@@@@@@@@'+csvRecordData[5]+'@');
                System.debug('@@@@@@@@'+csvRecordData[5].removeStart(' ')+'@');
                System.debug('@@@@@@@@'+csvRecordData[5].removeEnd(' ')+'@');
                System.debug(' csv Data'+Decimal.valueOf(csvRecordData[5].replaceAll(' ',''))+'@');*/
                //importDataFromCSVController.wrap wrapInstance = new importDataFromCSVController.wrap(csvRecordData[0].removeStart(' '),Decimal.valueOf(csvRecordData[1].removeStart(' ')),Decimal.valueOf(csvRecordData[2].removeStart(' ')),Boolean.valueOf(csvRecordData[3].removeStart(' ')),Boolean.valueOf(csvRecordData[4].removeStart(' ')),Decimal.valueOf(csvRecordData[5].replaceAll(' ','')));
                importDataFromCSVController.wrap wrapInstance = new importDataFromCSVController.wrap(csvRecordData[0].removeStart(' '),csvRecordData[1].removeStart(' '),Decimal.valueOf(csvRecordData[2].removeStart(' ')),Decimal.valueOf(csvRecordData[3].removeStart(' ')),Boolean.valueOf(csvRecordData[4].removeStart(' ')),Boolean.valueOf(csvRecordData[5].removeStart(' ')),Decimal.valueOf(csvRecordData[6].replaceAll(' ','')));

                System.debug(' wrapInstance wrapInstance'+wrapInstance);
                myWrapList.add(wrapInstance);

            }
        if(!myWrapList.isEmpty()){
            processWrapList();
            //processWrapList();
        }
            //insert acclist;
        }
        catch (Exception e)
        {
            HandleBusinessException.captureError('import csv data','import',e);
            System.debug('Exception :::: '+e.getMessage()+' At '+e.getLineNumber());
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }
    }
    public void processWrapList(){
        try {
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            System.debug('#####'+myWrapList);
            for(importDataFromCSVController.wrap wrapRecord:myWrapList){
                Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
                customMetadata.fullName = 'Security_Configuration_Master.'+wrapRecord.prodName;
                customMetadata.label = wrapRecord.prodNameWithSpaces;

                Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
                customField1.field = 'Collateral_Security_Coverage__c';
                customField1.value = wrapRecord.collSecCoverage;

                customMetadata.values.add(customField1);

                Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
                customField2.field = 'Primary_Security_Coverage__c';
                customField2.value = wrapRecord.primarySecCoverage;

                customMetadata.values.add(customField2);

                /*Metadata.CustomMetadataValue customField3 = new Metadata.CustomMetadataValue();
                customField3.field = 'Collateral_Security_Coverage__c';
                customField3.value = wrapRecord.collSecCoverage;

                customMetadata.values.add(customField3);*/

                Metadata.CustomMetadataValue customField4 = new Metadata.CustomMetadataValue();
                customField4.field = 'Is_Collateral_Security_Required__c';
                customField4.value = wrapRecord.collateralSecurityrequired;

                customMetadata.values.add(customField4);

                Metadata.CustomMetadataValue customField5 = new Metadata.CustomMetadataValue();
                customField5.field = 'Is_Primary_Security_Required__c';
                customField5.value = wrapRecord.primarySecurityrequired;

                customMetadata.values.add(customField5);

                Metadata.CustomMetadataValue customField6 = new Metadata.CustomMetadataValue();
                customField6.field = 'Priority__c';
                customField6.value = wrapRecord.prior;

                customMetadata.values.add(customField6);
                System.debug('+++++'+customMetadata);
                mdContainer.addMetadata(customMetadata);

        /*       Metadata.CustomMetadata customMetadata5 =  new Metadata.CustomMetadata();
                customMetadata.fullName = 'Security_Configuration_Master.'+wrapRecord.prior;
                customMetadata.label = wrapRecord.prior;

                Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                customField.field = 'Collateral_Security_Coverage__c';
                customField.value = wrapRecord.prior;

                Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
                customMetadata.fullName = 'Security_Configuration_Master.'+wrapRecord.collateralSecurityrequired;
                customMetadata.label = wrapRecord.collateralSecurityrequired;

                Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                customField.field = 'Collateral_Security_Coverage__c';
                customField.value = wrapRecord.collateralSecurityrequired;

                Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
                customMetadata.fullName = 'Security_Configuration_Master.'+wrapRecord.collateralSecurityrequired;
                customMetadata.label = wrapRecord.collateralSecurityrequired;

                Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                customField.field = 'Collateral_Security_Coverage__c';
                customField.value = wrapRecord.collateralSecurityrequired; */
            }
            CustomMetadataCallback callback = new CustomMetadataCallback();
            Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
        } catch (Exception e) {
            HandleBusinessException.captureError('import csv data','import',e);
            System.debug('Exception :::: '+e.getMessage()+' At '+e.getLineNumber());

        }

    }
    public class wrap{
        public String prodName{get;set;}
        public String prodNameWithSpaces{get;set;}
        public decimal primarySecCoverage{get;set;}
        public decimal collSecCoverage{get;set;}
        public Boolean collateralSecurityrequired{get;set;}
        public Boolean primarySecurityrequired{get;set;}
        public Decimal prior{get;set;}
        public wrap(String prodName,String prodNameWithSpaces,decimal primarySecCoverage,decimal collSecCoverage,Boolean collateralSecurityrequired,Boolean primarySecurityrequired,Decimal prior){
            this.prodName = prodName;
            this.prodNameWithSpaces = prodNameWithSpaces;
            this.primarySecCoverage = primarySecCoverage;
            this.collSecCoverage = collSecCoverage;
            this.collateralSecurityrequired = collateralSecurityrequired;
            this.primarySecurityrequired = primarySecurityrequired;
            this.prior = prior;
        }
    }
}