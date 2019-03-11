/*
* Name    : WS_eStampDocGen
* Company : ET Marlabs
* Purpose : This class will generate document form Legal Desk
* Author  : Subas
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
V1.1    29-Aug-2018    Braj          #VL717:Addition of Hypothecation document generation structure
V1.2    20-Feb-2019    Braj          #HL MVP2:Addition of A54 and A66 document structure
*******************************************************************************************/
public class WS_eStampDocGen {
    
    public class EstampDocGenResp{
        public string  Content;
        public integer PageCount;
    }
    public Static HTTPResponse docGenRes = new HTTPResponse();
    public Static String Tittle_B1 = '';
    public Static String Borrower1_Name1 = '';
    public Static String Borrower1_Add_line1 = '';
    public Static String Borrower1_Add_line2 = '';
    public Static String Borrower1_Add_line3 = '';
    public Static String Tittle_B2           = '';
    public Static String Borrower2_Name1     = '';
    public Static String Borrower2_Add_line1 = '';
    public Static String Borrower2_Add_line2 = '';
    public Static String Borrower2_Add_line3 = '';
    public Static String Tittle_B3           = '';
    public Static String Borrower3_Name1     = '';
    public Static String Borrower3_Add_line1 = '';
    public Static String Borrower3_Add_line2 = '';
    public Static String Borrower3_Add_line3 = '';
    public Static String Tittle_B4           = '';
    public Static String Borrower4_Name1     = '';
    public Static String Borrower4_Add_line1 = '';
    public Static String Borrower4_Add_line2 = '';
    public Static String Borrower4_Add_line3 = '';
    public Static String BorrowerDetails = '';
    public Static String Borrower1Names ='';
    public Static String Borrower1_Names = '';
    public Static String Borrower2Names ='';
    public Static String Borrower2_Names = '';
    public Static String Borrower3Names ='';
    public Static String Borrower3_Names = '';
    public Static String Borrower4Names ='';
    public Static String Borrower4_Names = '';
    public Static String Borrower5Names ='';
    public Static String Borrower6Names ='';
    public Static String Borrower5_Names = '';
    public Static String Borrower1_Addline1 ='';
    public Static String Borrower2_Addline1 ='';
    public Static String Borrower3_Addline1 ='';
    public Static String Borrower4_Addline1 ='';
    public Static String Borrower1_Addline2 ='';
    public Static String Borrower2_Addline2 ='';
    public Static String Borrower3_Addline2 ='';
    public Static String Borrower4_Addline2 ='';
    public Static String Borrower1_Addline3 ='';
    public Static String Borrower2_Addline3 ='';
    public Static String Borrower3_Addline3 ='';
    public Static String Borrower4_Addline3 ='';
    public Static String Borrower1_FHDNAME ='';
    public Static String Borrower2_FHDNAME ='';
    public Static String Borrower3_FHDNAME ='';
    public Static String Borrower4_FHDNAME ='';
    
    public Static String Title_Holder1Name1 ='';
    public Static String Title_Holder1_Addline1 ='';
    public Static String Title_Holder1_Addline2 ='';
    public Static String Title_Holder1_Addline3 ='';
    
    public Static String Title_Holder2Name1 ='';
    public Static String Title_Holder2_Addline1 ='';
    public Static String Title_Holder2_Addline2 ='';
    public Static String Title_Holder2_Addline3 ='';
    
    public Static String Title_Holder3Name1 ='';
    public Static String Title_Holder3_Addline1 ='';
    public Static String Title_Holder3_Addline2 ='';
    public Static String Title_Holder3_Addline3 ='';
    
    public Static String Title_Holder4Name1 ='';
    public Static String Title_Holder4_Addline1 ='';
    public Static String Title_Holder4_Addline2 ='';
    public Static String Title_Holder4_Addline3 ='';
    
    public Static String Title_Holder5Name1 ='';
    public Static String Title_Holder5_Addline1 ='';
    public Static String Title_Holder5_Addline2 ='';
    public Static String Title_Holder5_Addline3 ='';
    
    public Static String Title_Holder6Name1 ='';
    public Static String Title_Holder6_Addline1 ='';
    public Static String Title_Holder6_Addline2 ='';
    public Static String Title_Holder6_Addline3 ='';
    
    public Static String Title_Holder7Name1 ='';
    public Static String Title_Holder7_Addline1 ='';
    public Static String Title_Holder7_Addline2 ='';
    public Static String Title_Holder7_Addline3 ='';
    
    public Static String Title_Holder8Name1 ='';
    public Static String Title_Holder8_Addline1 ='';
    public Static String Title_Holder8_Addline2 ='';
    public Static String Title_Holder8_Addline3 ='';
    
    public Static String Title_Holder9Name1 ='';
    public Static String Title_Holder9_Addline1 ='';
    public Static String Title_Holder9_Addline2 ='';
    public Static String Title_Holder9_Addline3 ='';
    
    public Static String Title_Holder10Name1 ='';
    public Static String Title_Holder10_Addline1 ='';
    public Static String Title_Holder10_Addline2 ='';
    public Static String Title_Holder10_Addline3 ='';
    
    public Static String Title_Holder11Name1 ='';
    public Static String Title_Holder11_Addline1 ='';
    public Static String Title_Holder11_Addline2 ='';
    public Static String Title_Holder11_Addline3 ='';
    
    public Static String Title_Holder12Name1 ='';
    public Static String Title_Holder12_Addline1 ='';
    public Static String Title_Holder12_Addline2 ='';
    public Static String Title_Holder12_Addline3 ='';
    
    public Static String Title_Holder13Name1 ='';
    public Static String Title_Holder13_Addline1 ='';
    public Static String Title_Holder13_Addline2 ='';
    public Static String Title_Holder13_Addline3 ='';
    
    public Static String Title_Holder14Name1 ='';
    public Static String Title_Holder14_Addline1 ='';
    public Static String Title_Holder14_Addline2 ='';
    public Static String Title_Holder14_Addline3 ='';
    
    public Static String Title_Holderdetails =''; 
    public Static String GuarantorNames =''; 
    public Static String Guarantor1Names =''; 
    public Static String Guarantor2Names ='';
    public Static String Guarantor3Names ='';
    public Static String Guarantor4Names ='';
    public Static String Guarantor5Names ='';
    public Static String Guarantor6Names ='';
    public Static String Guarantor7Names ='';
    public Static String Guarantor8Names ='';
    public Static String Guarantor9Names ='';
    public Static String Guarantor10Names ='';    
    public Static String GuarantorDetails ='';
    //public Static String BorrowerDetails = '';
    public Static String Title_HolderAddress ='';
    public Static String documentName ='';
    public Static String Title_Holder1_Name1='';
    public Static String Title_Holder2_Name1='';
    public Static String Title_Holder3_Name1='';
    public Static String Title_Holder4_Name1='';
    public Static String Title_Holder5_Name1='';
    public Static String Title_Holder6_Name1='';
    public Static String Title_Holder7_Name1='';
    
    
    
    //LAP A23
    public Static string Loc_Ref_Branch            = '';
    public Static string Borrower_Details          = '';
    public Static string Ap_LT                     = '';
    public Static string Ap_LT_inwords             = '';
    public Static string Int_ROI                   = '';
    public Static string MCLR_Rate                 = '';
    public Static string Variance                  = '';
    public Static string PreClosure_Charges        = '';
    public Static string Penal_Interest            = '';
    public Static string Loan_tenor                = '';
    public Static string DD_FI                     = '';
    public Static string DD_LI                     = '';
    public Static string Property_Nature1          = '';
    public Static string Nature_Property1          = '';
    public Static string Property_Nature2          = '';
    public Static string Property_Nature3          = '';
    public Static string Property_Nature4          = '';
    public Static string Property_Nature5          = '';
    public Static string Disb_Ref_Day              = '';
    public Static string Disb_Ref_Month            = '';
    public Static string Disb_Ref_Year             = '';
    public Static string Survey_No_1               = '';
    public Static string Survey_No_2               = '';
    public Static string Survey_No_3               = '';
    public Static string Survey_No_4               = '';
    public Static string Survey_No_5               = '';
    public Static string Plot_Door_Bungalow_No_1   = '';
    public Static string Plot_Door_Bungalow_No_2   = '';
    public Static string Plot_Door_Bungalow_No_3   = '';
    public Static string Plot_Door_Bungalow_No_4   = '';
    public Static string Plot_Door_Bungalow_No_5   = '';
    public Static string Extent_Site_Uds_1         = '';
    public Static string Extent_Site_Uds_2         = '';
    public Static string Extent_Site_Uds_3         = '';
    public Static string Extent_Site_Uds_4         = '';
    public Static string Extent_Site_Uds_5         = '';
    public Static string Extent_Site_Uds           = '';
    public Static string Built_up_area_1           = '';
    public Static string Built_up_area_2           = '';
    public Static string Built_up_area_3           = '';
    public Static string Built_up_area_4           = '';
    public Static string Built_up_area_5           = '';
    public Static string Built_up_area              = '';
    public Static string Floor_No_1                    = '';
    public Static string Floor_No_2                    = '';
    public Static string Floor_No_3                    = '';
    public Static string Floor_No_4                    = '';
    public Static string Floor_No_5                    = '';
    public Static string Ward_No_1                     = '';
    public Static string Ward_No_2                     = '';
    public Static string Ward_No_3                     = '';
    public Static string Ward_No_4                     = '';
    public Static string Ward_No_5                     = '';
    public Static string Building_Society_Name_No_1    = '';
    public Static string Building_Society_Name_No_2    = '';
    public Static string Building_Society_Name_No_3    = '';
    public Static string Building_Society_Name_No_4    = '';
    public Static string Building_Society_Name_No_5    = '';
    public Static string Street_Name_1                 = '';
    public Static string Street_Name_2                 = '';
    public Static string Street_Name_3                 = '';
    public Static string Street_Name_4                 = '';
    public Static string Street_Name_5                 = '';
    public Static string Village_Town_1                = '';
    public Static string Village_Town_2                = '';
    public Static string Village_Town_3                = '';
    public Static string Village_Town_4                = '';
    public Static string Village_Town_5                = '';
    public Static string Taluka_Tehsil_1               = '';
    public Static string Taluka_Tehsil_2               = '';
    public Static string Taluka_Tehsil_3               = '';
    public Static string Taluka_Tehsil_4               = '';
    public Static string Taluka_Tehsil_5               = '';
    public Static string District_Name_1               = '';
    public Static string District_Name_2               = '';
    public Static string District_Name_3               = '';
    public Static string District_Name_4               = '';
    public Static string District_Name_5               = '';
    public Static string State_Name_1                  = '';
    public Static string State_Name_2                  = '';
    public Static string State_Name_3                  = '';
    public Static string State_Name_4                  = '';
    public Static string State_Name_5                  = '';
    public Static string PIN_CODE_1                    = '';
    public Static string PIN_CODE_2                    = '';
    public Static string PIN_CODE_3                    = '';
    public Static string PIN_CODE_4                    = '';
    public Static string PIN_CODE_5                    = '';
    public Static string Extent_Site_Ud_1               = '';
    public Static string Extent_Site_Ud_2               = '';
    public Static string Extent_Site_Ud_3               = '';
    public Static string Extent_Site_Ud_4               = '';
    public Static string Extent_Site_Ud_5               = '';
    public Static string Nature_Property_1              = '';
    public Static string Nature_Property_2              = '';
    public Static string Nature_Property_3              = '';
    public Static string Nature_Property_4              = '';
    public Static string Nature_Property_5              = '';
    
    //LAP A46
    public Static string Guarantor_Details       = '';
    public Static string Borrower_Names          = '';
    public Static string Loan_Product            = '';
    public Static string Guarantor1_Names        = '';
    public Static string Guarantor2_Names        = '';
    public Static string Guarantor3_Names        = '';
    public Static string Guarantor4_Names        = '';
    public Static string Guarantor5_Names        = '';
    public Static string Guarantor6_Names        = '';
    public Static string esign1                  = '';
    public Static string esign2                  = '';
    public Static string esign3                  = '';
    public Static string esign4                  = '';
    public Static string esign5                  = '';
    public Static string Auth_Sign_Bnk           = '';
    public Static string Processing_charges      = '';
    public Static string Sr_No_1                = '';
    public Static string Doc_No_1               ='';
    public Static string Doc_Dt_1           ='';
    public Static string Doc_Nature_1       ='';
    public Static string Transferor_1       ='';
    public Static string Transferee_1       ='';
    
    //V1.2:HL MVP2
    public Static String Borrower1Type = '';
    public Static String Borrower2Type = '';
    public Static String Borrower3Type = '';
    public Static String Borrower4Type = '';

    public static List<Account> accList;
    public class EstampResponse{  
        public String file_content;                   
        public String code;
        public String message;
        public String AppID;
    }
    
    public static DMS_Structure.EStampResponse createDoc(genesis__Applications__c application , String DocName,string AcceToken,string stampState){
        try{
            RETURN createDocnew(application , null,null, DocName,AcceToken, stampState);
            
        }catch(Exception e){
            System.debug('##### estamp exception '+ e.getMessage() +' ' +e.getLineNumber());
            return null;
        }
    }
    
    public static DMS_Structure.EStampResponse createDocnew(genesis__Applications__c application,clcommon__Collateral__c col,List<Ownership__c> owenerList,String DocName,string AcceToken,string stampState){
        try{ 
            
            Set<Id> accIdSet = new Set<Id>();
            
            accList = new List<Account>();
            if(application.Record_Type_Name__c == Constants.LAPLOAN){
                //accIdSet.add(application.genesis__Account__c);
                if(owenerList.size()>0){
                    for(Ownership__c ownerShip : owenerList){
                        accIdSet.add(ownerShip.Account__c);
                    }
                }
            }
            if(accIdSet.Size() > 0){
                for(Account accRec:[SELECT Id,Name,Full_Name__c,Aadhaar_Number__pc,PersonMobilePhone,PersonMailingStreet,PersonMailingCity,PersonMailingState FROM Account WHERE Id IN : accIdSet]){
                    accList.add(accRec);
                }
            }
            List<clcommon__Collateral__c> colList = new List<clcommon__Collateral__c>();
            if(application.Record_Type_Name__c == Constants.LAPLOAN)
                for(clcommon__Collateral__c colrec:[SELECT id,Name,SurveyKhasraKhataPatta_No__c,Collateral_Type__c,EM_Charge_type__c,Nature_of_Property__c,PlotDoorShopBungalow_No__c,Buildup_Area__c,ExtentCarpet_area_Built_up_area__c,Floor_No__c,Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,VillageTown__c,TalukaTehsil__c,District_Name__c,State__c,Property_Pincode__c,Total_Market_value__c,clcommon__City__c,clcommon__Postal_Code__c,Building_Name__c,Valuation_Date__c FROM clcommon__Collateral__c WHERE Active__c = true AND genesis__Application__c =:application.Id]){
                    colList.add(colrec);
                }
            String TemplateID = '';
            String TempUID = '';
            string DocCateg='';
            Decimal stampCharge = 0.00;
            integer dis = (30 * (application.Sanctioned_Tenure__c != null ? Integer.ValueOf(application.Sanctioned_Tenure__c) : 0));
            
            
            List<Stamping_Charges__mdt> stampChargeAmt =[Select ID,MasterLabel,Declaration_Of_Title_Mortgage__c,Declaration_of_Original_Mortgage__c,
                                                         Create_Mortgage_Charges__c,Vehicle_Loan_Agreement__c,Personal_Loan_Agreement__c,LAP_B1_Stamp_Charge_Amount__c,Housing_Loan_Agreement__c,Agreement_of_Guarantee__c,HL_TopUp_A66__c,HL_TakeOver_A54__c 
                                                         From Stamping_Charges__mdt Where MasterLabel =:stampState Limit 1];
            
            if(application.Record_Type_Name__c == Constants.LAPLOAN || application.Record_Type_Name__c == Constants.HOMELOAN || application.Record_Type_Name__c == Constants.VL4W || application.Record_Type_Name__c == Constants.VL2W){
                createVal(application);
            }
            if(stampChargeAmt.size()>0){
                if(DocName == Constants.A23_HL ){
                    stampCharge = stampChargeAmt[0].Housing_Loan_Agreement__c;
                }
                else if(DocName == Constants.LAP_A23){
                    stampCharge = stampChargeAmt[0].Housing_Loan_Agreement__c;
                }
                else if(DocName == Constants.A46_HL){
                    stampCharge = stampChargeAmt[0].Agreement_of_Guarantee__c;
                }
                else if(DocName == Constants.LAP_A46){
                    stampCharge = stampChargeAmt[0].Agreement_of_Guarantee__c;
                }
                else if(DocName == Constants.B1_HL){
                    stampCharge = stampChargeAmt[0].Declaration_Of_Title_Mortgage__c;
                }
                else if(DocName == Constants.LAP_B1){
                    stampCharge = stampChargeAmt[0].Declaration_Of_Title_Mortgage__c;
                }
                else if(DocName == Constants.B2_HL){
                    stampCharge = stampChargeAmt[0].Declaration_of_Original_Mortgage__c;
                }
                else if(DocName == Constants.B17_HL){
                    stampCharge = stampChargeAmt[0].Create_Mortgage_Charges__c;
                }else if(DocName == Constants.PL_AGREEMENT_DOC){
                    stampCharge = stampChargeAmt[0].Personal_Loan_Agreement__c;
                }else if(DocName == Constants.VLHYPOTHECATIONLD){
                    stampCharge = stampChargeAmt[0].Vehicle_Loan_Agreement__c;
                }else if(DocName == Constants.HL_Topup_A66){//V1.2
                    stampCharge = stampChargeAmt[0].HL_TopUp_A66__c;
                }else if(DocName == Constants.HL_Takeover_A54){//V1.2
                    stampCharge = stampChargeAmt[0].HL_TakeOver_A54__c;
                }
                System.debug('##DataLog### --- > '+ stampCharge);
            }
            DocCateg=System.label.Legal_Desk_Doc_Cat1;
            if(DocName == Constants.A23_HL ){
                DIGIO_Templates__c objGame = DIGIO_Templates__c.getValues(DocName);                
                TemplateID = objGame.Template_Unique_Id__c;
                TempUID = objGame.UID__c;                    
            }
            else if(DocName == Constants.LAP_A23){
                DIGIO_Templates__c objGame = DIGIO_Templates__c.getValues(DocName);                
                TemplateID = objGame.Template_Unique_Id__c;
                TempUID = objGame.UID__c;         
            }
            else if(DocName == Constants.A46_HL){
                DIGIO_Templates__c objGame = DIGIO_Templates__c.getValues(DocName);                
                TemplateID = objGame.Template_Unique_Id__c;
                TempUID = objGame.UID__c;                    
            }
            else if(DocName == Constants.LAP_A46){
                DIGIO_Templates__c objGame = DIGIO_Templates__c.getValues(DocName);                
                 TempUID = objGame.UID__c;         
                
            }
            else if(DocName == Constants.LAP_B1){
                DIGIO_Templates__c objGame = DIGIO_Templates__c.getValues(DocName);                
                TemplateID = objGame.Template_Unique_Id__c;
                TempUID = objGame.UID__c;  
                DocCateg=System.label.Legal_Desk_Doc_Cat8;
            }
            else if(DocName == Constants.B1_HL){
                DIGIO_Templates__c objGame = DIGIO_Templates__c.getValues(DocName);                
                TemplateID = objGame.Template_Unique_Id__c;
                TempUID = objGame.UID__c;  
                DocCateg=System.label.Legal_Desk_Doc_Cat8;
            }
            else if(DocName == Constants.B2_HL){
                DIGIO_Templates__c objGame = DIGIO_Templates__c.getValues(DocName);                
                TemplateID = objGame.Template_Unique_Id__c;
                TempUID = objGame.UID__c; 
                DocCateg=System.label.Legal_Desk_Doc_Cat8;
            }
            else if(DocName == Constants.B17_HL){
                DIGIO_Templates__c objGame = DIGIO_Templates__c.getValues(DocName);                
                TemplateID = objGame.Template_Unique_Id__c;
                TempUID = objGame.UID__c;                    
            }else if(DocName == Constants.PL_AGREEMENT_DOC){
                DIGIO_Templates__c objGame = DIGIO_Templates__c.getValues(DocName);                
                TemplateID = objGame.Template_Unique_Id__c;
                TempUID = objGame.UID__c;   
            }else if(DocName == Constants.VLHYPOTHECATIONLD){
                DIGIO_Templates__c objGame = DIGIO_Templates__c.getValues(DocName);                
                TemplateID = objGame.Template_Unique_Id__c;
                TempUID = objGame.UID__c;   
            }  else if(DocName == Constants.HL_Topup_A66){//V1.2
                DIGIO_Templates__c objGame = DIGIO_Templates__c.getValues(DocName);                
                TemplateID = objGame.Template_Unique_Id__c;
                TempUID = objGame.UID__c;   
            }else if(DocName == Constants.HL_Takeover_A54){//V1.2
                DIGIO_Templates__c objGame = DIGIO_Templates__c.getValues(DocName);                
                TemplateID = objGame.Template_Unique_Id__c;
                TempUID = objGame.UID__c;
            }          
            
            Estamp_HelperStructure.Estamp eStampSerObj                      =   new Estamp_HelperStructure.Estamp();
            eStampSerObj.ReferenceID                                        =   CreateUniqueId.uniqID();
            eStampSerObj.ApplicationID                                      =   application.Id;
            eStampSerObj.TemplateID                                         =   TemplateID; //A23;//'5a4e0bd91c32160854d5c687'; //TemplateID//Document Template ID
            eStampSerObj.StampPaperData                                     =   new Estamp_HelperStructure.StampPaperData();
            eStampSerObj.uuid                                               = '';
            //DMS Tags 
            eStampSerObj.metadata.applicationType                           = application.RecordType_Developer_Name__c;
            eStampSerObj.metadata.customerId                           		= '1';
            eStampSerObj.metadata.documentType                           	= 'DocName';
            eStampSerObj.metadata.accountNumbers                            = '1';
            eStampSerObj.metadata.applicationId                             = application.Id;
            
            //Adding Stamp Paper Data               
            eStampSerObj.StampPaperData.FirstParty                          = 'First Party';
            eStampSerObj.StampPaperData.SecondParty                         = 'Second Party';
            eStampSerObj.StampPaperData.StampAmount                         = String.ValueOf(Integer.ValueOf(stampCharge));
            eStampSerObj.StampPaperData.StampDutyPaidBy                     = System.label.EstampDutyPaid; //'FirstParty';
            eStampSerObj.StampPaperData.DocumentCategory                    = DocCateg;
            eStampSerObj.StampPaperData.UID                                 = TempUID;
            eStampSerObj.StampPaperData.StampState                          = stampState;
            
            eStampSerObj.FormData                                           =   new Estamp_HelperStructure.FormData();
            
            if(application.Record_Type_Name__c == Constants.LAPLOAN){               
                if(colList.size()>0){
                    eStampSerObj.FormData.Nature_Property_1                            = Utility.getBlankStringIfNull(colList[0].Collateral_Type__c);
                    eStampSerObj.FormData.Survey_No_1                                 = Utility.getBlankStringIfNull(colList[0].SurveyKhasraKhataPatta_No__c);
                    eStampSerObj.FormData.Plot_Door_Bungalow_No_1                     = Utility.getBlankStringIfNull(colList[0].PlotDoorShopBungalow_No__c);
                    eStampSerObj.FormData.Extent_Site_Uds_1                           =  Utility.getBlankStringIfNull(String.valueOf(colList[0].ExtentCarpet_area_Built_up_area__c));
                    eStampSerObj.FormData.Built_up_area_1                             = Utility.getBlankStringIfNull(String.valueOf(colList[0].Buildup_Area__c));
                    eStampSerObj.FormData.Floor_No_1                                  = Utility.getBlankStringIfNull(colList[0].Floor_No__c);
                    eStampSerObj.FormData.Ward_No_1                                   = Utility.getBlankStringIfNull(colList[0].Stage_Sector_Ward_Block_No__c);
                    eStampSerObj.FormData.Building_Society_Name_No_1                  = Utility.getBlankStringIfNull(colList[0].Building_Society_Name__c);
                    eStampSerObj.FormData.Street_Name_1                               = Utility.getBlankStringIfNull(colList[0].Street_NameNo__c);
                    eStampSerObj.FormData.Village_Town_1                              = Utility.getBlankStringIfNull(colList[0].clcommon__City__c);
                    eStampSerObj.FormData.Taluka_Tehsil_1                             = Utility.getBlankStringIfNull(colList[0].TalukaTehsil__c);
                    eStampSerObj.FormData.District_Name_1                             = Utility.getBlankStringIfNull(colList[0].District_Name__c);
                    eStampSerObj.FormData.State_Name_1                                = Utility.getBlankStringIfNull(colList[0].State__c);
                    eStampSerObj.FormData.PIN_CODE_1                                  = Utility.getBlankStringIfNull(colList[0].Property_Pincode__c);
                }
                if(colList.size()>1){
                    eStampSerObj.FormData.Nature_Property_2                            = Utility.getBlankStringIfNull(colList[1].Collateral_Type__c);
                    eStampSerObj.FormData.Survey_No_2                                 = Utility.getBlankStringIfNull(colList[1].SurveyKhasraKhataPatta_No__c);
                    eStampSerObj.FormData.Plot_Door_Bungalow_No_2                     = Utility.getBlankStringIfNull(colList[1].PlotDoorShopBungalow_No__c);
                    eStampSerObj.FormData.Extent_Site_Uds_2                           = Utility.getBlankStringIfNull(colList[1].ExtentCarpet_area_Built_up_area__c);
                    eStampSerObj.FormData.Built_up_area_2                             = Utility.getBlankStringIfNull(String.valueOf(colList[1].Buildup_Area__c));
                    eStampSerObj.FormData.Floor_No_2                                  = Utility.getBlankStringIfNull(colList[1].Floor_No__c);
                    eStampSerObj.FormData.Ward_No_2                                   = Utility.getBlankStringIfNull(colList[1].Stage_Sector_Ward_Block_No__c);
                    eStampSerObj.FormData.Building_Society_Name_No_2                  = Utility.getBlankStringIfNull(colList[1].Building_Society_Name__c);
                    eStampSerObj.FormData.Street_Name_2                               = Utility.getBlankStringIfNull(colList[1].Street_NameNo__c);
                    eStampSerObj.FormData.Village_Town_2                              = Utility.getBlankStringIfNull(colList[1].clcommon__City__c);
                    eStampSerObj.FormData.Taluka_Tehsil_2                             = Utility.getBlankStringIfNull(colList[1].TalukaTehsil__c);
                    eStampSerObj.FormData.District_Name_2                             = Utility.getBlankStringIfNull(colList[1].District_Name__c);
                    eStampSerObj.FormData.State_Name_2                                = Utility.getBlankStringIfNull(colList[1].State__c);
                    eStampSerObj.FormData.PIN_CODE_2                                  = Utility.getBlankStringIfNull(colList[1].Property_Pincode__c);
                }
                if(colList.size()>2){
                    eStampSerObj.FormData.Nature_Property_3                            = Utility.getBlankStringIfNull(colList[2].Collateral_Type__c);
                    eStampSerObj.FormData.Survey_No_3                                 = Utility.getBlankStringIfNull(colList[2].SurveyKhasraKhataPatta_No__c);
                    eStampSerObj.FormData.Plot_Door_Bungalow_No_3                     = Utility.getBlankStringIfNull(colList[2].PlotDoorShopBungalow_No__c);
                    eStampSerObj.FormData.Extent_Site_Uds_3                           = Utility.getBlankStringIfNull(colList[2].ExtentCarpet_area_Built_up_area__c);
                    eStampSerObj.FormData.Built_up_area_3                             = Utility.getBlankStringIfNull(String.valueOf(colList[2].Buildup_Area__c));
                    eStampSerObj.FormData.Floor_No_3                                  = Utility.getBlankStringIfNull(colList[2].Floor_No__c);
                    eStampSerObj.FormData.Ward_No_3                                   = Utility.getBlankStringIfNull(colList[2].Stage_Sector_Ward_Block_No__c);
                    eStampSerObj.FormData.Building_Society_Name_No_3                  = Utility.getBlankStringIfNull(colList[2].Building_Society_Name__c);
                    eStampSerObj.FormData.Street_Name_3                               = Utility.getBlankStringIfNull(colList[2].Street_NameNo__c);
                    eStampSerObj.FormData.Village_Town_3                              = Utility.getBlankStringIfNull(colList[2].clcommon__City__c);
                    eStampSerObj.FormData.Taluka_Tehsil_3                             = Utility.getBlankStringIfNull(colList[2].TalukaTehsil__c);
                    eStampSerObj.FormData.District_Name_3                             = Utility.getBlankStringIfNull(colList[2].VillageTown__c);
                    eStampSerObj.FormData.State_Name_3                                = Utility.getBlankStringIfNull(colList[2].State__c);
                    eStampSerObj.FormData.PIN_CODE_3                                  = Utility.getBlankStringIfNull(colList[2].Property_Pincode__c);
                }
                if(colList.size()>3){
                    eStampSerObj.FormData.Nature_Property_4                            = Utility.getBlankStringIfNull(colList[3].Collateral_Type__c);
                    eStampSerObj.FormData.Survey_No_4                                 = Utility.getBlankStringIfNull(colList[3].SurveyKhasraKhataPatta_No__c);
                    eStampSerObj.FormData.Plot_Door_Bungalow_No_4                     = Utility.getBlankStringIfNull(colList[3].PlotDoorShopBungalow_No__c);
                    eStampSerObj.FormData.Extent_Site_Uds_4                           = Utility.getBlankStringIfNull(colList[3].ExtentCarpet_area_Built_up_area__c);
                    eStampSerObj.FormData.Built_up_area_4                             = Utility.getBlankStringIfNull(String.valueOf(colList[3].Buildup_Area__c));
                    eStampSerObj.FormData.Floor_No_4                                  = Utility.getBlankStringIfNull(colList[3].Floor_No__c);
                    eStampSerObj.FormData.Ward_No_4                                   = Utility.getBlankStringIfNull(colList[3].Stage_Sector_Ward_Block_No__c);
                    eStampSerObj.FormData.Building_Society_Name_No_4                  = Utility.getBlankStringIfNull(colList[3].Building_Society_Name__c);
                    eStampSerObj.FormData.Street_Name_4                               = Utility.getBlankStringIfNull(colList[3].Street_NameNo__c);
                    eStampSerObj.FormData.Village_Town_4                              = Utility.getBlankStringIfNull(colList[3].clcommon__City__c);
                    eStampSerObj.FormData.Taluka_Tehsil_4                             = Utility.getBlankStringIfNull(colList[3].TalukaTehsil__c);
                    eStampSerObj.FormData.District_Name_4                             = Utility.getBlankStringIfNull(colList[3].District_Name__c);
                    eStampSerObj.FormData.State_Name_4                                = Utility.getBlankStringIfNull(colList[3].State__c);
                    eStampSerObj.FormData.PIN_CODE_4                                  = Utility.getBlankStringIfNull(colList[3].Property_Pincode__c);
                }
                if(colList.size()>4){
                    eStampSerObj.FormData.Nature_Property_5                            = Utility.getBlankStringIfNull(colList[4].Collateral_Type__c);
                    eStampSerObj.FormData.Survey_No_5                                 = Utility.getBlankStringIfNull(colList[4].SurveyKhasraKhataPatta_No__c);
                    eStampSerObj.FormData.Plot_Door_Bungalow_No_5                     = Utility.getBlankStringIfNull(colList[4].PlotDoorShopBungalow_No__c);
                    eStampSerObj.FormData.Extent_Site_Uds_5                           = Utility.getBlankStringIfNull(colList[4].ExtentCarpet_area_Built_up_area__c);
                    eStampSerObj.FormData.Built_up_area_5                             = Utility.getBlankStringIfNull(String.valueOf(colList[4].Buildup_Area__c));
                    eStampSerObj.FormData.Floor_No_5                                  = Utility.getBlankStringIfNull(colList[4].Floor_No__c);
                    eStampSerObj.FormData.Ward_No_5                                   = Utility.getBlankStringIfNull(colList[4].Stage_Sector_Ward_Block_No__c);
                    eStampSerObj.FormData.Building_Society_Name_No_5                  = Utility.getBlankStringIfNull(colList[4].Building_Society_Name__c);
                    eStampSerObj.FormData.Street_Name_5                               = Utility.getBlankStringIfNull(colList[4].Street_NameNo__c);
                    eStampSerObj.FormData.Village_Town_5                              = Utility.getBlankStringIfNull(colList[4].clcommon__City__c);
                    eStampSerObj.FormData.Taluka_Tehsil_5                             = Utility.getBlankStringIfNull(colList[4].TalukaTehsil__c);
                    eStampSerObj.FormData.District_Name_5                             = Utility.getBlankStringIfNull(colList[4].District_Name__c);
                    eStampSerObj.FormData.State_Name_5                                = Utility.getBlankStringIfNull(colList[4].State__c);
                    eStampSerObj.FormData.PIN_CODE_5                                  = Utility.getBlankStringIfNull(colList[4].Property_Pincode__c);
                }
                eStampSerObj.FormData.Nature_Property                           = Utility.getBlankStringIfNull(col.Collateral_Type__c);
                eStampSerObj.FormData.Survey_No                                 = Utility.getBlankStringIfNull(col.SurveyKhasraKhataPatta_No__c);
                eStampSerObj.FormData.Plot_Door_Bungalow_No                     = Utility.getBlankStringIfNull(col.PlotDoorShopBungalow_No__c);
                eStampSerObj.FormData.Extent_Site_Uds                           = Utility.getBlankStringIfNull(col.ExtentCarpet_area_Built_up_area__c);
                eStampSerObj.FormData.Built_up_area                             = Utility.getBlankStringIfNull(String.valueOf(col.Buildup_Area__c));
                eStampSerObj.FormData.Floor_No                                  = Utility.getBlankStringIfNull(col.Floor_No__c);
                eStampSerObj.FormData.Ward_No                                   = Utility.getBlankStringIfNull(col.Stage_Sector_Ward_Block_No__c);
                eStampSerObj.FormData.Building_Society_Name_No                  = Utility.getBlankStringIfNull(col.Building_Society_Name__c);
                eStampSerObj.FormData.Street_Name                               = Utility.getBlankStringIfNull(col.Street_NameNo__c);
                eStampSerObj.FormData.Village_Town                              = Utility.getBlankStringIfNull(col.clcommon__City__c);
                eStampSerObj.FormData.Taluka_Tehsil                             = Utility.getBlankStringIfNull(col.TalukaTehsil__c);
                eStampSerObj.FormData.District_Name                             = Utility.getBlankStringIfNull(col.District_Name__c);
                eStampSerObj.FormData.State_Name                                = Utility.getBlankStringIfNull(col.State__c);
                eStampSerObj.FormData.PIN_CODE                                  = Utility.getBlankStringIfNull(col.Property_Pincode__c);
            }

            // prashant singh on 16-11-2018----COLLATERAL STRUCTURE CHANGES
            else if(application.Record_Type_Name__c == Constants.HOMELOAN){  
                if(application.genesis__Collaterals__r!=null && application.genesis__Collaterals__r.size()>0)
                {
                    eStampSerObj.FormData.PIN_CODE =Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].Property_Pincode__c);
                    eStampSerObj.FormData.Village_Town=Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].clcommon__City__c);
                    eStampSerObj.FormData.State_Name  =Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].State__c);
                    eStampSerObj.FormData.District_Name=Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].District_Name__c);
                    eStampSerObj.FormData.Taluka_Tehsil=Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].TalukaTehsil__c); 
                    eStampSerObj.FormData.Street_Name=Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].Street_NameNo__c);
                    eStampSerObj.FormData.Building_Society_Name_No=Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].Building_Society_Name__c);
                    eStampSerObj.FormData.Ward_No=Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].Stage_Sector_Ward_Block_No__c); 
                    eStampSerObj.FormData.Survey_No =Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].SurveyKhasraKhataPatta_No__c);
                    eStampSerObj.FormData.Nature_Property=Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].Nature_Of_Property__c);
                    eStampSerObj.FormData.Seller_Name                               = Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].Builder_Present_Owner_Seller_Name__c);
                    eStampSerObj.FormData.Site_Extent                              = Utility.getBlankStringIfNull(string.valueOf(application.genesis__Collaterals__r[0].Area_of_the_Land__c));
                    eStampSerObj.FormData.Plot_Door_Bungalow_No                     = Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].Flat_Door_Shop_Bungalow_Nos__c);
                    eStampSerObj.FormData.Floor_No                                  = Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].Floor_No__c);
                    
                    if(application.Loan_Purpose__c==Constants.Construction || application.Loan_Purpose__c==Constants.ConstructionOn){
                        eStampSerObj.FormData.Built_up_area=Utility.getBlankStringIfNull(String.ValueOf(application.genesis__Collaterals__r[0].Buildup_Area__c)); 
                    }
                    else{
                        eStampSerObj.FormData.Built_up_area=Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].ExtentCarpet_area_Built_up_area__c);
                    }
                    String Ptype='';
                    if(application.genesis__Collaterals__r[0].clcommon__Property_Type__c == 'Flat'){
                        Ptype = Utility.getBlankStringIfNull(String.ValueOf(application.genesis__Collaterals__r[0].UDS_Sq_Ft__c));
                    }else{
                        Ptype = Utility.getBlankStringIfNull(String.ValueOf(application.genesis__Collaterals__r[0].Area_of_the_Land__c));
                    }
                    eStampSerObj.FormData.Extent_Site_Uds = Ptype;
                    //V1.2(start)
                    if (application.Sub_Type__c == Constants.Sub_Type_Top_Up) {
                        eStampSerObj.FormData.East_collateral = Utility.getBlankStringIfNull(String.ValueOf(application.genesis__Collaterals__r[0].Boundaries_East__c));
                        eStampSerObj.FormData.West_collateral = Utility.getBlankStringIfNull(String.ValueOf(application.genesis__Collaterals__r[0].Boundaries_West__c));
                        eStampSerObj.FormData.North_collateral = Utility.getBlankStringIfNull(String.ValueOf(application.genesis__Collaterals__r[0].Boundaries_North__c));
                        eStampSerObj.FormData.South_collateral = Utility.getBlankStringIfNull(String.ValueOf(application.genesis__Collaterals__r[0].Boundaries_South__c));
                    }
                    //V1.2(end)
                }   
            }
            // prashant singh ends---COLLATERAL STRUCTURE CHANGES
            
            //Same code for all
            eStampSerObj.FormData.Disb_Ref_Day                              = System.now().format('dd');
            eStampSerObj.FormData.Disb_Ref_Month                            = System.now().format('MMMM');
            eStampSerObj.FormData.Disb_Ref_Year                             = System.now().format('yyyy');

            eStampSerObj.FormData.Loc_Ref_Branch                            = Utility.getBlankStringIfNull(application.Branch_Name__c);
            eStampSerObj.FormData.Borrower_Details                          = (application.genesis__Account__r.Full_Name__c != null ? application.genesis__Account__r.Full_Name__c :'') + (Borrower2Names != '' ? ' & '+Borrower2Names :'') + (Borrower3Names != '' ? ' & '+Borrower3Names :'') + (Borrower4Names != '' ? ' & '+Borrower4Names :'');
            if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
                eStampSerObj.FormData.Borrower_Details  = eStampSerObj.FormData.Borrower_Details + ', S/W/D of ' + application.genesis__Account__r.Father_Husband_Daughter_Name__c + ', aged about ' + application.genesis__Account__r.Age__c + ',  residing at ' + application.genesis__Account__r.PersonOtherStreet + ' ';
            }
            eStampSerObj.FormData.Loan_Product                              = Utility.getBlankStringIfNull(application.genesis__CL_Product_Name__c);
            eStampSerObj.FormData.Advance_Amount                            = Utility.getBlankStringIfNull(String.ValueOf(application.Advance_Payment_Made_If_Any__c));
            eStampSerObj.FormData.Sale_Agreem_Date                          = Utility.getBlankStringIfNull(String.valueOf(application.Date_Of_Sale_Agreement__c));
            
            if(application.Record_Type_Name__c == Constants.LAPLOAN){
                //List iteration
                eStampSerObj.FormData.Title_deed_deposited_date = Utility.getBlankStringIfNull(String.valueOf(application.MOD_Date__c));
                if(accList.size()>0){
                    for(Integer i = 0 ; i < accList.size() ; i++){
                        if(i == 0){
                            eStampSerObj.FormData.Title_Holder1_Name1     = Utility.getBlankStringIfNull(accList.get(i).Full_Name__c);
                            Title_Holder1_Name1 = Utility.getBlankStringIfNull(accList.get(i).Full_Name__c);
                            eStampSerObj.FormData.Title_Holder1_Add_line1 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingStreet);
                            eStampSerObj.FormData.Title_Holder1_Add_line2 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingCity);
                            eStampSerObj.FormData.Title_Holder1_Add_line3 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingState);
                        }
                        else if(i == 1){
                            eStampSerObj.FormData.Title_Holder2_Name1     = Utility.getBlankStringIfNull(accList.get(i).Full_Name__c);
                            Title_Holder2_Name1 = Utility.getBlankStringIfNull(accList.get(i).Full_Name__c);
                            eStampSerObj.FormData.Title_Holder2_Add_line1 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingStreet);
                            eStampSerObj.FormData.Title_Holder2_Add_line2 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingCity);
                            eStampSerObj.FormData.Title_Holder2_Add_line3 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingState);
                        }
                        else if(i == 2){
                            eStampSerObj.FormData.Title_Holder3_Name1     = Utility.getBlankStringIfNull(accList.get(i).Full_Name__c);
                            Title_Holder3_Name1 = Utility.getBlankStringIfNull(accList.get(i).Full_Name__c);
                            eStampSerObj.FormData.Title_Holder3_Add_line1 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingStreet);
                            eStampSerObj.FormData.Title_Holder3_Add_line2 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingCity);
                            eStampSerObj.FormData.Title_Holder3_Add_line3 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingState); 
                        }
                        else if(i == 3){
                            eStampSerObj.FormData.Title_Holder4_Name1     = Utility.getBlankStringIfNull(accList.get(i).Full_Name__c);
                            Title_Holder4_Name1 = Utility.getBlankStringIfNull(accList.get(i).Full_Name__c);
                            eStampSerObj.FormData.Title_Holder4_Add_line1 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingStreet);
                            eStampSerObj.FormData.Title_Holder4_Add_line2 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingCity);
                            eStampSerObj.FormData.Title_Holder4_Add_line3 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingState);
                        }
                        else if(i == 4){
                            eStampSerObj.FormData.Title_Holder5_Name1     = Utility.getBlankStringIfNull(accList.get(i).Full_Name__c);
                            Title_Holder5_Name1 = Utility.getBlankStringIfNull(accList.get(i).Full_Name__c);
                            eStampSerObj.FormData.Title_Holder5_Add_line1 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingStreet);
                            eStampSerObj.FormData.Title_Holder5_Add_line2 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingCity);
                            eStampSerObj.FormData.Title_Holder5_Add_line3 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingState);
                        }
                        else if(i == 5){
                            eStampSerObj.FormData.Title_Holder6_Name1     = Utility.getBlankStringIfNull(accList.get(i).Full_Name__c);
                            Title_Holder6_Name1 = Utility.getBlankStringIfNull(accList.get(i).Full_Name__c);
                            eStampSerObj.FormData.Title_Holder6_Add_line1 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingStreet);
                            eStampSerObj.FormData.Title_Holder6_Add_line2 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingCity);
                            eStampSerObj.FormData.Title_Holder6_Add_line3 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingState);
                        }
                        else if(i == 6){
                            eStampSerObj.FormData.Title_Holder7_Name1     = Utility.getBlankStringIfNull(accList.get(i).Full_Name__c);
                            Title_Holder7_Name1 = Utility.getBlankStringIfNull(accList.get(i).Full_Name__c);
                            eStampSerObj.FormData.Title_Holder7_Add_line1 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingStreet);
                            eStampSerObj.FormData.Title_Holder7_Add_line2 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingCity);
                            eStampSerObj.FormData.Title_Holder7_Add_line3 = Utility.getBlankStringIfNull(accList.get(i).PersonMailingState);
                        }
                    }
                }
                eStampSerObj.FormData.Doc_Gen_date            = formatDate(System.today()); //date field
            } else{
                eStampSerObj.FormData.Doc_Gen_date            = formatDate(System.today()); //date field
                eStampSerObj.FormData.Title_Holder1_Name1     = Utility.getBlankStringIfNull(Title_Holder1Name1);
                eStampSerObj.FormData.Title_Holder1_Add_line1 = Utility.getBlankStringIfNull(Title_Holder1_Addline1);
                eStampSerObj.FormData.Title_Holder1_Add_line2 = Utility.getBlankStringIfNull(Title_Holder1_Addline2);
                eStampSerObj.FormData.Title_Holder1_Add_line3 = Utility.getBlankStringIfNull(Title_Holder1_Addline3);
                eStampSerObj.FormData.Title_Holder2_Name1     = Utility.getBlankStringIfNull(Title_Holder2Name1);
                eStampSerObj.FormData.Title_Holder2_Add_line1 = Utility.getBlankStringIfNull(Title_Holder2_Addline1);
                eStampSerObj.FormData.Title_Holder2_Add_line2 = Utility.getBlankStringIfNull(Title_Holder2_Addline2);
                eStampSerObj.FormData.Title_Holder2_Add_line3 = Utility.getBlankStringIfNull(Title_Holder2_Addline3);
                eStampSerObj.FormData.Title_Holder3_Name1     = Utility.getBlankStringIfNull(Title_Holder3Name1);
                eStampSerObj.FormData.Title_Holder3_Add_line1 = Utility.getBlankStringIfNull(Title_Holder3_Addline1);
                eStampSerObj.FormData.Title_Holder3_Add_line2 = Utility.getBlankStringIfNull(Title_Holder3_Addline2);
                eStampSerObj.FormData.Title_Holder3_Add_line3 = Utility.getBlankStringIfNull(Title_Holder3_Addline3);
                eStampSerObj.FormData.Title_Holder4_Name1     = Utility.getBlankStringIfNull(Title_Holder4Name1);
                eStampSerObj.FormData.Title_Holder4_Add_line1 = Utility.getBlankStringIfNull(Title_Holder4_Addline1);
                eStampSerObj.FormData.Title_Holder4_Add_line2 = Utility.getBlankStringIfNull(Title_Holder4_Addline2);
                eStampSerObj.FormData.Title_Holder4_Add_line3 = Utility.getBlankStringIfNull(Title_Holder4_Addline3);
                eStampSerObj.FormData.Title_Holder5_Name1     = Utility.getBlankStringIfNull(Title_Holder5Name1);
                eStampSerObj.FormData.Title_Holder5_Add_line1 = Utility.getBlankStringIfNull(Title_Holder5_Addline1);
                eStampSerObj.FormData.Title_Holder5_Add_line2 = Utility.getBlankStringIfNull(Title_Holder5_Addline2);
                eStampSerObj.FormData.Title_Holder5_Add_line3 = Utility.getBlankStringIfNull(Title_Holder5_Addline3);
                
                eStampSerObj.FormData.Title_Holder6_Name1     = Utility.getBlankStringIfNull(Title_Holder6Name1);
                eStampSerObj.FormData.Title_Holder6_Add_line1 = Utility.getBlankStringIfNull(Title_Holder6_Addline1);
                eStampSerObj.FormData.Title_Holder6_Add_line2 = Utility.getBlankStringIfNull(Title_Holder6_Addline2);
                eStampSerObj.FormData.Title_Holder6_Add_line3 = Utility.getBlankStringIfNull(Title_Holder6_Addline3);
                
                eStampSerObj.FormData.Title_Holder7_Name1     = Utility.getBlankStringIfNull(Title_Holder7Name1);
                eStampSerObj.FormData.Title_Holder7_Add_line1 = Utility.getBlankStringIfNull(Title_Holder7_Addline1);
                eStampSerObj.FormData.Title_Holder7_Add_line2 = Utility.getBlankStringIfNull(Title_Holder7_Addline2);
                eStampSerObj.FormData.Title_Holder7_Add_line3 = Utility.getBlankStringIfNull(Title_Holder7_Addline3);
                
                eStampSerObj.FormData.Title_Holder8_Name1     = Utility.getBlankStringIfNull(Title_Holder8Name1);
                eStampSerObj.FormData.Title_Holder8_Add_line1 = Utility.getBlankStringIfNull(Title_Holder8_Addline1);
                eStampSerObj.FormData.Title_Holder8_Add_line2 = Utility.getBlankStringIfNull(Title_Holder8_Addline2);
                eStampSerObj.FormData.Title_Holder8_Add_line3 = Utility.getBlankStringIfNull(Title_Holder8_Addline3);
                
                eStampSerObj.FormData.Title_Holder9_Name1     = Utility.getBlankStringIfNull(Title_Holder9Name1);
                eStampSerObj.FormData.Title_Holder9_Add_line1 = Utility.getBlankStringIfNull(Title_Holder9_Addline1);
                eStampSerObj.FormData.Title_Holder9_Add_line2 = Utility.getBlankStringIfNull(Title_Holder9_Addline2);
                eStampSerObj.FormData.Title_Holder9_Add_line3 = Utility.getBlankStringIfNull(Title_Holder9_Addline3);
                
                eStampSerObj.FormData.Title_Holder10_Name1     = Utility.getBlankStringIfNull(Title_Holder10Name1);
                eStampSerObj.FormData.Title_Holder10_Add_line1 = Utility.getBlankStringIfNull(Title_Holder10_Addline1);
                eStampSerObj.FormData.Title_Holder10_Add_line2 = Utility.getBlankStringIfNull(Title_Holder10_Addline2);
                eStampSerObj.FormData.Title_Holder10_Add_line3 = Utility.getBlankStringIfNull(Title_Holder10_Addline3);
                
                eStampSerObj.FormData.Title_Holder11_Name1     = Utility.getBlankStringIfNull(Title_Holder11Name1);
                eStampSerObj.FormData.Title_Holder11_Add_line1 = Utility.getBlankStringIfNull(Title_Holder11_Addline1);
                eStampSerObj.FormData.Title_Holder11_Add_line2 = Utility.getBlankStringIfNull(Title_Holder11_Addline2);
                eStampSerObj.FormData.Title_Holder11_Add_line3 = Utility.getBlankStringIfNull(Title_Holder11_Addline3);
                
                eStampSerObj.FormData.Title_Holder12_Name1     = Utility.getBlankStringIfNull(Title_Holder12Name1);
                eStampSerObj.FormData.Title_Holder12_Add_line1 = Utility.getBlankStringIfNull(Title_Holder12_Addline1);
                eStampSerObj.FormData.Title_Holder12_Add_line2 = Utility.getBlankStringIfNull(Title_Holder12_Addline2);
                eStampSerObj.FormData.Title_Holder12_Add_line3 = Utility.getBlankStringIfNull(Title_Holder12_Addline3);
                
                eStampSerObj.FormData.Title_Holder13_Name1     = Utility.getBlankStringIfNull(Title_Holder13Name1);
                eStampSerObj.FormData.Title_Holder13_Add_line1 = Utility.getBlankStringIfNull(Title_Holder13_Addline1);
                eStampSerObj.FormData.Title_Holder13_Add_line2 = Utility.getBlankStringIfNull(Title_Holder13_Addline2);
                eStampSerObj.FormData.Title_Holder13_Add_line3 = Utility.getBlankStringIfNull(Title_Holder13_Addline3);
                
                eStampSerObj.FormData.Title_Holder14_Name1     = Utility.getBlankStringIfNull(Title_Holder14Name1);
                eStampSerObj.FormData.Title_Holder14_Add_line1 = Utility.getBlankStringIfNull(Title_Holder14_Addline1);
                eStampSerObj.FormData.Title_Holder14_Add_line2 = Utility.getBlankStringIfNull(Title_Holder14_Addline2);
                eStampSerObj.FormData.Title_Holder14_Add_line3 = Utility.getBlankStringIfNull(Title_Holder14_Addline3); 
            }
            
            
            eStampSerObj.FormData.MOD_Branch = Utility.getBlankStringIfNull(application.MOD_Branch__c);
            eStampSerObj.FormData.Borrower_Names = Utility.getBlankStringIfNull(application.Primary_Applicant__c);

            if(application.Record_Type_Name__c == Constants.LAPLOAN){
                eStampSerObj.FormData.Title_Holder_details = (Title_Holder1_Name1 != '' ? Title_Holder1_Name1 :'') + (Title_Holder2_Name1 != '' ? ' & '+Title_Holder2_Name1 :'') + (Title_Holder3_Name1 != '' ? ' & '+Title_Holder3_Name1 :'') + (Title_Holder4_Name1 != '' ? ' & '+Title_Holder4_Name1 :'') + (Title_Holder5_Name1 != '' ? ' & '+Title_Holder5_Name1 :'') + (Title_Holder6_Name1 != '' ? ' & '+Title_Holder6_Name1 :'') + (Title_Holder7Name1 != '' ? ' & '+Title_Holder7_Name1 :'');
            }else{
                eStampSerObj.FormData.Title_Holder_details = (Title_Holder1Name1 != '' ? Title_Holder1Name1 :'') + (Title_Holder2Name1 != '' ? ' & '+Title_Holder2Name1 :'') + (Title_Holder3Name1 != '' ? ' & '+Title_Holder3Name1 :'') + (Title_Holder4Name1 != '' ? ' & '+Title_Holder4Name1 :'') + (Title_Holder5Name1 != '' ? ' & '+Title_Holder5Name1 :'');  
            }

            eStampSerObj.FormData.Mod_date = Utility.getBlankStringIfNull(String.ValueOf(application.MOD_Date__c));
            eStampSerObj.FormData.Xerox_Doc_table = Utility.getBlankStringIfNull(application.Xerox_Doc_Table__c);
            eStampSerObj.FormData.Xerox_Reason1 = Utility.getBlankStringIfNull(application.Xerox_Reason1__c);
            eStampSerObj.FormData.Xerox_Reason2 = Utility.getBlankStringIfNull(application.Xerox_Reason2__c);
            eStampSerObj.FormData.Sanction_Ref_Number = Utility.getBlankStringIfNull(application.Sanction_Reference_Number__c);
            eStampSerObj.FormData.Sanction_date = formatDate(application.Sanction_Date__c); //date field
            eStampSerObj.FormData.Ap_LT = Utility.getBlankStringIfNull(String.ValueOf(application.Sanction_Authority_Limit__c));//Sanction_Authority_Limit__c
            eStampSerObj.FormData.Guarantor_Details = Utility.getBlankStringIfNull(GuarantorDetails);
            eStampSerObj.FormData.Borrower_Names = Utility.getBlankStringIfNull(BorrowerDetails); 
            eStampSerObj.FormData.Int_ROI = Utility.getBlankStringIfNull(string.valueOf(application.genesis__Interest_Rate__c));
            eStampSerObj.FormData.Loan_tenor = Utility.getBlankStringIfNull(string.valueOf(application.genesis__Term__c));
            eStampSerObj.FormData.Holiday_period = Utility.getBlankStringIfNull(string.valueOf(application.Holiday_Period__c));
            eStampSerObj.FormData.Penal_Interest = Utility.getBlankStringIfNull(string.valueof(KVB_Company_Details__c.getOrgDefaults().Penal_Interest__c));
            eStampSerObj.FormData.Variance       = Utility.getBlankStringIfNull(String.valueOf(application.Interest_Variation__c));
            eStampSerObj.FormData.Guarantor1_Names  = Guarantor1Names;
            eStampSerObj.FormData.Guarantor2_Names  = Guarantor2Names;
            eStampSerObj.FormData.Guarantor3_Names  = Guarantor3Names;
            eStampSerObj.FormData.Guarantor4_Names  = Guarantor4Names;
            eStampSerObj.FormData.Guarantor5_Names  = Guarantor5Names;
            eStampSerObj.FormData.Guarantor6_Names  = Guarantor6Names;
            eStampSerObj.FormData.Guarantor7_Names  = Guarantor7Names;
            eStampSerObj.FormData.Guarantor8_Names  = Guarantor8Names;
            eStampSerObj.FormData.Guarantor9_Names  = Guarantor9Names;
            eStampSerObj.FormData.Guarantor10_Names = Guarantor10Names;             
            eStampSerObj.FormData.Auth_Sign_Bnk = Constants.KvbBank ;
            eStampSerObj.FormData.EMI_amount = Utility.getBlankStringIfNull(string.valueOf(application.Sanctioned_EMI__c));
            eStampSerObj.FormData.Ap_LT_inwords = Utility.getBlankStringIfNull(string.valueOf(application.Sanction_Amount_Words__c));
            eStampSerObj.FormData.Loan_Purpose = Utility.getBlankStringIfNull(application.Loan_Purpose__c);
            eStampSerObj.FormData.Processing_charges = Utility.getBlankStringIfNull(String.valueOf(application.Processing_Fee__c));
            eStampSerObj.FormData.Int_Type = Utility.getBlankStringIfNull(application.genesis__Interest_Calculation_Method__c);
            eStampSerObj.FormData.ROI_MCLR = Utility.getBlankStringIfNull(string.valueOf(application.Diff_B_w_ROI_MCLR__c));
            eStampSerObj.FormData.MCLR_Rate = Utility.getBlankStringIfNull(string.valueOf(getMCLRMasterValue(365,9999)));
            eStampSerObj.FormData.Rating_Freq = Utility.getBlankStringIfNull(String.valueOf(application.Rating_Frequency__c)); 
            
            if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
                eStampSerObj.FormData.PreClosure_Charges = application.Preclosure_Charges__c != null ? string.valueOf(application.Preclosure_Charges__c) : '0';
            }else{
                eStampSerObj.FormData.PreClosure_Charges = application.PreClosure_Interest_Rate__c != null ? string.valueOf(application.PreClosure_Interest_Rate__c) : '0';
            }
            
            if(application.Record_Type_Name__c == Constants.HOMELOAN){
                if(!Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) && application.FPIPrincRepayInstal2__c<> null){
                    eStampSerObj.FormData.DD_FI =  formatDate(application.FPIPrincRepayInstal2__c);
                    if(!Utility.ISStringBlankorNull(string.valueOf(application.Sanctioned_Tenure__c) )){
                        eStampSerObj.FormData.DD_LI = formatDate( (application.FPIPrincRepayInstal2__c).addMonths(integer.valueOf(application.Sanctioned_Tenure__c-1) ));
                    }
                    else{
                        eStampSerObj.FormData.DD_LI ='';
                    }
                }
                else if(Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) && application.FPIPrincRepayInstal__c<> null){
                    eStampSerObj.FormData.DD_FI =  Utility.getBlankStringIfNull(formatDate(application.FPIPrincRepayInstal__c));
                    if(!Utility.ISStringBlankorNull(string.valueOf(application.Sanctioned_Tenure__c) )){
                        eStampSerObj.FormData.DD_LI = Utility.getBlankStringIfNull(formatDate( (application.FPIPrincRepayInstal__c).addMonths(integer.valueOf(application.Sanctioned_Tenure__c-1))));
                    }
                    else{
                        eStampSerObj.FormData.DD_LI ='';
                    }
                }

                //V1.2(start)
                if (application.Sub_Type__c == Constants.Sub_Type_Take_Over) {
                    if (application.Facilities__r.size() > 0) {
                        eStampSerObj.FormData.Takeover_Bank = Utility.getBlankStringIfNull(String.ValueOf(application.Facilities__r[0].Approved_Takeover_Bank_Name__c));
                        eStampSerObj.FormData.Takeover_Outstanding = Utility.getBlankStringIfNull(String.ValueOf(application.Facilities__r[0].Approved_Takeover_Outstanding_Loan_Amoun__c));
                        eStampSerObj.FormData.Takeover_Branch = Utility.getBlankStringIfNull(String.ValueOf(application.Facilities__r[0].Takeover_Branch__c));
                        eStampSerObj.FormData.Takeover_Loan_Amount = Utility.getBlankStringIfNull(String.ValueOf(application.Facilities__r[0].Approved_Takeover_Sanctioned_Loan_Amount__c));
                        eStampSerObj.FormData.Takeover_Type_of_charge = Utility.getBlankStringIfNull(String.ValueOf(application.Facilities__r[0].Takeover_Type_of_Charge__c));
                        eStampSerObj.FormData.Takeover_OSDate = Utility.getBlankStringIfNull(String.ValueOf(application.Facilities__r[0].Approved_Takeover_Outstanding_as_on__c));
                    }
                    eStampSerObj.FormData.Application_number = Utility.getBlankStringIfNull(String.ValueOf(application.Name));
                }

                if (application.Sub_Type__c == Constants.Sub_Type_Top_Up) {
                    if (application.Facilities__r!=null && application.Facilities__r.size() > 0) {
                        eStampSerObj.FormData.Existing_MOD_SRO = Utility.getBlankStringIfNull(String.ValueOf(application.Facilities__r[0].Existing_HL_MOD_SRO__c));
                        eStampSerObj.FormData.Existing_HL_amount = Utility.getBlankStringIfNull(String.ValueOf(application.Facilities__r[0].Existing_HL_Sanctioned_Amount__c));
                        NumberToWordConversion numberToWord = new NumberToWordConversion();
                        String ExistingHLAmtINWrd = Utility.getBlankStringIfNull(String.valueOf(numberToWord.getNumberTOWordConvertion(application.Facilities__r[0].Existing_HL_Sanctioned_Amount__c)));
                        eStampSerObj.FormData.Existing_HL_amount_in_words = ExistingHLAmtINWrd;
                        eStampSerObj.FormData.Existing_MOD = Utility.getBlankStringIfNull(String.ValueOf(application.Facilities__r[0].Existing_HL_MOD_No__c));
                        eStampSerObj.FormData.Existing_A23_date = Utility.getBlankStringIfNull(String.ValueOf(application.Facilities__r[0].Existing_HL_A23_Agreement_Date__c));
                        eStampSerObj.FormData.Existing_MOD_date = Utility.getBlankStringIfNull(String.ValueOf(application.Facilities__r[0].Existing_HL_MOD_Date__c));
                    }
                }
                //V1.2(end)
                
            }else if(application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.LAPLOAN){
                if( application.FPIPrincRepayInstal__c <> null && application.Sanctioned_Tenure__c <> null){               
                    eStampSerObj.FormData.DD_FI = Utility.getBlankStringIfNull(formatDate(application.FPIPrincRepayInstal__c));
                    eStampSerObj.FormData.DD_LI = Utility.getBlankStringIfNull(formatDate( (application.FPIPrincRepayInstal__c).addMonths(integer.valueOf(application.Sanctioned_Tenure__c -1))));
                }
            }else if(application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W) {
                if( application.FPIPrincRepayInstal__c <> null && application.Sanctioned_Tenure__c <> null){
                    eStampSerObj.FormData.DD_FI= Utility.getBlankStringIfNull(String.ValueOf(application.FPIPrincRepayInstal__c));
                    eStampSerObj.FormData.DD_LI= Utility.getBlankStringIfNull(String.ValueOf((application.FPIPrincRepayInstal__c).addMonths(integer.valueOf(application.Sanctioned_Tenure__c-1) )));
                }
            }else{
                eStampSerObj.FormData.DD_FI = Utility.getBlankStringIfNull(formatDate(application.genesis__Disbursement_Date__c + 30)); //date field   
                eStampSerObj.FormData.DD_LI = Utility.getBlankStringIfNull(formatDate(application.genesis__Disbursement_Date__c + dis)); 
            }
            
            eStampSerObj.FormData.Borrower1_Names = application.genesis__Account__r.Full_Name__c;
            eStampSerObj.FormData.Borrower2_Names = Borrower2Names;
            eStampSerObj.FormData.Borrower3_Names = Borrower3Names;
            eStampSerObj.FormData.Borrower4_Names = Borrower4Names;
            eStampSerObj.FormData.Borrower5_Names = Borrower5Names;

            //v1.2(start)
            eStampSerObj.FormData.Borrower1_Type = Borrower1Type;
            eStampSerObj.FormData.Borrower2_Type = Borrower2Type;
            eStampSerObj.FormData.Borrower3_Type = Borrower3Type;
            eStampSerObj.FormData.Borrower4_Type = Borrower4Type;
            //v1.2(end)
            
            //V1.1-start
            if (application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W){
                eStampSerObj.FormData.Auth_Sign_Bnk= Constants.KvbBank ;
                eStampSerObj.FormData.Loc_Ref_Branch=Utility.getBlankStringIfNull(application.Branch_Name__c);
                eStampSerObj.FormData.Branch_code=Utility.getBlankStringIfNull(application.Branch_Code__c);
                eStampSerObj.FormData.Application_date=Utility.getBlankStringIfNull(String.ValueOf(application.Created_Date__c));
                eStampSerObj.FormData.Application_number=Utility.getBlankStringIfNull(application.Name);
                eStampSerObj.FormData.Financial_Yr=Utility.getBlankStringIfNull(String.ValueOf(System.today().Year()));
                eStampSerObj.FormData.Sanction_date=Utility.getBlankStringIfNull(String.ValueOf(System.today()));
                eStampSerObj.FormData.Loan_Product=Utility.getBlankStringIfNull(application.genesis__CL_Product_Name__c);
                eStampSerObj.FormData.Ap_LT=Utility.getBlankStringIfNull(String.ValueOf(application.Sanction_Authority_Limit__c)); 
                eStampSerObj.FormData.Loan_tenor=Utility.getBlankStringIfNull(String.ValueOf(application.Sanctioned_Tenure__c));
                
                eStampSerObj.FormData.Processing_charges=Utility.getBlankStringIfNull(String.ValueOf(application.Processing_Fee__c));
                eStampSerObj.FormData.Borrower_Details=Utility.getBlankStringIfNull(application.genesis__Account__r.Full_Name__c)+' S/W/D of '+Utility.getBlankStringIfNull(application.genesis__Account__r.Father_Name__pc)+' aged about '+Utility.getBlankStringIfNull(String.ValueOf(application.genesis__Account__r.Age__c))+' residing at '+Utility.getBlankStringIfNull(application.genesis__Account__r.PersonOtherStreet)+','+Utility.getBlankStringIfNull(application.genesis__Account__r.PersonOtherCity)+','+Utility.getBlankStringIfNull(application.genesis__Account__r.PersonOtherState) +'-'+Utility.getBlankStringIfNull(application.genesis__Account__r.PersonOtherPostalCode);
                if(application.Penal_Interest__c==null){
                    application.Penal_Interest__c=0;
                }
                eStampSerObj.FormData.Penal_Interest=Utility.getBlankStringIfNull(String.ValueOf((application.Penal_Interest__c.setScale(2))));
                
                if(application.Preclosure_Charges__c==null){
                    application.Preclosure_Charges__c=0;
                }
                eStampSerObj.FormData.PreClosure_Charges=Utility.getBlankStringIfNull(String.ValueOf(application.Preclosure_Charges__c.setScale(2)));
                eStampSerObj.FormData.Borrower1_Phone=Utility.getBlankStringIfNull(application.genesis__Account__r.PersonMobilePhone);
                
                //Additional tags for Hypothecation Document
                if( application.FPIPrincRepayInstal__c <> null && application.Sanctioned_Tenure__c <> null){
                    eStampSerObj.FormData.DD_FI= Utility.getBlankStringIfNull(String.ValueOf(application.FPIPrincRepayInstal__c));
                    eStampSerObj.FormData.DD_LI= Utility.getBlankStringIfNull(String.ValueOf((application.FPIPrincRepayInstal__c).addMonths(integer.valueOf(application.Sanctioned_Tenure__c-1) )));
                }
                
                
                if(application.Record_Type_Name__c == Constants.VL2W) {
                    eStampSerObj.FormData.Vehicle_Type = Utility.getBlankStringIfNull(Constants.VL2W_Name);
                } else if(application.Record_Type_Name__c == Constants.VL4W){
                    eStampSerObj.FormData.Vehicle_Type = Utility.getBlankStringIfNull(Constants.VL4W_Name);
                }
                String AmtINWrd = Utility.getBlankStringIfNull(String.ValueOf(application.Sanction_Amount_Words__c));   
                eStampSerObj.FormData.Ap_LT_inwords = AmtINWrd.replace('Rupess Only','');
                eStampSerObj.FormData.MCLR_Refresh = ' ';//Utility.getBlankStringIfNull(String.ValueOf(application.MCLR_Type__c));
                eStampSerObj.FormData.Disb_Ref_Day = System.now().format('dd');
                eStampSerObj.FormData.Disb_Ref_Month = System.now().format('MMMM')+' month';
                eStampSerObj.FormData.Disb_Ref_Year = System.now().format('yyyy')+' in year';
                
                if(application.genesis__Collaterals__r.size() > 0) {
                    eStampSerObj.FormData.Dealer_Name = Utility.getBlankStringIfNull(application.genesis__Collaterals__r[0].Dealer_name__c);
                    eStampSerObj.FormData.DD_PI= Utility.getBlankStringIfNull(String.ValueOf(application.genesis__Collaterals__r[0].Proforma_Invoice_Date__c));
                    eStampSerObj.FormData.V_Amt = Utility.getBlankStringIfNull(String.ValueOf(application.genesis__Collaterals__r[0].Total_Vehicle_Value__c));
                    eStampSerObj.FormData.Manufacture_Year = Utility.getBlankStringIfNull(String.ValueOf(application.genesis__Collaterals__r[0].clcommon__Year__c));
                    String vehdetails=application.genesis__Collaterals__r[0].clcommon__Manufacturer__c+' '+application.genesis__Collaterals__r[0].clcommon__Model__c+' '+application.genesis__Collaterals__r[0].Variant__c;
                    eStampSerObj.FormData.Vehicle_Details = Utility.getBlankStringIfNull(vehdetails);
                    eStampSerObj.FormData.Proforma_No = Utility.getBlankStringIfNull(String.ValueOf(application.genesis__Collaterals__r[0].Proforma_Invoice_No__c));
                }
                eStampSerObj.FormData.CC_Details = '';
                if(application.genesis__Interest_Rate__c==null){
                    application.genesis__Interest_Rate__c=0;
                }
                eStampSerObj.FormData.Interest_Type_Rate = 'Fixed interest rate of '+Utility.getBlankStringIfNull(String.ValueOf(application.genesis__Interest_Rate__c.setScale(2)))+'%';
                eStampSerObj.FormData.Extent_Site_Uds = '';
            } 
            //V1.1-end
            
            eStampSerObj.StampPaperData.FirstPartyAddress = new Estamp_HelperStructure.FirstPartyAddress();
            eStampSerObj.StampPaperData.FirstPartyAddress.StreetAddress     = KVB_Company_Details__c.getOrgDefaults().StreetAddress_eStamp__c;
            eStampSerObj.StampPaperData.FirstPartyAddress.Locality          =KVB_Company_Details__c.getOrgDefaults().Locality_eStamp__c;
            eStampSerObj.StampPaperData.FirstPartyAddress.City              =KVB_Company_Details__c.getOrgDefaults().City_eStamp__c;
            eStampSerObj.StampPaperData.FirstPartyAddress.State             =KVB_Company_Details__c.getOrgDefaults().State_eStamp__c    ;
            eStampSerObj.StampPaperData.FirstPartyAddress.Pincode           =KVB_Company_Details__c.getOrgDefaults().Pincode_eStamp__c;
            eStampSerObj.StampPaperData.FirstPartyAddress.Country           =KVB_Company_Details__c.getOrgDefaults().Country_estamp__c;
            
            eStampSerObj.StampPaperData.SecondPartyAddress = new Estamp_HelperStructure.FirstPartyAddress();
            eStampSerObj.StampPaperData.SecondPartyAddress.StreetAddress    =application.genesis__Account__r.PersonMailingStreet;
            eStampSerObj.StampPaperData.SecondPartyAddress.Locality         ='';
            eStampSerObj.StampPaperData.SecondPartyAddress.City             =application.genesis__Account__r.PersonMailingCity;
            eStampSerObj.StampPaperData.SecondPartyAddress.State            =application.genesis__Account__r.PersonMailingState;
            eStampSerObj.StampPaperData.SecondPartyAddress.Pincode          =application.genesis__Account__r.PersonMailingPostalCode;
            eStampSerObj.StampPaperData.SecondPartyAddress.Country          =application.genesis__Account__r.PersonMailingCountry;
            
            //Inserting Table 
            eStampSerObj.FormData.TableData = new List<Estamp_HelperStructure.cls_TableData>();
            List<Estamp_HelperStructure.cls_TableData> tableList = new List<Estamp_HelperStructure.cls_TableData>();
            List<MOD_Documents__c> modList = new List<MOD_Documents__c>();
            if(application.Record_Type_Name__c == Constants.LAPLOAN){
                for(MOD_Documents__c modRec:[Select Id,DOcNo__c,Date_Of_DOc__c,Nature_of_Doc__c,Parties_to_Document_From__c,Parties_to_Document_To__c,Document_Upload_Type__c,Collateral__c,Collateral__r.Active__c From MOD_Documents__c Where Application__c =:application.Id  AND Document_Upload_Type__c ='Copy' AND Collateral__r.Active__c = true AND Collateral__c =: col.Id]){
                    modList.add(modRec);
                }
            }else{
                for(MOD_Documents__c modRec:[Select Id,DOcNo__c,Date_Of_DOc__c,Nature_of_Doc__c,Parties_to_Document_From__c,Parties_to_Document_To__c,Document_Upload_Type__c,Collateral__c,Collateral__r.Active__c From MOD_Documents__c Where Application__c =:application.Id  AND Document_Upload_Type__c ='Copy']){
                    modList.add(modRec);
                }
            }
            System.debug('modList+++++++####'+modList);
            Integer slNo = 0;
            Integer index =0;
            if(modList.size()>0){
                for(MOD_Documents__c mod : modList){
                    slNo = slNo+1;
                    Estamp_HelperStructure.cls_TableData tb = new Estamp_HelperStructure.cls_TableData();
                    tb.sr_no = String.ValueOf(slNo);
                    tb.Doc_no = mod.DOcNo__c;  
                    tb.Doc_dt = formatDate(mod.Date_Of_DOc__c); //date field
                    tb.doc_nature = mod.Nature_of_Doc__c;
                    tb.transferor = mod.Parties_to_Document_From__c;
                    tb.transferee = mod.Parties_to_Document_To__c;
                    tableList.add(tb);
                }
                System.debug('tableList#####:::::'+tableList);
                
                eStampSerObj.FormData.TableData = tableList;
            }
            if(application.Record_Type_Name__c == Constants.VL4W || application.Record_Type_Name__c == Constants.VL2W){
                Estamp_HelperStructure.cls_TableData tb = new Estamp_HelperStructure.cls_TableData();
                tb.sr_no = '';
                tb.Doc_no = '';  
                tb.Doc_dt = ''; //date field
                tb.doc_nature = '';
                tb.transferor = '';
                tb.transferee = '';
                tableList.add(tb);
                eStampSerObj.FormData.TableData = tableList;
            }
            System.debug('## eStampSerObj ### --- > '+ JSON.serialize(eStampSerObj));
            return calleStampAPI(JSON.serialize(eStampSerObj),DocName,stampCharge,AcceToken);
        }catch(Exception e){
            System.debug('##DataLog### --- > '+ e.getCause() +' ' +e.getLineNumber());
            HandleBusinessException.captureError('WS_eStampDocGen','createDocnew', e);
        }
        return null;
    }
    public static DMS_Structure.EStampResponse calleStampAPI(string eStampReq, String DocName, Decimal stampCharge, string ApiToken){
        HTTPResponse response                                   = new HTTPResponse();
        try{
            DMS_Structure.EStampResponse Est = new DMS_Structure.EStampResponse();
            
           // KVB_Endpoint_URLs__c kvbEndpointURL = KVB_Endpoint_URLs__c.getValues('eStamp_url_test');
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            headerMap.put('Authorization',ApiToken);
            
          //  String endPoint                                         = kvbEndpointURL.Endpoint_URL__c;//'https://demo-eu05-test.apigee.net/next/v1/estamp'; 
            response = HttpUtility.sendHTTPRequest(Utility.getEndpointApigee('eStamp_url_test'), 'POST', null,eStampReq,headerMap,null);
            System.debug('Response Body ::'+ response.getBody());
            System.debug('Status1::: ' + response.getStatusCode());
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                
                String jsonString = response.getBody();
                System.debug('jsonString1::: ' + jsonString);
                Map<String, Object> obj = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
                
                if(obj.get('status') == 'success'){
                    map<String,Object> obj1 = (map<String,Object>)obj.get('result');
                    
                    //Inserting Document in Attachment
                    //  Digioe_Docs_Service.upsertDoc((String)obj1.get('ApplicationID'),DocName+'.pdf',(String)obj1.get('Content'));
                    // return (String)obj1.get('Content');
                    Est.result.uuid=(Integer)obj1.get('uuid');
                    Est.result.pageCount=(Integer)obj1.get('pageCount');
                    return Est; 
                }
                else{
                    docGenRes = response;
                }
            }else{
                docGenRes = response;
                //throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
            }
        }catch(Exception e){
            docGenRes = response;
            System.debug('Error'+e.getStackTraceString() +'LineNumber'+e.getLineNumber());
            HandleBusinessException.captureError('WS_eStampDocGen','createDocnew', e);
            //return null;
        } 
        return null;
    }
    public static void createVal(genesis__Applications__c app){
        List<genesis__Application_Parties__c> partiesList = new List<genesis__Application_Parties__c>();
        for(genesis__Application_Parties__c partyType:[Select Id,genesis__Party_Type__c,Company__c,Title_Holder__c,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.PersonMailingState,
                                                       genesis__Party_Account_Name__r.Name,genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.Full_Name__c,
                                                       genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c From genesis__Application_Parties__c where genesis__Application__c=:app.Id and active__c=true]){
                                                           partiesList.add(partyType);
                                                       }
        List<genesis__Application_Parties__c> borrowerList = new List<genesis__Application_Parties__c>();
        List<genesis__Application_Parties__c> grantorList = new List<genesis__Application_Parties__c>();
        List<genesis__Application_Parties__c> titleList = new List<genesis__Application_Parties__c>();
        for(genesis__Application_Parties__c pt : partiesList){
            if (pt.genesis__Party_Type__c == Constants.PRIMARY_APP) {
                Borrower1Type = Utility.getBlankStringIfNull(pt.genesis__Party_Type__c);//v1.2
            }
            if(pt.genesis__Party_Type__c == 'Co-Borrower' && pt.Company__c == false){
                borrowerList.add(pt);
            }
            if(pt.genesis__Party_Type__c == Constants.Gurantor && pt.Company__c == false){
                grantorList.add(pt);                
            }
        }
        for(genesis__Application_Parties__c pt : partiesList){
            if(pt.Title_Holder__c ==True){
                titleList.add(pt);
            }
            
        }  
        System.debug('titleList:-'+titleList);
        System.debug('borrowerList:-'+borrowerList);
        System.debug('grantorList:-'+grantorList);
        
        if(borrowerList.size() > 0){            
            Borrower2Names = Utility.getBlankStringIfNull(borrowerList[0].genesis__Party_Account_Name__r.Full_Name__c);
            Borrower2_Addline1 = Utility.getBlankStringIfNull(borrowerList[0].genesis__Party_Account_Name__r.PersonMailingStreet);
            Borrower2_Addline2 = Utility.getBlankStringIfNull(borrowerList[0].genesis__Party_Account_Name__r.PersonMailingCity);
            Borrower2_Addline3 = Utility.getBlankStringIfNull(borrowerList[0].genesis__Party_Account_Name__r.PersonMailingState);              
            Borrower2_FHDNAME = Utility.getBlankStringIfNull(borrowerList[0].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c);
            Borrower2Type = Utility.getBlankStringIfNull(borrowerList[0].genesis__Party_Type__c);//v1.2
        }
        if(borrowerList.size() > 1){            
            Borrower3Names = Utility.getBlankStringIfNull(borrowerList[1].genesis__Party_Account_Name__r.Full_Name__c);
            Borrower3_Addline1 = Utility.getBlankStringIfNull(borrowerList[1].genesis__Party_Account_Name__r.PersonMailingStreet);
            Borrower3_Addline2 = Utility.getBlankStringIfNull(borrowerList[1].genesis__Party_Account_Name__r.PersonMailingCity);
            Borrower3_Addline3 = Utility.getBlankStringIfNull(borrowerList[1].genesis__Party_Account_Name__r.PersonMailingState);              
            Borrower3_FHDNAME = Utility.getBlankStringIfNull(borrowerList[1].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c);
            Borrower3Type = Utility.getBlankStringIfNull(borrowerList[0].genesis__Party_Type__c);//v1.2
        }
        if(borrowerList.size() > 2){            
            Borrower4Names     = Utility.getBlankStringIfNull(borrowerList[2].genesis__Party_Account_Name__r.Full_Name__c);
            Borrower4_Addline1 = Utility.getBlankStringIfNull(borrowerList[2].genesis__Party_Account_Name__r.PersonMailingStreet);
            Borrower4_Addline2 = Utility.getBlankStringIfNull(borrowerList[2].genesis__Party_Account_Name__r.PersonMailingCity);
            Borrower4_Addline3 = borrowerList[2].genesis__Party_Account_Name__r.PersonMailingState;              
            Borrower4_FHDNAME  = borrowerList[2].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c;
            Borrower4Type = Utility.getBlankStringIfNull(borrowerList[0].genesis__Party_Type__c);//v1.2
        }
        if(grantorList.size() >0){
            Guarantor1Names  = grantorList[0].genesis__Party_Account_Name__r.Full_Name__c;
            Guarantor1_Names = grantorList[0].genesis__Party_Account_Name__r.Full_Name__c;
        }
        if(grantorList.size() >1){
            Guarantor2Names = grantorList[1].genesis__Party_Account_Name__r.Full_Name__c;
            Guarantor2_Names = grantorList[1].genesis__Party_Account_Name__r.Full_Name__c;  
        }
        if(grantorList.size() >2){
            Guarantor3Names = grantorList[2].genesis__Party_Account_Name__r.Full_Name__c;
            Guarantor3_Names = grantorList[2].genesis__Party_Account_Name__r.Full_Name__c;  
        }
        if(grantorList.size() >3){
            Guarantor4Names = grantorList[3].genesis__Party_Account_Name__r.Full_Name__c;
            Guarantor4_Names = grantorList[3].genesis__Party_Account_Name__r.Full_Name__c;  
        }
        if(grantorList.size() >4){
            Guarantor5Names = grantorList[4].genesis__Party_Account_Name__r.Full_Name__c;
            Guarantor5_Names = grantorList[4].genesis__Party_Account_Name__r.Full_Name__c;  
        }
        if(grantorList.size() >5){
            Guarantor6Names = grantorList[5].genesis__Party_Account_Name__r.Full_Name__c;
            // Guarantor6_Names = grantorList[0].genesis__Party_Account_Name__r.Name;  
        }        
        if(grantorList.size() >6){
            Guarantor7Names = grantorList[6].genesis__Party_Account_Name__r.Full_Name__c;  
        }  
        if(grantorList.size() >7){
            Guarantor8Names = grantorList[7].genesis__Party_Account_Name__r.Full_Name__c;  
        }   
        if(grantorList.size() >8){
            Guarantor9Names = grantorList[8].genesis__Party_Account_Name__r.Full_Name__c;  
        } 
        if(grantorList.size() >9){
            Guarantor10Names = grantorList[9].genesis__Party_Account_Name__r.Full_Name__c;  
        }        
        if(app.Record_Type_Name__c == Constants.LAPLOAN || app.Record_Type_Name__c == Constants.HOMELOAN){
            GuarantorDetails='';
            GuarantorDetails += (Guarantor1_Names != '' ? Guarantor1_Names : '') ;  
            GuarantorDetails += (Guarantor2_Names != '' ? ' & '+Guarantor2_Names : '');
            GuarantorDetails += (Guarantor3_Names != '' ? ' & '+Guarantor3_Names : '');
            GuarantorDetails += (Guarantor4_Names != '' ? ' & '+Guarantor4_Names : '');
            GuarantorDetails += (Guarantor5_Names != '' ? ' & '+Guarantor5_Names : '');
            BorrowerDetails='';
            Borrower1Names = app.genesis__Account__r.Full_Name__c;
            BorrowerDetails += (Borrower1Names != '' ?  Borrower1Names : '');
            BorrowerDetails += (Borrower2Names != '' ? ' & ' +Borrower2Names : '');
            BorrowerDetails += (Borrower3Names != '' ? ' & ' +Borrower3Names : '');
            BorrowerDetails += (Borrower4Names != '' ? ' & ' +Borrower4Names : '');
            BorrowerDetails += (Borrower5Names != '' ? ' & ' +Borrower5Names : '');
            BorrowerDetails += (Borrower6Names != '' ? ' & ' +Borrower6Names : '');
        }else{
            GuarantorDetails = (Guarantor1Names != '' ? Guarantor1Names : '') + (Guarantor2Names != '' ? '&'+Guarantor2Names :'') + (Guarantor3Names != '' ? '&'+Guarantor3Names : '') + (Guarantor4Names != '' ? '&'+Guarantor4Names : '' )+ Guarantor5Names != '' ? '&'+Guarantor5Names :'';  
        }
        
        // in title list   ---only checking title holder is true
        if(titleList.size() >0){
            Title_Holder1Name1 = titleList[0].genesis__Party_Account_Name__r.Full_Name__c;
            Title_Holder1_Addline1 = titleList[0].genesis__Party_Account_Name__r.PersonMailingStreet;
            Title_Holder1_Addline2 = titleList[0].genesis__Party_Account_Name__r.PersonMailingCity;
            Title_Holder1_Addline3 = titleList[0].genesis__Party_Account_Name__r.PersonMailingState; 
        }
        if(titleList.size() >1){
            Title_Holder2Name1     = titleList[1].genesis__Party_Account_Name__r.Full_Name__c;
            Title_Holder2_Addline1 = titleList[1].genesis__Party_Account_Name__r.PersonMailingStreet;
            Title_Holder2_Addline2 = titleList[1].genesis__Party_Account_Name__r.PersonMailingCity;
            Title_Holder2_Addline3 = titleList[1].genesis__Party_Account_Name__r.PersonMailingState;  
        }
        if(titleList.size() >2){
            Title_Holder3Name1     = titleList[2].genesis__Party_Account_Name__r.Full_Name__c;
            Title_Holder3_Addline1 = titleList[2].genesis__Party_Account_Name__r.PersonMailingStreet;
            Title_Holder3_Addline2 = titleList[2].genesis__Party_Account_Name__r.PersonMailingCity;
            Title_Holder3_Addline3 = titleList[2].genesis__Party_Account_Name__r.PersonMailingState;  
        }
        if(titleList.size() >3){
            Title_Holder4Name1     = titleList[3].genesis__Party_Account_Name__r.Full_Name__c;
            Title_Holder4_Addline1 = titleList[3].genesis__Party_Account_Name__r.PersonMailingStreet;
            Title_Holder4_Addline2 = titleList[3].genesis__Party_Account_Name__r.PersonMailingCity;
            Title_Holder4_Addline3 = titleList[3].genesis__Party_Account_Name__r.PersonMailingState;  
        }
        if(titleList.size() >4){
            Title_Holder5Name1     = titleList[4].genesis__Party_Account_Name__r.Full_Name__c;
            Title_Holder5_Addline1 = titleList[4].genesis__Party_Account_Name__r.PersonMailingStreet;
            Title_Holder5_Addline2 = titleList[4].genesis__Party_Account_Name__r.PersonMailingCity;
            Title_Holder5_Addline3 = titleList[4].genesis__Party_Account_Name__r.PersonMailingState;  
        }
        if(titleList.size() >5){
            Title_Holder6Name1     = titleList[5].genesis__Party_Account_Name__r.Full_Name__c;
            Title_Holder6_Addline1 = titleList[5].genesis__Party_Account_Name__r.PersonMailingStreet;
            Title_Holder6_Addline2 = titleList[5].genesis__Party_Account_Name__r.PersonMailingCity;
            Title_Holder6_Addline3 = titleList[5].genesis__Party_Account_Name__r.PersonMailingState;  
        }
        if(titleList.size() >6){
            Title_Holder7Name1     = titleList[6].genesis__Party_Account_Name__r.Full_Name__c;
            Title_Holder7_Addline1 = titleList[6].genesis__Party_Account_Name__r.PersonMailingStreet;
            Title_Holder7_Addline2 = titleList[6].genesis__Party_Account_Name__r.PersonMailingCity;
            Title_Holder7_Addline3 = titleList[6].genesis__Party_Account_Name__r.PersonMailingState;  
        }
        if(titleList.size() >7){
            Title_Holder8Name1     = titleList[7].genesis__Party_Account_Name__r.Full_Name__c;
            Title_Holder8_Addline1 = titleList[7].genesis__Party_Account_Name__r.PersonMailingStreet;
            Title_Holder8_Addline2 = titleList[7].genesis__Party_Account_Name__r.PersonMailingCity;
            Title_Holder8_Addline3 = titleList[7].genesis__Party_Account_Name__r.PersonMailingState;  
        }
        if(titleList.size() >8){
            Title_Holder9Name1     = titleList[8].genesis__Party_Account_Name__r.Full_Name__c;
            Title_Holder9_Addline1 = titleList[8].genesis__Party_Account_Name__r.PersonMailingStreet;
            Title_Holder9_Addline2 = titleList[8].genesis__Party_Account_Name__r.PersonMailingCity;
            Title_Holder9_Addline3 = titleList[8].genesis__Party_Account_Name__r.PersonMailingState;  
        }
        if(titleList.size() >9){
            Title_Holder10Name1     = titleList[9].genesis__Party_Account_Name__r.Full_Name__c;
            Title_Holder10_Addline1 = titleList[9].genesis__Party_Account_Name__r.PersonMailingStreet;
            Title_Holder10_Addline2 = titleList[9].genesis__Party_Account_Name__r.PersonMailingCity;
            Title_Holder10_Addline3 = titleList[9].genesis__Party_Account_Name__r.PersonMailingState;  
        }
        if(titleList.size() >10){
            Title_Holder11Name1     = titleList[10].genesis__Party_Account_Name__r.Full_Name__c;
            Title_Holder11_Addline1 = titleList[10].genesis__Party_Account_Name__r.PersonMailingStreet;
            Title_Holder11_Addline2 = titleList[10].genesis__Party_Account_Name__r.PersonMailingCity;
            Title_Holder11_Addline3 = titleList[10].genesis__Party_Account_Name__r.PersonMailingState;  
        }
        if(titleList.size() >11){
            Title_Holder12Name1     = titleList[11].genesis__Party_Account_Name__r.Full_Name__c;
            Title_Holder12_Addline1 = titleList[11].genesis__Party_Account_Name__r.PersonMailingStreet;
            Title_Holder12_Addline2 = titleList[11].genesis__Party_Account_Name__r.PersonMailingCity;
            Title_Holder12_Addline3 = titleList[11].genesis__Party_Account_Name__r.PersonMailingState;  
        }
        if(titleList.size() >12){
            Title_Holder13Name1     = titleList[12].genesis__Party_Account_Name__r.Full_Name__c;
            Title_Holder13_Addline1 = titleList[12].genesis__Party_Account_Name__r.PersonMailingStreet;
            Title_Holder13_Addline2 = titleList[12].genesis__Party_Account_Name__r.PersonMailingCity;
            Title_Holder13_Addline3 = titleList[12].genesis__Party_Account_Name__r.PersonMailingState;  
        }
        if(titleList.size() >13){
            Title_Holder14Name1     = titleList[13].genesis__Party_Account_Name__r.Full_Name__c;
            Title_Holder14_Addline1 = titleList[13].genesis__Party_Account_Name__r.PersonMailingStreet;
            Title_Holder14_Addline2 = titleList[13].genesis__Party_Account_Name__r.PersonMailingCity;
            Title_Holder14_Addline3 = titleList[13].genesis__Party_Account_Name__r.PersonMailingState;  
        }        
    }
    public static String formatDate(Date d) {
        if(d != null){
            return d.day() + '-' + d.month() + '-' + d.year();
        }
        return '';
    }
    
    public static Decimal getMCLRMasterValue(Integer codFrom, integer codTo){
        try{
            return [Select id,COD_Term_From__c,COD_Term_To__c,Effective_Date__c,
                    Expiry_Date__c,Interest_Rate_Reset__c,Int_ID__c,MCLR_Of_Interest__c 
                    from MCLR_Master__c where COD_Term_From__c =:codFrom AND COD_Term_To__c = :codTo limit 1].MCLR_Of_Interest__c;
        }catch(Exception e){
            return 0;
        }
        
    }
}