/**
 * Author : EtMarlabs
 * Client : KVB
 * Date   :29-05-2018
 * Module :MVP2/Sprint 3
 */


public  class SanctionMatrixController_EA {

    public static Map<String,Integer> applicationCountByRole   = new Map<String, Integer>();


    public static String saveAuthorityreccomendations(String appId,Boolean isMoreThanTenDays,Boolean isAuthNeedstoBeInserted){
        System.debug('@@@@@@@@'+isMoreThanTenDays);
        List<Facility__c> allfacilities                        = new List<Facility__c>();
        List<EAE_Sanction_Matrix__mdt> otherRoles              = new List<EAE_Sanction_Matrix__mdt>();
        List<EAE_Sanction_Matrix__mdt> managerRoles            = new List<EAE_Sanction_Matrix__mdt>();
        EAE_Sanction_Matrix__mdt  nextHigherAuth               = new EAE_Sanction_Matrix__mdt();
        Decimal nextOrderToCheckWith                           = 0;
        Decimal aggregateExistingLimit                         = 0;
        Decimal aggregateNewLimit                              = 0;
        String appManagerRole                                  = '';
        String renewalApplicationSanctionAuth                  = '';
        Boolean isManagerHigherAuthority                       = false;

        Boolean canGivenRoleApprove                            = FALSE;
        User appOwner                                          = new User();
        List<genesis__Applications__c> appInfo                 = new List<genesis__Applications__c>();
        //if(isMoreThanTenDays) isManagerHigherAuthority = false;
        try{
            otherRoles                                         = SanctionMatrixControllerHelper_EA.getEAESanction_matricesRecords('No');
            managerRoles                                       = SanctionMatrixControllerHelper_EA.getEAESanction_matricesRecords('Yes');
            System.debug('otherRoles---> '+otherRoles);
            System.debug('managerRoles---> '+managerRoles);
            if(appId != null && appId != ''){
                appInfo                                        = SOQL_Util.getApplication(new Set<Id>{appId});

                if(! appInfo.isEmpty() && appInfo[0].genesis__Account__c != null){
                    System.debug('#####'+appInfo[0]);
                    System.debug('Appliaction Owner---> '+appInfo[0].OwnerId);
                    applicationCountByRole                     = getSanctionAuthority_Count(appInfo[0].genesis__Account__c);
                    System.debug('applicationCountByRole---> ' + applicationCountByRole);
                    appOwner                                   = SanctionMatrixControllerHelper_EA.appOwnerInfo(appInfo[0].OwnerId);
                    System.debug('appOwner Name----> ' + appOwner.Name);
                }

                if (appOwner != null) {
                    appManagerRole                             = appOwner.Designation__c;
                    System.debug('appManagerRole---> '+appManagerRole);
                }

                allfacilities                                  = SanctionMatrixControllerHelper_EA.getAllFacilities(appId);
				System.debug('allfacilities::::'+allfacilities);
                if (allfacilities != null && !allfacilities.isEmpty()) {
                    System.debug('@@@@'+allfacilities[0]);
                    aggregateExistingLimit                     = SanctionMatrixControllerHelper_EA.getExistingLimitAggregate(allfacilities);
                    aggregateNewLimit                          = SanctionMatrixControllerHelper_EA.getNewLimitAggregate(allfacilities);
                    system.debug('aggregateExistingLimit---> '+aggregateExistingLimit);
                    system.debug('aggregateNewLimit---> '+aggregateNewLimit);
                }
            }else{
                system.debug('appId is null');
            }

            EAE_Sanction_Matrix__mdt managerRolerec = new EAE_Sanction_Matrix__mdt();
            /* For loop on managerRoles*/
            if(!isMoreThanTenDays)
            for(EAE_Sanction_Matrix__mdt sanctionRec:managerRoles){

                System.debug('Inside for/before IF');
                if(sanctionRec.Role__c == appManagerRole){
                    managerRolerec = sanctionRec;
                    system.debug('sanctionRec.Role__c---> '+sanctionRec.Role__c);
                    system.debug('sanctionRec.No_of_application_per_year__c---> '+sanctionRec.No_of_application_per_year__c);
                    system.debug('checkIfRoleCrossedItsLimit---> '+checkIfRoleCrossedItsLimit(sanctionRec.Role__c,sanctionRec.No_of_application_per_year__c));
                    // 1.check if bm has crossed its boundary
                    if(!checkIfRoleCrossedItsLimit(sanctionRec.Role__c,sanctionRec.No_of_application_per_year__c)){
                        // 2.Check if BM can approve it
                        System.debug('sanctionRec.Limit_in_Percentage__c---> '+sanctionRec.Limit_in_Percentage__c);
                        Decimal approvableAmByRolePercentage   = SanctionMatrixControllerHelper_EA.getSpecifiedPercentageValueOfExistingLimit(aggregateExistingLimit,sanctionRec.Limit_in_Percentage__c);
                        System.debug('approvableAmByRolePercentage---> '+approvableAmByRolePercentage);
                        Decimal highestAmountRoleCanApprove    = SanctionMatrixControllerHelper_EA.calculateMinimum(approvableAmByRolePercentage,sanctionRec.Limit_in_Amount__c);
                        System.debug('highestAmountRoleCanApprove---> '+highestAmountRoleCanApprove);
                        canGivenRoleApprove                    = SanctionMatrixControllerHelper_EA.canGivenRoleSanctionNewLimit(highestAmountRoleCanApprove,aggregateNewLimit);
                        System.debug('approvableAmByRolePercentage2---> '+approvableAmByRolePercentage);
                        System.debug('highestAmountRoleCanApprove2---> '+highestAmountRoleCanApprove);
                        System.debug('canGivenRoleApprove---> '+canGivenRoleApprove);
                        if(canGivenRoleApprove){
                            isManagerHigherAuthority            = canGivenRoleApprove;
                            break;
                        }
                        if(renewalApplicationSanctionAuth == null || renewalApplicationSanctionAuth == ''){
                            nextOrderToCheckWith               = sanctionRec.Order__c + 1;
                            System.debug('nextOrderToCheckWith---> '+nextOrderToCheckWith);
                        }
                    }

                    //
                }

            }

            /* If Manager Can't Approve*/
            /*1. Check Final Authority on renewal application*/
            /*2. Continue with rest*/
            if(! canGivenRoleApprove && renewalApplicationSanctionAuth != null && renewalApplicationSanctionAuth != appManagerRole){
                System.debug('canGivenRoleApprove---> ' + canGivenRoleApprove);
                System.debug('appManagerRole---> ' + appManagerRole);
                System.debug('renewalApplicationSanctionAuth---> ' + renewalApplicationSanctionAuth);
                for(EAE_Sanction_Matrix__mdt sanctionRec:otherRoles) {
                    if(sanctionRec.Role__c == renewalApplicationSanctionAuth){
                        // Check if renewal authority can approve it
                        System.debug('@@@@@@@@@@'+sanctionRec.Role__c);
                        System.debug('@@@@@@@@@@'+sanctionRec.No_of_application_per_year__c);
                        System.debug('@@@@@@@@@@'+checkIfRoleCrossedItsLimit(sanctionRec.Role__c,sanctionRec.No_of_application_per_year__c));
                        if (!checkIfRoleCrossedItsLimit(sanctionRec.Role__c,sanctionRec.No_of_application_per_year__c)) {
                            System.debug('sanctionRec.Limit_in_Amount__c---> ' + sanctionRec.Limit_in_Amount__c);
                            Decimal approvableAmByRolePercentage = SanctionMatrixControllerHelper_EA.getSpecifiedPercentageValueOfExistingLimit(aggregateExistingLimit, sanctionRec.Limit_in_Percentage__c);
                            Decimal highestAmountRoleCanApprove = SanctionMatrixControllerHelper_EA.calculateMinimum(approvableAmByRolePercentage, sanctionRec.Limit_in_Amount__c);
                            canGivenRoleApprove = SanctionMatrixControllerHelper_EA.canGivenRoleSanctionNewLimit(highestAmountRoleCanApprove, aggregateNewLimit);
                            System.debug('approvableAmByRolePercentage3---> ' + approvableAmByRolePercentage);
                            System.debug('highestAmountRoleCanApprove3---> ' + highestAmountRoleCanApprove);
                            System.debug('canGivenRoleApprove3---> ' + canGivenRoleApprove);
                            if (canGivenRoleApprove) {
                                //isManagerHigherAuthority            = canGivenRoleApprove;
                                nextHigherAuth = sanctionRec;
                                System.debug('nextHigherAuth3---> ' + nextHigherAuth);
                                break;
                            } else {
                                nextOrderToCheckWith = sanctionRec.Order__c + 1;
                                System.debug('nextOrderToCheckWith3---> ' + nextOrderToCheckWith);
                            }
                        }

                    }
                }

            }
            /* if Highest Authority has not been found yet*/
            /*System.debug('otherRoles4---> '+otherRoles);
            System.debug('nextOrderToCheckWith4---> '+nextOrderToCheckWith);*/
            if(! canGivenRoleApprove){
                for(EAE_Sanction_Matrix__mdt sanctionRec:otherRoles) {
                    System.debug('sanctionRec.Order__c---> '+sanctionRec.Order__c);
                    System.debug('sanctionRec.Role__c---> '+sanctionRec.Role__c);
                    system.debug('nextOrderToCheckWith12345---> ' + nextOrderToCheckWith);
                    if(! checkDmLevelAggregateCount() && (sanctionRec.Role__c =='DO_DM'  || sanctionRec.Role__c =='DOCC')){
                        continue;
                    }
                    if(sanctionRec.Order__c < nextOrderToCheckWith){
                        System.debug('sanctionRec.Order__c continue---> '+sanctionRec.Order__c );
                        System.debug('nextOrderToCheckWith continue---> '+nextOrderToCheckWith);
                        continue;
                    }else{
                        System.debug('@@@@@ sanctionRec.Role__c---> ' + sanctionRec.Role__c);
                        if (!checkIfRoleCrossedItsLimit(sanctionRec.Role__c,sanctionRec.No_of_application_per_year__c)) {
                            Decimal approvableAmByRolePercentage = SanctionMatrixControllerHelper_EA.getSpecifiedPercentageValueOfExistingLimit(aggregateExistingLimit, sanctionRec.Limit_in_Percentage__c);
                            Decimal highestAmountRoleCanApprove = SanctionMatrixControllerHelper_EA.calculateMinimum(approvableAmByRolePercentage, sanctionRec.Limit_in_Amount__c);
                            canGivenRoleApprove = SanctionMatrixControllerHelper_EA.canGivenRoleSanctionNewLimit(highestAmountRoleCanApprove, aggregateNewLimit);
                            System.debug('@@@@@ approvableAmByRolePercentage---> ' + approvableAmByRolePercentage);
                            System.debug('@@@@@ highestAmountRoleCanApprove---> ' + highestAmountRoleCanApprove);
                            System.debug('@@@@@ canGivenRoleApprove---> ' + canGivenRoleApprove);
                            if (canGivenRoleApprove) {
                                nextHigherAuth = sanctionRec;
                                //isManagerHigherAuthority            = canGivenRoleApprove;
                                break;
                            }
                        }
                    }
                }
            }


            System.debug('@@@@ nextHigherAuthW---> '+nextHigherAuth);

            //newly added 05.06.2018 
            List<EAE_Sanction_Matrix__mdt> metadataList = new List<EAE_Sanction_Matrix__mdt>();
            if(nextHigherAuth != null && !isManagerHigherAuthority){
                metadataList.add(nextHigherAuth);
                if(isAuthNeedstoBeInserted){
                    SanctionMatrixControllerHelper_EA.saveAllFacilityRecomendation(metadataList,appId,isManagerHigherAuthority);
                    Underwriting_CTRL_Helper.closeExistingBMTask(appId,SanctionUnderwriting_Process.APPILICATION_REVIEW);
                }

                System.debug('@@@@@@@@@@@@'+metadataList[0].Role__c);
                if(!metadataList.isEmpty())
                return ''+metadataList[0].Role__c;
                else
                  return '';
            }else if(isManagerHigherAuthority){
                if(isAuthNeedstoBeInserted)
                SanctionMatrixControllerHelper_EA.changeBMAsHighrAuthoriry(appId,isManagerHigherAuthority);
                return 'BM';
            }
            /*metadataList.add(nextHigherAuth);
            metadataList.add(managerRolerec);
            SanctionMatrixControllerHelper_EA.saveAllFacilityRecomendation(metadataList,appId,isManagerHigherAuthority);*/
            //createTaskForBM(appId);
            return ' is Not Found';
        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage()+e.getStackTraceString());
            return null;
        }
    }
    public static void createTaskForBM(Id appId){
        try {
            List<genesis__Applications__c> appInfo                 = new List<genesis__Applications__c>();
            appInfo                                        = SOQL_Util.getApplication(new Set<Id>{appId});
            Task taskRec = SanctionUnderwriting_Process.getTaskObj(appId, appInfo[0].OwnerId, SanctionUnderwriting_Process.SANC_OFFICER_TASK_SUBJ, SanctionUnderwriting_Process.APPILICATION_REVIEW);
            TaskFlow_Helper.TASK_TRIGGER_RUNNING    = true;
            insert taskRec;
        } catch (Exception e) {
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage()+e.getStackTraceString());
        }

    }

    public static Map<String,Integer> getSanctionAuthority_Count(String losAccountId){
        try{
            List<String> listOfRecordType = new List<String>{'SME_Exceeding'};
            Map<String,Integer> mapObject = new Map<String,Integer>();
            Integer countFromAccountOperations=0;
            Account accRec = new Account();
            accRec = [SELECT Id,No_Of_Exceeding_And_Adhoc__c from Account where Id=:losAccountId];

            if(accRec!= null && accRec.No_Of_Exceeding_And_Adhoc__c != null && YearDataConstant.currFiscalYear=='2017-18'){
                countFromAccountOperations = Integer.valueOf(accRec.No_Of_Exceeding_And_Adhoc__c) ;
            }
            If(losAccountId !=null && losAccountId !=''){
                List<genesis__Applications__c>  ListAppObj = [select id,Sanction_Authority__c,genesis__Account__c from genesis__Applications__c where genesis__Account__c =:losAccountId AND RecordType.DeveloperName IN : listOfRecordType ];
                System.debug('!!!!!! '+ListAppObj);
                If(ListAppObj !=null && !ListAppObj.isEmpty()){
                    for(genesis__Applications__c appObj  : ListAppObj){
                        system.debug('Sanction Authority--> '+appObj.Sanction_Authority__c);
                        If(appObj !=null && appObj.Sanction_Authority__c !=null){
                            If(mapObject.containsKey(appObj.Sanction_Authority__c)){
                                mapObject.put(appObj.Sanction_Authority__c,mapObject.get(appObj.Sanction_Authority__c)+1);
                            }else{
                                if((appObj.Sanction_Authority__c).contains('BR') && countFromAccountOperations>0){
                                    mapObject.put(appObj.Sanction_Authority__c,1+countFromAccountOperations);
                                }else{
                                    mapObject.put(appObj.Sanction_Authority__c,1);
                                }

                            }
                        }
                    }
                    If(mapObject !=null){
                        return mapObject;
                    }
                }
            }
            return new Map<String,Integer>();
        }catch(Exception ex){
            system.debug('Line Number ---> '+ex.getLineNumber());
            return new Map<String,Integer>();
        }
    }
    public static Boolean checkIfRoleCrossedItsLimit(String currentRole,Decimal roleLimitCount){
        try{
            /*System.debug('AAAA'+applicationCountByRole);
            System.debug('AAAA'+currentRole);
            System.debug('AAAA'+roleLimitCount);*/
            if(! applicationCountByRole.isEmpty()){
                /*System.debug('AAAA'+applicationCountByRole);*/
                for (String roles:applicationCountByRole.keySet()) {
                    /*System.debug('AAAA'+roles);*/
                    if(roles == currentRole){
                        return roleLimitCount>Decimal.valueOf(applicationCountByRole.get(roles))?FALSE:TRUE;
                    }
                }
            }

            return false;

        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber());
            return false;
        }
    }
    public static Boolean checkDmLevelAggregateCount(){
        try {
            Integer allBmCount = 0;
            if (!applicationCountByRole.isEmpty()) {

                for (String roles:applicationCountByRole.keySet()) {
                    /*roles.contains('BR') ||*/
                    if( roles.contains('DO'))
                        allBmCount  +=applicationCountByRole.get(roles);
                }

            }
            return allBmCount >= 2 ? false:true;
        } catch (Exception e) {
            return null;
        }
    }


}