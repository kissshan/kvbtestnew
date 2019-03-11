/**
 * Created by ET-MARLABS on 26-12-2018.
 */

global with sharing class SecurityCoverageRefactorHelper {

    Public static Integer collateralOrderCounter                            = 1;
    Public static String DUPLICATE                                          = 'DUPLICATE';
    Public static String NONDUPLICATE                                       = 'NONDUPLICATE';
    public static Map<String,PackingOrderWrapper> packingOWrap              = new Map<String, PackingOrderWrapper>();

    public static Map<Id,List<genesis__Application_Collateral__c>> getApplicationCollateralsByCollateral(Set<String> allCollIds){
        //Map<String,Decimal> faclityAmountByFaclity = new Map<String, Decimal>();

        Map<Id,List<genesis__Application_Collateral__c>> appCollateralsByCollateralMap = new Map<Id, List<genesis__Application_Collateral__c>>();
        for(genesis__Application_Collateral__c appColRec:SecurityCoverageRefactorModel.getAllApplicationColletrForCollaterals(allCollIds)){
            System.debug('########### appColRec === '+appColRec);
            SecurityCoverageRefactor.faclityAmountByFaclity.put(appColRec.Facility__c,appColRec.Facility__r.BRE_Limit__c);
            if(appColRec.Facility__r.Account_Number__c != null){
                if(appColRec.Facility__r.CL_Product__r.Facility_Code__c == 'TL'){
                    SecurityCoverageRefactor.existingTLByFaclity.put(appColRec.Facility__c,true);
                }else{
                    SecurityCoverageRefactor.existingTLByFaclity.put(appColRec.Facility__c,false);

                }
            }
            SecurityCoverageRefactor.collateralAmountBycollateral.put(appColRec.genesis__Collateral__c,appColRec.genesis__Collateral__r.clcommon__Value__c);
            System.debug('SecurityCoverageRefactor.collateralAmountBycollateral => '+SecurityCoverageRefactor.collateralAmountBycollateral);
            if(appCollateralsByCollateralMap.containsKey(appColRec.genesis__Collateral__c)){
                appCollateralsByCollateralMap.get(appColRec.genesis__Collateral__c).add(appColRec);
            }else{
                appCollateralsByCollateralMap.put(appColRec.genesis__Collateral__c,new List<genesis__Application_Collateral__c>{appColRec});
            }
        }
        return appCollateralsByCollateralMap;
    }



    public static Set<String> getAllCollateralIdsFromApplicationCollateral(List<genesis__Application_Collateral__c> appColRecs){

        Set<String> allColIds = new Set<String>();
        for(genesis__Application_Collateral__c appColRec:appColRecs){
            allColIds.add(appColRec.genesis__Collateral__c);
        }
        return allColIds;

    }
    public Static void coverAllExistingFacility(List<genesis__Application_Collateral__c> appCollList,String collId){
        try {
            System.debug(' coll Name  ' +appCollList[0].genesis__Collateral__r.Name);
            System.debug(' App Col List   ' +appCollList);
            Set<String> existingFacIds = new Set<String>();
            Map<String,genesis__Application_Collateral__c> securityByExistingFacIds = new Map<String,genesis__Application_Collateral__c>();
            Set<String> newFacIds = new Set<String>();
            Map<String,genesis__Application_Collateral__c> securityByNewFacIds = new Map<String,genesis__Application_Collateral__c>();
            for(genesis__Application_Collateral__c appColRec:appCollList){
                System.debug('appColRec.Facility__r.Account_Number__c'+appColRec.Facility__r.Account_Number__c +'!!');
                if(appColRec.Facility__r.Account_Number__c != null){

                    existingFacIds.add(appColRec.Facility__c);
                    securityByExistingFacIds.put(appColRec.Facility__c,appColRec);
                    System.debug('Coll Id inside if'+collId+' '+' securityByExistingFacIds ==>' +securityByExistingFacIds);
                }else /*if(*//*appColRec.Facility__r.Account_Number__c *//*)*/{
                    newFacIds.add(appColRec.Facility__c);
                    securityByNewFacIds.put(appColRec.Facility__c,appColRec);
                    System.debug('Coll Id inside if'+collId+' '+' securityByNewFacIds ==>' +securityByNewFacIds);
                }

            }
            System.debug(' Coollateral Name =>'+appCollList[0].genesis__Collateral__r.Name +' Existing FacIds '+ securityByExistingFacIds);
            System.debug(' Coollateral Name =>'+appCollList[0].genesis__Collateral__r.Name +' new  FacIds '+ securityByNewFacIds);

            if(!existingFacIds.isEmpty()){

                if(existingFacIds.size() == 1){
                    System.debug(' Existing Fac size is one ==>');
                    System.debug(' SecurityCoverageRefactor.facilityPriorityOrderByCollateral ==>' +SecurityCoverageRefactor.facilityPriorityOrderByCollateral);
                    if(SecurityCoverageRefactor.facilityPriorityOrderByCollateral.containsKey(collId)){
                        SecurityCoverageRefactor.facilityPriorityOrderByCollateral.get(collId).add(new SecurityCoverageRefactor.FacilityPriorityByCollateral(((new list<string>(existingFacIds) )[0]),securityByExistingFacIds.get((new list<string>(existingFacIds) )[0]).Facility__r.Product_Name__c,collateralOrderCounter,securityByExistingFacIds.get(((new list<string>(existingFacIds) )[0])).Security_Type__c));
                        collateralOrderCounter++;
                        System.debug(' SecurityCoverageRefactor.facilityPriorityOrderByCollateral ==>' +SecurityCoverageRefactor.facilityPriorityOrderByCollateral);
                    }else{
                        //String ss = existingFacIds[0];
                        SecurityCoverageRefactor.facilityPriorityOrderByCollateral.put(collId,new List<SecurityCoverageRefactor.FacilityPriorityByCollateral>{new SecurityCoverageRefactor.FacilityPriorityByCollateral(String.valueOf((new list<string>(existingFacIds) )[0]),securityByExistingFacIds.get((new list<string>(existingFacIds) )[0]).Facility__r.Product_Name__c,collateralOrderCounter,securityByExistingFacIds.get(((new list<string>(existingFacIds) )[0])).Security_Type__c)});
                        collateralOrderCounter++;
                        System.debug(' SecurityCoverageRefactor.facilityPriorityOrderByCollateral ==>' +SecurityCoverageRefactor.facilityPriorityOrderByCollateral);

                    }

                }else if(existingFacIds.size() > 1){
                    System.debug(' Existing Fac size is more than one ==>');
                    System.debug(' existingFacIds.size()' +existingFacIds.size());

                    // call ps and cs tiny method
                    if(newFacIds.isEmpty()) {
                        System.debug( '  Existing Fac size is more than one ==> and new facility is blank');
                        System.debug(' existingFacIds.size() and new facility is empty' +existingFacIds.size());
                        // Send All ApplicationCollateral for Processing
                        coverAllPrimarySecurityFacility(appCollList,collId);
                    }else{
                        System.debug(' existingFacIds.size() and new facility is not empty' +existingFacIds.size());
                        // remove newFacIds
                        coverAllPrimarySecurityFacility(removeGivenFacilityFromAppColl(appCollList,newFacIds),collId);
                    }

                }
            }
            if(!newFacIds.isEmpty()){
                if(newFacIds.size() == 1){
                    System.debug( ' New Facility size is 1');
                    if(SecurityCoverageRefactor.facilityPriorityOrderByCollateral.containsKey(collId)){
                        SecurityCoverageRefactor.facilityPriorityOrderByCollateral.get(collId).add(new SecurityCoverageRefactor.FacilityPriorityByCollateral(((new list<string>(newFacIds) )[0]),securityByNewFacIds.get((new list<string>(newFacIds) )[0]).Facility__r.Product_Name__c,collateralOrderCounter,securityByNewFacIds.get(((new list<string>(newFacIds) )[0])).Security_Type__c));
                        collateralOrderCounter++;
                    }else{
                        System.debug('collateralOrderCounter '+collateralOrderCounter);
                        SecurityCoverageRefactor.facilityPriorityOrderByCollateral.put(collId,new List<SecurityCoverageRefactor.FacilityPriorityByCollateral>{new SecurityCoverageRefactor.FacilityPriorityByCollateral((new list<string>(newFacIds) )[0],securityByNewFacIds.get((new list<string>(newFacIds) )[0]).Facility__r.Product_Name__c,collateralOrderCounter,securityByNewFacIds.get(((new list<string>(newFacIds) )[0])).Security_Type__c)});
                        collateralOrderCounter++;
                    }

                }else if(newFacIds.size() > 1){
                    System.debug( ' New Facility size is more than 1');
                    // call ps and cs tiny method
                    if(existingFacIds.isEmpty()) {
                        System.debug( ' New Facility size is more than 1');
                        // Send All ApplicationCollateral for Processing
                        coverAllPrimarySecurityFacility(appCollList,collId);

                    }else{
                        System.debug( ' New Facility size is more than 1');
                        // remove existingFacIds
                        coverAllPrimarySecurityFacility(removeGivenFacilityFromAppColl(appCollList,existingFacIds),collId);

                    }



                }
            }
        } catch (Exception e) {
            HandleBusinessException.captureError('SecurityCoverageRefactorHelper','coverAllExistingFacility',e);
        }
    }
    public Static void coverAllNewFacility(List<genesis__Application_Collateral__c> appCollList){
        try {

        } catch (Exception e) {
            HandleBusinessException.captureError('SecurityCoverageRefactorHelper','coverAllNewFacility',e);
        }
    }
    public Static void coverAllPrimarySecurityFacility(List<genesis__Application_Collateral__c> appCollList,String collId){
        try {
            System.debug(' Calling coverAllPrimarySecurityFacility');
            Set<String> existingPrimFacIds = new Set<String>();
            Set<String> existingCollFacIds = new Set<String>();
            Set<String> newPrimFacIds = new Set<String>();
            Set<String> newCollFacIds = new Set<String>();
            Map<String,genesis__Application_Collateral__c> securityByFacIds = new Map<String,genesis__Application_Collateral__c>();
            System.debug(' Calling coverAllPrimarySecurityFacility appCollList size ==>'+appCollList.size());
            for(genesis__Application_Collateral__c appColRec:appCollList) {
                System.debug('App col Rec '+appColRec.Facility__r.Account_Number__c);

                System.debug('appColRec.Facility__r.Account_Number__c ==>'+appColRec.Facility__r.Account_Number__c);
                System.debug('appColRec.Facility__r.Account_Number__c ==>'+appColRec.Security_Type__c);
                securityByFacIds.put(appColRec.Facility__c,appColRec);
                if (appColRec.Facility__r.Account_Number__c != null) {

                    if(appColRec.Security_Type__c == 'Primary Securities')
                        existingPrimFacIds.add(appColRec.Facility__c);
                    else if(appColRec.Security_Type__c == 'Collateral Securities')
                        existingCollFacIds.add(appColRec.Facility__c);
                    System.debug('existingPrimFacIds ==>'+existingPrimFacIds);
                    System.debug('existingCollFacIds ==>'+existingCollFacIds);
                }else{

                    if(appColRec.Security_Type__c == 'Primary Securities')
                        newPrimFacIds.add(appColRec.Facility__c);
                    else if(appColRec.Security_Type__c == 'Collateral Securities')
                        newCollFacIds.add(appColRec.Facility__c);
                    System.debug('newCollFacIds ==>'+newCollFacIds);
                    System.debug('newPrimFacIds ==>'+newPrimFacIds);
                }
            }

            if(!existingPrimFacIds.isEmpty()) {
                System.debug('existingCollFacIds ==>'+existingCollFacIds);
                System.debug('existingCollFacIds ==>'+existingCollFacIds);
                if(existingPrimFacIds.size()==1) {
                    if(SecurityCoverageRefactor.facilityPriorityOrderByCollateral.containsKey(collId)){
                        SecurityCoverageRefactor.facilityPriorityOrderByCollateral.get(collId).add(new SecurityCoverageRefactor.FacilityPriorityByCollateral(new List<String>(existingPrimFacIds)[0],securityByFacIds.get(new List<String>(existingPrimFacIds)[0]).Facility__r.Product_Name__c,collateralOrderCounter,'Primary Securities'));
                        collateralOrderCounter++;
                    }else{
                        SecurityCoverageRefactor.facilityPriorityOrderByCollateral.put(collId,new List<SecurityCoverageRefactor.FacilityPriorityByCollateral>{new SecurityCoverageRefactor.FacilityPriorityByCollateral(new List<String>(existingPrimFacIds)[0],securityByFacIds.get(new List<String>(existingPrimFacIds)[0]).Facility__r.Product_Name__c,collateralOrderCounter,'Primary Securities')});
                        collateralOrderCounter++;
                    }
                }else if(existingPrimFacIds.size() > 1){
                    // call packing order only for existing primary
                    coverAllFacilityFromPackingOrder(pickOnlyGivenFacilityFromAppColl(appCollList,existingPrimFacIds),collId);

                }
            }
            if(!existingCollFacIds.isEmpty()) {
                System.debug('existingCollFacIds ==>'+existingCollFacIds);
                System.debug('existingCollFacIds ==>'+existingCollFacIds);
                if(existingCollFacIds.size()==1) {
                    if(SecurityCoverageRefactor.facilityPriorityOrderByCollateral.containsKey(collId)){
                        SecurityCoverageRefactor.facilityPriorityOrderByCollateral.get(collId).add(new SecurityCoverageRefactor.FacilityPriorityByCollateral(new List<String>(existingCollFacIds)[0],securityByFacIds.get(new List<String>(existingCollFacIds)[0]).Facility__r.Product_Name__c,collateralOrderCounter,'Collateral Securities'));
                        collateralOrderCounter++;
                    }else{
                        SecurityCoverageRefactor.facilityPriorityOrderByCollateral.put(collId,new List<SecurityCoverageRefactor.FacilityPriorityByCollateral>{new SecurityCoverageRefactor.FacilityPriorityByCollateral(new List<String>(existingCollFacIds)[0],securityByFacIds.get(new List<String>(existingCollFacIds)[0]).Facility__r.Product_Name__c,collateralOrderCounter,'Collateral Securities')});
                        collateralOrderCounter++;
                    }
                }else if(existingCollFacIds.size() > 1){
                    // call packing order
                    coverAllFacilityFromPackingOrder(pickOnlyGivenFacilityFromAppColl(appCollList,existingCollFacIds),collId);
                }
            }
            if(!newPrimFacIds.isEmpty()) {
                if(newPrimFacIds.size()==1) {
                    if(SecurityCoverageRefactor.facilityPriorityOrderByCollateral.containsKey(collId)){
                        SecurityCoverageRefactor.facilityPriorityOrderByCollateral.get(collId).add(new SecurityCoverageRefactor.FacilityPriorityByCollateral(new List<String>(newPrimFacIds)[0],securityByFacIds.get(new List<String>(newPrimFacIds)[0]).Facility__r.Product_Name__c,collateralOrderCounter,'Primary Securities'));
                        collateralOrderCounter++;
                    }else{
                        SecurityCoverageRefactor.facilityPriorityOrderByCollateral.put(collId,new List<SecurityCoverageRefactor.FacilityPriorityByCollateral>{new SecurityCoverageRefactor.FacilityPriorityByCollateral(new List<String>(newPrimFacIds)[0],securityByFacIds.get(new List<String>(newPrimFacIds)[0]).Facility__r.Product_Name__c,collateralOrderCounter,'Primary Securities')});
                        collateralOrderCounter++;
                    }
                }else if(newPrimFacIds.size() > 1){
                    // call packing order
                    coverAllFacilityFromPackingOrder(pickOnlyGivenFacilityFromAppColl(appCollList,newPrimFacIds),collId);
                }
            }
            if(!newCollFacIds.isEmpty()) {
                if(newCollFacIds.size()==1) {
                    if(SecurityCoverageRefactor.facilityPriorityOrderByCollateral.containsKey(collId)){
                        SecurityCoverageRefactor.facilityPriorityOrderByCollateral.get(collId).add(new SecurityCoverageRefactor.FacilityPriorityByCollateral(new List<String>(newCollFacIds)[0],securityByFacIds.get(new List<String>(newCollFacIds)[0]).Facility__r.Product_Name__c,collateralOrderCounter,'Collateral Securities'));
                        collateralOrderCounter++;
                    }else{
                        SecurityCoverageRefactor.facilityPriorityOrderByCollateral.put(collId,new List<SecurityCoverageRefactor.FacilityPriorityByCollateral>{new SecurityCoverageRefactor.FacilityPriorityByCollateral(new List<String>(newCollFacIds)[0],securityByFacIds.get(new List<String>(newPrimFacIds)[0]).Facility__r.Product_Name__c,collateralOrderCounter,'Collateral Securities')});
                        collateralOrderCounter++;
                    }
                }else if(newCollFacIds.size() > 1){
                    // call packing order only for New Collaterally secured facilities
                    coverAllFacilityFromPackingOrder(pickOnlyGivenFacilityFromAppColl(appCollList,newCollFacIds),collId);
                }
            }
        }catch (Exception e) {
            HandleBusinessException.captureError('SecurityCoverageRefactorHelper','coverAllPrimarySecurityFacility',e);
        }
    }
    public Static void coverAllCollateralFacility(List<genesis__Application_Collateral__c> appCollList){
        try {

        } catch (Exception e) {
            HandleBusinessException.captureError('SecurityCoverageRefactorHelper','coverAllCollateralFacility',e);
        }
    }
    public Static void coverAllFacilityFromPackingOrder(List<genesis__Application_Collateral__c> appCollList,String collId){
        try {
            packingOWrap = new Map<String, PackingOrderWrapper>();
            Map<String,Security_Configuration_Master__mdt> priorityByProduct = getAllSecurityMasterByName();
            Security_Configuration_Master__mdt SmInstance;
            // get priority of each appcol by creating a wrapper;
            for(genesis__Application_Collateral__c appColRec:appCollList){
                System.debug('appColRec.Facility__r.CL_Product__r.Name'+appColRec.Facility__r.Product_Name__c);
                if(appColRec.Facility__r.CL_Product__r.Name != null && priorityByProduct.containsKey(appColRec.Facility__r.Product_Name__c)){
                    SmInstance = priorityByProduct.get(appColRec.Facility__r.Product_Name__c);
                    System.debug('SmInstance'+SmInstance);
                    packingOWrap.put(appColRec.Facility__c,new PackingOrderWrapper(String.valueOf(appColRec.Facility__c),String.valueOf(appColRec.genesis__Collateral__c),String.valueOf(appColRec.Id),String.valueOf(appColRec.Security_Type__c),Integer.valueOf(SmInstance.Priority__c),appColRec.Facility__r.Product_Name__c));

                }
            }
            System.debug('packingOWrap'+packingOWrap);
            // then check if any duplicate priority exist in this wrapper list
            Map<String,List<PackingOrderWrapper>> duplicateAndNonDupli = getDuplicateAndNonDuplicateFacilitites(packingOWrap.values());
            System.debug('duplicateAndNonDupli'+duplicateAndNonDupli);

            if(!duplicateAndNonDupli.isEmpty()){
                Set<String> nonDupeFacility = new Set<String>();
                if(duplicateAndNonDupli.containsKey(NONDUPLICATE)){
                    List<PackingOrderWrapper> nonDuplicatePO = duplicateAndNonDupli.get(NONDUPLICATE);
                    System.debug('nonDuplicatePO'+nonDuplicatePO);
                    // fill order for non duplicate facility by their priority
                    updateFacilityPriorityOrderByCollateral(nonDuplicatePO,collId);

                    for(PackingOrderWrapper packRec:nonDuplicatePO){
                        nonDupeFacility.add(packRec.facId);
                    }
                    System.debug('nonDupeFacility'+nonDupeFacility);
                }
                // if duplicate then pass those duplicate records to priortize on the basis of BRE Limit
                if(duplicateAndNonDupli.containsKey(DUPLICATE)){
                    List<PackingOrderWrapper> duplicatePO = duplicateAndNonDupli.get(DUPLICATE);
                    System.debug('duplicatePO'+duplicatePO);

                    // Call coverAllFacilityFromBreLimit
                    if(!duplicatePO.isEmpty()){
                        System.debug('duplicatePO'+duplicatePO);
                        coverAllFacilityFromBreLimit(duplicatePO,collId);
                    }
                }

            }



        } catch (Exception e) {
            HandleBusinessException.captureError('SecurityCoverageRefactorHelper','coverAllFacilityFromPackingOrder',e);
        }
    }
    public Static void coverAllFacilityFromBreLimit(List<PackingOrderWrapper> duplicaterecsByPriority,String collId){
        try {

            duplicaterecsByPriority.sort();
            //collateralOrderCounter++; removed it from below intentionally
            for(PackingOrderWrapper pacRec:duplicaterecsByPriority){
                if(SecurityCoverageRefactor.facilityPriorityOrderByCollateral.containsKey(collId)){
                    SecurityCoverageRefactor.facilityPriorityOrderByCollateral.get(collId).add(new SecurityCoverageRefactor.FacilityPriorityByCollateral(pacRec.facId,pacRec.productName,collateralOrderCounter,pacRec.securityType));
                    //collateralOrderCounter++;
                }else{
                    SecurityCoverageRefactor.facilityPriorityOrderByCollateral.put(collId,new List<SecurityCoverageRefactor.FacilityPriorityByCollateral>{new SecurityCoverageRefactor.FacilityPriorityByCollateral(pacRec.facId,pacRec.productName,collateralOrderCounter,pacRec.securityType)});
                    //collateralOrderCounter++;
                }
            }
            collateralOrderCounter++;
        } catch (Exception e) {
            HandleBusinessException.captureError('SecurityCoverageRefactorHelper','coverAllFacilityFromBreLimit',e);
        }
    }
    public Static void coverAllFacilityFromResidual(List<genesis__Application_Collateral__c> appCollList){
        try {

        } catch (Exception e) {
            HandleBusinessException.captureError('SecurityCoverageRefactorHelper','coverAllFacilityFromResidual',e);
        }
    }
    public Static void coverAllPendingFacility(List<genesis__Application_Collateral__c> appCollList){
        try {

        } catch (Exception e) {
            HandleBusinessException.captureError('SecurityCoverageRefactorHelper','coverAllPendingFacility',e);
        }
    }
    public static List<genesis__Application_Collateral__c> removeGivenFacilityFromAppColl(List<genesis__Application_Collateral__c> appCollList,Set<String> facIds) {

        List<genesis__Application_Collateral__c> listToBeReturned = new List<genesis__Application_Collateral__c>();

        for(genesis__Application_Collateral__c appColRec:appCollList) {
            if(!facIds.contains(appColRec.Facility__c)){
                listToBeReturned.add(appColRec);
            }
        }

        return listToBeReturned;
    }
    public static List<genesis__Application_Collateral__c> pickOnlyGivenFacilityFromAppColl(List<genesis__Application_Collateral__c> appCollList,Set<String> facIds) {

        List<genesis__Application_Collateral__c> listToBeReturned = new List<genesis__Application_Collateral__c>();

        for(genesis__Application_Collateral__c appColRec:appCollList) {
            if(facIds.contains(appColRec.Facility__c)){
                listToBeReturned.add(appColRec);
            }
        }

        return listToBeReturned;
    }

    public static Map<String,Security_Configuration_Master__mdt> getAllSecurityMasterByName(){
        Map<String,Security_Configuration_Master__mdt> priorityByProduct = new Map<String, Security_Configuration_Master__mdt>();
        for(Security_Configuration_Master__mdt secrityRec:SecurityCoverageRefactorModel.getSecurityMasters()){
            //Waste If-else
            if(priorityByProduct.containsKey(secrityRec.MasterLabel)){
                priorityByProduct.put(secrityRec.MasterLabel,secrityRec);
            }else{
                priorityByProduct.put(secrityRec.MasterLabel,secrityRec);
            }
        }
        return priorityByProduct;
    }



    public Static Map<String,List<PackingOrderWrapper>> getDuplicateAndNonDuplicateFacilitites(List<PackingOrderWrapper> packingOrderRecs){
        Map<String,List<PackingOrderWrapper>> duplicateAndNonDupli = new Map<String, List<PackingOrderWrapper>>();

        Map<Integer,PackingOrderWrapper> tempMap = new Map<Integer, PackingOrderWrapper>();
        List<PackingOrderWrapper> tempDuplicateList = new List<PackingOrderWrapper>();
        for(PackingOrderWrapper pacRec:packingOrderRecs){
            // Please pay extra attention before filling or emptying a map. There is no possiility that this below map code is wrong. Yeah, it might seem at first glance, but you know, Believe me, I have written it.
            if(!tempMap.containsKey(pacRec.priority)){
                tempMap.put(pacRec.priority,pacRec);
            }else{
                PackingOrderWrapper pack = tempMap.get(pacRec.priority);
                tempMap.remove(pacRec.priority);
                tempDuplicateList.add(pacRec);
                tempDuplicateList.add(pack);
            }
        }
        if(!tempMap.isEmpty()){
            duplicateAndNonDupli.put(NONDUPLICATE,tempMap.values());
        }
        if(!tempDuplicateList.isEmpty()){
            duplicateAndNonDupli.put(DUPLICATE,tempDuplicateList);
        }
        return duplicateAndNonDupli;
    }
    public static void updateFacilityPriorityOrderByCollateral(List<PackingOrderWrapper> NonDuplicatePackingOrderWrappers,String collId){
        for(PackingOrderWrapper pacRec:NonDuplicatePackingOrderWrappers){
            if(SecurityCoverageRefactor.facilityPriorityOrderByCollateral.containsKey(collId)){
                SecurityCoverageRefactor.facilityPriorityOrderByCollateral.get(collId).add(new SecurityCoverageRefactor.FacilityPriorityByCollateral(pacRec.facId,pacRec.productName,collateralOrderCounter,pacRec.securityType));
                collateralOrderCounter++;
            }else{
                SecurityCoverageRefactor.facilityPriorityOrderByCollateral.put(collId,new List<SecurityCoverageRefactor.FacilityPriorityByCollateral>{new SecurityCoverageRefactor.FacilityPriorityByCollateral(pacRec.facId,pacRec.productName,collateralOrderCounter,pacRec.securityType)});
                collateralOrderCounter++;
            }
        }
        System.debug('########## SecurityCoverageRefactor.facilityPriorityOrderByCollateral' +SecurityCoverageRefactor.facilityPriorityOrderByCollateral);
    }

    public static void processApplicationSecurityCoverage(String appId){
        try {
            System.debug(' SecurityCoverageRefactor.facilityPriorityOrderByCollateral '+SecurityCoverageRefactor.facilityPriorityOrderByCollateral);

            Map<String, Map<Integer,List<SecurityCoverageRefactor.FacilityPriorityByCollateral>>> finalMap = new Map<String, Map<Integer, List<SecurityCoverageRefactor.FacilityPriorityByCollateral>>>();
            finalMap = processFinalMap();
            System.debug(' finalMap.finalMap '+finalMap);

            List<genesis__Application_Collateral__c> listAppCol = SecurityCoverageRefactorModel.getAllApplicationColletrForCollaterals((new Set<string>(finalMap.keySet()) ));
            System.debug(' listAppCol ==> '+listAppCol);
            List<genesis__Application_Collateral__c> listAppColToBeUpdated = new List<genesis__Application_Collateral__c>();
            Map<String,List<genesis__Application_Collateral__c>> appCollMapToBEUpdated = new Map<String, List<genesis__Application_Collateral__c>>();

            for(String collId:finalMap.keySet()){

                //Decimal collValue = 0;
                // For loop over each tiny FacilityList Inside integer map(which must be sorted by integer value)
                Map<Integer,List<SecurityCoverageRefactor.FacilityPriorityByCollateral>> tempPriorityMap = finalMap.get(collId);
                System.debug('########### tempPriorityMap'+tempPriorityMap);
                for(Integer priorityOrder:tempPriorityMap.keySet()){
                    genesis__Application_Collateral__c appCollInstanceToBeUpdated = new genesis__Application_Collateral__c();
                    System.debug('########### priorityOrder'+priorityOrder);
                    // loop over each facility in tiny facility list
                    // if list size for one priority is 1 then Assign coverage directly
                    List<SecurityCoverageRefactor.FacilityPriorityByCollateral> tempFacList = tempPriorityMap.get(priorityOrder);
                    System.debug('########### tempFacList'+tempPriorityMap.get(priorityOrder));
                    if(tempFacList.size() == 1){
                        appCollInstanceToBeUpdated =  findApplicationCollateralByFacilityAndCollateral(listAppCol,tempFacList[0].facId,collId);
                        System.debug(' appCollInstanceToBeUpdated ==> '+appCollInstanceToBeUpdated);
                        Decimal primaryOrCollateralSecurityToBeApplied =0.0;
                        // Get Primary Security or Collateral Security Coverage % to be applied for this facility on the basis of Packing order Table
                        if(tempFacList[0].isPrimaryOrCollateral == 'Primary Securities')
                            primaryOrCollateralSecurityToBeApplied = (SecurityCoverageRefactor.securityMasterByProduct).get(tempFacList[0].productName).Primary_Security_Coverage__c;
                        else if(tempFacList[0].isPrimaryOrCollateral == 'Collateral Securities')
                            primaryOrCollateralSecurityToBeApplied = (SecurityCoverageRefactor.securityMasterByProduct).get(tempFacList[0].productName).Collateral_Security_Coverage__c;
                        System.debug(' primaryOrCollateralSecurityToBeApplied ==> '+primaryOrCollateralSecurityToBeApplied);
                        if(primaryOrCollateralSecurityToBeApplied != 0.0){
                            // if collateral has this much amount already left
                            System.debug('SecurityCoverageRefactor.collateralAmountBycollateral.get(collId) =>'+SecurityCoverageRefactor.collateralAmountBycollateral.get(collId));
                            System.debug('SecurityCoverageRefactor.faclityAmountByFaclity.get(tempFacList[0].facId) * (primaryOrCollateralSecurityToBeApplied/100.00) =>'+SecurityCoverageRefactor.faclityAmountByFaclity.get(tempFacList[0].facId) * (primaryOrCollateralSecurityToBeApplied/100.00));
                            if(SecurityCoverageRefactor.collateralAmountBycollateral.get(collId) > SecurityCoverageRefactor.faclityAmountByFaclity.get(tempFacList[0].facId) * (primaryOrCollateralSecurityToBeApplied/100.00)){
                                    appCollInstanceToBeUpdated.Allocated_Amount__c = SecurityCoverageRefactor.faclityAmountByFaclity.get(tempFacList[0].facId) * (primaryOrCollateralSecurityToBeApplied/100.00);
                                System.debug(' appCollInstanceToBeUpdated.Allocated_Amount__c ==> '+appCollInstanceToBeUpdated.Allocated_Amount__c);
                            }else{
                                appCollInstanceToBeUpdated.Allocated_Amount__c = SecurityCoverageRefactor.collateralAmountBycollateral.get(collId);
                                System.debug(' appCollInstanceToBeUpdated.Allocated_Amount__c ==> '+appCollInstanceToBeUpdated.Allocated_Amount__c);
                            }
                            // Else Assign whatever is left in collateral

                        }else{
                            appCollInstanceToBeUpdated.Allocated_Amount__c = 0.0;
                            System.debug(' appCollInstanceToBeUpdated.Allocated_Amount__c ==> '+appCollInstanceToBeUpdated.Allocated_Amount__c);
                        }
                        // Reducce Allocated amount from collateral total value;
                        if(SecurityCoverageRefactor.collateralAmountBycollateral.get(collId) != null && appCollInstanceToBeUpdated.Allocated_Amount__c != null){
                            System.debug(' Insside if =>');
                            System.debug(' appCollInstanceToBeUpdated.Allocated_Amount__c ==> '+appCollInstanceToBeUpdated.Allocated_Amount__c);

                            System.debug(' Insside Else => SecurityCoverageRefactor.collateralAmountBycollateral.get(collId) =>'+SecurityCoverageRefactor.collateralAmountBycollateral.get(collId));

                            SecurityCoverageRefactor.collateralAmountBycollateral.put(collId,SecurityCoverageRefactor.collateralAmountBycollateral.get(collId) - appCollInstanceToBeUpdated.Allocated_Amount__c);

                        }


                        listAppColToBeUpdated.add(appCollInstanceToBeUpdated);
                    }else{
                        System.debug(' Insside Else =>');
                       // System.debug(' allocateCollateralValuesInEqual(collId,tempFacList,listAppCol) ==> '+allocateCollateralValuesInEqual(collId,tempFacList,listAppCol,false));

                        listAppColToBeUpdated.addAll(allocateCollateralValuesInEqual(collId,tempFacList,listAppCol,false));


                    }


                }

                if(!listAppColToBeUpdated.isEmpty()){
                    System.debug(' listAppColToBeUpdated ==> '+listAppColToBeUpdated);
                    update listAppColToBeUpdated;
                }
                System.debug('##### Residual Value in Collaterals'+SecurityCoverageRefactor.collateralAmountBycollateral.get(collId));
                if(SecurityCoverageRefactor.collateralAmountBycollateral.get(collId)>0.0){
                    System.debug(' SecurityCoverageRefactor.collateralAmountBycollateral.get(collId) ==> '+SecurityCoverageRefactor.collateralAmountBycollateral.get(collId));
                    // Run this loop again for residual value;
                    updateApplicationsForResidual(tempPriorityMap,collId,listAppColToBeUpdated);
                }
                // Call Main Method




            }
            securityWiseAllocatedAmount(appId);
        } catch (Exception e) {
            HandleBusinessException.captureError('SecurityCoverageRefactorhelper','processApplicationSecurityCoverage',e);
        }
    }
    public static void updateApplicationsForResidual(Map<Integer,List<SecurityCoverageRefactor.FacilityPriorityByCollateral>> tempPriorityMap,String collId,List<genesis__Application_Collateral__c> existingAppColl){
        try {
            List<genesis__Application_Collateral__c> listAppColToBeUpdated = new List<genesis__Application_Collateral__c>();

            List<genesis__Application_Collateral__c> listAppCol = SecurityCoverageRefactorModel.getAllApplicationColletrForCollaterals((new Set<string>{collId} ));


                System.debug('########### tempPriorityMap'+tempPriorityMap);
                for(Integer priorityOrder:tempPriorityMap.keySet()){
                    genesis__Application_Collateral__c appCollInstanceToBeUpdated = new genesis__Application_Collateral__c();
                    System.debug('########### priorityOrder'+priorityOrder);
                    // loop over each facility in tiny facility list
                    // if list size for one priority is 1 then Assign coverage directly
                    List<SecurityCoverageRefactor.FacilityPriorityByCollateral> tempFacList = tempPriorityMap.get(priorityOrder);
                    System.debug('########### tempFacList'+tempPriorityMap.get(priorityOrder));
                    if(tempFacList.size() == 1){

                        Boolean flag = true;
                        if(SecurityCoverageRefactor.existingTLByFaclity.containsKey(tempFacList[0].facId)){
                            flag = !SecurityCoverageRefactor.existingTLByFaclity.get(tempFacList[0].facId);
                        }
                        System.debug('#######'+flag);
                        if(flag) {

                            System.debug('########### tempFacList'+tempPriorityMap.get(priorityOrder));
                            //appCollInstanceToBeUpdated = findApplicationCollateralByFacilityAndCollateral(listAppCol, tempFacList[0].facId, collId);
                            for(genesis__Application_Collateral__c appColrec:existingAppColl){
                                if(appColrec.Facility__c == tempFacList[0].facId && appColrec.genesis__Collateral__c == collId){
                                    appColrec.Allocated_Amount__c = appColrec.Allocated_Amount__c + SecurityCoverageRefactor.collateralAmountBycollateral.get(collId);
                                    SecurityCoverageRefactor.collateralAmountBycollateral.put(collId,0.00);
                                    listAppColToBeUpdated.add(appColrec);
                                }
                            }

                        }
                    }else{

                        listAppColToBeUpdated.addAll(allocateCollateralValuesInEqual(collId,tempFacList,existingAppColl,false));
                        /*for(genesis__Application_Collateral__c appColrec:existingAppColl){
                            if(appColrec.Facility__c == tempFacList[0].facId && appColrec.genesis__Collateral__c == collId){
                                appColrec.Allocated_Amount__c = appColrec.Allocated_Amount__c + SecurityCoverageRefactor.collateralAmountBycollateral.get(collId);
                                SecurityCoverageRefactor.collateralAmountBycollateral.put(collId,0.00);
                                listAppColToBeUpdated.add(appColrec);
                            }
                        }*/


                    }


                }
                // if still collateral value is left then call residual wala method

                if(!listAppColToBeUpdated.isEmpty()){
                    System.debug(' listAppColToBeUpdated ==> '+listAppColToBeUpdated);
                    update listAppColToBeUpdated;
                }





        } catch (Exception e) {
            HandleBusinessException.captureError('SecurityCoverageRefactorhelper','updateApplicationsForResidual',e);
        }
    }
    public static Map<String, Map<Integer,List<SecurityCoverageRefactor.FacilityPriorityByCollateral>>> processFinalMap(){
        Map<String, Map<Integer,List<SecurityCoverageRefactor.FacilityPriorityByCollateral>>> finalMapToBeReturned = new Map<String, Map<Integer, List<SecurityCoverageRefactor.FacilityPriorityByCollateral>>>();

        Map<String,List<SecurityCoverageRefactor.FacilityPriorityByCollateral>> tempfacilityPriorityOrderByCollateral = SecurityCoverageRefactor.facilityPriorityOrderByCollateral;

        for(String collId:tempfacilityPriorityOrderByCollateral.keySet()){
            List<SecurityCoverageRefactor.FacilityPriorityByCollateral> tempFacilityTobeConvertedToMap = tempfacilityPriorityOrderByCollateral.get(collId);
            Map<Integer,List<SecurityCoverageRefactor.FacilityPriorityByCollateral>> singleFacilityByOrder = convertTempFacilityToMap(tempFacilityTobeConvertedToMap);
            finalMapToBeReturned.put(collId,singleFacilityByOrder);
        }
        return finalMapToBeReturned;
    }
    public static List<genesis__Application_Collateral__c> allocateCollateralValuesInEqual(String collId,List<SecurityCoverageRefactor.FacilityPriorityByCollateral> facList,List<genesis__Application_Collateral__c> listAppCol,Boolean isResidual){
        List<genesis__Application_Collateral__c> appCollListToBeReturned = new List<genesis__Application_Collateral__c>();
        Map<String,Decimal> coverageNeededByFacility = new Map<String, Decimal>();

        System.debug(' isResidual ==> '+isResidual);
        System.debug(' facList ==> '+facList);
        System.debug(' SecurityCoverageRefactor.existingTLByFaclity ==> '+SecurityCoverageRefactor.existingTLByFaclity);
        for(SecurityCoverageRefactor.FacilityPriorityByCollateral facWrapRec:facList){
            System.debug(' SecurityCoverageRefactor.existingTLByFaclity.get(facWrapRec.facId) ==> '+SecurityCoverageRefactor.existingTLByFaclity.get(facWrapRec.facId));

                Decimal coverageNeeded = 0.00;
                System.debug(' facWrapRec.isPrimaryOrCollateral ==> ' + facWrapRec.isPrimaryOrCollateral);
                if (facWrapRec.isPrimaryOrCollateral == 'Primary Securities')
                    coverageNeeded = (SecurityCoverageRefactor.securityMasterByProduct).get(facWrapRec.productName).Primary_Security_Coverage__c; else if (facWrapRec.isPrimaryOrCollateral == 'Collateral Securities')
                    coverageNeeded = (SecurityCoverageRefactor.securityMasterByProduct).get(facWrapRec.productName).Collateral_Security_Coverage__c;
                if (coverageNeeded != 0.00) {
                    System.debug(' SecurityCoverageRefactor.faclityAmountByFaclity.get(facWrapRec.facId) * (coverageNeeded/100.00) ==> ' + SecurityCoverageRefactor.faclityAmountByFaclity.get(facWrapRec.facId) * (coverageNeeded / 100.00));
                    coverageNeededByFacility.put(facWrapRec.facId, SecurityCoverageRefactor.faclityAmountByFaclity.get(facWrapRec.facId) * (coverageNeeded / 100.00));

                } else {
                    // What to do
                    System.debug(' SecurityCoverageRefactor.faclityAmountByFaclity.get(facWrapRec.facId) ==> ' + SecurityCoverageRefactor.faclityAmountByFaclity.get(facWrapRec.facId));
                    coverageNeededByFacility.put(facWrapRec.facId, SecurityCoverageRefactor.faclityAmountByFaclity.get(facWrapRec.facId));
                }

            //}

        }
        // check if collateral Amount is enough for all
        Decimal totalCoveragerequired =0.00;
        for(Decimal coverageRequiredByEachFac:coverageNeededByFacility.values()){
            totalCoveragerequired +=coverageRequiredByEachFac;

        }
        System.debug(' totalCoveragerequired ==> '+totalCoveragerequired);
        System.debug(' SecurityCoverageRefactor.collateralAmountBycollateral.get(collId) ==> '+SecurityCoverageRefactor.collateralAmountBycollateral.get(collId));
        if(SecurityCoverageRefactor.collateralAmountBycollateral.get(collId) > totalCoveragerequired){
            // if greater -> then allocate full amount which is required by facility
            for(SecurityCoverageRefactor.FacilityPriorityByCollateral facWrapRec:facList){

                    System.debug(' findApplicationCollateralByFacilityAndCollateral(listAppCol,facWrapRec.facId,collId) ==> ' + findApplicationCollateralByFacilityAndCollateral(listAppCol, facWrapRec.facId, collId));
                    genesis__Application_Collateral__c applicationCollateralInstance = findApplicationCollateralByFacilityAndCollateral(listAppCol, facWrapRec.facId, collId);
                    // check if facility has this much amount -> Of-couse it will have man, So no need to check
                    applicationCollateralInstance.Allocated_Amount__c = coverageNeededByFacility.get(facWrapRec.facId);
                    System.debug(' coverageNeededByFacility.get(facWrapRec.facId) ==> ' + coverageNeededByFacility.get(facWrapRec.facId));

                    appCollListToBeReturned.add(applicationCollateralInstance);
                    SecurityCoverageRefactor.collateralAmountBycollateral.put(collId, SecurityCoverageRefactor.collateralAmountBycollateral.get(collId) - applicationCollateralInstance.Allocated_Amount__c);

            }


        }else{
            // Allocate By BRE Limit Ratio
            // Decimal BREMultiplierForFacility = Total Available Collateral Value / Total Bre Value
            Decimal BREMultiplierForFacility = SecurityCoverageRefactor.collateralAmountBycollateral.get(collId) / totalCoveragerequired;
            System.debug(' BREMultiplierForFacility ==> '+BREMultiplierForFacility);

            for(SecurityCoverageRefactor.FacilityPriorityByCollateral facWrapRec:facList){

                    genesis__Application_Collateral__c applicationCollateralInstance = findApplicationCollateralByFacilityAndCollateral(listAppCol, facWrapRec.facId, collId);
                    // check if facility has this much amount -> Of-couse it will have man, So no need to check
                    applicationCollateralInstance.Allocated_Amount__c = coverageNeededByFacility.get(facWrapRec.facId) * BREMultiplierForFacility;
                    appCollListToBeReturned.add(applicationCollateralInstance);

            }
            SecurityCoverageRefactor.collateralAmountBycollateral.put(collId,0.00);

        }
        System.debug(' appCollListToBeReturned=> '+appCollListToBeReturned);
        return appCollListToBeReturned;
    }

    public static Map<Integer,List<SecurityCoverageRefactor.FacilityPriorityByCollateral>> convertTempFacilityToMap(List<SecurityCoverageRefactor.FacilityPriorityByCollateral> tempFacilityTobeConvertedToMap){
        Map<Integer,List<SecurityCoverageRefactor.FacilityPriorityByCollateral>> singleFacilityByOrder = new Map<Integer,List<SecurityCoverageRefactor.FacilityPriorityByCollateral>> ();
        for(SecurityCoverageRefactor.FacilityPriorityByCollateral orderRec:tempFacilityTobeConvertedToMap){
            if(singleFacilityByOrder.containsKey(orderRec.order)){
                singleFacilityByOrder.get(orderRec.order).add(orderRec);
            }else{
                singleFacilityByOrder.put(orderRec.order,new List<SecurityCoverageRefactor.FacilityPriorityByCollateral>{orderRec});
            }
        }
        // duplicate value in map for same priority will get overrriden by last item
        return singleFacilityByOrder;
    }

    public static genesis__Application_Collateral__c findApplicationCollateralByFacilityAndCollateral(List<genesis__Application_Collateral__c> appColList,String facId,String collId){
        for(genesis__Application_Collateral__c appColRec:appColList){
            if(appColRec.Facility__c == facId && appColRec.genesis__Collateral__c == collId)
                return appColRec;
        }
        return null;
    }

    public static void securityWiseAllocatedAmount(String appId){
        try{
            List<genesis__Application_Collateral__c> appCollList = new List<genesis__Application_Collateral__c>();
            Map<Id,Facility__c> failityRecByFacId = new  Map<Id, Facility__c>();
            failityRecByFacId = SecurityCoverageRefactorModel.getFacilityByFacId(appId);
            System.debug('######## failityRecByFacId'+failityRecByFacId);
            genesis__Applications__c appRecord = [Select id,Application_Stage__c,Sub_Stage__c from genesis__Applications__c where Id=:appId];
            Map<String,List<genesis__Application_Collateral__c>> facWiseAppCollMap = new Map<String,List<genesis__Application_Collateral__c>>();
            List<Facility__c> facListToBeUpdated = new List<Facility__c>();
            Map<String,String> prodNameByFacility =new Map<String, String>();
            if(appId != null){
                appCollList = [SELECT id,Name,Facility__c,Facility__r.Product_Name__c,Facility__r.BRE_Limit__c,Facility__r.Primary_Security_Allocated__c,Facility__r.Collateral_Security_Allocated__c,Allocated_Amount__c,
                        Security_Type__c FROM genesis__Application_Collateral__c WHERE Application__c =: appId];
            }

            if(! appCollList.isEmpty()){
                for(genesis__Application_Collateral__c col : appCollList){
                    prodNameByFacility.put(col.Facility__c,col.Facility__r.Product_Name__c);
                    if(facWiseAppCollMap.containsKey(col.Facility__c)){
                        facWiseAppCollMap.get(col.Facility__c).add(col);
                    }
                    else{
                        facWiseAppCollMap.put(col.Facility__c,new List<genesis__Application_Collateral__c>{col});
                    }
                }
            }
            System.debug('$$$$$$$$$$$ facWiseAppCollMap'+facWiseAppCollMap);
            System.debug('########### facWiseAppCollMap'+facWiseAppCollMap.size());
            for(String str : facWiseAppCollMap.keyset()){
                System.debug('^^^^^^^^^^^^'+str);
                Decimal primarySecurityAllocated     = 0.00;
                Decimal collateralSecurityAllocated  = 0.00;
                Facility__c fac = new Facility__c();

                for(genesis__Application_Collateral__c appCol : facWiseAppCollMap.get(str)){
                    if(appCol.Security_Type__c == 'Primary Securities'){
                        if(appCol.Allocated_Amount__c != null)
                        primarySecurityAllocated += appCol.Allocated_Amount__c;
                    }
                    else {
                        if(appCol.Allocated_Amount__c != null)
                            collateralSecurityAllocated += appCol.Allocated_Amount__c;
                    }
                }
                System.debug(' ############ primarySecurityAllocated'+primarySecurityAllocated);
                System.debug(' ############ collateralSecurityAllocated'+collateralSecurityAllocated);
                System.debug(' ############ facId'+str);
                System.debug('######## is facility exist in map'+failityRecByFacId.containsKey(str));
                fac.Id = str;
                //Is_Collateral_Security_Required
                //Is_Primary_Security_Required
                System.debug('@@@@@'+prodNameByFacility.get(str));
                fac.Is_Collateral_Security_Required__c = SecurityCoverageRefactor.securityMasterByProduct.get(prodNameByFacility.get(str)).Is_Collateral_Security_Required__c;
                fac.Is_Primary_Security_Required__c = SecurityCoverageRefactor.securityMasterByProduct.get(prodNameByFacility.get(str)).Is_Primary_Security_Required__c;
                if(primarySecurityAllocated != 0.00){
                    fac.Primary_Security_Allocated__c = primarySecurityAllocated;
                    System.debug('#####'+failityRecByFacId.get(str).BRE_Limit__c);
                    fac.Primary_Security_Coverage__c = (primarySecurityAllocated * Decimal.valueOf(100))/ failityRecByFacId.get(str).BRE_Limit__c;
                }

                //fac.Primary_Security_Coverage__c = primarySecurityAllocated / failityRecByFacId.get(str).BRE_Limit__c;

                if(collateralSecurityAllocated != 0.00){
                    fac.Collateral_Security_Allocated__c = collateralSecurityAllocated;
                    System.debug(' ############ primarySecurityAllocated'+primarySecurityAllocated);
                    System.debug('#####'+failityRecByFacId.get(str).BRE_Limit__c);
                    if(failityRecByFacId.get(str).Type__c == 'Funded'){
                        System.debug(' ############ primarySecurityAllocated'+primarySecurityAllocated);
                        fac.Collateral_Security_Coverage__c =  (collateralSecurityAllocated * Decimal.valueOf(100))/ failityRecByFacId.get(str).BRE_Limit__c;
                    }else if(failityRecByFacId.get(str).Type__c == 'Non-Funded'){
                        System.debug('##### collateralSecurityAllocated'+collateralSecurityAllocated);
                        System.debug('##### collateralSecurityAllocated'+collateralSecurityAllocated);
                        fac.Collateral_Security_Coverage__c = (collateralSecurityAllocated / ((failityRecByFacId.get(str).BRE_Limit__c)*(100-failityRecByFacId.get(str).Margin__c))) * 10000.00;
                        System.debug('##### collateralSecurityAllocated'+collateralSecurityAllocated);
                    }else{
                        System.debug(' ############ failityRecByFacId.get(str).Type__c'+failityRecByFacId.get(str).Type__c);
                    }
                }

                // Now Calculation for PsCR And CSCR
                if(SecurityCoverageRefactor.securityMasterByProduct.get(prodNameByFacility.get(str)).Is_Collateral_Security_Required__c){
                    fac.Collateral_Security_Coverage_Required__c = SecurityCoverageRefactor.securityMasterByProduct.get(prodNameByFacility.get(str)).Collateral_Security_Coverage__c;

                }
                if(SecurityCoverageRefactor.securityMasterByProduct.get(prodNameByFacility.get(str)).Is_Primary_Security_Required__c){
                    //fac.Primary_Security_Coverage_Required__c = 100*100/(1-failityRecByFacId.get(str).Margin__c);
                    if(failityRecByFacId.get(str).Margin__c != null)
                    fac.Primary_Security_Coverage_Required__c  = Decimal.valueOf(10000)*(1/(100-failityRecByFacId.get(str).Margin__c));
                }
                // Set Stage to Insufficient
                if(SecurityCoverageRefactor.securityMasterByProduct.get(prodNameByFacility.get(str)).Is_Primary_Security_Required__c){
                    if(fac.Primary_Security_Coverage_Required__c < fac.Primary_Security_Coverage__c){
                        //appRecord.Sub_Stage__c = Constants.INSUFFICIENT_COLLATERAL_COVERAGE;
                    }
                }
                if(SecurityCoverageRefactor.securityMasterByProduct.get(prodNameByFacility.get(str)).Is_Collateral_Security_Required__c){
                    if(fac.Collateral_Security_Coverage_Required__c < fac.Collateral_Security_Coverage__c){
                        //appRecord.Sub_Stage__c = Constants.INSUFFICIENT_COLLATERAL_COVERAGE;
                    }
                }
                System.debug(' ############ fac'+fac);
                facListToBeUpdated.add(fac);
            }
            UPDATE facListToBeUpdated;
            //update appRecord;

        }
        catch(Exception e){
            HandleBusinessException.captureError('SecurityCoverageRefactorHelper','securityWiseAllocatedAmount',e);

            System.debug('Error Message--> ' + e.getMessage()+' At '+e.getLineNumber()+' Stack Trace '+e.getStackTraceString());
        }


    }
    public static void mymethod(List<collatralResidualReallocationWrapper> collAllocationWrap){
        try{

            System.debug('appId =>'+collAllocationWrap);

            List<String> collIds = new List<String>();

            Map<Id,genesis__Application_Collateral__c> orgWideAppColls = new Map<Id,genesis__Application_Collateral__c>();

            for (Integer i = 0; i < collAllocationWrap.size(); i++) {
                collIds.add(collAllocationWrap[i].collId);
            }

            if (collIds != null) {
                orgWideAppColls = SecurityCoverageRefactorModel.getAllApplicationColletrForGivenCollaterals(collIds);

                for (Id id : orgWideAppColls.keySet()) {
                     orgWideAppColls.get(id).Allocated_residual__c = 0.00;

                }
                update orgWideAppColls.values();
            }
            
            // 1. Collect All collaterl Ids
            // 2. Reduce Allocated residual from Allocated amount in application Collateral for all these collateral(For Reducing get All Application colaateral related to these collateral )
            // 3. Increase Collateral % value in Allocated Amount of Application Collateral(And again update Allocated residual on Application)




        }catch(Exception e){
            HandleBusinessException.captureError('className','methodName',e);
            System.debug('Error Message :'+e.getMessage()+' AT '+e.getLineNumber());
        }
    }


    public class collatralResidualReallocationWrapper{
        public String collId;
        public  Map<String,Decimal> percentageAllocationByFacility;
        public collatralResidualReallocationWrapper(){
            collId = '';
            percentageAllocationByFacility = new Map<String, Decimal>();
        }
    }








}