public class OVERALL_EXPOSURE_UPDATION_HELPER {
    
    public Static OVERALL_EXPOSURE_UPDATION.updateOverAllExposureResponse updateOverallExposureData(List<OVERALL_EXPOSURE_UPDATION.cls_updateOverAllExposure> exposureListToUpate){
        try{
            OVERALL_EXPOSURE_UPDATION.updateOverAllExposureResponse exposureResponse= new OVERALL_EXPOSURE_UPDATION.updateOverAllExposureResponse();
            
            list<OVERALL_EXPOSURE_UPDATION.cls_ResultData> failData= new list<OVERALL_EXPOSURE_UPDATION.cls_ResultData>();
            list<OVERALL_EXPOSURE_UPDATION.cls_ResultData> SuccData= new list<OVERALL_EXPOSURE_UPDATION.cls_ResultData>();
            List<Facility__c> faciToUpdate = new List<Facility__c>();
            Set<Id> updateSuccessFaciIDs= new Set<Id>();
            Map<String,OVERALL_EXPOSURE_UPDATION.cls_updateOverAllExposure> exposureAccNoMap= new Map<String,OVERALL_EXPOSURE_UPDATION.cls_updateOverAllExposure>();
            Map<String,Facility__c> faciAccNoMap= new Map<String,Facility__c>();
            for(OVERALL_EXPOSURE_UPDATION.cls_updateOverAllExposure expData: exposureListToUpate){
                exposureAccNoMap.put(expData.Account_Number,expData);
            }
            if(exposureAccNoMap.size()>0 && exposureAccNoMap.keyset()!= null){
                List<Facility__c> listOfTermLoanFac = [SELECT id,name,Application__c,Account_Number__c,Application__r.recordtype.developername FROM Facility__c WHERE Account_Number__c IN:exposureAccNoMap.keyset() ]; //AND Application__r.recordtype.developername = 'Term_Loan'
                for(Facility__c faci: listOfTermLoanFac){
                    faciAccNoMap.put(faci.Account_Number__c,faci);
                }
                for(OVERALL_EXPOSURE_UPDATION.cls_updateOverAllExposure expWrp: exposureAccNoMap.values()){
                    if(faciAccNoMap.size()>0 && faciAccNoMap.containsKey(expWrp.Account_Number)){
                        Facility__c faciUpdt= faciAccNoMap.get(expWrp.Account_Number);
                        if(!Utility.ISStringBlankorNull(expWrp.Outstanding_Balance)){
                            faciUpdt.Current_Outstanding__c = Decimal.valueOf(expWrp.Outstanding_Balance);
                        }
                        if(!Utility.ISStringBlankorNull(expWrp.Rate_Of_Interest)){
                            faciUpdt.Interest_Rate__c = Decimal.valueOf(expWrp.Rate_Of_Interest);
                        }if(!Utility.ISStringBlankorNull(expWrp.holiday_period)){
                            faciUpdt.Holiday_Period__c = Decimal.valueOf(expWrp.holiday_period);
                        }
                        faciToUpdate.add(faciUpdt);
                    }else{
                        OVERALL_EXPOSURE_UPDATION.cls_ResultData RecErrRslt= new OVERALL_EXPOSURE_UPDATION.cls_ResultData();
                        RecErrRslt.Account_Number= expWrp.Account_Number;
                        RecErrRslt.Message= 'Record Not Found';
                        failData.add(RecErrRslt);

                    }
                }
                System.debug('faciToUpdate.size()----->>>'+faciToUpdate.size());
                if(faciToUpdate.size()>0){
                    List<Database.SaveResult> result = Database.update(faciToUpdate, false);
                    for(Database.SaveResult sr:result){
                        if (sr.isSuccess()) {
                            updateSuccessFaciIDs.add(sr.getId());
                        }
                    }
                    system.debug('updateSuccessFaciIDs=====> '+updateSuccessFaciIDs);
                }
                if(faciAccNoMap.size()>0){
                    for(Facility__c faci: faciAccNoMap.values()){
                        if(updateSuccessFaciIDs.size()>0 && updateSuccessFaciIDs.contains(faci.Id)){
                            OVERALL_EXPOSURE_UPDATION.cls_ResultData UpdtSucRslt= new OVERALL_EXPOSURE_UPDATION.cls_ResultData();
                            UpdtSucRslt.Account_Number= faci.Account_Number__c;
                            UpdtSucRslt.Message= 'Update Success';
                            SuccData.add(UpdtSucRslt);
                        }else{
                            OVERALL_EXPOSURE_UPDATION.cls_ResultData UpdtErrRslt= new OVERALL_EXPOSURE_UPDATION.cls_ResultData();
                            UpdtErrRslt.Account_Number= faci.Account_Number__c;
                            UpdtErrRslt.Message= 'Update Error';
                            failData.add(UpdtErrRslt);
                        }

                    }

                }
            }
            if(SuccData.size()>0){
             system.debug('SuccData===> '+SuccData); 
             exposureResponse.SuccessResult = new OVERALL_EXPOSURE_UPDATION.cls_SuccessResult();
             exposureResponse.SuccessResult.ResultData= SuccData;
            }
            if(failData.size()>0){
             system.debug('failData===> '+failData);
             exposureResponse.FailureResult = new OVERALL_EXPOSURE_UPDATION.cls_FailureResult(); 
             exposureResponse.FailureResult.ResultData= failData;
            }
            if(exposureResponse!= null){
                return exposureResponse;
            }else{
                return null;
            }


        }catch(Exception ex){
             system.debug('Exception::' + ex.getMessage() + ex.getMessage() + ex.getLineNumber());
             return null;
              
        }
    }
}