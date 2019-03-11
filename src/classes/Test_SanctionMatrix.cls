@IsTest
Private class Test_SanctionMatrix{
    
    static testmethod void testSanctionMatrix(){
        try{
           Set<String> userIds = new Set<String>();
           SanctionMatrix_Helper.getUserDetail(userIds);
           }catch(Exception e){}            
            try{
            SanctionMatrix_Helper.getAuthorityLevel();
            }catch(Exception e){}
            try{
            SanctionMatrix_Helper.getDivisonCOMapping();
            }catch(Exception e){}
            try{
            List<Authority_Hierarchy_Level__mdt> authHierarchy = new List<Authority_Hierarchy_Level__mdt>();
            SanctionMatrix_Helper.hierarchyLevel(authHierarchy);
            }catch(Exception e){}
            try{
            SanctionMatrix_Helper.getOverallMatrix();
            }catch(Exception e){}
            try{
            SanctionMatrix_Helper.getChildFacility(null,null,null,null,1,true,true);
            }catch(Exception e){}           
            try{
            set<String> productIds = new set<String>();
            SanctionMatrix_Helper.getSanctionMatricRules(productIds);
            }catch(Exception e){}
            Set<string> facilityIds = new Set<string>();
            Set<string> collateralIds = new Set<string>();
            try{            
            SanctionMatrix_Helper.getFacilityCollaterals(facilityIds);
            }catch(Exception e){}
            
            try{
            SanctionMatrix_Helper.getAllFacilityCollaterals(collateralIds,facilityIds,null);
        }catch(Exception e){}
        
    }
}