//uday---->77%
@isTest
public class Test_YearDataConstant {
@isTest
    public static void method1(){
         Id RecordTypeIdclProd1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        account acc1= SME_TestUtil.createparentAccount('Test FName','Test LName','nagaram','12345','SFO','test@yahoo.com','1234567','12345678','Mahesh','Father in law','KVB');        
        acc1.RecordTypeId=RecordTypeIdclProd1;
            acc1.CIBIL_Status__pc='Complete';
        acc1.CIBIL_Score__c=500;
            insert acc1;
        date lastfiscalyear=date.newInstance(date.today().year()-1,3,31);
        account acc=SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
           acc.CBS_Customer_ID__c='1210009';
            acc.Date_of_Incorporation__c=date.newInstance(lastfiscalyear.year()-2,3,31);
       
            insert acc;
         genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',acc.id,'Application review','test','CompanyDetailsView');
            //genApp.RecordTypeId=Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
            genApp.Type__c='NTB-New to credit';
            genApp.Active__c=true;
            genApp.New_to_Business__c=true;
            genApp.BRE_Done__c=true;
        	genApp.BRE_Done__c = false;
        	genApp.CommercialPR_Stage__c='Completed';
        	genApp.List_Matching_Stage__c='Completed';
            insert genApp;
        
        list<genesis__Application_Parties__c> listParty = new list<genesis__Application_Parties__c>();
        genesis__Application_Parties__c prty=SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
        prty.CIBIL_Scores__c=10;
        prty.genesis__Party_Account_Name__c=acc1.id;
        prty.Active__c=true;
      
        insert prty;
        listParty.add(prty);
        Perfios__c prfs=new Perfios__c();
        Id RecordTypeIdclProd = Schema.SObjectType.Perfios__c.getRecordTypeInfosByName().get('SME New Loan Perfios').getRecordTypeId();
        prfs.RecordTypeId=RecordTypeIdclProd;
        prfs.Application__c=genApp.id;
        insert prfs;
         ints__TransUnion_Credit_Report__c repobj=new ints__TransUnion_Credit_Report__c(Account__c=acc.id);
		insert repobj;    
        RankVec__c rv=new RankVec__c();
        rv.Rank_Name__c='hef';
        rv.Tu_Credit_Report__c=repobj.id;
        rv.Rank_Value__c='CMR-7';
        insert rv;
        Task tsk = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk.Status='Completed';
        tsk.Type='Takeover Intelligence';
        update tsk;
        Task tsk1 = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk1.Status='Completed';
        tsk1.Type='Market Intelligence';
        update tsk1;
        Task tsk2 = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk2.Status='Completed';
        tsk2.Type='Verified diff b/w App Exposure and TU Exposure as per Application';
        update tsk2;
        Task tsk3 = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk3.Status='Completed';
        tsk3.Type='Financial Upload';
        update tsk3;
         system.debug('tsk==++'+tsk.WhatId);
        List<Task> tsklst=new List<Task>();
        tsklst.add(tsk);
        List<string> tasktype=new List<string>();
        tasktype.add('Property Evaluation');
        tasktype.add('Pre-disbursement Approval');
        tasktype.add('Qualitative Input Needed');
        tasktype.add('Takeover Intelligence');
        tasktype.add('Market Intelligence');
        tasktype.add('Verified diff b/w App Exposure and TU Exposure as per Application');
        tasktype.add('Financial Upload');
        Test.startTest();
        YearDataConstant.sendMissingYearsFinancials(acc.id);
        YearDataConstant.isPerfiosStatus_Completed(genApp.id);
        YearDataConstant.isTaskCompleted(genApp.id);
        YearDataConstant.checkAppConditionForBRERun(genApp.id);
        YearDataConstant.checkNewToBusinessRMD_Deviation(genApp.id);
        YearDataConstant.getCheque_Return_Gr_than_2(genApp);
        YearDataConstant.getCibilScore_Reject(genApp.id);
        YearDataConstant.getFinalAuthRecomForLessThan_50L(genApp);
        YearDataConstant.isTaskCompleted(genApp.id);
        YearDataConstant.main();
        YearDataConstant.getManagement_Exp_Gr_than_3(genApp);
        YearDataConstant.getMinCibilScore_Gr_than_700(genApp.id);
        YearDataConstant.isMarketIntelligenceCompleted(genApp.id);
        YearDataConstant.isPerfiosStatus_Completed(genApp.id);
        YearDataConstant.isRunBREForNewLoan(genApp.id);
        YearDataConstant.getAllMissingYear(acc.id,true);
        YearDataConstant.checkAllTaskDoneForBRERun(genApp.id,tasktype);
        YearDataConstant.ForntbNtcTakeover(listParty);
        YearDataConstant.getCibilScore_Reject_New(genApp.id);
        YearDataConstant.getCANameNumberMissingYearWise(acc.id);
        Test.stopTest();
    }
    @isTest
    public static void method2(){
            account acc=SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB'); 
                acc.Date_of_Incorporation__c=system.today()-2;
                insert acc;
            Id RecordTypeIdclProd1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
               acc.CBS_Customer_ID__c='1210009';
              account acc1= SME_TestUtil.createparentAccount('Test FName','Test LName','nagaram','12345','SFO','test@yahoo.com','1234567','12345678','Mahesh','Father in law','KVB');        
              acc1.RecordTypeId=RecordTypeIdclProd1;
              acc1.CIBIL_Status__pc='Complete';
              acc1.CIBIL_Score__c=500;
              insert acc1;
             genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',acc.id,'Application review','test','CompanyDetailsView');
                genApp.Type__c='NTB-Takeover';
                genApp.Active__c=true;
        		genApp.New_to_Business__c=true;
       
            //genApp.New_to_Business__c=true;
            insert genApp;
        GSTN_Info__c gst1=new GSTN_Info__c();
        gst1.RecordTypeId=Schema.SObjectType.GSTN_Info__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
        gst1.Account__c=acc.id;
        gst1.Application__c=genApp.id;
        insert gst1;
        GSTN_Info__c gst=new GSTN_Info__c();
       // gst.RecordTypeId=Schema.SObjectType.GSTN_Info__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
        gst.Account__c=acc.id;
        gst.Application__c=genApp.id;
        gst.Parent__c=gst1.id;
        gst.Year__c='2020';
        gst.Months__c='7';
        gst.Total_Sales__c=500;
        insert gst;
        
        
        genesis__Application_Parties__c prty=SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
        prty.CIBIL_Scores__c=-1;
        prty.genesis__Party_Account_Name__c=acc1.id;
        insert prty;
        system.debug('genesis__Application__r.CustomerID__c==++'+prty.genesis__Application__r.CustomerID__c);
        Perfios__c prfs=new Perfios__c();
        Id RecordTypeIdclProd = Schema.SObjectType.Perfios__c.getRecordTypeInfosByName().get('SME New Loan Perfios').getRecordTypeId();
        prfs.RecordTypeId=RecordTypeIdclProd;
        prfs.Application__c=genApp.id;
        prfs.Status__c = 'Completed';
        insert prfs;
                 ints__TransUnion_Credit_Report__c repobj=new ints__TransUnion_Credit_Report__c(Account__c=acc.id);
		insert repobj;    
        RankVec__c rv=new RankVec__c();
        rv.Rank_Name__c='hef';
        rv.Tu_Credit_Report__c=repobj.id;
        rv.Rank_Value__c='CMR-7';
        insert rv;
             Task  newTask=SME_TestUtil.createtask('Takeover Intelligence','Subject','Completed',UserInfo.getUserId(),genApp.Id);
             //newTask.WhatId=genApp.Id;
             insert newTask;
         //Task  newTask1=SME_TestUtil.createtask('Market Intelligence','Subject','Completed',UserInfo.getUserId(),genApp.Id);
         // insert newTask1;
        List<Task> tsklst=new List<Task>();
        tsklst.add(newTask);
        List<string> tasktype=new List<string>();
        tasktype.add('Property Evaluation');
        tasktype.add('Pre-disbursement Approval');
        tasktype.add('Qualitative Input Needed');
        tasktype.add('Takeover Intelligence');
        tasktype.add('Market Intelligence');
        tasktype.add('Verified diff b/w App Exposure and TU Exposure as per Application');
        tasktype.add('Financial Upload');
        Test.startTest();
        YearDataConstant.sendMissingYearsFinancials(acc.id);
       // YearDataConstant.isPerfiosStatus_Completed(genApp.id);
       // YearDataConstant.isTaskCompleted(genApp.id);
        //YearDataConstant.checkAppConditionForBRERun(genApp.id);
        //YearDataConstant.checkNewToBusinessRMD_Deviation(genApp.id);
        //YearDataConstant.getCheque_Return_Gr_than_2(genApp);
        YearDataConstant.getCibilScore_Reject(genApp.id);
        YearDataConstant.getFinalAuthRecomForLessThan_50L(genApp);
        //YearDataConstant.isTaskCompleted(genApp.id);
        //YearDataConstant.main();
        //YearDataConstant.getManagement_Exp_Gr_than_3(genApp);
        //YearDataConstant.getMinCibilScore_Gr_than_700(genApp.id);
        //YearDataConstant.isMarketIntelligenceCompleted(genApp.id);
        //YearDataConstant.isPerfiosStatus_Completed(genApp.id);
        //YearDataConstant.isRunBREForNewLoan(genApp.id);
        YearDataConstant.getAllMissingYear(acc.id,false);
        YearDataConstant.checkAllTaskDoneForBRERun(genApp.id,tasktype);
        Test.stopTest();
    }
      @isTest
    public static void method02(){
            account acc=SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB'); 
                acc.Date_of_Incorporation__c=system.today()-2;
                insert acc;
        Id RecordTypeIdclProd1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        acc.CBS_Customer_ID__c='1210009';
        account acc1= SME_TestUtil.createparentAccount('Test FName','Test LName','nagaram','12345','SFO','test@yahoo.com','1234567','12345678','Mahesh','Father in law','KVB');        
        acc1.RecordTypeId=RecordTypeIdclProd1;
        acc1.CIBIL_Status__pc='Complete';
        acc1.CIBIL_Score__c=500;
        insert acc1;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',acc.id,'Application review','test','CompanyDetailsView');
        genApp.Type__c='NTB-Takeover';
        genApp.Active__c=true;
        genApp.New_to_Business__c=true;
        insert genApp;
        
        GSTN_Info__c gst1=new GSTN_Info__c();
        gst1.RecordTypeId=Schema.SObjectType.GSTN_Info__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
        gst1.Account__c=acc.id;
        gst1.Application__c=genApp.id;
        insert gst1;
        
        GSTN_Info__c gst=new GSTN_Info__c();
       // gst.RecordTypeId=Schema.SObjectType.GSTN_Info__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
        gst.Account__c=acc.id;
        gst.Application__c=genApp.id;
        gst.Parent__c=gst1.id;
        gst.Year__c='2020';
        gst.Months__c='7';
        gst.Total_Sales__c=500;
        insert gst;
        
        
        genesis__Application_Parties__c prty=SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
        prty.CIBIL_Scores__c=-1;
        //prty.genesis__Party_Account_Name__c=acc1.id;
        insert prty;
        
        system.debug('genesis__Application__r.CustomerID__c==++'+prty.genesis__Application__r.CustomerID__c);
        Perfios__c prfs=new Perfios__c();
        Id RecordTypeIdclProd = Schema.SObjectType.Perfios__c.getRecordTypeInfosByName().get('SME New Loan Perfios').getRecordTypeId();
        prfs.RecordTypeId=RecordTypeIdclProd;
        prfs.Application__c=genApp.id;
        prfs.Status__c = 'Completed';
        insert prfs;
        
        ints__TransUnion_Credit_Report__c repobj=new ints__TransUnion_Credit_Report__c(Account__c=acc.id);
        insert repobj;   
       
        RankVec__c rv=new RankVec__c();
        rv.Rank_Name__c='hef';
        rv.Tu_Credit_Report__c=repobj.id;
        rv.Rank_Value__c='CMR-7';
        rv.Tu_Credit_Report__c=repobj.id;
        insert rv;
        
        Task  newTask=SME_TestUtil.createtask('Takeover Intelligence','Subject','Completed',UserInfo.getUserId(),genApp.Id);
        //newTask.WhatId=genApp.Id;
        insert newTask;
        //Task  newTask1=SME_TestUtil.createtask('Market Intelligence','Subject','Completed',UserInfo.getUserId(),genApp.Id);
        // insert newTask1;
        List<Task> tsklst=new List<Task>();
        tsklst.add(newTask);
        List<string> tasktype=new List<string>();
        tasktype.add('Property Evaluation');
        tasktype.add('Pre-disbursement Approval');
        tasktype.add('Qualitative Input Needed');
        tasktype.add('Takeover Intelligence');
        tasktype.add('Market Intelligence');
        tasktype.add('Verified diff b/w App Exposure and TU Exposure as per Application');
        tasktype.add('Financial Upload');
        Test.startTest();
        YearDataConstant.sendMissingYearsFinancials(acc.id);
        YearDataConstant.getCibilScore_Reject(genApp.id);
        YearDataConstant.getFinalAuthRecomForLessThan_50L(genApp);
        YearDataConstant.getAllMissingYear(acc.id,false);
        YearDataConstant.checkAllTaskDoneForBRERun(genApp.id,tasktype);
        Test.stopTest();
    }
    
    @isTest
    public static void method3(){
         Id RecordTypeIdclProd1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        account acc1= SME_TestUtil.createparentAccount('Test FName','Test LName','nagaram','12345','SFO','test@yahoo.com','1234567','12345678','Mahesh','Father in law','KVB');        
        acc1.RecordTypeId=RecordTypeIdclProd1;
            acc1.CIBIL_Status__pc='Complete';
        acc1.CIBIL_Score__c=500;
            insert acc1;
        date lastfiscalyear=date.newInstance(date.today().year()-1,3,31);
        account acc=SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            //acc.CBS_Customer_ID__c='1210009';
            acc.Date_of_Incorporation__c=date.newInstance(lastfiscalyear.year()-2,3,31);
        //acc.ParentId=acc1.id;
            insert acc;
        //account acc1=SME_TestUtil.createAccount('HP Agencies1','CHENNAI','1210008','Mahesh','Father in law','KVB');
       
            //acc.CBS_Customer_ID__c='1210009';

         genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',acc.id,'Application review','test','CompanyDetailsView');
            genApp.RecordTypeId=Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
            genApp.Type__c='NTB-New to credit';
            genApp.Active__c=true;
            genApp.New_to_Business__c=true;
            //genApp.BRE_Done__c=true;
            genApp.List_Matching_Stage__c='Completed';
            genApp.CommercialPR_Stage__c='Completed';
            insert genApp;
        
        genesis__Application_Parties__c prty=SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
        prty.CIBIL_Scores__c=10;
        prty.genesis__Party_Account_Name__c=acc1.id;
        prty.Active__c=true;
        insert prty;
        
        Perfios__c prfs=new Perfios__c();
        Id RecordTypeIdclProd = Schema.SObjectType.Perfios__c.getRecordTypeInfosByName().get('SME New Loan Perfios').getRecordTypeId();
        prfs.RecordTypeId=RecordTypeIdclProd;
        prfs.Application__c=genApp.id;
        prfs.Status__c = 'Completed';
        insert prfs;
        
         ints__TransUnion_Credit_Report__c repobj=new ints__TransUnion_Credit_Report__c(Account__c=acc.id);
		insert repobj;    
        RankVec__c rv=new RankVec__c();
        rv.Rank_Name__c='hef';
        rv.Tu_Credit_Report__c=repobj.id;
        rv.Rank_Value__c='CMR-7';
        insert rv;
        Task tsk = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk.Status='Completed';
        tsk.Type='Takeover Intelligence';
        update tsk;
        Task tsk1 = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk1.Status='Completed';
        tsk1.Type='Market Intelligence';
        update tsk1;
        Task tsk2 = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk2.Status='Completed';
        tsk2.Type='Verified diff b/w App Exposure and TU Exposure as per Application';
        update tsk2;
        Task tsk3 = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk3.Status='Completed';
        tsk3.Type='Financial Upload';
        update tsk3;
         system.debug('tsk==++'+tsk.WhatId);
        List<Task> tsklst=new List<Task>();
        tsklst.add(tsk);
        List<string> tasktype=new List<string>();
        tasktype.add('Property Evaluation');
        tasktype.add('Pre-disbursement Approval');
        tasktype.add('Qualitative Input Needed');
        tasktype.add('Takeover Intelligence');
        tasktype.add('Market Intelligence');
        tasktype.add('Verified diff b/w App Exposure and TU Exposure as per Application');
        tasktype.add('Financial Upload');
        Test.startTest();
        YearDataConstant.sendMissingYearsFinancials(acc.id);
        YearDataConstant.isPerfiosStatus_Completed(genApp.id);
        YearDataConstant.isTaskCompleted(genApp.id);
        YearDataConstant.checkAppConditionForBRERun(genApp.id);
        YearDataConstant.checkNewToBusinessRMD_Deviation(genApp.id);
        YearDataConstant.getCheque_Return_Gr_than_2(genApp);
        YearDataConstant.getCibilScore_Reject(genApp.id);
        YearDataConstant.getFinalAuthRecomForLessThan_50L(genApp);
        YearDataConstant.isTaskCompleted(genApp.id);
        YearDataConstant.main();
        YearDataConstant.getManagement_Exp_Gr_than_3(genApp);
        YearDataConstant.getMinCibilScore_Gr_than_700(genApp.id);
        YearDataConstant.isMarketIntelligenceCompleted(genApp.id);
        YearDataConstant.isPerfiosStatus_Completed(genApp.id);
        YearDataConstant.isRunBREForNewLoan(genApp.id);
        YearDataConstant.getAllMissingYear(acc.id,true);
        YearDataConstant.checkAllTaskDoneForBRERun(genApp.id,tasktype);
        Test.stopTest();
    }
    @isTest
    public static void method4(){
         Id RecordTypeIdclProd1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        account acc1= SME_TestUtil.createparentAccount('Test FName','Test LName','nagaram','12345','SFO','test@yahoo.com','1234567','12345678','Mahesh','Father in law','KVB');        
        acc1.RecordTypeId=RecordTypeIdclProd1;
        acc1.CIBIL_Status__pc='Complete';
        acc1.CIBIL_Score__c=1000;
        insert acc1;
        date lastfiscalyear=date.newInstance(date.today().year()-1,3,31);
        
        account acc=SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.CBS_Customer_ID__c='1210009';
        acc.Date_of_Incorporation__c=date.newInstance(lastfiscalyear.year()-2,3,31);
        String id=acc.id;
        acc.CBS_Customer_ID__c=id;
        insert acc;
        
		
         genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',acc.id,'Application review','test','CompanyDetailsView');
            //genApp.RecordTypeId=Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
            genApp.Type__c='NTB-New to credit';
            genApp.Active__c=true;
            genApp.New_to_Business__c=false;
            genApp.BRE_Done__c=true;
        	//genApp.Type__c = 'ETB-WC';
        	genApp.Type__c = 'Takeover';
        	genApp.Inward_cheque_return__c=5;
           insert genApp;
        
        list<genesis__Application_Parties__c> listParty = new list<genesis__Application_Parties__c>();
        genesis__Application_Parties__c prty=SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
        prty.CIBIL_Scores__c=10;
        prty.genesis__Party_Account_Name__c=acc1.id;
        prty.Active__c=true;
        insert prty;
        listParty.add(prty);
        
        Perfios__c prfs=new Perfios__c();
        Id RecordTypeIdclProd = Schema.SObjectType.Perfios__c.getRecordTypeInfosByName().get('SME New Loan Perfios').getRecordTypeId();
        prfs.RecordTypeId=RecordTypeIdclProd;
        prfs.Application__c=genApp.id;
       insert prfs;
        
        ints__TransUnion_Credit_Report__c repobj=new ints__TransUnion_Credit_Report__c(Account__c=acc.id);
		insert repobj;  
        
        RankVec__c rv=new RankVec__c();
        rv.Rank_Name__c='hef';
        rv.Tu_Credit_Report__c=repobj.id;
        rv.Rank_Value__c='CMR-7';
        rv.Tu_Credit_Report__c=repobj.id;
        insert rv;
        Task tsk = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk.Status='Completed';
        tsk.Type='Takeover Intelligence';
        update tsk;
        Task tsk1 = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk1.Status='Completed';
        tsk1.Type='Market Intelligence';
        update tsk1;
        Task tsk2 = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk2.Status='Completed';
        tsk2.Type='Verified diff b/w App Exposure and TU Exposure as per Application';
        update tsk2;
        Task tsk3 = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk3.Status='Completed';
        tsk3.Type='Financial Upload';
        update tsk3;
         system.debug('tsk==++'+tsk.WhatId);
        List<Task> tsklst=new List<Task>();
        tsklst.add(tsk);
        List<string> tasktype=new List<string>();
        tasktype.add('Property Evaluation');
        tasktype.add('Pre-disbursement Approval');
        tasktype.add('Qualitative Input Needed');
        tasktype.add('Takeover Intelligence');
        tasktype.add('Market Intelligence');
        tasktype.add('Verified diff b/w App Exposure and TU Exposure as per Application');
        tasktype.add('Financial Upload');
        Test.startTest();
        YearDataConstant.sendMissingYearsFinancials(acc.id);
        YearDataConstant.isPerfiosStatus_Completed(genApp.id);
        YearDataConstant.isTaskCompleted(genApp.id);
        YearDataConstant.checkAppConditionForBRERun(genApp.id);
        YearDataConstant.checkNewToBusinessRMD_Deviation(genApp.id);
        YearDataConstant.getCheque_Return_Gr_than_2(genApp);
        YearDataConstant.getCibilScore_Reject(genApp.id);
        YearDataConstant.getFinalAuthRecomForLessThan_50L(genApp);
        YearDataConstant.isTaskCompleted(genApp.id);
        YearDataConstant.main();
        YearDataConstant.getManagement_Exp_Gr_than_3(genApp);
        YearDataConstant.getMinCibilScore_Gr_than_700(genApp.id);
        YearDataConstant.isMarketIntelligenceCompleted(genApp.id);
        YearDataConstant.isPerfiosStatus_Completed(genApp.id);
        YearDataConstant.isRunBREForNewLoan(genApp.id);
        YearDataConstant.getAllMissingYear(acc.id,true);
        YearDataConstant.checkAllTaskDoneForBRERun(genApp.id,tasktype);
        YearDataConstant.ForntbNtcTakeover(listParty);
        YearDataConstant.getCibilScore_Reject_New(genApp.id);
        YearDataConstant.getCANameNumberMissingYearWise(acc.id);
        Test.stopTest();
    }
    
    @isTest
    public static void method5(){
         Id RecordTypeIdclProd1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        account acc1= SME_TestUtil.createparentAccount('Test FName','Test LName','nagaram','12345','SFO','test@yahoo.com','1234567','12345678','Mahesh','Father in law','KVB');        
        acc1.RecordTypeId=RecordTypeIdclProd1;
            acc1.CIBIL_Status__pc='Complete';
        acc1.CIBIL_Score__c=1000;
            insert acc1;
        date lastfiscalyear=date.newInstance(date.today().year()-1,3,31);
        account acc=SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
           acc.CBS_Customer_ID__c='1210009';
            acc.Date_of_Incorporation__c=date.newInstance(lastfiscalyear.year()-2,3,31);
        
		
         genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',acc.id,'Application review','test','CompanyDetailsView');
            //genApp.RecordTypeId=Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
            genApp.Type__c='NTB-New to credit';
            genApp.Active__c=true;
            genApp.New_to_Business__c=false;
            genApp.BRE_Done__c=true;
        	genApp.Type__c = 'ETB-WC';
        	genApp.Inward_cheque_return__c=5;
         //  insert genApp;
        
        list<genesis__Application_Parties__c> listParty = new list<genesis__Application_Parties__c>();
        genesis__Application_Parties__c prty=SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
        prty.CIBIL_Scores__c=10;
        prty.genesis__Party_Account_Name__c=acc1.id;
        prty.Active__c=true;
        insert prty;
        listParty.add(prty);
        Perfios__c prfs=new Perfios__c();
        Id RecordTypeIdclProd = Schema.SObjectType.Perfios__c.getRecordTypeInfosByName().get('SME New Loan Perfios').getRecordTypeId();
        prfs.RecordTypeId=RecordTypeIdclProd;
        prfs.Application__c=genApp.id;
       //insert prfs;
         ints__TransUnion_Credit_Report__c repobj=new ints__TransUnion_Credit_Report__c(Account__c=acc.id);
		insert repobj;    
        RankVec__c rv=new RankVec__c();
        rv.Rank_Name__c='hef';
        rv.Tu_Credit_Report__c=repobj.id;
        rv.Rank_Value__c='CMR-7';
        insert rv;
        Task tsk = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk.Status='Completed';
        tsk.Type='Takeover Intelligence';
        update tsk;
        Task tsk1 = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk1.Status='Completed';
        tsk1.Type='Market Intelligence';
        update tsk1;
        Task tsk2 = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk2.Status='Completed';
        tsk2.Type='Verified diff b/w App Exposure and TU Exposure as per Application';
        update tsk2;
        Task tsk3 = Utility.createTask(genApp.id,UserInfo.getUserId(),'Subject',0);
        tsk3.Status='Completed';
        tsk3.Type='Financial Upload';
        update tsk3;
         system.debug('tsk==++'+tsk.WhatId);
        List<Task> tsklst=new List<Task>();
        tsklst.add(tsk);
        List<string> tasktype=new List<string>();
       tasktype.add(' ');
        tasktype.add(' ');
        tasktype.add('Qualitative Input Needed');
       tasktype.add(' ');
        tasktype.add('Market Intelligence');
        tasktype.add('Verified diff b/w App Exposure and TU Exposure as per Application');
        tasktype.add(' ');
        Test.startTest();
        
        
        YearDataConstant.checkAllTaskDoneForBRERun(genApp.id,tasktype);
       
        Test.stopTest();
    }
}