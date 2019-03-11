/*
* Name     : CRILC_API_Response_Handler
* Company  : ET Marlabs
* Purpose  : To used as a Handler class for CRILC_API_Response. 
* Author   : Raushan
*/
public class CRILC_API_Response_Handler {
    //method
    public static void getCRILC_API_Response(CRILC_API_Response crilcAPIObj,String custSFId){
        If(crilcAPIObj !=null && custSFId !=null && custSFId !=''){ 
            If(crilcAPIObj.statusOfClassificationOfBorrower !=null){
                CRILC_API_Response.StatusOfClassificationOfBorrower	statusOfClassObj	=	crilcAPIObj.statusOfClassificationOfBorrower;
                If(statusOfClassObj !=null){
                    Account 	accObj	=	new Account();
                    If(statusOfClassObj.assetClassificationOfBorrower !=null){
                        List<String> listOfSmaClassficationStr  = new List<String>{'Non-CDR Standard Restructured','Standard Restructured under CDR','Sub-standard','Substandard restructured','Doubtful 1','Doubtful 2','Doubtful 3','Doubtful Restructured','Loss'};
                        Integer smeSum	= 0;
                        Integer count 	= 0;
                        List<CRILC_API_Response.AssetClassificationOfBorrower>   listOfassetClassObjWrrp   =    statusOfClassObj.assetClassificationOfBorrower;
                        If(listOfassetClassObjWrrp !=null){
                            for(CRILC_API_Response.AssetClassificationOfBorrower assetClassObj : listOfassetClassObjWrrp){
                                If(assetClassObj !=null){
                                    If(!Utility.ISStringBlankorNull(assetClassObj.smaClassification)){
                                        If(assetClassObj.smaClassification =='Standard'){
                                            smeSum +=0;
                                        }else If(assetClassObj.smaClassification =='SMA-0'){
                                            smeSum +=30;
                                        }else If(assetClassObj.smaClassification =='SMA-1'){
                                            smeSum +=60;
                                        }else If(assetClassObj.smaClassification =='SMA-2'){
                                            smeSum +=90;
                                        }else If(listOfSmaClassficationStr.contains(assetClassObj.smaClassification)){
                                            smeSum +=90;
                                        }
                                        count++;
                                    }
                                    
                                }
                                
                            }
                            If(smeSum > 0 && count >0){
                                accObj.Id	=	(Id)custSFId;
                                accObj.Crilc_Info__c = smeSum/count;    
                             }
                           If(accObj.id !=null){
                            AccountTriggerHandler.isAccountTrigger = false;   
                            update accObj;   
                            } 
                        }
                    }
                }
            }
        }
    }
}