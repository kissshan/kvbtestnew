/*
* Name    : ApplicationDocument Category Structure
* Company : ET Marlabs
* Purpose : This class will be used for Creating Application Document Category
* Author  : Venu Gopal Namala-----------------------------------------------------------------------
   Version  Date         Author             Remarks                                                 
  =======   ==========   =============  ==================================
    V1.1    08-10-2018    Venu          KYC DOcuments Updating
    v1.2    21-01-2019    Braj          HL MVP2
*******************************************************************************************/
public class APPDocCategoryCreation {
    
    public static Boolean CreateDocCat(genesis__Applications__c APP,Account Acc,Boolean AccountType){
        try{
            Map<String,ID> AppDocCatID=new Map<string,ID>();
            Map<String,ID> DocCatID=new  Map<String,ID>();
            List<genesis__Application_Document_Category__c> ParentList=new List<genesis__Application_Document_Category__c>();
            List<genesis__Application_Document_Category__c> SubParentList=new List<genesis__Application_Document_Category__c>();
            List<genesis__Application_Document_Category__c> MiniparentList=new List<genesis__Application_Document_Category__c>();
            set<string> DocCateNames=DocCatNamesset();
            set<string> FolderNames=Foldernamescapture();
            set<string> SubFolderNames1=subFoldernamesCapture1();  
            set<string> SubFolderNames2=subFoldernamesCapture2();         
            set<string> SubFolderNames3=subFoldernamesCapture3();
            set<string> SubFolderNames4 = subFoldernamesCapture4();  // V1.1

            // For Vehicle Loan
            List<String> RemoveVL = new List<String>{Constants.PropVerifiReport,Constants.PropertyDocuments,Constants.UploadInsurance};
            List<String> AddVL = new List<String>{Constants.VehicleVerifiReport,Constants.VehicleDocuments,Constants.Upload_Vehicle_Insurance};
            List<String> Add_HL_Take_Over = new List<String>{Constants.Original_Sanction_Letters,Constants.Loan_Account_Statement,Constants.DOcuments_Other_Bank};//v1.2

            //Pre Approved Loan PL
            List<String> PreApprovedPL = new List<String>{Constants.PropVerifiReport,Constants.PropertyDocuments,Constants.UploadInsurance,Constants.CustPhoto,Constants.KYCDocumnents,Constants.FIReport,Constants.IncomeDocuments,Constants.UploadEC,Constants.custDec,Constants.CreditInsurancePolicy,Constants.Uploadcomfortletter};
            
            if(App.Record_Type_Name__c==Constants.VL2W || App.Record_Type_Name__c==Constants.VL4W){
                DocCateNames.AddAll(AddVL);
            }
            List<genesis__Document_Category__c> DocCatList=[select id,name,genesis__Category_Name__c from genesis__Document_Category__c where  genesis__Category_Name__c IN:DocCateNames];
            for(genesis__Document_Category__c DCID:DocCatList){
                DocCatID.put(DCID.genesis__Category_Name__c, DCID.Id);
            }
            
            if(AccountType==true){
                genesis__Application_Document_Category__c ParentAppDocCat=new genesis__Application_Document_Category__c();
                if(App.Record_Type_Name__c==Constants.HOMELOAN){
                    ParentAppDocCat.name= Constants.ParentDOCCatgName;
                    //v1.2(start)
                    if (app.Sub_Type__c==Constants.Sub_Type_Take_Over) {
                        FolderNames.AddAll(Add_HL_Take_Over);
                    }
                    if (app.Sub_Type__c==Constants.Sub_Type_Reimbursement) {
                        FolderNames.add(Constants.Original_Payment_Receipts);
                    }
                    //v1.2(end)
                }
                else if(App.Record_Type_Name__c==Constants.LAPLOAN){
                    ParentAppDocCat.name= Constants.ParentDOCCatgNameLAP;
                }
                else if(App.Record_Type_Name__c==Constants.PERSONALLOAN){
                    ParentAppDocCat.name= Constants.ParentDOCCatgNamePL;
                    if(App.Pre_Approved_Flag__c==true)
                    {
                        FolderNames.RemoveAll(PreApprovedPL);
              
                    }
                }else if(App.Record_Type_Name__c==Constants.VL2W || App.Record_Type_Name__c==Constants.VL4W){
                     ParentAppDocCat.name= Constants.ParentDOCCatgNameVL;
                     FolderNames.RemoveAll(RemoveVL);
                     FolderNames.AddAll(AddVL);
                }
                ParentAppDocCat.genesis__Application__c=APP.id;
                insert ParentAppDocCat;
                system.debug('##DataLog FolderNames ### --- > '+ FolderNames);
                for(string s:FolderNames){
                System.debug('ParentList:::'+s);
                    genesis__Application_Document_Category__c ChildAppDocCat=new genesis__Application_Document_Category__c();
                    ChildAppDocCat.Name=s;
                    ChildAppDocCat.genesis__Application__c=APP.id;
                    ChildAppDocCat.genesis__Parent_Application_Document_Category__c=ParentAppDocCat.Id;
                    ParentList.add(ChildAppDocCat);
                }
                insert ParentList;
                
                for(genesis__Application_Document_Category__c subFolder1:ParentList){
                    
                    if(subFolder1.Name==Constants.PropVerifiReport){
                        for(string Sfd1:SubFolderNames1){
                            genesis__Application_Document_Category__c SAPPDOcCat1=new genesis__Application_Document_Category__c();
                            SAPPDOcCat1.Name=sfd1;
                            SAPPDOcCat1.genesis__Application__c=APP.id;
                            SAPPDOcCat1.genesis__Parent_Application_Document_Category__c=subFolder1.Id;
                            SubParentList.add(SAPPDOcCat1);  
                        }
                        
                    }
                    
                    else if(subFolder1.Name==Constants.IncomeDocuments){
                        for(string Sfd2:SubFolderNames2){
                            genesis__Application_Document_Category__c SAPPDOcCat2=new genesis__Application_Document_Category__c(); 
                            SAPPDOcCat2.Name=sfd2;
                            SAPPDOcCat2.genesis__Application__c=APP.id;
                            SAPPDOcCat2.genesis__Parent_Application_Document_Category__c=subFolder1.Id;
                            SubParentList.add(SAPPDOcCat2);  
                        }
                    }
                    // v1.1 Start  DOne by Venu
                    else if(subFolder1.Name==Constants.KYCDocumnents){
                         for(string Sfd2:SubFolderNames4){
                            genesis__Application_Document_Category__c SAPPDOcCat2=new genesis__Application_Document_Category__c(); 
                            SAPPDOcCat2.Name=sfd2;
                            SAPPDOcCat2.genesis__Application__c=APP.id;
                            SAPPDOcCat2.genesis__Parent_Application_Document_Category__c=subFolder1.Id;
                            SubParentList.add(SAPPDOcCat2);  
                        }
                    }
                    // V1.1 End
                    
                }
                insert SubParentList;
                
                for(genesis__Application_Document_Category__c MiniFolder:SubParentList){
                    if(MiniFolder.Name==Constants.MainIncome){
                        for(string Sfd1:SubFolderNames3){
                            genesis__Application_Document_Category__c SAPPDOcCat3=new genesis__Application_Document_Category__c();
                            SAPPDOcCat3.Name=sfd1;
                            SAPPDOcCat3.genesis__Application__c=APP.id;
                            SAPPDOcCat3.genesis__Parent_Application_Document_Category__c=MiniFolder.Id;
                            MiniparentList.add(SAPPDOcCat3);  
                        }
                        
                    }
                    
                    
                }
                insert MiniparentList;
                List<genesis__Application_Document_Category__c> TotalList=new List<genesis__Application_Document_Category__c>();
                TotalList.addAll(SubParentList);
                TotalList.addAll(ParentList);
                TotalList.addAll(MiniparentList);
                
                system.debug('TotalList'+TotalList);
                system.debug('SubParentList'+SubParentList);
                system.debug('DocCatID'+DocCatID);
                
                system.debug('ParentList'+ParentList);
                
                for(genesis__Application_Document_Category__c DOcList:TotalList){
                    AppDocCatID.put(DOcList.Name, DOcList.id);
                }
            }
            
            else if(AccountType==false){
                list<genesis__Application_Document_Category__c> ListAppDocCat=[select id,name,genesis__Parent_Application_Document_Category__c,genesis__Application__c from genesis__Application_Document_Category__c where genesis__Application__c=:App.id];
                for(genesis__Application_Document_Category__c DOcList:ListAppDocCat){
                    AppDocCatID.put(DOcList.Name, DOcList.id);
                }
                
            }
            list<genesis__Application_Document_Category__c> ApplicantDocCat=new List<genesis__Application_Document_Category__c>();
            for(string s:DocCatID.keySet()){
                if(AppDocCatID.containsKey(s)){
                    genesis__Application_Document_Category__c SubAPPDoc=new genesis__Application_Document_Category__c();
                    SubAPPDoc.Applicant__c=Acc.id;
                    SubAPPDoc.genesis__Document_Category__c=DocCatID.get(s);
                    SubAPPDoc.genesis__Parent_Application_Document_Category__c=AppDocCatID.get(s);
                    SubAPPDoc.genesis__Application__c=App.id;
                    SubAPPDoc.Name=s+'-'+Acc.Full_Name__c;
                    ApplicantDocCat.add(SubAPPDoc);
                }
                
            }
            insert  ApplicantDocCat ;
            return true;
        }
        
        
        catch(exception e){
            system.debug('error message for DOC Category'+e.getLineNumber()+'Class name  '+e.getStackTraceString());
            return false;
            
        }
        
    }
    
    
    public static set<string> Foldernamescapture(){
        set<string> abc= new set<string>();
        abc.add(Constants.CustPhoto);
        abc.add(Constants.KYCDocumnents);
        abc.add(Constants.PropVerifiReport);
        abc.add(Constants.FIReport);
        abc.add(Constants.IncomeDocuments);
        abc.add(Constants.PropertyDocuments);
        abc.add(Constants.LoanDocuments);
        abc.add(Constants.UploadEC);
        abc.add(Constants.UploadInsurance);
        abc.add(Constants.Uploadcomfortletter);
        abc.add(Constants.CreditInsurancePolicy);
        abc.add(Constants.custDec);
        return abc;
    }
    
    
    public static set<string> subFoldernamesCapture1(){
        set<string> xyz= new set<string>();
        xyz.add(Constants.LegalOpinion);
        xyz.add(Constants.ValuReport);
        return xyz;
    }
    public static set<string> subFoldernamesCapture2(){
        set<string> PQR= new set<string>();
        PQR.add(Constants.MainIncome);
        //  PQR.add(Constants.ITR);
        PQR.add(Constants.AgriIncomeProof);
        PQR.add(Constants.ShareProfIncoProof);
        PQR.add(Constants.RentalIncomeProof);
        PQR.add(Constants.PensIncoemProof);
        PQR.add(Constants.Others);
        
        return PQR;
        
    }
    
    public static set<string> subFoldernamesCapture3(){
        set<string> KLM= new set<string>();
        KLM.add(Constants.ITR);
        KLM.add(Constants.FormAS);
        KLM.add(Constants.BankStatement);
        
        return KLM;
        
    }  
    // V1.1 Start Here
     public static set<string> subFoldernamesCapture4(){
        set<string> KYCList= new set<string>();
        KYCList.add(Constants.CustAddresProof);
        KYCList.add(Constants.PermanantAdd);
        KYCList.add(Constants.IdentityProof);
        
        return KYCList;
        
    }
    // V1.1 End
    public static set<string> DocCatNamesset(){
        set<string> MNO= new set<string>();
        MNO.add(Constants.CustPhoto);
        MNO.add(Constants.CustAddresProof);
        //  MNO.add(Constants.PropertyDocuments);
        MNO.add(Constants.FIReport);
        //  MNO.add(Constants.LoanDocuments);
        //  MNO.add(Constants.LegalOpinion);
        //  MNO.add(Constants.ValuReport);
        //  MNO.add(Constants.MainIncome);
        // MNO.add(Constants.ITR);
        MNO.add(Constants.AgriIncomeProof);
        MNO.add(Constants.ShareProfIncoProof);
        MNO.add(Constants.RentalIncomeProof);
        MNO.add(Constants.PensIncoemProof);
        MNO.add(Constants.Others);
        MNO.add(Constants.FormAS);
        MNO.add(Constants.ITR);
        MNO.add(Constants.BankStatement);
        MNO.add('Credit Insurance Policy');
        MNO.add(Constants.PermanantAdd);  //v1.1
        MNO.add(Constants.IdentityProof);  //v1.1
        MNO.add(Constants.custDec);
        return MNO;
        
    } 
    
}