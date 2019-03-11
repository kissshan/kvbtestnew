/*
* Name          : ROIComputationEAE
* Description   : Calculate the ROI based on Score and Coverage of application and Facilities
* Author        : Vignesh
*/
public class ROIComputationEAE {
    public ROIComputationEAE() {
        
    }
    
    public static map<Id,Decimal> computeROI(Id appId, Decimal securityCoverage){
        try{
            List<Facility__c> facilityLst= [Select id,Application__r.Overall_Score__c,Application__r.Type__c,Application__r.genesis__Customer_Cash_Used_For__c,Application__r.New_to_Business__c,CL_Product__r.Product_Type__c,CL_Product__r.Facility_Category__c,Application__r.genesis__Account__r.Date_of_Incorporation__c from Facility__c where Application__c=: appId];
            Map<String,List<Spread__mdt>> spreadMap= new Map<String,List<Spread__mdt>>();
            Map<Id,Decimal> faciIdwithValMap= new Map<Id,Decimal>();
            Boolean isGreaterThanOneFinancialYear = Application_AssessmentCtrl.calculateFinancialOneYear(facilityLst[0].Application__r.genesis__Account__r.Date_of_Incorporation__c);
            system.debug('isGreaterThanOneFinancialYear::'+isGreaterThanOneFinancialYear);
            for(Spread__mdt spd: [select MasterLabel,Overall_Score__c,New_to_Credit__c,New_to_Business__c,Overall_Score__r.Min_Value__c,Overall_Score__r.Max_Value__c,Security_Coverage__r.Min_Value__c,Security_Coverage__r.Max_Value__c,Security_Coverage__r.Type__c,Spread_Value__c from Spread__mdt] ){
                
                if(spreadMap.containsKey(spd.Security_Coverage__r.Type__c)){
                    spreadMap.get(spd.Security_Coverage__r.Type__c).add(spd);
                }else{
                    spreadMap.put(spd.Security_Coverage__r.Type__c, new List<Spread__mdt>{spd});
                }
            }
            Decimal overallScore=0.0;
            Decimal spreadValue= 0.0;
            if(facilityLst.size()>0){
                for(Facility__c faci: facilityLst){
                    
                    String ProdType= (faci.CL_Product__r.Facility_Category__c== 'SOD' )? constants.SOD_CATEGORY : (faci.CL_Product__r.Facility_Category__c== 'OCC'? constants.OCC_CATEGORY: null);
                        // I need occ and sod in
                        
                        system.debug('ProdType== '+ProdType);
                    if(ProdType!=null){
                        if(faci.Application__r.New_to_Business__c && !isGreaterThanOneFinancialYear){
                            if(faci.CL_Product__r.Facility_Category__c== 'SOD'){
                                faciIdwithValMap.put(faci.Id,4.00);
                            }
                            else if(faci.CL_Product__r.Facility_Category__c== 'OCC'){
                                faciIdwithValMap.put(faci.Id,3.50);
                            }
                        }else{
                            for(Spread__mdt spd: spreadMap.get(ProdType)){
                                system.debug('spd== '+spd);
                                system.debug('spd== '+spreadMap.get(ProdType));
                                overallScore= faci.Application__r.Overall_Score__c!=null ? Decimal.valueOf(faci.Application__r.Overall_Score__c): 0.0;
                                system.debug('overallScore== '+overallScore);
                                if(faci.Application__r.New_to_Business__c==true && (spd.New_to_Business__c== true) &&
                                   (securityCoverage>= spd.Security_Coverage__r.Min_Value__c && securityCoverage <= spd.Security_Coverage__r.Max_Value__c) && (overallScore >= spd.Overall_Score__r.Min_Value__c && overallScore <= spd.Overall_Score__r.Max_Value__c)){
                                       spreadValue= faci.Application__r.genesis__Customer_Cash_Used_For__c== 'Priority'?  spd.Spread_Value__c-0.50: spd.Spread_Value__c;
                                       faciIdwithValMap.put(faci.Id,spreadValue);
                                       system.debug('faciIdwithValMap::'+faciIdwithValMap);
                                       break;
                                   }
                                else if(faci.Application__r.New_to_Business__c==false && (spd.New_to_Credit__c== true) &&
                                        (securityCoverage>= spd.Security_Coverage__r.Min_Value__c && securityCoverage <= spd.Security_Coverage__r.Max_Value__c)
                                        && (overallScore >= spd.Overall_Score__r.Min_Value__c && overallScore <= spd.Overall_Score__r.Max_Value__c)){
                                            spreadValue= faci.Application__r.genesis__Customer_Cash_Used_For__c== 'Priority'?  spd.Spread_Value__c-0.50: spd.Spread_Value__c;
                                            faciIdwithValMap.put(faci.Id,spreadValue);
                                            system.debug('faciIdwithValMap::'+faciIdwithValMap);
                                            break;
                                        }
                            }
                        }
                        
                    }
                    
                }
            }
            system.debug('faciIdwithValMap===> '+faciIdwithValMap);
            return faciIdwithValMap;
        }catch(Exception e){
            System.debug('@@@@@@@@@'+e.getMessage()+' AT '+e.getLineNumber());
            HandleBusinessException.captureError('ROIComputationEAE', 'computeROI', e);
            return null;
        }
        
        
    }
}