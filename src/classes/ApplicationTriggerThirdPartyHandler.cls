/************************************************
 Name: ApplicationTriggerThirdPartyHandler
 Company: ET Marlabs
 Author: Dipen Ishani
***********************************************/ 
public class ApplicationTriggerThirdPartyHandler {
    //singleton instance
    private static ApplicationTriggerThirdPartyHandler instance = null;
    
    //constructor
    private ApplicationTriggerThirdPartyHandler(){}
    
    //get singleton instance
    public static ApplicationTriggerThirdPartyHandler getInstance(){
        if(instance == null){
            instance = new ApplicationTriggerThirdPartyHandler();
        }
        RETURN instance;
    }
    
    //before update
    public void beforeUpdateThirdPartyApplication(List<genesis__Applications__c> Applist, Map<Id,genesis__Applications__c> oldAppMap){
        list<Third_Party_ROI_Matrix__mdt> matrixList = new list<Third_Party_ROI_Matrix__mdt>(); 
        if(Applist.size()>0){
            genesis__Applications__c app =  Applist[0];
            List<genesis__Application_Parties__c> partyList = new List<genesis__Application_Parties__c>();
            partyList = [SELECT CIBIL_Scores__c FROM genesis__Application_Parties__c WHERE genesis__Application__c =: app.Id AND CIBIL_Scores__c!=null AND (genesis__Party_Type__c =: WS_Vendor_Constants.PRIMARY_APP OR genesis__Party_Type__c =: WS_Vendor_Constants.CO_BORROWER) AND Financial_Applicant__c =: True];
            Decimal maxCibil;
            String SelectedSchm;
            List<Scheme_Master__c> SelectedScheme = new List<Scheme_Master__c>();
            //List<String> usrList = new List<String>();            
            if(app.genesis__CL_Product_Name__c != null && app.genesis__CL_Product_Name__c.contains('Co-Lending')){                
                if(partyList.size()>0){
                    maxCibil =  partyList[0].CIBIL_Scores__c;
                }
                if(app.Max_CIBIL_Score__c != null){
                    maxCibil = app.Max_CIBIL_Score__c;
                    system.debug('maxCibil--->'+maxCibil);
                }
                if(partyList.size()>0){
                    for(genesis__Application_Parties__c part : partyList){
                        if(part.CIBIL_Scores__c > maxCibil){
                            maxCibil = part.CIBIL_Scores__c;
                            system.debug('maxCibil--->'+maxCibil);
                        }
                    }
                    app.Max_CIBIL_Score__c = maxCibil;
                    system.debug('app.Max_CIBIL_Score__c --->'+app.Max_CIBIL_Score__c);
                }
                Account acc = [SELECT Employment_Type__c,Financial_Applicant__c,Age__c FROM Account WHERE Id =: app.genesis__Account__c];
                List<genesis__Application_Parties__c> partyList1 = [SELECT Financial_Applicant__c,Employment_Types__c FROM genesis__Application_Parties__c WHERE genesis__Party_Account_Name__c =: app.genesis__Account__c AND genesis__Application__c =: app.Id AND genesis__Party_Type__c =: WS_Vendor_Constants.PRIMARY_APP LIMIT 1];
                if(partyList1.size()>0){
                    genesis__Application_Parties__c party = partyList1[0];
                    if(app.Record_Type_Name__c != WS_Vendor_Constants.PERSONALLOAN){
                        List<Decimal> decList = WS_Vendor_RestAPIHelper.getInterestRate(app.Sourced_By__c,party.Employment_Types__c,party.Financial_Applicant__c,app.Sanction_Authority_Limit__c,acc.Age__c,app.Record_Type_Name__c,app.Max_CIBIL_Score__c);
                        if(decList.size()>1){
                            app.genesis__Interest_Rate__c = decList[0];
                            app.MCLR_Rate__c = decList[1];
                        }
                        app.Interest_Variation__c = app.genesis__Interest_Rate__c - app.MCLR_Rate__c;
                    }else if(app.Record_Type_Name__c == WS_Vendor_Constants.PERSONALLOAN){
                        Decimal indexVar = Third_Party_CBR_Codes__c.getValues(app.Sourced_By__c).Index_Variance__c;
                        app.genesis__Interest_Rate__c = app.Recommended_Final_Rate_of_Interest__c;
                        app.Interest_Variation__c = app.genesis__Interest_Rate__c - indexVar;
                    }
                }
                /*matrixList = [select id, MasterLabel,ROI_Floating_650_700__c,ROI_Floating_700__c,ROI_Cibil_1__c,ROI_Cibil_5__c FROM Third_Party_ROI_Matrix__mdt where Field_Investigation__c =: app.Sourced_By__c AND Target_Borrowers__c =: party.Employment_Types__c AND Is_Financial_Applicant__c =: party.Financial_Applicant__c AND Loan_Amount_Max__c>=:app.Sanction_Authority_Limit__c AND Loan_Amount_Min__c<=:app.Sanction_Authority_Limit__c AND Age_Norms_Origination__c<=:acc.Age__c AND Age_Norms_Maturity__c>=:acc.Age__c AND Record_Type__c =: app.Record_Type_Name__c];
                if(matrixList.size()>0){
                    if(app.Max_CIBIL_Score__c >= 650 && app.Max_CIBIL_Score__c<700){
                        app.genesis__Interest_Rate__c = matrixList[0].ROI_Floating_650_700__c;
                    }else if(app.Max_CIBIL_Score__c >= 700){
                        app.genesis__Interest_Rate__c = matrixList[0].ROI_Floating_700__c;
                    }else if(app.Max_CIBIL_Score__c == -1){
                        app.genesis__Interest_Rate__c = matrixList[0].ROI_Cibil_1__c;
                    }else if(app.Max_CIBIL_Score__c == 5){
                        app.genesis__Interest_Rate__c = matrixList[0].ROI_Cibil_5__c;
                    }else{
                    app.genesis__Interest_Rate__c = 0;
                    }
                    //app.Interest_Variation__c = app.genesis__Interest_Rate__c - app.MCLR_Rate__c;
                }else{
                    app.genesis__Interest_Rate__c = 0;
                }
                 if(app.MCLR_Rate__c!=null){
                    app.Interest_Variation__c = app.genesis__Interest_Rate__c - app.MCLR_Rate__c;
                }else{
                    app.Interest_Variation__c = app.genesis__Interest_Rate__c;
                }*/              
            }
            if(app.Sub_Stage__c == WS_Vendor_Constants.SUB_STAGE_CBS_PENDING && oldAppMap.get(app.Id).Sub_Stage__c!=WS_Vendor_Constants.SUB_STAGE_CBS_PENDING){ 
                taskCreation(app);  
                ThirdParty_BREScoreCal.Calculate_Bre(app);  
                if(app.Record_Type_Name__c == WS_Vendor_Constants.VL2W || app.Record_Type_Name__c == WS_Vendor_Constants.VL4W){
                for(clcommon__Collateral__c cc : App.genesis__Collaterals__r){
                     SelectedSchm = cc.Scheme_Type__c != null ? cc.Scheme_Type__c : '';
                }
                    SelectedScheme =  [Select Id,Name,Scheme_Code__c,ProductType__c,Active_Flag__c,LTV_increase__c,Pricing_Discount__c,Processing_fee_discount__c from Scheme_Master__c Where Active_Flag__c = True and ProductType__c=:app.Record_Type_Name__c and Scheme_Code__c=:SelectedSchm limit 1];
                }
                if(SelectedScheme.size()>0){
                    app.genesis__Interest_Rate__c =  app.genesis__Interest_Rate__c - SelectedScheme[0].Pricing_Discount__c ;
                    app.Interest_Variation__c = app.genesis__Interest_Rate__c - app.MCLR_Rate__c;
                }                          
            }
        }      
    }
    
    //before insert
    public void beforeInsertThirdPartyApplication(List<genesis__Applications__c> Applist){
        if(Applist.size()>0){
            genesis__Applications__c app =  Applist[0];
            if(app.Sub_Stage__c == WS_Vendor_Constants.SUB_STAGE_APP_CREATED || app.Sub_Stage__c == WS_Vendor_Constants.SUB_STAGE_CBS_PENDING){
                Branch_Master__c brMaster = WS_Vendor_RestAPIHelper.getBranchDetails(app.Sourced_By__c);
                if(brMaster!=null){
                    app.Branch_Code__c = brMaster.CODCCBRN__c;
                    app.Branch_Name__c = brMaster.NAM_BRANCH__c;
                }
                app.CBS_API_Sequence__c = '0.1';
                if(app.Sourced_By__c!=null){
                    String casaAcc = Third_Party_CBR_Codes__c.getValues(app.Sourced_By__c).CASAAccountNumber__c;
                    app.Disbursement_Account_Number__c = casaAcc;
                    app.CASA_Account_No__c = casaAcc;
                }
            }          
        }
    }
    
    //after insert
    public void afterInsertThirdPartyApplication(List<genesis__Applications__c> Applist){
        if(Applist.size()>0){
            genesis__Applications__c app =  Applist[0];
            if(app.Sub_Stage__c == WS_Vendor_Constants.SUB_STAGE_CBS_PENDING && app.Sourced_By__c!=WS_Vendor_Constants.THIRDPARTY_HOMECREDIT){
                System.debug('Home Credit Test');
                taskCreation(app);                
            }
        }
    }
    public void afterUpdateThirdPartyApplication(List<genesis__Applications__c> Applist){
        if(Applist.size()>0){
            genesis__Applications__c app =  Applist[0];
            if(app.Sub_Stage__c == WS_Vendor_Constants.SUB_STAGE_CBS_PENDING){               
                genesis.ScorecardAPI.generateScorecard(app.Id);        
            }
        }
    }

    public void taskCreation(genesis__Applications__c app){
        List<String> usrList = new List<String>();
        usrList = WS_Vendor_RestAPIHelper.getUserList(app.Sourced_By__c);
        String userId;
        String Rlpc = 'hariprasads@kvbmail.com'; //hardcoded for HL and LAP ver1.0;
        String pbg = 'sathyamoorthyh@kvbmail.com '; //hardcoded for HL and LAP ver1.0;
        if(usrList.size()>0){
            userId = usrList[0];
        }
        /*if(usrList.size()>1){
            Rlpc = usrList[1];
        }
        if(usrList.size()>2){
            pbg = usrList[2];
        }*/
        system.debug('userId'+userId);
        if(userId != null){
            WS_Vendor_RestAPIHelper.creatTaskAll(app.Id, userId, 'Review Vendor Application',1, Rlpc, pbg);                                               
        }      
    }
}