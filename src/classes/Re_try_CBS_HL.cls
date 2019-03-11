global class Re_try_CBS_HL {
    
    Webservice static void retry_CBS(String AppId){    
        genesis__Applications__c  app = new genesis__Applications__c();
        app = [Select ID,Service_Type_Name__c,Record_Type_Name__c,CBS_API_Sequence__c,Retry_CBS__c,genesis__Disbursement_Date__c  From genesis__Applications__c Where Id =:AppId];
        system.debug('^^^^^^'+app);
        if(app.Retry_CBS__c == False && (app.CBS_API_Sequence__c<>null || app.CBS_API_Sequence__c<>'')){          
            system.debug('**Retry**'+app.Retry_CBS__c+'**Sequence**'); 
            List<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
            if(app.CBS_API_Sequence__c =='0.1'){
                WS_Vendor_CBS_CreateCustIC.cbs_CreateCustIC(app.Id);
            }else if(app.CBS_API_Sequence__c =='1'){
                //Customer Dedupe
                WS_CBS_Dedupe.callDedupe(app.Id);
            }else if(app.CBS_API_Sequence__c =='2'){
                //Customer EKYC 
                if(app.Record_Type_Name__c == 'SME Renewal') SME_CBS_Handler.eKYC_Updation(new List<Id>{app.Id});
                else {
                    WS_CBS_Dedupe.callDedupe(app.Id);
                    //WS_CBS_eKYC_Creation_HL.cbs_eKYC_Creation(null,app.Id,null);
                }
            }else if(app.CBS_API_Sequence__c =='3'){
                //Customer ID creation
                if(app.Record_Type_Name__c == 'SME Renewal') SME_CBS_Handler.customerIdCreation(new List<Id>{appId}); 
                else{
                    WS_CBS_Dedupe.callDedupe(app.Id);
                     //WS_CBS_eKYC_Creation_HL.cbs_eKYC_Creation(null,app.Id,null);
                     //WS_CBS_Create_CustID.getCBSID(app.Id); 
                }
            }else if(app.CBS_API_Sequence__c =='4'){
                //Loan Creation
                WS_CBS_Loan_Creation_HL.createLoan(app.Id,null);
            }else if(app.CBS_API_Sequence__c =='5'){
                //Customer Link to loan
                if(app.Record_Type_Name__c == 'SME Renewal') SME_CBS_Handler.customerLinkage(new List<Id>{app.Id});
                else WS_CBS_Loan_Creation_HL.customerLinkage(null, app.Id, null,UpcbsLog);
            }else if(app.CBS_API_Sequence__c =='6'){
                //Collateral Creation
                WS_CBS_Collateral_Creation.Collateral_Creation(app.Id,null,null,UpcbsLog );
            }else if(app.CBS_API_Sequence__c =='7'){
                //Customer Linkage
                WS_CBS_Collateral_Linkage_HL.linkCollateral(app.Id,null,UpcbsLog);
            }else if(app.CBS_API_Sequence__c =='8'){
                //CBR file updation
                WS_CBS_CBR_DTLS_HL.CBR_DTLS(app.Id);
            }else if(app.CBS_API_Sequence__c =='11.5'){
                //Host Disbursment
                WS_CBS_HOST_Disbursment_HL.Host_request(app.Id,null);
            }else if(app.CBS_API_Sequence__c =='10'){
                //Mis file update
                WS_CBS_MIS_Update_HL.Mis_Update(app.Id,UpcbsLog);
            }
            else if(app.CBS_API_Sequence__c =='11'){
                //Photo update
                WS_CBS_UploadImage.cbs_photo_upload(app.Id,UpcbsLog);
            }
            else if(app.CBS_API_Sequence__c =='14'){
                SME_StockStatementHandler.requesthandler(appId);
            }
            else if(app.CBS_API_Sequence__c =='15'){
                if(app.Record_Type_Name__c == 'SME Exceeding'){
                    if(app.Service_Type_Name__c == 'LimitUpdation'){
                        SME_CBS_Handler.limitUpdation_ChargeColllection(new List<Id>{appId});
                    }else if(app.Service_Type_Name__c == 'ChargeCollection'){
                        SME_CBS_Handler.chargeCollection(new List<Id>{appId},true);
                    }
                }
                else
                    SME_CBS_EAE.requestHandler(appId);
            }
            else if(app.CBS_API_Sequence__c =='16'){
                SME_CBS_EAE.requestHandlerNewLoan(appId,'');
            }
            else if(app.CBS_API_Sequence__c =='20'){
                // WS_CBS_HOST_Disbursment_HL.Host_request(app.Id);
                WS_CBS_Loan_Disbursment_HL.callDisb(app.Id,UpcbsLog,null); //As discussed with Vivek and Sriram sir calling Loan Disbusrsment - Dated: 2018/Oct/02
            }
            else if(app.CBS_API_Sequence__c =='21'){
                List <ID> appIds = new List<ID>();
                appIds.add(app.Id);
                CBS_SI_CreateHandler.CBS_SI_Creation(appIds,UpcbsLog,null); //Calling SI CBS API
            }
             else if(app.CBS_API_Sequence__c =='20.5'){
                  WS_CBS_CASA_Disbursement_Retail.CASA_request(app.Id,UpcbsLog,string.valueOf(app.genesis__Disbursement_Date__c),null); //Calling CASA CBS API
            }
             else if(app.CBS_API_Sequence__c =='3.5'){
                 Ws_CBS_CustdetailsModification.CBS_Custmodificationrequest(app.Id,null); //Calling CASA CBS API
            }
            else if(app.CBS_API_Sequence__c =='6.2'){
                WS_CBS_Collateral_Creation.Collateral_Creation(app.Id,null,null,UpcbsLog );
            }
            else if(app.CBS_API_Sequence__c =='6.1'){
                 WS_CBS_Collateral_Linkage_HL.linkCollateral(app.Id,null,UpcbsLog );
            }
            // added for vl collateral update api
             else if(app.CBS_API_Sequence__c =='22'){
                Ws_CBS_collateral_updateAPI.Collateral_Update(app.Id,null); //retry for 22 api
            }
           //end 
        }       
        //update app;
        
    }
}