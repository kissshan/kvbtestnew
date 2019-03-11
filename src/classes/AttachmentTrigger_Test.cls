@isTest(seeAllData=false)
private class AttachmentTrigger_Test {
	
    static testMethod void testAttachment(){
        test.startTest();
        	genesis__Applications__c appRecord =TestUtility.intialSetUp('product',false);
        	//insert appRecord;
            Attachment attach=new Attachment();   	
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=appRecord.id;
            insert attach;
        test.stopTest();
    }
    static testMethod void testM121(){
        test.startTest();
        	clcommon__Collateral__c colRec = new clcommon__Collateral__c(clcommon__Collateral_Name__c='Col-1');
        	insert colRec;
        	M21_A__c m21Record = new M21_A__c(Estimated_value_Rs__c=212,Collateral__c=colRec.Id,Visit_Date__c=System.today(), Comments__c='comments');
        	insert m21Record;
        test.stopTest();
    }
}