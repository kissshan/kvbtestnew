/*
* @Name         : SanctionMatrix_Helper
* @description  : This class is used as an utility/helper for SanctionMatrix_Calculation class
* @author       : Amritesh 
*/
public class SanctionMatrix_Helper {


    /*@purpose      : Get user infomation from User table
     *@param        : userIds set of user Id
     *@returtype    : Map<Id,User>
    */
    public static Map<Id,User> getUserDetail(Set<String> userIds){
        return new Map<Id,User>([Select id,Name,Division,Designation__c from User where Id IN: userIds]);
    }

    /*@purpose      : Get Sanction Authority level infomation from Authority_Hierarchy_Level__mdt custom-metadat type oject
     *@returtype    : List<Authority_Hierarchy_Level__mdt>
    */
    public static List<Authority_Hierarchy_Level__mdt> getAuthorityLevel(){
        return [Select MasterLabel,DeveloperName,Authority_Level__c,EAE_Limit__c,Margin_OCC_Manufacturing_Receivables__c,Margin_OCC_Manufacturing_Stock__c,Margin_OCC_Trading_Stock__c,Margin_SOD__c from Authority_Hierarchy_Level__mdt];
    }


    /*
    *@purpose   : Get Division vs CO Officer mapping from Division_CO_Mapping__mdt custom meta data type object
    *@returtype : Map<String,string>
    */
    public static Map<String,string> getDivisonCOMapping(){
        Map<String,string> mapping  = new Map<String,String>();

        for(Division_CO_Mapping__mdt s : [Select id,developerName,CO_Officer__c,Division__c from Division_CO_Mapping__mdt]){
            if(s.Division__c != null && s.CO_Officer__c != null){
                mapping.put((s.Division__c).toUpperCase(),s.CO_Officer__c);
            }
        }
        return mapping;
    }

    /*
    *@purpose   : Get sanction auhtority role vs level map
    *@returtype : Map<string,integer>
    */
    public static Map<string,integer> hierarchyLevel(List<Authority_Hierarchy_Level__mdt> authHierarchy){
        Map<String, integer> roleLevel  = new Map<String, integer>();

        for(Authority_Hierarchy_Level__mdt mdt : authHierarchy){
            roleLevel.put(mdt.MasterLabel, Integer.valueOf(mdt.Authority_Level__c));
        }
        return roleLevel;
    }

    /*
    *@purpose   : Get Overall exposure sanction matrix rule.Overall_Exposure_Check__c checkbox field on
                  Product_Security_Association__c object defines if the rule is applicable for overall exposure or not.
                  if checkbox is true : Rule applicable for Overall exposure else not.
    *@returtype : Map<String, List<Sanction_Authority_Matrix_Association__c>>
    */
    public static Map<String, List<Sanction_Authority_Matrix_Association__c>> getOverallMatrix(){

        List<Product_Security_Authority_Association__c> psmatrix                        = new List<Product_Security_Authority_Association__c>();
        Map<String, List<Sanction_Authority_Matrix_Association__c>> overallExpMatrix    = new Map<String, List<Sanction_Authority_Matrix_Association__c>>();

        psmatrix    = [Select id,Authority_Category__c,Authority_Category__r.Name,
        (select id,Role__c,Sanction_Limit__c from Sanction_Authority_Matrix_Association__r order by Sanction_Limit__c asc)
        from Product_Security_Authority_Association__c
        where Product_Security_Association__r.Overall_Exposure_Check__c = true AND Product_Security_Association__r.Product__c =null];

        for(Product_Security_Authority_Association__c ps : psmatrix){
            overallExpMatrix.put(ps.Authority_Category__r.Name,ps.Sanction_Authority_Matrix_Association__r);
        }

        return overallExpMatrix;
    }

    /*@purpose     : Get Facility__c object
     *@param       : recordtypeId facillity record type Id
     *@param       : productId facility product Id
     *@param       : parentId facility parent record Id
     *@param       : role sanction authority role name
     *@param       : order sanction authority level
     *@param       : isAuthority true if authority is final, else false
     *@returntype  : Facility__c sObject type
     */
    public static Facility__c getChildFacility(String recordtypeId,string productId,string parentId,string role,integer order,boolean isAuthority, boolean isReadOnly){
        Facility__c facility                = new Facility__c();
        facility.RecordTypeId               = recordtypeId;
        facility.CL_Product__c              = productId;
        facility.Facility__c                = parentId;
        facility.Role__c                    = role;
        facility.Higher_Authority_Order__c  = order;
        facility.Highest_Authority__c       = isAuthority;
        facility.Read_Only_User__c          = isReadOnly;
        return facility;
    }

    /*@purpose      : Get all configured Sanction Matrix rule for the Product
     *@param        : productIds Set of product Ids
     *@returnType   : List<Sanction_Authority_Matrix_Association__c>
     */
    public static List<Sanction_Authority_Matrix_Association__c> getSanctionMatricRules(set<String> productIds){
        return [Select id,Authority_Sanction_Limit__c,Margin__c,Product_Name__c,Product_Security_Authority_Association__c,Collateral_Security_Type__c,
                Product_Security_Authority_Association__r.Authority_Category__r.Name,Product_Security_Authority_Association__r.Authority_Category__c,
                Role__c,Sanction_Limit__c,Security_Category__c,Security_Type__c,Product_Security_Authority_Association__r.Product_Security_Association__r.Product__c,
                Product_Security_Authority_Association__r.Product_Security_Association__r.Security_Coverage_Config__r.Primary_Security_Margin__c,
                Product_Security_Authority_Association__r.Product_Security_Association__r.Security_Coverage_Config__r.Collateral_Margin_Start_Range__c,
                Product_Security_Authority_Association__r.Product_Security_Association__r.Security_Coverage_Config__r.Collateral_Margin_End_Range__c,
                Product_Security_Authority_Association__r.Product_Security_Association__r.Security_Coverage_Config__r.Collateral_Security_Type__c
        from Sanction_Authority_Matrix_Association__c
        where Product_Security_Authority_Association__r.Product_Security_Association__r.Product__c IN : productIds order by Sanction_Limit__c asc];

    }

    /*@purpose      : Get all collateral security related to Facility
     *@param        : facilityIds Set of facility Ids
     *@returnType   : Map<Id,genesis__Application_Collateral__c>
     */
    public static Map<Id,genesis__Application_Collateral__c> getFacilityCollaterals(Set<string> facilityIds){
        return new Map<Id,genesis__Application_Collateral__c>([Select Id,Name,genesis__Collateral__c,Application__c,Facility__r.CL_Product__c,Application__r.Sanction_Authority__c,
                Facility__c,Facility__r.Existing_Limit__c,genesis__Collateral__r.clcommon__Value__c
        from genesis__Application_Collateral__c
        where Facility__c IN: facilityIds  AND Facility__r.Active__c = true AND Application__r.Active__c = true]);
    }

    /*@purpose      : Get all Application/facilty collateral for collateral
     *@param        : facilityIds Set of facility Ids
     *@returnType   : Map<Id,genesis__Application_Collateral__c>
     */
    public static Map<Id,genesis__Application_Collateral__c> getAllFacilityCollaterals(Set<string> collateralIds, Set<string> facilityIds, Set<String> parentApplnIds){
        List<String> closeStageList = new List<String>{'Limit renewed/Application close','Enhancement Application close','Exceeding Application close','Adhoc Application close','New loan - Application close','Discontinued Application','Limit Opened'};
        if(parentApplnIds !=null && parentApplnIds.size() > 0){
            return new Map<Id,genesis__Application_Collateral__c>([Select Id,Name,genesis__Collateral__c,Facility__r.Limit_Amount__c,Application__c,Facility__r.CL_Product__c,Application__r.Sanction_Authority__c,
                    Facility__c,Facility__r.Existing_Limit__c,genesis__Collateral__r.clcommon__Value__c,Facility__r.Type__c
            from genesis__Application_Collateral__c
            where genesis__Collateral__c IN: collateralIds AND Facility__c != :facilityIds
            AND  Facility__r.Active__c = true AND Application__r.Active__c = true AND Application__c NOT IN:parentApplnIds]);
        }else{
            return new Map<Id,genesis__Application_Collateral__c>([Select Id,Name,genesis__Collateral__c,Facility__r.Limit_Amount__c,Application__c,Facility__r.CL_Product__c,Application__r.Sanction_Authority__c,
                    Facility__c,Facility__r.Existing_Limit__c,genesis__Collateral__r.clcommon__Value__c,Facility__r.Type__c
            from genesis__Application_Collateral__c
            where genesis__Collateral__c IN: collateralIds AND Facility__c != :facilityIds
            AND  Facility__r.Active__c = true AND Application__r.Active__c = true]);
        }

    }

    /*@purpose     : Get sanction matrix rule by BM Role Level
    *@param        : prodAuthIds Set of Product_Security_Authority_Association__c Ids
    *@returnType   : Map<Id,Product_Security_Authority_Association__c>
    */
    public static Map<Id,Product_Security_Authority_Association__c> getMatrixRuleByAuthority(Set<string> prodAuthIds){
        return new Map<Id,Product_Security_Authority_Association__c>([Select id,Authority_Category__c,
        (Select Role__c,Sanction_Limit__c,Product_Name__c
        from Sanction_Authority_Matrix_Association__r order by Sanction_Limit__c asc)
        from Product_Security_Authority_Association__c
        where Id IN: prodAuthIds]);
    }


    // Used in Sanction Letter Generation
    public Static Map<String,String> getSecurityDetails(String appId){
        Map<String,String> secMap    = new Map<String,String>();
        String RecordTypeName = '';

        try{
            List<clcommon__Collateral__c> collaterals = new List<clcommon__Collateral__c>();
            collaterals = [Select id,Nature_of_Property__c,SurveyKhasraKhataPatta_No__c,PlotDoorShopBungalow_No__c,Door__c,Floor_No__c,Stage_Sector_Ward_Block_No__c,
                    Building_Society_Name__c,Street_NameNo__c,VillageTown__c,TalukaTehsil__c,District_Name__c,clcommon__Postal_Code__c,State__c,Area_Square_Feet__c,
                    clcommon__Value__c,clcommon__Value_Date__c,FE_Created__c,
            (SELECT Id,Application__c,Application__r.RecordType.DeveloperName FROM genesis__Application_Collaterals__r WHERE Facility__r.Application__c =: appId),
            (Select id,Account__c,Account__r.Salutation,Account__r.Name from Ownerships__r)
            from clcommon__Collateral__c where Id IN (Select genesis__Collateral__c from genesis__Application_Collateral__c where Facility__r.Application__c =:appId)];

            if(! collaterals.isEmpty()){
                RecordTypeName = collaterals[0].genesis__Application_Collaterals__r[0].Application__r.RecordType.DeveloperName;
                
                for(clcommon__Collateral__c c : collaterals){
                
                    string details    =  '';
                    if(RecordTypeName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || RecordTypeName == Constants.SME_APP_RECORD_TYPE_ADHOC || RecordTypeName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                        if(c.FE_Created__c == true){
                            details    = 'Fresh EM CHARGE ON ';
                        }
                        else details    = 'Additional EM CHARGE ON ';
                    }
                    else if(RecordTypeName == Constants.SME_APP_RECORD_TYPE){
                        details    =  'Existing EM CHARGE ON ';
                    }

                    if(c.Nature_of_Property__c != null)details += c.Nature_of_Property__c;
                    if(c.SurveyKhasraKhataPatta_No__c!= null)details += 'SITUATED AT, '+c.SurveyKhasraKhataPatta_No__c;
                    if(c.PlotDoorShopBungalow_No__c!= null)details += ','+c.PlotDoorShopBungalow_No__c;
                    if(c.Door__c!= null)details += ','+c.Door__c;
                    if(c.Floor_No__c!= null)details += ','+c.Floor_No__c;
                    if(c.Stage_Sector_Ward_Block_No__c!= null)details += ','+c.Stage_Sector_Ward_Block_No__c;
                    if(c.Building_Society_Name__c!= null)details += ','+c.Building_Society_Name__c;
                    if(c.Street_NameNo__c!= null)details += ','+c.Street_NameNo__c;
                    if(c.VillageTown__c!= null)details += ','+c.VillageTown__c;
                    if(c.TalukaTehsil__c!= null)details += ','+c.TalukaTehsil__c;
                    if(c.clcommon__Postal_Code__c!= null)details += ','+c.clcommon__Postal_Code__c;
                    if(c.State__c!= null)details += ','+c.State__c;
                    if(c.Area_Square_Feet__c!= null)details += ' WITH TOTAL EXTENT OF, '+c.Area_Square_Feet__c+' SQ.FT';
                    string ownerName ='';
                    for(Ownership__c owner : c.Ownerships__r){
                    if(c.District_Name__c!= null)details += ','+c.District_Name__c;
                        if(owner.Account__r.Name != null){
                            if(owner.Account__r.Salutation != null)ownerName += owner.Account__r.Salutation+' ';
                            ownerName += owner.Account__r.Name+', ';
                        }
                    }
                    ownerName = ownerName.trim();
                    ownerName = ownerName.removeEnd(',');
                    if(!DigioTemplateService.ownerNameMap.containsKey(c.Id))DigioTemplateService.ownerNameMap.put(c.Id,ownerName);
                    details  += ' STANDING IN THE NAME OF '+ ownerName;
                    if(c.clcommon__Value__c!= null)details += ' VALUED AT '+c.clcommon__Value__c;
                    if(c.clcommon__Value_Date__c!= null)details += ' AS PER VALUATION REPORT DATED '+(c.clcommon__Value_Date__c).format();

                    if(!secMap.containsKey(c.Id)){
                        secMap.put(c.Id,details);
                    }
                }
            }            

        }catch(Exception eColl){}

        return secMap;
    }

    public static void reRunSactionAuth(String appId){
        try{
            string query                              = 'Select id,Application__r.Is_Take_Over__c,Application__r.Type__c,Application__r.New_to_Business__c,Name,Application__c,Application__r.Parent_Application__c,Application__r.ownerId,Application__r.RecordType.DeveloperName,Application__r.Application_Stage__c,Limit_Amount__c,Existing_Limit__c,Type__c,Application__r.genesis__Account__c,CL_Product__c,Existing_Rate__c,Existing_Processing_Charge__c,Approved_Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Trading__c,Recommended_Limit__c,Recommended_Rate__c,Recommended_Processing_Charge__c,Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c'+', (select id,genesis__Collateral__c from Facility_Security__r) from Facility__c where Application__c =:appId';
            List<Facility__c> facList                = Database.query(query);
            Map<Id,Facility__c> exisFinalUser        = SanctionUnderwriting_Process.getExistingAuthorityLevel(appId);
            SanctionMatrix_Calculation finalRun      = new SanctionMatrix_Calculation();
            System.debug('$$$$$$$$'+facList);
            SanctionMatrix_Calculation.COVERAGE_MAP mymap= finalRun.calculateAuthority(facList,false,SanctionMatrix_Calculation.FINAL_AUTHORITY_METHOD,exisFinalUser);
            System.debug('$$$$$$$$'+mymap);
        }catch(Exception e){
            HandleBusinessException.captureError('SanctionMatix','calculateAuthority',e);
        }
    }
}