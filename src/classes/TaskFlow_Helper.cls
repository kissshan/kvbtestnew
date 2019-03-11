/*
* Name    : TaskFlow_Helper
* Company : ET Marlabs
* Purpose : This class is used to assign Task to the users
* Author  : Subas
* Test class: TaskFlow_Helper_Test
-----------------------------------------------------------------------
Version     Date            Author          Remarks                                                 
=======     ==========      =============   ==================================
V1.1        22-Aug-2018     Braj            Addition and modification in Task creation for Vehicle Loan
V1.2        17-Sept-2018    Braj            New task for Vehicle RC check and updating application status based on that
v1.3        08-Oct-2018     Braj            New task added for VL name 'Generate dealer document'
v1.4        09-oct-2018     prashant        two new tasks Verify KYC for New to Bank Customers AND Approve KYC Data for Changes New to Bank Customers on sub-stage-Terms and condition for all products
v1.5        20-Oct-2018     Braj            Added new task 'Complete Documentation' and Verify Documentation added for HL,LAP,PL and VL and reopen task if it is already created
v1.6        05-Nov-2018     Braj            Legal desk flag check sub stage moved from 'Terms and Conditions Accepted' to 'Personal Details Captured'
v1.7        07-Nov-2018     Braj            'Verifing Officer' designation is added in getUserList()
v1.8        18-Dec-2018     Braj            Removed FI Status 'fraud' and added 'Manual' condition for 'Verify FI rejection' task which is now assign to BM from RLPC Head and 'Approve FI' task assign to 'DOO' from DO head
v1.9        07-Jan-2018     Braj            Restrict approve income, approve kyc, approve property data entry task at substage T&C only
v2.0        16-Jan-2019     prashant        task name change as per requirement
v2.1        29-Jan-2019     Braj            New Task of HL MVP2
*******************************************************************************************/
global class TaskFlow_Helper {
    public static boolean TASK_TRIGGER_RUNNING = false;
    public static Boolean Notask = True; // for STP stage only
    public static void createTask(List<genesis__Applications__c> newAppList, List<genesis__Applications__c> oldAppList){

        Map<Id,genesis__Applications__c> mapApp=new Map<Id,genesis__Applications__c>();
        try{
            
            // Record type id of LAP Loan
            Id AppLapId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
            
            //this logic implemented to Legal desk state flag updation -Start Here
            List<String> SM = new List<String>();
            for(State_Master__c sMaster : [select id, Name from State_Master__c where Legal_desk_state_flag__c = true]){
                SM.add((sMaster.Name).toUpperCase());
            }
            //this logic implemented to Legal desk state flag updation -End Here
            
            Map<String, String> stateMap = new Map<String, String>();
            for(Branch_Master__c bm : [select id, CODCCBRN__c, State__c from Branch_Master__c]){
                stateMap.put(bm.CODCCBRN__c, bm.State__c);
            }
            for(genesis__Applications__c newApp :newAppList){
                
                for(genesis__Applications__c oldApp :oldAppList){
                    
                    //v1.6(start)
                    if((newApp.Sub_Stage__c == Constants.APPL_STAGE_LOAN_SANCTIONED_NON_STOP && oldApp.Sub_Stage__c <> Constants.APPL_STAGE_LOAN_SANCTIONED_NON_STOP) && (newApp.Record_Type_Name__c ==Constants.PERSONALLOAN || newApp.Record_Type_Name__c ==Constants.VL2W || newApp.Record_Type_Name__c ==Constants.VL4W)){
                        if(!SM.contains(stateMap.get(oldApp.Branch_Code__c))){
                            genesis__Applications__c gap = new genesis__Applications__c();
                            gap.Legal_desk_state_flag__c = false;
                            gap.id = newApp.id;
                            mapApp.put(gap.id,gap);
                        }
                    }
                    //v1.6(end)

                    //v1.5(start)
                    if (((newApp.Sub_Stage__c == Constants.SI_DETAILS_CAPTURED_SUBSTAGE && newApp.Sub_Stage__c!=oldApp.Sub_Stage__c) && (newApp.Record_Type_Name__c ==Constants.HOMELOAN || newApp.Record_Type_Name__c ==Constants.LAPLOAN)) || (newApp.Sub_Stage__c == Constants.PROCESSING_FEE_PAID_SUBSTAGE && (newApp.Record_Type_Name__c ==Constants.PERSONALLOAN || newApp.Record_Type_Name__c ==Constants.VL2W || newApp.Record_Type_Name__c ==Constants.VL4W))){
                        if (!newApp.Legal_desk_state_flag__c) {
                            String usrId = getUserList(newApp.Branch_Code__c,'Branch manager');
                            System.debug('^^^usrId^^^^'+usrId);
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Complete Documentation', 1);
                            }
                        }
                    }
                    
                    if ((newApp.Sub_Stage__c == Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE && newApp.Sub_Stage__c!=oldApp.Sub_Stage__c) && (newApp.Record_Type_Name__c ==Constants.HOMELOAN || newApp.Record_Type_Name__c ==Constants.LAPLOAN || newApp.Record_Type_Name__c ==Constants.PERSONALLOAN || newApp.Record_Type_Name__c ==Constants.VL2W || newApp.Record_Type_Name__c ==Constants.VL4W)){
                        if (!newApp.Legal_desk_state_flag__c) {
                            String usrId = getUserList(newApp.Branch_Code__c,'Verifying Officer');
                            System.debug('^^^usrId^^^^'+usrId);
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Verify Documentation',1);
                            }
                        }
                    }//v1.5(end)

                    /*if ((newApp.Sub_Stage__c == Constants.TermsAccepted && newApp.Sub_Stage__c!=oldApp.Sub_Stage__c) && (newApp.Record_Type_Name__c ==Constants.HOMELOAN || newApp.Record_Type_Name__c ==Constants.LAPLOAN || newApp.Record_Type_Name__c ==Constants.PERSONALLOAN || newApp.Record_Type_Name__c ==Constants.VL2W || newApp.Record_Type_Name__c ==Constants.VL4W)){
                            String usrId = getUserList(newApp.Branch_Code__c,'RLPC Processing Officer');
                            System.debug('^^^usrId^^^^'+usrId);
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Trigger FCU',1);
                            }
                    }*/

                    if(newApp.Legal_desk_state_flag__c && (newApp.Record_Type_Name__c == Constants.HOMELOAN || newApp.Record_Type_Name__c == Constants.LAPLOAN || newApp.Record_Type_Name__c == Constants.PERSONALLOAN) && newApp.Sub_Stage__c != oldApp.Sub_Stage__c){

                        if((newApp.Record_Type_Name__c == Constants.HOMELOAN && (((newApp.Sub_Stage__c == Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE || newApp.Sub_Stage__c == Constants.InitaiteMOD) && (newApp.Loan_Purpose__c==Constants.Construction || newApp.Loan_Purpose__c==Constants.RepairHouse)) || (newApp.Sub_Stage__c == Constants.InitaiteMOD && (newApp.Loan_Purpose__c==Constants.IdentifiedProperty || newApp.Loan_Purpose__c==Constants.ConstructionOn)))) || (newApp.Sub_Stage__c == Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE && (newApp.Record_Type_Name__c == Constants.LAPLOAN || newApp.Record_Type_Name__c == Constants.PERSONALLOAN))){
                            String usrId = getUserList(newApp.Branch_Code__c,'DO Legal Clearance Officer');
                            System.debug('^^^usrId^^^^'+usrId);
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'FEC Clearance', 1);
                            }
                        }
                    }

                    List<genesis__Application_Parties__c> parlist=queryService.getparties(newApp.id);//added common party query

                    //prashant kyc
                    if(newApp.Sub_Stage__c == Constants.TermsAccepted && (newApp.Record_Type_Name__c ==Constants.HOMELOAN || newApp.Record_Type_Name__c ==Constants.LAPLOAN || newApp.Record_Type_Name__c ==Constants.PERSONALLOAN || newApp.Record_Type_Name__c ==Constants.VL2W || newApp.Record_Type_Name__c ==Constants.VL4W))
                    {
                        for(genesis__Application_Parties__c par : parlist){
                            if(par.IsKYC__c==false)
                            {
                                String usrId = getUserList(newApp.Branch_Code__c,'RLPC Processing Officer');
                                System.debug('^^^usrId^^^^'+usrId);
                                if(usrId != null){
                                    creatTaskAll(newApp.Id, usrId, 'Verify KYC', 1);                            
                                }
                                break;
                            }
                        }
                        
                        //v1.8(start)//Verify FI rejection task for HL/LAP/PL/VL
                        if(newApp.FI_Status__c == Constants.FI_Nega || newApp.FI_Status__c == Constants.FI_Refer || newApp.FI_Status__c == Constants.FI_MANUAL)
                        {
                            String usrId = getUserList(newApp.Branch_Code__c,'Branch manager');
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Verify FI rejection', 2);
                            }
                        }//v1.8(end)
                    }
                    //kyc ends

                    if(newApp.Record_Type_Name__c ==Constants.HOMELOAN && oldApp.Record_Type_Name__c ==Constants.HOMELOAN){
                        clcommon__Collateral__c collRec=new clcommon__Collateral__c();
                        if (newApp.Id!=null && (newApp.Sub_Stage__c == Constants.TermsAccepted || newApp.Sub_Stage__c ==Constants.LOAN_SANCTIONED_NON_STP_SUBSTAGE || newApp.Sub_Stage__c ==Constants.LOAN_SANCTIONED_STP_SUBSTAGE || newApp.Sub_Stage__c =='Loan Sanctioned-Committee' || newApp.Sub_Stage__c ==Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE || newApp.Sub_Stage__c == Constants.InitaiteMOD) && newApp.Sub_Type__c == Constants.Sub_Type_Top_Up){
                            collRec = [select id,Approved_Additional_Charge__c,Valuation_Applicable__c from clcommon__Collateral__c where genesis__Application__c=:newApp.Id limit 1];
                        }
                        System.debug('collRec>>'+collRec);
                        
                        if(newApp.Sub_Stage__c == Constants.TermsAccepted && oldApp.Sub_Stage__c <> Constants.TermsAccepted){
                            //M121                                
                            String usrId = getUserList(newApp.Branch_Code__c,'Branch manager');
                            System.debug('^^M121^^^usrId^^^^'+usrId);
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Verify property and upload valuation and legal reports', 5);                                    
                            }
                        }
                        
                        else if(newApp.Sub_Stage__c == Constants.TermsAccepted && newApp.Flags_Raised__c ==True && oldApp.Flags_Raised__c ==False && newApp.Charges_Processed__c == oldApp.Charges_Processed__c){
                            //Flag CLEARNCE
                            String usrId = getUserList(newApp.Branch_Code__c,'DO Processing Officer');
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Verify application flags', 1);
                            }
                        }
                        
                        //Task for Disbursement
                        else if((((newApp.Sub_Stage__c == Constants.LOAN_SANCTIONED_NON_STP_SUBSTAGE || newApp.Sub_Stage__c ==Constants.LOAN_SANCTIONED_STP_SUBSTAGE || newApp.Sub_Stage__c =='Loan Sanctioned-Committee') && (((newApp.Loan_Purpose__c==Constants.IdentifiedProperty || newApp.Loan_Purpose__c==Constants.ConstructionOn) && newApp.Sub_Type__c == null) || newApp.Sub_Type__c == Constants.Sub_Type_Take_Over || (newApp.Sub_Type__c == Constants.Sub_Type_Top_Up && collRec.Approved_Additional_Charge__c == 0))) || (newApp.Sub_Stage__c == Constants.InitaiteMOD && (((newApp.Loan_Purpose__c==Constants.Construction || newApp.Loan_Purpose__c==Constants.RepairHouse) && newApp.Sub_Type__c == null) || (newApp.Sub_Type__c == Constants.Sub_Type_Reimbursement || (newApp.Sub_Type__c == Constants.Sub_Type_Top_Up && collRec.Approved_Additional_Charge__c > 0))))) && newApp.Sub_Stage__c <> oldApp.Sub_Stage__c && newApp.Charges_Processed__c == oldApp.Charges_Processed__c){
                            String usrId = getBMList(newApp.Branch_Code__c,'Branch manager');
                            if(usrId !=null || usrId !=''){
                                creatTaskAll(newApp.Id, usrId, 'Approve disbursement', 60);   //v2.0 
                            }
                        }
                        
                        //Task for MOD
                        else if(((newApp.Sub_Stage__c ==Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE && (((newApp.Loan_Purpose__c==Constants.IdentifiedProperty || newApp.Loan_Purpose__c==Constants.ConstructionOn) && newApp.Sub_Type__c == null) || newApp.Sub_Type__c == Constants.Sub_Type_Take_Over)) || ((newApp.Sub_Stage__c ==Constants.LOAN_SANCTIONED_NON_STP_SUBSTAGE || newApp.Sub_Stage__c ==Constants.LOAN_SANCTIONED_STP_SUBSTAGE || newApp.Sub_Stage__c =='Loan Sanctioned-Committee') && (newApp.Sub_Type__c == Constants.Sub_Type_Reimbursement || (newApp.Sub_Type__c != Constants.Sub_Type_Reimbursement && (newApp.Loan_Purpose__c==Constants.Construction || newApp.Loan_Purpose__c==Constants.RepairHouse))) && (newApp.Sub_Type__c != Constants.Sub_Type_Top_Up || (newApp.Sub_Type__c == Constants.Sub_Type_Top_Up && collRec.Approved_Additional_Charge__c > 0)))) && newApp.Sub_Stage__c <> oldApp.Sub_Stage__c && newApp.Charges_Processed__c == oldApp.Charges_Processed__c){
                            String usrId = getBMList(newApp.Branch_Code__c,'Branch manager');
                            if(usrId !=null || usrId !=''){
                                creatTaskAll(newApp.Id, usrId, 'Initiate MOD', 14); 
                            }
                        }

                        if(newApp.Sub_Stage__c =='MOD Documents Esigned' && oldApp.Sub_Stage__c <> 'MOD Documents Esigned'){
                            String usrId = getBMList(newApp.Branch_Code__c, 'Branch Manager');
                            if(usrId !=null || usrId !=''){
                                creatTaskAll(newApp.Id, usrId, 'Upload latest EC', 10); 
                                
                                creatTaskAll(newApp.Id, usrId, 'Upload Property Insurance', 10);
                            }
                        }
                       /* if(newApp.Sub_Stage__c == Constants.TermsAccepted && oldApp.Sub_Stage__c <> Constants.TermsAccepted && newApp.Is_Take_Over__c == oldApp.Is_Take_Over__c && oldApp.Is_Take_Over__c == True){
                            String usrId = getBMList(newApp.Branch_Code__c,'Branch manager');
                            if(usrId !=null || usrId !=''){
                                creatTaskAll(newApp.Id, usrId, 'Take-over Validation', 5); 
                            }                        
                        } */
                        //v2.1:Enter Top Up Venu
                        if(newApp.Sub_Stage__c == Constants.TermsAccepted && oldApp.Sub_Stage__c <> Constants.TermsAccepted && newApp.Sub_Type__c == oldApp.Sub_Type__c && newApp.Sub_Type__c == Constants.Sub_Type_Top_Up){
                           String usrId = getUserList(newApp.Branch_Code__c,'RLPC processing officer');
                            if(usrId !=null || usrId !=''){
                                creatTaskAll(newApp.Id, usrId, 'Enter Top Up Details', 1); 
                            }                        
                        }

                        //Additonal Income Assessment task create only if additional agriculture income is claimed
                        if(newApp.Sub_Stage__c == Constants.TermsAccepted && oldApp.Sub_Stage__c <> Constants.TermsAccepted){
                            integer AgrriCount = 0;
                            integer AllhavePerfios = 0;  
                            Integer financeCount = 0;
                            List <Account> accList = queryService.ApplicantList(newApp.id);
                            for(genesis__Application_Parties__c par : parlist){
                                if(par.Financial_Applicant__c == true){
                                    financeCount++;
                                    if(par.Perfios_Captured__c == True){
                                        AllhavePerfios++;
                                    }
                                    if(par.Additional_Income_Amount1__c != null && par.Additional_Income_Amount1__c != 0){
                                        AgrriCount++;
                                    }
                                }
                            }

                            if(AgrriCount > 0 && parlist.size() == AllhavePerfios){
                                String usrId = getUserList(newApp.Branch_Code__c,'RLPC processing officer');
                                if(usrId ==null || usrId ==''){
                                    usrId = getUserList(newApp.Branch_Code__c,'DO Processing Officer');
                                }
                                if(usrId !=null || usrId !=''){
                                    creatTaskAll(newApp.Id, usrId, 'Additonal Income Assessment', 5);
                                }
                            }else if(financeCount != AllhavePerfios){
                                String usrId = getRPCUser(newApp.Branch_Code__c,new Set<String>{'RLPC processing officer', 'RPC Outsource Officer'});
                                if(usrId !=null || usrId !=''){
                                    creatTaskAll(newApp.Id, usrId, 'Assess income', 1);
                                }
                            } 
                        }

                        //v2.1(start)
                        //Top Up
                        if (newApp.Sub_Type__c == Constants.Sub_Type_Top_Up && oldApp.Sub_Type__c == Constants.Sub_Type_Top_Up){
                            if(newApp.Sub_Stage__c == Constants.TermsAccepted && oldApp.Sub_Stage__c <> Constants.TermsAccepted){
                                if (!collRec.Valuation_Applicable__c) {
                                    String usrId = getUserList(newApp.Branch_Code__c, 'Branch manager');
                                    if(usrId !=null || usrId !=''){
                                        creatTaskAll(newApp.Id, usrId, 'Upload existing HL\'s valuation report', 1);
                                    }
                                }
                            }
                        }

                        //Take Over
                        if (newApp.Sub_Type__c == Constants.Sub_Type_Take_Over && oldApp.Sub_Type__c == Constants.Sub_Type_Take_Over){

                            if(newApp.Sub_Stage__c == Constants.TermsAccepted && oldApp.Sub_Stage__c <> Constants.TermsAccepted){
                                String usrId = getUserList(newApp.Branch_Code__c, 'RLPC processing officer');
                                if(usrId !=null || usrId !=''){
                                    creatTaskAll(newApp.Id, usrId, 'Verify Take Over details', 1);
                                }
                            }
                            if(newApp.Sub_Stage__c == Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE && oldApp.Sub_Stage__c <> Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE){
                                String usrId = getUserList(newApp.Branch_Code__c, 'Branch manager');
                                if(usrId !=null || usrId !=''){
                                    creatTaskAll(newApp.Id, usrId, 'Collect Original Documents', 1);
                                }
                            }
                            if(newApp.Sub_Stage__c == Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE && oldApp.Sub_Stage__c <> Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE){
                                String usrId = getUserList(newApp.Branch_Code__c, 'Branch manager');
                                if(usrId !=null || usrId !=''){
                                    creatTaskAll(newApp.Id, usrId, 'Supplementary Legal Opinion', 1);
                                }
                            }
                        }

                        //Reimbursement
                        if (newApp.Sub_Type__c == Constants.Sub_Type_Reimbursement && oldApp.Sub_Type__c == Constants.Sub_Type_Reimbursement){

                            if(newApp.Sub_Stage__c == Constants.TermsAccepted && oldApp.Sub_Stage__c <> Constants.TermsAccepted){
                                String usrId = getUserList(newApp.Branch_Code__c, 'RLPC processing officer');
                                if(usrId !=null || usrId !=''){
                                    creatTaskAll(newApp.Id, usrId, 'Verify Expenses incurred', 1);
                                }
                            }
                        }
                        //v2.1(end)
                    }
                    
                    
                    // Personal Loan Task Creation starts here -------------------------------------------------------
                    //V1.1-start
                    //Vehical Loan Task creation added 
                    else if((newApp.Record_Type_Name__c == Constants.PERSONALLOAN && oldApp.Record_Type_Name__c == Constants.PERSONALLOAN) || (newApp.Record_Type_Name__c == Constants.VL2W && oldApp.Record_Type_Name__c == Constants.VL2W) || (newApp.Record_Type_Name__c == Constants.VL4W && oldApp.Record_Type_Name__c == Constants.VL4W)){
                        
                        if(newApp.Sub_Stage__c == Constants.TermsAccepted && oldApp.Sub_Stage__c <> Constants.TermsAccepted && oldApp.Perfios_Captured__c == False){
                            //Assess Income TASK         
                            String usrId = getRPCUser(newApp.Branch_Code__c,new Set<String>{'RLPC processing officer', 'RPC Outsource Officer'});
                            System.debug('^^^usrId^^^^'+usrId);
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Assess income', 1);  
                                Notask = False;                          
                            }
                        }
                        if(newApp.Sub_Stage__c == Constants.TermsAccepted && oldApp.Sub_Stage__c <> Constants.TermsAccepted && oldApp.Additional_Income_Approval__c == True && oldApp.Perfios_Captured__c == True && oldApp.Record_Type_Name__c == Constants.PERSONALLOAN){
                            //Assess Additional income TASK   
                            String usrId = getUserList(newApp.Branch_Code__c,'RLPC processing officer');
                            if(usrId ==null || usrId ==''){
                                
                                usrId = getUserList(newApp.Branch_Code__c,'DO processing officer');
                            }                        
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Assess Additional income', 1);
                                Notask = False;                             
                            }
                        }

                        if(newApp.Sub_Stage__c == Constants.TermsAccepted && oldApp.Sub_Stage__c <> Constants.TermsAccepted && (oldApp.Record_Type_Name__c == Constants.VL2W || oldApp.Record_Type_Name__c == Constants.VL4W) && oldApp.Perfios_Captured__c == True){
                            //Assess Additional income TASK   
                            integer AgrriCount = 0;
                            integer AllhavePerfios = 0;
                            for(genesis__Application_Parties__c par : parlist){
                                if(par.Perfios_Captured__c == True){
                                    AllhavePerfios++;
                                }
                                if(par.Additional_Income_Amount1__c != null && par.Additional_Income_Amount1__c != 0){
                                    AgrriCount++;
                                }
                            }
                            System.debug('AllhavePerfios -- VL '+AllhavePerfios+' **AgrriCount VL ** '+AgrriCount);
                            if(AgrriCount > 0 && parlist.size() == AllhavePerfios){
                                
                                String usrId = getUserList(newApp.Branch_Code__c,'RLPC processing officer');
                                if(usrId ==null || usrId ==''){
                                    usrId = getUserList(newApp.Branch_Code__c,'DO Processing Officer');
                                }
                                if(usrId !=null || usrId !=''){
                                    creatTaskAll(newApp.Id, usrId, 'Assess Additional income', 5); 
                                }
                            }
                        }// end of main IF conditions....
                        //V1.2-end
                        
                        if(newApp.Sub_Stage__c == Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE && oldApp.Sub_Stage__c <> Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE && newApp.Record_Type_Name__c == Constants.PERSONALLOAN && !newApp.Is_GMRA_Policy_Selected__c){                
                            String usrId = getUserList(newApp.Branch_Code__c,'Branch manager');
                            System.debug('^^^usrId^^^^'+usrId);
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Update credit life insurance', 30);  
                                Notask = False;                           
                            }
                        }
                    } 
                    
                    //V1.2-start
                    if ((newApp.Record_Type_Name__c == Constants.VL2W && oldApp.Record_Type_Name__c == Constants.VL2W) || (newApp.Record_Type_Name__c == Constants.VL4W && oldApp.Record_Type_Name__c == Constants.VL4W)) {
                        //V1.1-start
                        //v1.3(start)
                        if(newApp.Sub_Stage__c ==Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE && oldApp.Sub_Stage__c <> Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE){               
                            String usrId = getUserList(newApp.Branch_Code__c,'Branch manager');
                            System.debug('^^^usrId^^^^'+usrId);
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Generate dealer document', 1);
                            }
                        }
                        //v1.3(end)
                        if(newApp.Sub_Stage__c ==Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE && oldApp.Sub_Stage__c <> Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE){
                            String usrId = getUserList(newApp.Branch_Code__c,'Branch manager');
                            System.debug('^^^usrId^^^^'+usrId);
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Update mandatory documents & verify RC details', 30);
                            }
                        }
                        //V1.1-end      
                    }
                    //V1.2-end
                    
                    // PL Task creation ENDs here------------------------------------------------------
                    
                    /// Lap Task start here
                    if(newApp.Record_Type_Name__c ==Constants.LAPLOAN && oldApp.Record_Type_Name__c ==Constants.LAPLOAN ){
                        //Assess income //v2.0
                        if(newApp.Sub_Stage__c =='Terms and Conditions Accepted' && oldApp.Sub_Stage__c <> 'Terms and Conditions Accepted' && newApp.Perfios_Captured__c == False){
                            
                            String usrId = getRPCUser(newApp.Branch_Code__c,new Set<String>{'RLPC processing officer', 'RPC Outsource Officer'});
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Assess income', 1);   //v2.0                         
                            }
                        }
                        
                        // Additional income assessment
                        integer AgrriCount = 0;
                        integer AllhavePerf = 0;  
                        
                        List <Account> accList = queryService.ApplicantList(newApp.id);
                        
                        for(genesis__Application_Parties__c par : parlist){
                            if(par.Perfios_Captured__c == True){
                                AllhavePerf++;
                            }
                            
                            if(par.Additional_Income_Amount1__c != null && par.Additional_Income_Amount1__c != 0){
                                AgrriCount++;
                            }
                        }
                        
                        //As discussed with kailas this 'Additional_Income_Approval__c' check box removed from LAP.
                        if(newApp.Sub_Stage__c =='Terms and Conditions Accepted' && oldApp.Sub_Stage__c <> 'Terms and Conditions Accepted' && newApp.Perfios_Captured__c == True ){
                            
                            if(AgrriCount> 0 && parlist.size() == AllhavePerf){
                                String usrId = getUserList(newApp.Branch_Code__c,'RLPC processing officer');
                                if(usrId ==null || usrId ==''){
                                    
                                    usrId = getUserList(newApp.Branch_Code__c,'DO processing officer');
                                }                        
                                if(usrId != null){
                                    creatTaskAll(newApp.Id, usrId, 'Additional income assessment', 1);                            
                                }
                            }
                        }
                        
                        // Verify property and upload valuation and legal reports //v2.0
                        if(newApp.Sub_Stage__c =='Terms and conditions accepted' && oldApp.Sub_Stage__c <> 'Terms and conditions accepted'){
                            
                            String usrId = getUserList(newApp.Branch_Code__c,'Branch manager');
                            
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Verify property and upload valuation and legal reports', 5); //v2.0                           
                            }
                        }

                        Boolean bureau_flag=false;
                        
                        
                        List<genesis__Application_Parties__c> partylist =associtedBuisness(newApp.Id );
                        System.debug('partylist'+partylist);
                        for(genesis__Application_Parties__c pp: partylist){
                            System.debug('**ppp'+pp.Key_Contact__r.Jocata_List_Match__c);
                            if(pp.Key_Contact__r.Bureau_Score__c != null || pp.Key_Contact__r.Jocata_List_Match__c != null){
                                if(pp.Key_Contact__r.Bureau_Score__c=='NoBorrowerFound'){
                                    pp.Key_Contact__r.Bureau_Score__c='6';
                                }
                                
                                if(pp.Key_Contact__r.Jocata_List_Match__c=='Yes' || Integer.valueOf(pp.Key_Contact__r.Bureau_Score__c)>=7 ){
                                    bureau_flag=true;
                                    break;
                                }
                            }
                        }
                        
                        //Approve associated business entity
                        if(newApp.Sub_Stage__c =='Terms and conditions accepted' && oldApp.Sub_Stage__c <> 'Terms and conditions accepted'  && bureau_flag==true){
                            
                            String usrId =getUserList(newApp.Branch_Code__c,'DO Head');
                            
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Approve associated business entity', 1);                            
                            }
                        }
                        //Initiate MOD TASK 
                        if(newApp.Sub_Stage__c ==Constants.LOAN_SANCTIONED_NON_STP_SUBSTAGE && oldApp.Sub_Stage__c <> Constants.LOAN_SANCTIONED_NON_STP_SUBSTAGE){
                            integer totalday = 90;//numberDays+90;
                            System.debug('## Initiate MOD ### --- > '+ oldApp.Sub_Stage__c);
                            String usrId = getUserList(newApp.Branch_Code__c,'Branch manager');
                            
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Initiate MOD', totalday);
                            }
                        }
                        System.debug('newApp.MODValueCheckbox__c >>> ' + newApp.MODValueCheckbox__c);
                        //Approve disbursement
                        if(newApp.MODValueCheckbox__c==True){
                            Date todaydate = system.today();
                            Date sanctiondate = newApp.Sanction_Date__c;
                            Integer numberDays = todaydate.daysBetween(sanctiondate);
                            integer totalday =numberDays+90;
                            System.debug('newApp.MODValueCheckbox__c >>> ' + newApp.MODValueCheckbox__c);
                            String usrId = getUserList(newApp.Branch_Code__c,'Branch manager');
                            if(usrId != null){
                                creatTaskAll(newApp.Id, usrId, 'Approve disbursement', totalday);
                            }
                        }
                    }
                    //LAP end here

                    if(( newApp.Sub_Stage__c ==Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE && oldApp.Sub_Stage__c <> Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE && newApp.SI_Bank_Name__c != Constants.PL_SI_KVB ) || (newApp.CBS_API_Sequence__c == Constants.VL_SI_E_mandate && oldApp.CBS_API_Sequence__c !=Constants.VL_SI_E_mandate) ){
                        String usrId = getBMList(newApp.Branch_Code__c,'Branch manager');
                        if(usrId !=null || usrId !=''){
                            creatTaskAll(newApp.Id, usrId, 'SI/ E-mandate', 10);    
                        }
                    }
                }
            }
            ApplicationTriggerHandler.IsFirstRun = false;
            System.debug('mapApp'+mapApp);
            update mapApp.values();

        }catch(Exception e){
            HandleBusinessException.captureError('TaskFlow_Helper', 'createTask', e); 
        }
    }

    //method will be called from Task Trigger
    Webservice static void createTaskApp(String appId, String taskSubject, Task tsk){
        try{
            genesis__Applications__c application = [Select Id,Loan_Purpose__c,Legal_desk_state_flag__c,Application_Stage__c,Branch_Code__c,Additional_Income_Approval__c,Record_Type_Name__c,Sub_Stage__c,FI_Status__c,Primary_Applicant__c,Sub_Type__c,(Select Id,name,Valuation_Applicable__c from genesis__Collaterals__r Limit 1) From genesis__Applications__c where Id =:appId];//v2.1
            System.debug('!!!!!'+application);
            if(application != null && (application.Record_Type_Name__c == Constants.HOMELOAN ||application.Record_Type_Name__c == Constants.LAPLOAN || application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W)){
                //Post FE trigger
                // removed taskSubject == 'Income Assessment'--v2.0   
                if((taskSubject =='Assess income' || taskSubject =='Additonal income assessment' || taskSubject == 'Assess Additional income' ) && (application.Record_Type_Name__c == Constants.HOMELOAN || application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W) && application.Sub_Stage__c == Constants.TermsAccepted){//v1.9
                    String usrId = getUserList(application.Branch_Code__c,'RLPC Head');
                    if(usrId ==null || usrId ==''){
                        usrId = getUserList(application.Branch_Code__c,'DOO');
                        if(usrId ==null || usrId ==''){
                            usrId = getUserList(application.Branch_Code__c,'DO Head');
                        }
                    }
                    if(usrId !=null || usrId !=''){
                        creatTaskAll(application.Id, usrId, 'Approve income', 1);
                    }
                }
                
                //Post M121
                else if(taskSubject =='Approve property details' && application.Record_Type_Name__c == Constants.HOMELOAN && application.Sub_Stage__c == Constants.TermsAccepted && application.Sub_Type__c != Constants.Sub_Type_Top_Up && application.Sub_Type__c != Constants.Sub_Type_Take_Over){//v2.0
                    String usrId = getUserList(application.Branch_Code__c,'DO Legal Clearance Officer');
                    System.debug('^^^usrId^^^^'+usrId);
                    if(usrId !=null || usrId !=''){
                        creatTaskAll(application.Id, usrId, 'Legal clearance', 1);
                    }
                }

                //prashant kyc for all products
                else if(taskSubject == 'Verify KYC' && application.Sub_Stage__c == Constants.TermsAccepted){//v1.9
                    String usrId = getUserList(application.Branch_Code__c,'RLPC Head');
                    if(usrId != null){
                        creatTaskAll(application.Id, usrId, 'Approve KYC', 1);
                    }
                }
                //prashant kyc 
                
                //Post Legal Clearance
                else if(taskSubject =='Verify property and upload valuation and legal reports' && application.Record_Type_Name__c == Constants.HOMELOAN && application.Sub_Stage__c == Constants.TermsAccepted && ((application.Sub_Type__c == Constants.Sub_Type_Top_Up && application.genesis__Collaterals__r.size() > 0 && application.genesis__Collaterals__r[0].Valuation_Applicable__c) || application.Sub_Type__c != Constants.Sub_Type_Top_Up)){//v1.9//v2.1
                    String usrId = getUserList(application.Branch_Code__c,'RLPC processing officer');
                    if(usrId ==null || usrId ==''){
                        usrId = getUserList(application.Branch_Code__c,'DO Processing Officer');    
                    }
                    creatTaskAll(application.Id, usrId, 'Enter property details', 1);             
                }
                
                else if(taskSubject =='RMDTask' && (application.Application_Stage__c != Constants.APPLICATION_REJECTED_MAINSTAGE && application.Application_Stage__c != Constants.DEACTIVATED_APPLICATIONS_MAINSTAGE)){//v1.9
                    String usrId = getUserList(application.Branch_Code__c,'RMD officer');
                    if(usrId !=null || usrId !=''){
                        creatTaskAll(application.Id, usrId, 'Approve score deviation', 1);      
                    }
                }
                //v2.1:Approve Top Up Venu
                else if(taskSubject =='Enter Top Up Details'  && application.Record_Type_Name__c == Constants.HOMELOAN && application.Sub_Stage__c == Constants.TermsAccepted && application.Sub_Type__c == Constants.Sub_Type_Top_Up){
                 String usrId = getUserList(application.Branch_Code__c,'RLPC Head');
                    if(usrId != null){
                        creatTaskAll(application.Id, usrId, 'Approve Top Up Details', 1);
                    }
                }

                //v2.1(start)
                else if (!application.Legal_desk_state_flag__c && (application.Sub_Stage__c == Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE || application.Sub_Stage__c == Constants.InitaiteMOD) && (application.Record_Type_Name__c == Constants.HOMELOAN ||application.Record_Type_Name__c == Constants.LAPLOAN || application.Record_Type_Name__c == Constants.PERSONALLOAN)) {
                    
                    if((taskSubject == 'Verify Documentation' || taskSubject == 'Correct Documentation')){
                        String usrId = getUserList(application.Branch_Code__c,'DO Legal Clearance Officer');
                        System.debug('^^^usrId^^^^'+usrId);
                        if(usrId != null){
                            creatTaskAll(application.Id, usrId, 'FEC Clearance', 1);
                        }
                    }
                } else if (application.Sub_Stage__c == Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE && (application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W)) {
                    if(taskSubject == 'Update mandatory documents & verify RC details' || taskSubject == 'Validate collateral details mis-match'){
                        String usrId = getUserList(application.Branch_Code__c,'DO Legal Clearance Officer');
                        System.debug('^^^usrId^^^^'+usrId);
                        if(usrId != null){
                            creatTaskAll(application.Id, usrId, 'FEC Clearance', 1);
                        }
                    }
                }//v2.1(end)
            }

            //v1.8(start)//All Products
            if(application <> null && application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.LAPLOAN || application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W || application.Record_Type_Name__c == Constants.HOMELOAN){
                
                if(taskSubject == 'Verify FI rejection' && application.Sub_Stage__c == Constants.TermsAccepted && (application.FI_Status__c == Constants.FI_Nega || application.FI_Status__c == Constants.FI_Refer || application.FI_Status__c == Constants.FI_MANUAL)){
                    //Approve FI TASK
                    String usrId = getUserList(application.Branch_Code__c,'DOO');//v1.8
                    System.debug('^^^usrId^^^^'+usrId);
                    if(usrId != null){
                        creatTaskAll(application.Id, usrId, 'Approve FI', 1);
                    }
                }
            }//v1.8(end)

            // approve property data entry task
            if(application <> null && application.Record_Type_Name__c == Constants.HOMELOAN){//v1.9

                if(taskSubject == 'Enter property details' && application.Sub_Stage__c == Constants.TermsAccepted){
                    String usrId = getUserList(application.Branch_Code__c,'RLPC Head');
                    System.debug('^^^usrId^^^^'+usrId);
                    if(usrId != null){
                        creatTaskAll(application.Id, usrId, 'Approve property details', 1); //v2.0
                    }
                }
                

                //v2.1(start)
                //Take-over(start)
                if(application.Sub_Type__c == Constants.Sub_Type_Take_Over){
                    if(taskSubject == 'Verify Take Over details' && application.Sub_Stage__c == Constants.TermsAccepted){
                        String usrId = getUserList(application.Branch_Code__c,'RLPC Head');
                        System.debug('^^^usrId^^^^'+usrId);
                        if(usrId != null){
                            creatTaskAll(application.Id, usrId, 'Approve Take Over details', 1);                          
                        }
                    }
                    //fetch completed task
                    if(taskSubject == 'Collect Original Documents' && (application.Sub_Stage__c == Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE || application.Sub_Stage__c == Constants.InitaiteMOD)){
                        List<Task> lstTask = new List<Task>();
                        lstTask = [Select Subject,WhatId From Task Where WhatId =:application.Id AND Subject = 'Supplementary Legal Opinion' AND Status = 'Completed'];
                        if (lstTask.size() > 0) {
                            String usrId = getUserList(application.Branch_Code__c,'DO Legal Clearance Officer');
                            System.debug('^^^usrId^^^^'+usrId);
                            if(usrId != null){
                                creatTaskAll(application.Id, usrId, 'Supplementary Legal Clearance', 1);
                            }
                        }
                    } else if(taskSubject == 'Supplementary Legal Opinion' && (application.Sub_Stage__c == Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE || application.Sub_Stage__c == Constants.InitaiteMOD)){
                        List<Task> lstTask = new List<Task>();
                        lstTask = [Select Subject,WhatId From Task Where WhatId =:application.Id AND Subject = 'Collect Original Documents' AND Status = 'Completed'];
                        if (lstTask.size() > 0) {
                            String usrId = getUserList(application.Branch_Code__c,'DO Legal Clearance Officer');
                            System.debug('^^^usrId^^^^'+usrId);
                            if(usrId != null){
                                creatTaskAll(application.Id, usrId, 'Supplementary Legal Clearance', 1);
                            }
                        }
                    }

                    /*if(taskSubject == 'Approve Take Over details' && application.Sub_Stage__c == Constants.TermsAccepted){
                        List<Facility__c> lstFacility = new List<Facility__c>();
                        lstFacility = [select Id,Name,Number_of_Delayed_EMI_payments__c,Number_of_Part_payments_of_EMI__c from Facility__c where Application__c=:application.Id AND Active__c = true];
                        if (lstFacility.size() > 0 && (lstFacility[0].Number_of_Delayed_EMI_payments__c > 0 || lstFacility[0].Number_of_Part_payments_of_EMI__c > 0)) {
                            String usrId = getUserList(application.Branch_Code__c,'RMD officer');
                            System.debug('^^^usrId^^^^'+usrId);
                            if(usrId != null){
                                creatTaskAll(application.Id, usrId, 'Verify Loan Application', 1);                        
                            }
                        }
                    }*/

                    if(taskSubject =='Approve property details' && application.Record_Type_Name__c == Constants.HOMELOAN && application.Sub_Stage__c == Constants.TermsAccepted){//v2.0
                        List<Task> lstTask = new List<Task>();
                        lstTask = [Select Subject,WhatId From Task Where WhatId =:application.Id AND Subject = 'Approve Take Over details' AND Status = 'Completed'];
                        if (lstTask.size() > 0) {
                            String usrId = getUserList(application.Branch_Code__c,'DO Legal Clearance Officer');
                            System.debug('^^^usrId^^^^'+usrId);
                            if(usrId !=null || usrId !=''){
                                creatTaskAll(application.Id, usrId, 'Legal clearance', 1);      
                            }
                        }
                    } else if(taskSubject =='Approve Take Over details' && application.Record_Type_Name__c == Constants.HOMELOAN && application.Sub_Stage__c == Constants.TermsAccepted){//v2.0
                        List<Task> lstTask = new List<Task>();
                        lstTask = [Select Subject,WhatId From Task Where WhatId =:application.Id AND Subject = 'Approve property details' AND Status = 'Completed'];
                        if (lstTask.size() > 0) {
                            String usrId = getUserList(application.Branch_Code__c,'DO Legal Clearance Officer');
                            System.debug('^^^usrId^^^^'+usrId);
                            if(usrId !=null || usrId !=''){
                                creatTaskAll(application.Id, usrId, 'Legal clearance', 1);      
                            }
                        }
                    }
                }
                //Take-over(end)
                

                //Reimbursement
                if (application.Sub_Type__c == Constants.Sub_Type_Reimbursement && application.Sub_Stage__c == Constants.TermsAccepted) {
                    if(taskSubject == 'Verify Expenses incurred'){
                        String usrId = getUserList(application.Branch_Code__c,'RLPC Head');
                        System.debug('^^^usrId^^^^'+usrId);
                        if(usrId != null){
                            creatTaskAll(application.Id, usrId, 'Approve Expenses incurred', 1);                          
                        }
                    }
                }
                //v2.1(end)
            }

            if(application <> null && application.Record_Type_Name__c == Constants.LAPLOAN && application.Sub_Stage__c == Constants.TermsAccepted){//v1.9
                System.debug('**Approve property details');  //v2.0 
                if(taskSubject == 'Enter property details'){ //v2.0            
                    String usrId = getUserList(application.Branch_Code__c,'RLPC Head');
                    System.debug('^^^usrId^^^^'+usrId);
                    if(usrId != null){
                        creatTaskAll(application.Id, usrId, 'Approve property details', 1);//v2.0                            
                    }
                }
            }
            //end approve prooerty data entry task
            
            /// For  Lap task
            if(application <> null && application.Record_Type_Name__c == Constants.LAPLOAN && application.Sub_Stage__c == Constants.TermsAccepted){//v1.9
                //Verify property and upload valuation and legal reports //v2.0
                if(taskSubject =='Verify property and upload valuation and legal reports'){//v2.0
                    String usrId = getUserList(application.Branch_Code__c,'RLPC processing officer');
                    if(usrId ==null || usrId ==''){
                        usrId = getUserList(application.Branch_Code__c,'DO Processing Officer');    
                    }
                    creatTaskAll(application.Id, usrId, 'Enter property details', 1);// v2.0            
                }
                
                if(taskSubject =='Approve property details'){//v2.0
                    String usrId = getUserList(application.Branch_Code__c,'DO Legal Clearance Officer');
                    if(usrId ==null || usrId ==''){
                        usrId = getUserList(application.Branch_Code__c,'DO Processing Officer');    
                    }
                    creatTaskAll(application.Id, usrId, 'Legal clearance', 1);                  
                }
                
                if(taskSubject == 'Additional income assessment' || taskSubject == 'Assess income'){//v2.0
                    String usrId = getUserList(application.Branch_Code__c,'RLPC Head');
                    if(usrId ==null || usrId ==''){
                        
                        usrId = getUserList(application.Branch_Code__c,'DO Head');
                    }
                    
                    
                    if(usrId !=null || usrId !=''){
                        creatTaskAll(application.Id, usrId, 'Approve income', 1); 
                    }
                } 
            }
            // Lap end here
            
            //V1.2-start
          /*  if(taskSubject == 'Update mandatory documents & verify RC details' && application.Sub_Stage__c ==Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE && (application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W))
            {
                try {
                    clcommon__Collateral__c collateral=new clcommon__Collateral__c();
                    if(application.Id!=null) {
                        collateral = [select id,name,clcommon__Certificated__c,Financing_Authority__c,Vehicle_Owner_Name__c from clcommon__Collateral__c where genesis__Application__c=:application.Id limit 1];
                    }
                    if(collateral!=null && ((!collateral.clcommon__Certificated__c && collateral.Vehicle_Owner_Name__c != application.Primary_Applicant__c) || collateral.Financing_Authority__c!=Constants.KVB_LTD)) {
                        String usrId = getUserList(application.Branch_Code__c,'Branch manager');
                        System.debug('^^^usrId^^^^'+usrId);
                        if(usrId != null){
                            creatTaskAll(application.Id, usrId, 'Confirm RC details', 30);                         
                        }              
                    }  
                } catch(Exception e) {
                    System.debug('Task Exception== '+taskSubject+':'+e);
                    System.debug('**Line Number=='+e.getLineNumber());
                }
                
            }*/
            //start ---
            if(taskSubject == 'Update mandatory documents & verify RC details' && application.Sub_Stage__c ==Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE && (application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W))
            {
                
                    clcommon__Collateral__c collateral=new clcommon__Collateral__c();
                    if(application.Id!=null) {
                        collateral = [select id,RC_Response_Error_Message__c,name,NameMatch__c,CollateralMatch__c,clcommon__Certificated__c,Financing_Authority__c,Vehicle_Owner_Name__c from clcommon__Collateral__c where genesis__Application__c=:application.Id limit 1];
                    }
                String financeAuth=collateral.Financing_Authority__c;
                set<string> karurlist=new Set<string>{'Vysya','VYSYA','KVB','kvb','vysya'};
                boolean check=false;
                List<String> lsttest=financeAuth.split(' ');

              for(String s: lsttest){
                if(karurlist.contains(s)){
                check=true;
                System.debug('tesr'+check);
               break;
        }
    }
                
                if((collateral.NameMatch__c=='No'||collateral.CollateralMatch__c=='No' ||collateral.RC_Response_Error_Message__c==Constants.RegistrationNot) || check==false){
                        String usrId = getUserList(application.Branch_Code__c,'DOO');
                        System.debug('^^^usrId^^^^'+usrId);
                        if(usrId != null){
                            creatTaskAll(application.Id, usrId, 'Validate collateral details mis-match', 1);                         
                        }              
                    }  
                
                
            }
            
            //end---
            //V1.2-end
            
        }catch(Exception e){
            System.debug('**line number'+e.getLineNumber()+'Errro Trace'+e.getMessage());
            HandleBusinessException.captureError('TaskFlow_Helper', 'createTaskApp', e);
        }
    }

    public static void creatTaskAll(String appId,String usrId, String sub, Integer days){
        System.debug('inside task creation');
        List<Task> tskList = new List <Task>();
        tskList = [Select Subject,WhatId From Task Where WhatId =: appId AND Subject =: sub];
        System.debug('::::NNNN::::'+tskList);
        if(tskList.size()==0){
            Task tsk = new Task();
            tsk.WhatId = appId;
            tsk.OwnerId = usrId;
            tsk.ActivityDate = System.today() + days;
            tsk.Subject = sub;
            tsk.Status = 'Not Started';
            tsk.Priority = 'High';
            try{
                System.debug('tsk:::'+tsk);
                Insert tsk;
            }catch(Exception e){
                System.debug('e.msg:::'+e.getCause());
                System.debug('e.msg:::'+e.getLineNumber());
                System.debug('e.msg:::'+e.getMessage());
                System.debug('e.msg:::'+e.getStackTraceString());
            }
        }
        //v1.5(start) 
        else {
            try{
                genesis__Applications__c appln = [SELECT id,name,Record_Type_Name__c from genesis__Applications__c where Id=:tskList[0].WhatId];
                if ((sub=='Correct Documentation' || sub=='Verify Documentation') && (appln.Record_Type_Name__c ==Constants.HOMELOAN || appln.Record_Type_Name__c ==Constants.LAPLOAN || appln.Record_Type_Name__c ==Constants.PERSONALLOAN || appln.Record_Type_Name__c ==Constants.VL2W || appln.Record_Type_Name__c ==Constants.VL4W)){
                    Task tsk = new Task();
                    tsk.Id = tskList[0].Id;
                    tsk.OwnerId = usrId;
                    tsk.ActivityDate = System.today() + days;
                    tsk.Status = 'Not Started';
                    tsk.Priority = 'High';
                    System.debug('tsk:::'+tsk);
                    Update tsk;
                }
            }catch(Exception e){
                System.debug('e.msg:::tsk>>>'+e.getLineNumber());
                System.debug('e.msg:::tsk>>>'+e.getStackTraceString());
            }
        }
        //v1.5(end)
    }

    public static String getUserList(String branchCode, String Designation){
        System.debug('***branchCode**'+branchCode+'***Designation****'+Designation);
        List <User> usrList = new List <User>();
        if(Designation=='RMD officer'){
            usrList = [Select ID From User where  Role_Name__c=:Designation AND IsActive =:True];
            System.debug('!!!!!RMD officer::::'+usrList);
        }
        //v1.7(start)
        else if (Designation=='Verifying Officer') {
            usrList = [Select ID From User where  Role_Name__c=:Designation AND IsActive =:True];
            System.debug('!!!!!Verifying Officer::::'+usrList);
        }
        //v1.7(start)
        else{
            Branch_Master__c brMaster = [Select Id, CODCCBRN__c,Linked_RLPC__c, Division_Code__c From Branch_Master__c Where CODCCBRN__c=:branchCode limit 1];
            System.debug('brMaster:::'+brMaster);
            
            if(Designation =='Branch manager'){
                usrList = [Select ID From User where Office_Code__c =:brMaster.CODCCBRN__c And Role_Name__c=:Designation AND IsActive =:True];
                System.debug('!!!!!Branch manager::::'+usrList);
            }else if(Designation.contains('RLPC') && brMaster.Linked_RLPC__c != null){
                usrList = [Select ID From User where Office_Code__c =:brMaster.Linked_RLPC__c And Role_Name__c=:Designation AND IsActive =:True];
                System.debug('!!!!!RLPC::::'+usrList);
            }
            else if(Designation == 'DO Processing Officer'){
                usrList = [Select ID From User where Office_Code__c =:brMaster.Division_Code__c And Role_Name__c=:Designation AND Designation__c =:null AND IsActive =:True];
                System.debug('!!!!!DO Processing Officer::::'+usrList);
            }        else{
                usrList = [Select ID From User where Office_Code__c =:brMaster.Division_Code__c And Role_Name__c=:Designation AND IsActive = True];
                System.debug('##########userList'+usrList);        
            }
        }
        System.debug('####'+usrList);
        String UsrId = AssignTask.userAssign(usrList);
        if(UsrId == null){
            if(usrList.size()>0){
                UsrId = usrList[0].Id;
            }            
        } 
        return UsrId;
    }

    //RPC outsource officer / RLPC officer
    public static String getRPCUser(String branchCode, Set<String> RPC_User){
        System.debug('branchCode:'+branchCode+'RPC_User:'+RPC_User);
        List<User> usrList = new List<User>();
        Branch_Master__c brMaster = [Select Id, CODCCBRN__c, Linked_RLPC__c, Division_Code__c From Branch_Master__c Where CODCCBRN__c=:branchCode limit 1];
        if((RPC_User.contains('RLPC processing officer') || (RPC_User.contains('RPC Outsource Officer'))) && brMaster.Linked_RLPC__c != null){
                usrList = [Select ID From User where (Office_Code__c =:brMaster.Linked_RLPC__c OR Office_Code__c =:brMaster.Division_Code__c) AND Role_Name__c IN :RPC_User AND IsActive =:True];
        }
        System.debug('usrList:'+usrList);
        String UsrId = AssignTask.userAssign(usrList);
        if(UsrId == null){
            if(usrList.size()>0){
                UsrId = usrList[0].Id;
            }            
        }
        return UsrId;    
    }
    
    public static String getBMList(String branchCode, String Designation){
        System.debug('branchCode:::'+branchCode+':::Designation:::'+Designation);
        List <User> usrList = [Select ID From User where Office_Code__c =:branchCode And Role_Name__c=:Designation AND IsActive =:True];
        String UsrId = AssignTask.userAssign(usrList);
        return UsrId;
    }
    
    public static void preventTaskDeletion(Task taskRec){
        taskRec.addError('<div style="color:red"> This task can not be deleted, Please contact the administrator. </div>',false);
    }

    //for buisness entity
    public static  List<genesis__Application_Parties__c>  associtedBuisness(String appid){
        
        List<genesis__Application_Parties__c> partylist=[SELECT Active__c,Company__c,genesis__Application__c,genesis__Party_Account_Name__r.name,Key_Contact__r.Jocata_List_Match__c,Key_Contact__r.Bureau_Score__c,genesis__Party_Account_Name__r.Jocata_List_Match__c,genesis__Party_Account_Name__r.Bureau_Score__c FROM genesis__Application_Parties__c WHERE genesis__Application__c =:appid AND Active__c = true AND Company__c = true];
        
        return partylist;
    }

    //Task from Account
    public static void CrTaskAcc(List<Account> AccList,Map<id,Account> oldMapObj){
        for(Account ac : AccList){
            Integer Bureau = 0;
            Integer Jokata = 0;
            Integer BureauNull = 0;
            Integer JocataNull = 0;            
            String bureaScore = ac.Bureau_Score__c != null ? ac.Bureau_Score__c : '0';
            if(((oldMapObj.get(ac.id).Bureau_Score__c != ac.Bureau_Score__c) && (Integer.ValueOf(bureaScore) > 7)) || ((oldMapObj.get(ac.id).Jocata_List_Match__c != ac.Jocata_List_Match__c) && (ac.Jocata_List_Match__c == 'Yes'))){
                List<genesis__Application_Parties__c> PT = [Select Id,genesis__Application__r.Id,genesis__Application__r.Branch_Code__c From genesis__Application_Parties__c Where Key_Contact__c =:ac.Id];
                System.debug('$$$$'+PT);
                if(PT.size()>0){
                    System.debug('PT[0].genesis__Application__r.Id'+PT[0].genesis__Application__r.Id);
                    List<genesis__Application_Parties__c> PTList = [Select Id,genesis__Application__r.Branch_Code__c,Key_Contact__r.Bureau_Score__c,Key_Contact__r.Jocata_List_Match__c,Key_Contact__r.Id From genesis__Application_Parties__c Where genesis__Application__r.Id =: PT[0].genesis__Application__r.Id AND Active__c =: true AND Company__c =: true];
                    System.debug('ptlist:--'+PTList);
                    List<ID> Ids = new List<Id>();
                    for(genesis__Application_Parties__c party : PTList){
                        Ids.add(party.Key_Contact__r.Id);
                    }
                    List<Account> acList = [Select Id,Bureau_Score__c,Jocata_List_Match__c From Account Where Id IN: Ids];
                    System.debug('^^^^'+acList);
                    for(Account p : acList){
                        String BureauS  = p.Bureau_Score__c != null ? p.Bureau_Score__c : '0';
                        if(p.Bureau_Score__c == null){
                            BureauNull++;
                        }
                        if(p.Jocata_List_Match__c == null){
                            JocataNull++;
                        }
                        if(Integer.ValueOf(BureauS)>7){
                            Bureau++;
                        }
                        if(p.Jocata_List_Match__c == 'Yes'){
                            Jokata++;
                        }
                    }
                    System.debug(BureauNull+'##'+JocataNull+'##'+Bureau+'##'+Jokata);
                    if((BureauNull == 0 || JocataNull == 0) && (Bureau > 0 || Jokata > 0)){
                        String usrId =getUserList(PT[0].genesis__Application__r.Branch_Code__c,'DO Head');                        
                        if(usrId != null){
                            creatTaskAll(PT[0].genesis__Application__r.Id, usrId, 'Approve associated business entity', 1);                            
                        }
                    }
                }
            } 
        }
    }
    
    //compleate task
    public static void CloseNstpTask(Map<id,genesis__Applications__c> newMapApp,Map<id,genesis__Applications__c> oldMapApp){
        List<Task> tasklist=new List<Task>();
            for(genesis__Applications__c app :newMapApp.values()){
               if(oldMapApp.get(app.id).Sub_Stage__c !=Constants.LOAN_SANCTIONED_NON_STP_SUBSTAGE && app.Sub_Stage__c==Constants.LOAN_SANCTIONED_NON_STP_SUBSTAGE ){
                    List<Task> tlist=[select subject,status,WhatId from task where subject='Approve score deviation' AND WhatId=:app.id];
                    if(tlist.size()>0){
                       System.debug('check nstp++');
                       if(tlist[0].status!='Completed'){
                        tlist[0].sanction__c=true;
                        tlist[0].status='Completed';
                           tasklist.add(tlist[0]);
                       }
                   }
                }
            }
            if(tasklist!=null){
                update tasklist;
            }
    }
	
}