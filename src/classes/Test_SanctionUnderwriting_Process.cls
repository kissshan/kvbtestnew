/*
* Description : Test_SanctionUnderwriting_Process
* Author      : Kishan Panchal
*/
@isTest
public class Test_SanctionUnderwriting_Process {
    @isTest public static void sanctionUnderwriting_ProcessMethod1(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        u.Designation__c='BR';
        insert u;
        
        user u1 = Utility_Test.createUser('TestUserkvb@test1.com');
        u1.Designation__c='BR';
        insert u1;
        
        System.RunAs(u){   
            
            Account acc = new Account(Name = 'Test');
            Insert acc;
            
            genesis__Applications__c genApp = new genesis__Applications__c();
            genApp.Lead_Time__c = 10;
            genApp.Usance_Period__c = 2;
            genApp.Renewal_Due_Date__c = Date.today();
            genApp.genesis__Account__c = acc.Id;
            genApp.OwnerId = u1.Id;
            genApp.Type__c = 'NTB';
            genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
            Insert genApp;
            
            Task taskrecord = new Task();
            taskrecord.OwnerId = UserInfo.getUserId();
            taskrecord.Subject='Donni';
            taskrecord.Status='Not Started';
            taskrecord.Priority='Normal';
            insert taskrecord; 
            
            Audit__c auditObj = new Audit__c();
            auditObj.Application__c = genApp.id;
            auditObj.User__c = u.Id;
            auditObj.Sanction_Authority_Comment__c = 'No';
            auditObj.Terms_and_Conditions__c = 'No';
            auditObj.Complied__c = 'No';
            auditObj.RecordTypeId = Schema.SObjectType.Audit__c.getRecordTypeInfosByName().get('Pre-Disbursement Terms and Condition').getRecordTypeId();
            insert auditObj;
            
            genesis__Meeting_Schedule__c gms = new genesis__Meeting_Schedule__c();
            gms.genesis__Type__c='Loan Committee';
            gms.Sanction_Committe_For__c = 'DOCC';
            gms.Division__c = 'DOM';
            insert gms;
            
            genesis__Committee_Member__c gcm = new genesis__Committee_Member__c();
            gcm.Designation__c ='DOCC';
            gcm.genesis__Role__c='Administrator' ;
            gcm.genesis__User__c = u.id;
            gcm.genesis__Meeting_Schedule__c = gms.id;
            insert gcm;
            
            Renewal_Checklists__c rchl = new Renewal_Checklists__c();
            rchl.Application__c=genApp.Id;
            rchl.Checklist_Name__c = 'Have we collected the FEC document (s)';
            insert rchl;
            
            Id devRecordTypeId = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
            
            Facility__c fcParentObj = new Facility__c();
            fcParentObj.RecordTypeId = devRecordTypeId;
            fcParentObj.role__C='BR';
            fcParentObj.Application__c = genApp.Id;
            fcParentObj.Higher_Authority_Order__c=67;
            insert fcParentObj;
            
            Facility__c fcChildObj = new Facility__c();
            fcChildObj.RecordTypeId = devRecordTypeId1;
            fcChildObj.Role__c = 'BR'; 
            fcChildObj.Facility__c = fcParentObj.Id;
            fcChildObj.Deviation_Approver__c = true;
            fcChildObj.Highest_Authority__c = true;
            fcChildObj.Is_Referred_Back_Enabled__c = true;
            fcChildObj.Read_Only_User__c = true;
            fcChildObj.Higher_Authority_Order__c = 0;
            insert fcChildObj;
            
            
            SanctionUnderwriting_Process.checkIfOpenTaskExist(genApp.Id,u.id); 
            SanctionUnderwriting_Process.createTaskForNextAuthority(genApp.Id,false);
            SanctionUnderwriting_Process.createTaskForPreviousAuthority(genApp.Id);
            SanctionUnderwriting_Process.getCommitteMemebers('DOM',genApp.id,'DOCC');
            SanctionUnderwriting_Process.getCurrentUserStatus(genApp.id,genApp,u);
            SanctionUnderwriting_Process.checkMemberApproved(genApp.Id,gms.id);
            SanctionUnderwriting_Process.checkIfNextAuthIsRMD(genApp.Id);
            SanctionUnderwriting_Process.getCheckListPendingReason(new List<Renewal_Checklists__c>{rchl});
            SanctionUnderwriting_Process.UserInfoWrapper uif = new SanctionUnderwriting_Process.UserInfoWrapper();
            SanctionUnderwriting_Process ob=new SanctionUnderwriting_Process();
            SanctionUnderwriting_Process.refferBackTOBMForPreDis(genApp.Id);
            SanctionUnderwriting_Process.getUserRecord('DOM','Chennai');
            SanctionUnderwriting_Process.isEveryPreDisbersementBMComplied(genApp.Id);
            SanctionUnderwriting_Process.getpreDisbursementCommentsAuthorityComment(genApp.Id);
            SanctionUnderwriting_Process.getFacilityAuthority(genApp.Id);
            SanctionUnderwriting_Process.getFacilityAuthorityForAllfacility(genApp.Id);
            SanctionUnderwriting_Process.getExistingAuthorityLevel(genApp.Id);
            SanctionUnderwriting_Process.closeTaskForLoggedInUser(u,genApp.Id);
            SanctionUnderwriting_Process.getCommitteMemberIds(gms.Id);
            
        }
    }  
    
    @isTest public static void sanctionUnderwriting_ProcessMethod2(){
         User u = Utility_Test.createUser('TestUserkvb@test.com');
        u.Designation__c='BR';
        insert u;
        
        System.RunAs(u){   
            
            Account acc = new Account(Name = 'Test');
            Insert acc;
            
            genesis__Applications__c genApp = new genesis__Applications__c();
            genApp.Lead_Time__c = 10;
            genApp.Usance_Period__c = 2;
            genApp.Renewal_Due_Date__c = Date.today();
            genApp.genesis__Account__c = acc.Id;
            genApp.OwnerId = u.Id;
            genApp.Type__c = 'NTB';
            genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
            Insert genApp;
            
            Task taskrecord = new Task();
            taskrecord.OwnerId = UserInfo.getUserId();
            taskrecord.Subject='Donni';
            taskrecord.Status='Completed';
            taskrecord.Priority='Normal';
            taskrecord.Approval_Status__c = 'Approved';
            taskrecord.WhatId = genApp.id;
            insert taskrecord; 
            
            
            
            
            Renewal_Checklists__c rchl = new Renewal_Checklists__c();
            rchl.Application__c=genApp.Id;
            rchl.Checklist_Name__c = 'Have we collected the FEC document (s)';
            insert rchl;
            Id devRecordTypeId = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            Facility__c fc = new Facility__c();
            fc.RecordTypeId = devRecordTypeId;
            fc.role__C='BR';
            fc.Application__c = genApp.Id;
            fc.Higher_Authority_Order__c=67;
            
            insert fc;
            Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
            Facility__c fc1 = new Facility__c();
            fc1.RecordTypeId = devRecordTypeId1;
            fc1.Role__c = 'BR'; 
            fc1.Facility__c = fc.Id;
            fc1.Deviation_Approver__c = true;
            fc1.Highest_Authority__c = true;
            fc1.Is_Referred_Back_Enabled__c = true;
            fc1.Read_Only_User__c = true;
            fc1.Higher_Authority_Order__c = 0;
            insert fc1;
            
            
            SanctionUnderwriting_Process.checkIfOpenTaskExist(genApp.Id,u.id); 
            SanctionUnderwriting_Process.createTaskForNextAuthority(genApp.Id,false);
            SanctionUnderwriting_Process.createTaskForPreviousAuthority(genApp.Id);
            SanctionUnderwriting_Process.getCommitteMemebers('DOM',genApp.id,'DOCC');
            SanctionUnderwriting_Process.getCurrentUserStatus(genApp.id,genApp,u);
            
            SanctionUnderwriting_Process.checkIfNextAuthIsRMD(genApp.Id);
            SanctionUnderwriting_Process.getCheckListPendingReason(new List<Renewal_Checklists__c>{rchl});
            SanctionUnderwriting_Process.UserInfoWrapper uif = new SanctionUnderwriting_Process.UserInfoWrapper();
            SanctionUnderwriting_Process ob=new SanctionUnderwriting_Process();
            SanctionUnderwriting_Process.refferBackTOBMForPreDis(genApp.Id);
            SanctionUnderwriting_Process.getUserRecord('DOM','Chennai');
            SanctionUnderwriting_Process.isEveryPreDisbersementBMComplied(genApp.Id);
            SanctionUnderwriting_Process.getpreDisbursementCommentsAuthorityComment(genApp.Id);
            SanctionUnderwriting_Process.getFacilityAuthority(genApp.Id);
            SanctionUnderwriting_Process.getFacilityAuthorityForAllfacility(genApp.Id);
            SanctionUnderwriting_Process.getExistingAuthorityLevel(genApp.Id);
            SanctionUnderwriting_Process.closeTaskForLoggedInUser(u,genApp.Id);
            
        }
    }
}