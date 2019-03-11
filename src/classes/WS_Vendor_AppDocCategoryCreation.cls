/*
* Name    : WS_Vendor_AppDocCategoryCreation
* Company : ET Marlabs
* Purpose : This class will be used for Creating Application Document Category fot third party loan onboarding
* Author  : Bhavya P
-----------------------------------------------------------------------

*******************************************************************************************/
public class WS_Vendor_AppDocCategoryCreation {

    public class Document_Response {
        public string FolderId = '';
        public string Folder_Name = '';
    }
    
    public static List<Document_Response> CreateDocCat(genesis__Applications__c APP,List<Account> AccList,Boolean AccountType){
        try{
            Map<String,ID> AppDocCatID=new Map<string,ID>();
            Map<String,ID> DocCatID=new  Map<String,ID>();
            List<genesis__Application_Document_Category__c> ParentList=new List<genesis__Application_Document_Category__c>();
            List<genesis__Application_Document_Category__c> SubParentList=new List<genesis__Application_Document_Category__c>();
            List<genesis__Application_Document_Category__c> MiniparentList=new List<genesis__Application_Document_Category__c>();
            set<string> DocCateNames=DocCatNamesset();
            set<string> FolderNames=Foldernamescapture(App.Record_Type_Name__c);
            set<string> SubFolderNames1=subFoldernamesCapture1();  
            set<string> SubFolderNames2=subFoldernamesCapture2(App.Record_Type_Name__c);         
            set<string> SubFolderNames3=subFoldernamesCapture3();
            set<string> SubFolderNames4 = subFoldernamesCapture4();  // V1.1
            set<string> SubFolderNames5 = subFoldernamesCapture5();
            set<string> SubFolderNames6 = subFoldernamesCapture6(App.Record_Type_Name__c);
            set<string> SubFolderNames7 = subFoldernamesCapture7(); 
            set<string> SubFolderNames8 = subFoldernamesCapture8();
            set<string> Folders1 = MainFolders();
            List<genesis__Application_Document_Category__c> TotalList=new List<genesis__Application_Document_Category__c>();
            List<Document_Response> responseList = new List<Document_Response>();

            // For Vehicle Loan
            /*List<String> RemoveVL = new List<String>{Constants.PropVerifiReport,Constants.PropertyDocuments,Constants.UploadInsurance};
            List<String> AddVL = new List<String>{Constants.VehicleVerifiReport,Constants.VehicleDocuments,Constants.Upload_Vehicle_Insurance};
            if(App.Record_Type_Name__c==WS_Vendor_Constants.VL2W || App.Record_Type_Name__c==WS_Vendor_Constants.VL4W){
                DocCateNames.AddAll(AddVL);
            }*/
            List<genesis__Document_Category__c> DocCatList=[select id,name,genesis__Category_Name__c from genesis__Document_Category__c where  genesis__Category_Name__c IN:DocCateNames];
            for(genesis__Document_Category__c DCID:DocCatList){
                DocCatID.put(DCID.genesis__Category_Name__c, DCID.Id);
                
            }
            system.Debug('aaaaa'+DocCatID);
            if(AccountType==true){
                Account Acc = AccList[0];
                genesis__Application_Document_Category__c ParentAppDocCat=new genesis__Application_Document_Category__c();
                system.debug('App.Record_Type_Name__c'+App.Record_Type_Name__c);
                if(App.Record_Type_Name__c==WS_Vendor_Constants.HOMELOAN){
                    ParentAppDocCat.name= WS_Vendor_Constants.PARENT_CATEGORY_HL;
                }
                else if(App.Record_Type_Name__c==WS_Vendor_Constants.LAPLOAN){
                    ParentAppDocCat.name= WS_Vendor_Constants.PARENT_CATEGORY_LAP;
                }
                else if(App.Record_Type_Name__c==WS_Vendor_Constants.PERSONALLOAN){
                    ParentAppDocCat.name= WS_Vendor_Constants.PARENT_CATEGORY_PL;
                }else if(App.Record_Type_Name__c==WS_Vendor_Constants.VL2W || App.Record_Type_Name__c==WS_Vendor_Constants.VL4W){
                     ParentAppDocCat.name= WS_Vendor_Constants.PARENT_CATEGORY_VL;
                     /*FolderNames.RemoveAll(RemoveVL);
                     FolderNames.AddAll(AddVL);*/
                }
                ParentAppDocCat.genesis__Application__c=APP.id;
                insert ParentAppDocCat;
                system.debug('##DataLog FolderNames ### --- > '+ FolderNames);
                for(string s:FolderNames){
                    genesis__Application_Document_Category__c ChildAppDocCat=new genesis__Application_Document_Category__c();
                    ChildAppDocCat.Name=s;
                    ChildAppDocCat.genesis__Application__c=APP.id;
                    ChildAppDocCat.genesis__Parent_Application_Document_Category__c=ParentAppDocCat.Id;
                    ParentList.add(ChildAppDocCat);
                }
                insert ParentList;
                
                for(genesis__Application_Document_Category__c subFolder1:ParentList){
                    
                    if(subFolder1.Name==WS_Vendor_Constants.PropertyDocuments){
                        for(string Sfd1:SubFolderNames1){
                            genesis__Application_Document_Category__c SAPPDOcCat1=new genesis__Application_Document_Category__c();
                            SAPPDOcCat1.Name=sfd1;
                            SAPPDOcCat1.genesis__Application__c=APP.id;
                            SAPPDOcCat1.genesis__Parent_Application_Document_Category__c=subFolder1.Id;
                            SubParentList.add(SAPPDOcCat1);  
                        }
                        
                    }
                    
                    else if(subFolder1.Name==WS_Vendor_Constants.IncomeDocuments){
                        for(string Sfd2:SubFolderNames2){
                            genesis__Application_Document_Category__c SAPPDOcCat2=new genesis__Application_Document_Category__c(); 
                            SAPPDOcCat2.Name=sfd2;
                            SAPPDOcCat2.genesis__Application__c=APP.id;
                            SAPPDOcCat2.genesis__Parent_Application_Document_Category__c=subFolder1.Id;
                            SubParentList.add(SAPPDOcCat2);  
                        }
                    }
                    // v1.1 Start  DOne by Venu
                    else if(subFolder1.Name==WS_Vendor_Constants.KYCDocumnents){
                         for(string Sfd2:SubFolderNames4){
                            genesis__Application_Document_Category__c SAPPDOcCat2=new genesis__Application_Document_Category__c(); 
                            SAPPDOcCat2.Name=sfd2;
                            SAPPDOcCat2.genesis__Application__c=APP.id;
                            SAPPDOcCat2.genesis__Parent_Application_Document_Category__c=subFolder1.Id;
                            SubParentList.add(SAPPDOcCat2);  
                        }
                    }
                    // V1.1 End
                    else if(subFolder1.Name==WS_Vendor_Constants.LoanDocuments){
                         for(string Sfd2:SubFolderNames6){
                            genesis__Application_Document_Category__c SAPPDOcCat6=new genesis__Application_Document_Category__c(); 
                            SAPPDOcCat6.Name=sfd2;
                            SAPPDOcCat6.genesis__Application__c=APP.id;
                            SAPPDOcCat6.genesis__Parent_Application_Document_Category__c=subFolder1.Id;
                            SubParentList.add(SAPPDOcCat6);  
                        }
                    }
                    else if(subFolder1.Name==WS_Vendor_Constants.Others && App.Record_Type_Name__c!= WS_Vendor_Constants.VL2W && App.Record_Type_Name__c!= WS_Vendor_Constants.VL4W){
                         for(string Sfd2:SubFolderNames7){
                            genesis__Application_Document_Category__c SAPPDOcCat7=new genesis__Application_Document_Category__c(); 
                            SAPPDOcCat7.Name=sfd2;
                            SAPPDOcCat7.genesis__Application__c=APP.id;
                            SAPPDOcCat7.genesis__Parent_Application_Document_Category__c=subFolder1.Id;
                            SubParentList.add(SAPPDOcCat7);  
                        }
                    }
                    else if(subFolder1.Name==WS_Vendor_Constants.VEHICLE_INSURANCE){
                         for(string Sfd8:SubFolderNames8){
                            genesis__Application_Document_Category__c SAPPDOcCat8=new genesis__Application_Document_Category__c(); 
                            SAPPDOcCat8.Name=sfd8;
                            SAPPDOcCat8.genesis__Application__c=APP.id;
                            SAPPDOcCat8.genesis__Parent_Application_Document_Category__c=subFolder1.Id;
                            SubParentList.add(SAPPDOcCat8);  
                        }
                    }
                }
                insert SubParentList;
                
                for(genesis__Application_Document_Category__c MiniFolder:SubParentList){
                    if(MiniFolder.Name==WS_Vendor_Constants.MainIncome){
                        for(string Sfd1:SubFolderNames3){
                            genesis__Application_Document_Category__c SAPPDOcCat3=new genesis__Application_Document_Category__c();
                            SAPPDOcCat3.Name=sfd1;
                            SAPPDOcCat3.genesis__Application__c=APP.id;
                            SAPPDOcCat3.genesis__Parent_Application_Document_Category__c=MiniFolder.Id;
                            MiniparentList.add(SAPPDOcCat3);  
                        }
                        
                    }

                    if(MiniFolder.Name==WS_Vendor_Constants.PropVerifiReport){
                        for(string Sfd1:SubFolderNames5){
                            genesis__Application_Document_Category__c SAPPDOcCat5=new genesis__Application_Document_Category__c();
                            SAPPDOcCat5.Name=sfd1;
                            SAPPDOcCat5.genesis__Application__c=APP.id;
                            SAPPDOcCat5.genesis__Parent_Application_Document_Category__c=MiniFolder.Id;
                            MiniparentList.add(SAPPDOcCat5);  
                        }
                        
                    }
                                        
                }
                insert MiniparentList;                
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
            for(Account Acc : AccList){
                for(string s:DocCatID.keySet()){
                    if(AppDocCatID.containsKey(s)){
                        genesis__Application_Document_Category__c SubAPPDoc=new genesis__Application_Document_Category__c();
                        SubAPPDoc.Applicant__c=Acc.id;
                        SubAPPDoc.genesis__Document_Category__c=DocCatID.get(s);
                        SubAPPDoc.genesis__Parent_Application_Document_Category__c=AppDocCatID.get(s);
                        SubAPPDoc.genesis__Application__c=App.id;
                        SubAPPDoc.Name=s+'-'+Acc.Full_Name__c;
                        ApplicantDocCat.add(SubAPPDoc);
                        system.debug('SubAPPDoc.Name--->'+SubAPPDoc.Name);
                    }
                }    
            }
            system.debug('ApplicantDocCat--->'+ApplicantDocCat);
            insert ApplicantDocCat ;
            TotalList.addAll(ApplicantDocCat);

            for(genesis__Application_Document_Category__c doc:TotalList){
                if(!Folders1.contains(doc.Name)){
                    Document_Response res = new Document_Response();
                    res.FolderId = doc.Id;
                    res.Folder_Name = doc.Name;
                    responseList.add(res);
                }
            }

            return responseList;
        }
        
        
        catch(exception e){
            system.debug('error message for DOC Category'+e.getLineNumber()+'Class name  '+e.getStackTraceString());
            return null;
            
        }
        
    }
        
    public static set<string> Foldernamescapture(String rType){
        set<string> abc= new set<string>();
        abc.add(WS_Vendor_Constants.CustPhoto);
        abc.add(WS_Vendor_Constants.KYCDocumnents);
        abc.add(WS_Vendor_Constants.FIReport);
        abc.add(WS_Vendor_Constants.IncomeDocuments);
        if(rType == WS_Vendor_Constants.HOMELOAN || rType == WS_Vendor_Constants.LAPLOAN){
            abc.add(WS_Vendor_Constants.PropertyDocuments);
        }
        abc.add(WS_Vendor_Constants.LoanDocuments);
        if(rType == WS_Vendor_Constants.PERSONALLOAN){
            abc.add(WS_Vendor_Constants.CreditInsurancePolicy);
        }
        if(rType == WS_Vendor_Constants.VL2W || rType == WS_Vendor_Constants.VL4W){
            abc.add(WS_Vendor_Constants.VEHICLE_INSURANCE);
        }
        abc.add(WS_Vendor_Constants.CibilReport);
        abc.add(WS_Vendor_Constants.AppForm);
        abc.add(WS_Vendor_Constants.Others);
        return abc;
    }
    
    
    public static set<string> subFoldernamesCapture1(){
        set<string> abc= new set<string>();
        abc.add(WS_Vendor_Constants.PropVerifiReport);
        abc.add(WS_Vendor_Constants.UploadEC);
        abc.add(WS_Vendor_Constants.UploadInsurance);
        abc.add(WS_Vendor_Constants.Uploadcomfortletter);
        return abc;
    }

    public static set<string> subFoldernamesCapture2(String rType){
        set<string> PQR= new set<string>();
        PQR.add(WS_Vendor_Constants.MainIncome);
        PQR.add(WS_Vendor_Constants.AgriIncomeProof);
        if(rType == WS_Vendor_Constants.HOMELOAN || rType == WS_Vendor_Constants.LAPLOAN || rType == WS_Vendor_Constants.PERSONALLOAN){
            PQR.add(WS_Vendor_Constants.ShareProfIncoProof);
            PQR.add(WS_Vendor_Constants.RentalIncomeProof);
            PQR.add(WS_Vendor_Constants.PensIncoemProof);
        }
        PQR.add(WS_Vendor_Constants.OtherIncome);        
        return PQR;
        
    }
    
    public static set<string> subFoldernamesCapture3(){
        set<string> KLM= new set<string>();
        KLM.add(WS_Vendor_Constants.ITR);
        KLM.add(WS_Vendor_Constants.FormAS);
        KLM.add(WS_Vendor_Constants.BankStatement);    
        return KLM;
        
    }  
    // V1.1 Start Here
     public static set<string> subFoldernamesCapture4(){
        set<string> KYCList= new set<string>();
        KYCList.add(WS_Vendor_Constants.CustAddresProof);
        KYCList.add(WS_Vendor_Constants.PermanantAdd);
        KYCList.add(WS_Vendor_Constants.IdentityProof);    
        return KYCList;
        
    }

    public static set<string> subFoldernamesCapture5(){
        set<string> xyz= new set<string>();
        xyz.add(WS_Vendor_Constants.LegalOpinion);
        xyz.add(WS_Vendor_Constants.ValuReport);
        return xyz;
    }

    public static set<string> subFoldernamesCapture6(String rType){
        set<string> xyz= new set<string>();        
        if(rType == WS_Vendor_Constants.PERSONALLOAN){
            xyz.add(WS_Vendor_Constants.LoanAgreement);
            xyz.add(WS_Vendor_Constants.SanctionLetter);
        }
        if(rType == WS_Vendor_Constants.HOMELOAN || rType == WS_Vendor_Constants.LAPLOAN){
            xyz.add(WS_Vendor_Constants.C1);
            xyz.add(WS_Vendor_Constants.C11);
            xyz.add(WS_Vendor_Constants.A23);
            xyz.add(WS_Vendor_Constants.B17);
            xyz.add(WS_Vendor_Constants.A46);
            xyz.add(WS_Vendor_Constants.B1B2);
            xyz.add(WS_Vendor_Constants.MODDoc);
            xyz.add(WS_Vendor_Constants.Tripartite);
        }  
        if(rType == WS_Vendor_Constants.VL2W || rType == WS_Vendor_Constants.VL4W){
            xyz.add(WS_Vendor_Constants.VLSanctionLetter);
            xyz.add(WS_Vendor_Constants.VLPaymentAuthLetter);
            xyz.add(WS_Vendor_Constants.VLHypothecationLD);
            xyz.add(WS_Vendor_Constants.VlDealerPaymentLetter);
        }
        return xyz;
    }

    public static set<string> subFoldernamesCapture7(){
        set<string> xyz= new set<string>();
        xyz.add(WS_Vendor_Constants.DisbursementRequest);
        return xyz;
    }

    public static set<string> subFoldernamesCapture8(){
        set<string> hij= new set<string>();
        hij.add(WS_Vendor_Constants.UPLOAD_VEHICLE_INSURANCE);
        return hij;
    }

    // V1.1 End
    public static set<string> DocCatNamesset(){
        set<string> MNO= new set<string>();
        MNO.add(WS_Vendor_Constants.CustPhoto);
        MNO.add(WS_Vendor_Constants.CustAddresProof);
        //  MNO.add(WS_Vendor_Constants.PropertyDocuments);
        MNO.add(WS_Vendor_Constants.FIReport);
        //  MNO.add(WS_Vendor_Constants.LoanDocuments);
        //  MNO.add(WS_Vendor_Constants.LegalOpinion);
        //  MNO.add(WS_Vendor_Constants.ValuReport);
        //  MNO.add(WS_Vendor_Constants.MainIncome);
        MNO.add(WS_Vendor_Constants.CibilReport);
        MNO.add(WS_Vendor_Constants.AgriIncomeProof);
        MNO.add(WS_Vendor_Constants.ShareProfIncoProof);
        MNO.add(WS_Vendor_Constants.RentalIncomeProof);
        MNO.add(WS_Vendor_Constants.PensIncoemProof);
        //MNO.add(WS_Vendor_Constants.Others);
        MNO.add(WS_Vendor_Constants.FormAS);
        MNO.add(WS_Vendor_Constants.ITR);
        MNO.add(WS_Vendor_Constants.BankStatement);
        MNO.add(WS_Vendor_Constants.CreditInsurancePolicy);
        MNO.add(WS_Vendor_Constants.OtherIncome);
        MNO.add(WS_Vendor_Constants.PermanantAdd);  //v1.1
        MNO.add(WS_Vendor_Constants.IdentityProof);  //v1.1
        
        return MNO;
        
    }

    public static set<string> MainFolders(){
        set<string> MNO= new set<string>();
        MNO.add(WS_Vendor_Constants.CustPhoto);
        MNO.add(WS_Vendor_Constants.CibilReport);
        MNO.add(WS_Vendor_Constants.CustAddresProof);
        MNO.add(WS_Vendor_Constants.FIReport);
        MNO.add(WS_Vendor_Constants.AgriIncomeProof);
        MNO.add(WS_Vendor_Constants.ShareProfIncoProof);
        MNO.add(WS_Vendor_Constants.RentalIncomeProof);
        MNO.add(WS_Vendor_Constants.PensIncoemProof);
        MNO.add(WS_Vendor_Constants.Others);
        MNO.add(WS_Vendor_Constants.FormAS);
        MNO.add(WS_Vendor_Constants.ITR);
        MNO.add(WS_Vendor_Constants.BankStatement);
        MNO.add(WS_Vendor_Constants.OtherIncome);
        MNO.add(WS_Vendor_Constants.PermanantAdd);  //v1.1
        MNO.add(WS_Vendor_Constants.IdentityProof); 
        MNO.add(WS_Vendor_Constants.KYCDocumnents);
        MNO.add(WS_Vendor_Constants.PropertyDocuments);
        MNO.add(WS_Vendor_Constants.PropVerifiReport);
        MNO.add(WS_Vendor_Constants.MainIncome); //v1.
        MNO.add(WS_Vendor_Constants.CreditInsurancePolicy);
        MNO.add(WS_Vendor_Constants.IncomeDocuments);
        MNO.add(WS_Vendor_Constants.LoanDocuments);
        return MNO;
        
    } 
    
}