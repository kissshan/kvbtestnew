//alert('Hi Ajeet');
var app=angular.module('dashboadrdApp', ['ngRoute','ngAnimate','ngScrollable']);

app.controller('dashboadrdCtrl', function($scope, $timeout, $window, $location ) {
    $scope.show =[];
    $scope.isFlags = [];
    $scope.showExposure =false;
    $scope.riskUser = riskUser;
    $scope.riskUser = false;
    $scope.isriskUser = true;
    $scope.isApproved = true;
    $scope.listOfComments =[];
    $scope.listOfComments.length=1;
    $scope.listOfCommentsPreDis =[];
    $scope.listOfCommentsPreDisBM =[];

    $scope.listOfCommentsPreDis.length=1;
    $scope.listOfCommentsPreDisBM.push({"Terms_and_Conditions__c":"","Complied__c":"","Reason__c":""});
    $scope.preDisbursementCommentsAndCompliance = [];
    $scope.creditScore =creditScore;
    console.log('$scope.creditScore');
    console.log($scope.creditScore);
    console.log($scope.creditScore.applicationInfo.Security_coverage__c);
    console.log('is save operation done');
    console.log($scope.creditScore.facilityList[0].Is_Save_Operation_Done__c)
    $scope.obj = new Object();
    $scope.sancProcess = JSON.parse(sancProcess);
    $scope.onlyAppRej = false;
    $scope.history = true;
    $scope.sanctionHistory = true;
    $scope.rListClass = 'displayNone';
    console.log($scope.creditScore);
    $scope.roles = [];
    $scope.isApprRej = false;
    $scope.isRHA = true;
    $scope.onLoadRBCheck = false;
    $scope.onLoadisHRACheck = false;
    $scope.onLoadApproveCheck = false;
    $scope.onLoadMARCheck = false;
    $scope.comments = {};
    $scope.facilityLAR = {};
    $scope.facilitySaveList = [];
    $scope.bmCommentsList = [];
    $scope.termsAndConditions = {};
    $scope.isredirect = '';
    $scope.disableAll = false;
    $scope.facilityFIeldSet = false;
    $scope.commentsFieldset =false;
    $scope.disableAllshow = false;
    $scope.referback = false;
    $scope.termsAndConditionList = [];
    var limitCount = 0;
    var rateCount = 0;
    $scope.obj.showPRA = true;
    $scope.isReadonly = false;
    $scope.sancAuthRTypeId = rAuthTypeID;
    $scope.tcRtypeId = rTCTypeID;
    $scope.prerTCTypeID= prerTCTypeID;
    $scope.applicationId = appId;
    $scope.locationURL = window.location.origin;
    $scope.isRole = false;
    $scope.BMNoOfDaysRecom = 0;
    $scope.BMRole = '';
    $scope.HigherAuthRole = '';
    $scope.HigherAuthNoOfDaysRecom = 0;
    $scope.BMEditable = false;
    $scope.BMEditableXXX = false;
    $scope.compliedOptions =  ["Yes", "No"];

    $scope.round = function(value, decimals){
         return Number(Math.round(value+'e'+decimals)+'e-'+decimals);
    }
    for(var key in $scope.creditScore.facilityList){
         if ($scope.creditScore.facilityList.hasOwnProperty(key)) {
            $scope.creditScore.facilityList[key].MCLR_Rate__c = $scope.creditScore.mclrRate;
         }
    }
    // remove Renewal facility from FaciltyList for New Loan
    if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan' ){
        for(var key in $scope.creditScore.facilityList){
            if ($scope.creditScore.facilityList.hasOwnProperty(key)) {
                if($scope.creditScore.facilityList[key].NTB_Facility_Type__c == 'Renewal'){
                    $scope.creditScore.facilityList.splice(key,1);

                }

            }
        }
    }
    /*
        Pre-Population Starts Here
    */
    if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Enhancement' || $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan' || $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_AdHoc'){
            for(var i=0;i<$scope.creditScore.facilityList.length;i++){
                debugger;
                    if($scope.creditScore.facilityList[i].Facilities__r != undefined)
                    for(var j=0;j<$scope.creditScore.facilityList[i].Facilities__r.records.length;j++){
                        if(($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c==null || $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c==undefined) && (($scope.creditScore.facilityList[i].Facilities__r.records[j].Role__c).includes('BR') || ($scope.creditScore.facilityList[i].Facilities__r.records[j].Higher_Authority_Order__c >=3 && $scope.creditScore.facilityList[i].Facilities__r.records[j].Highest_Authority__c)) ){

                            $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c =   $scope.creditScore.facilityList[i].BRE_Limit__c ;

                            $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c =   $scope.creditScore.facilityList[i].BRE_Processing_Charge__c ;

                            if($scope.creditScore.facilityList[i].Type__c == 'Funded')
                                $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c =   $scope.creditScore.facilityList[i].BRE_Rate__c ;
                            /*if($scope.creditScore.facilityList[i].Type__c == 'Non-Funded')
                                $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c =   $scope.creditScore.facilityList[i].BRE_Rate__c ;*/

                            if($scope.creditScore.facilityList[i].CL_Product__r.Facility_Category__c.indexOf('OCC') < 0 ){
                                $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin__c =   $scope.creditScore.facilityList[i].BRE_Margin__c ;
                            }
                            else if($scope.creditScore.facilityList[i].CL_Product__r.Facility_Category__c.indexOf('OCC') >= 0 ){

                                $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Receivables__c = $scope.creditScore.facilityList[i].BRE_Margin_Receivables__c;
                                if(($scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='Trading') || ($scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='TRADING')){
                                    $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Stock_Trading__c = $scope.creditScore.facilityList[i].BRE_Margin_Stock_Trading__c;
                                }
                                if(( $scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='Manufacturing') || ($scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='MANUFACTURING')){
                                    $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Stock_Manufacturing__c = $scope.creditScore.facilityList[i].BRE_Margin_Stock_Manufacturing__c;
                                }

                            }
                        }
                    }


            }
        }
    /*
    Pr-population ends here

    */
    if($scope.creditScore.applicationInfo.Security_coverage__c == NaN){
        creditScore.applicationInfo.Security_coverage__c = 0;
    }
    if($scope.sancProcess.isSpecialTermsEditable){
        debugger;
        $scope.listOfComments=[];
        for(var key in $scope.creditScore.termsCondtionComments){

            if ($scope.creditScore.termsCondtionComments.hasOwnProperty(key)) {
                if($scope.creditScore.termsCondtionComments[key].Id != undefined && $scope.creditScore.termsCondtionComments[key].Id != null)
                $scope.listOfComments.push($scope.creditScore.termsCondtionComments[key].Terms_and_Conditions__c);
                $scope.termsAndConditions[key] = $scope.creditScore.termsCondtionComments[key].Terms_and_Conditions__c;
            }
        }
        console.log('listOfComments');
        console.log($scope.listOfComments);
    }
    if($scope.sancProcess.isSpecialTermsEditableByDeviation){
        debugger;
        $scope.listOfComments=[];
        for(var key in $scope.creditScore.termsCondtionComments){

            if ($scope.creditScore.termsCondtionComments.hasOwnProperty(key)) {
                if($scope.creditScore.termsCondtionComments[key].Id != undefined && $scope.creditScore.termsCondtionComments[key].Id != null)
                $scope.listOfComments.push($scope.creditScore.termsCondtionComments[key].Terms_and_Conditions__c);
                $scope.termsAndConditions[key] = $scope.creditScore.termsCondtionComments[key].Terms_and_Conditions__c;
            }
        }
        console.log('listOfComments');
        console.log($scope.listOfComments);
    }
    if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_AdHoc'){
            for(var key in $scope.creditScore.facilityList){
                debugger;
                if(key=='0'){
                    if($scope.creditScore.facilityList[0].Facilities__r != undefined)
                    for(var j=0;j<$scope.creditScore.facilityList[0].Facilities__r.records.length;j++){


                        if($scope.creditScore.facilityList[key].Facilities__r.records[j].Higher_Authority_Order__c==1){
                            $scope.BMRole = $scope.creditScore.facilityList[key].Facilities__r.records[j].Role__c;
                            if($scope.creditScore.facilityList[key].Facilities__r.records[j].Recommended_Days__c!= null)
                            $scope.BMNoOfDaysRecom = $scope.creditScore.facilityList[key].Facilities__r.records[j].Recommended_Days__c;


                        }else if($scope.creditScore.facilityList[key].Facilities__r.records[j].Highest_Authority__c){
                            $scope.HigherAuthRole = $scope.creditScore.facilityList[key].Facilities__r.records[j].Role__c;
                            if($scope.creditScore.facilityList[key].Facilities__r.records[j].Recommended_Days__c!= null)
                            $scope.HigherAuthNoOfDaysRecom = $scope.creditScore.facilityList[key].Facilities__r.records[j].Recommended_Days__c;
                        }
                    }
                }

            }
    }
    /*if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_AdHoc'){
            for(var i=0;i<$scope.creditScore.facilityList.length;i++){
                debugger;
                    if($scope.creditScore.facilityList[i].Facilities__r != undefined)
                    for(var j=0;j<$scope.creditScore.facilityList[i].Facilities__r.records.length;j++){
                        if(($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c==null || $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c==undefined) &&  ($scope.creditScore.facilityList[i].Facilities__r.records[j].Role__c).includes($scope.creditScore.loggedInUser.Designation__c)){
                            $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c =   $scope.creditScore.facilityList[i].Existing_Processing_Charge__c ;
                            $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c =   $scope.creditScore.facilityList[i].Existing_Spread__c + $scope.creditScore.facilityList[i].MCLR_Rate__c + 3 ;

                        }
                    }


            }
    }*/

    if($scope.creditScore.applicationInfo != null){
        if($scope.creditScore.applicationInfo.Is_Financial_security_Coverage_Less__c){
            // show a pop-up
            swal({
              title: "Current Security Coverage is less",
              text: "Do you still want to proceed ?",
              type: "warning",
              showCancelButton: true,
              confirmButtonClass: "btn-danger",
              confirmButtonText: "Ask For Additional collateral",
              cancelButtonText: "Proceed",
              closeOnConfirm: false,
              closeOnCancel: true
            },
            function(isConfirm) {
              if (isConfirm) {
                $scope.changeAppStageToInsufficientColl();
              } else {

                 $scope.BMEditable = true;
                 $scope.$apply();
              }
            });
        }
    }

    if(dashType !='' && dashType != undefined){
        $scope.dashboardType    = '('+dashType+')';
    }


    if($scope.creditScore.kvbCompanyDetails != null){
        $scope.tandcHelpText = $scope.creditScore.kvbCompanyDetails.Special_Sanction_Help_Text__c;
        $scope.Overall_score__c = $scope.creditScore.kvbCompanyDetails.Overall_score__c;
    }

    $scope.RecommendationDone   = false;
    for(var iCount=0; iCount < $scope.creditScore.facilityList.length; iCount++){
        debugger;
        if($scope.creditScore != undefined && $scope.creditScore.facilityList[iCount] != undefined
           && $scope.creditScore.facilityList[iCount].Facilities__r != undefined && $scope.creditScore.facilityList[iCount].Facilities__r.records != undefined){

            for(rCount=0; rCount < $scope.creditScore.facilityList[iCount].Facilities__r.records.length; rCount++){
                if(!$scope.isRole){
                    $scope.roles.push({name:$scope.creditScore.facilityList[iCount].Facilities__r.records[rCount].Role__c,orderRole:$scope.creditScore.facilityList[iCount].Facilities__r.records[rCount].Higher_Authority_Order__c});

                }
                if(!$scope.isReadonly && $scope.creditScore.facilityList[iCount].Facilities__r.records[rCount].Role__c == $scope.creditScore.loggedInUser.Designation__c){
                    $scope.isReadonly = $scope.creditScore.facilityList[iCount].Facilities__r.records[rCount].Read_Only_User__c;
                }

                if($scope.creditScore.facilityList[iCount].Facilities__r.records[rCount].Recommended_Limit__c != undefined &&
                   $scope.creditScore.facilityList[iCount].Facilities__r.records[rCount].Recommended_Limit__c != null
                   && $scope.creditScore.facilityList[iCount].Facilities__r.records[rCount].Recommended_Rate__c != undefined
                   && $scope.creditScore.facilityList[iCount].Facilities__r.records[rCount].Recommended_Rate__c != null
                   && $scope.creditScore.facilityList[iCount].Facilities__r.records[rCount].Recommended_Processing_Charge__c != undefined
                   && $scope.creditScore.facilityList[iCount].Facilities__r.records[rCount].Recommended_Processing_Charge__c != null){
                    if($scope.sancProcess.isBranchRole && $scope.creditScore.facilityList[iCount].Facilities__r.records[rCount].Higher_Authority_Order__c == 1)
                        $scope.RecommendationDone = true;
                    if($scope.sancProcess.isFinalAuhtority)
                        $scope.RecommendationDone = true;
                }
            }
            $scope.isRole = true;

        }
    }
    $scope.checkFacilityId = function(facilityId){
        var createObj = new Object();
        var isFound = true;
        if($scope.facilitySaveList.length != 0){
            for(sCount=0;sCount < $scope.facilitySaveList.length; sCount++){

                if($scope.facilitySaveList[sCount].id == facilityId){
                    createObj.facObj  = $scope.facilitySaveList[sCount];
                    createObj.isExist = true;
                    return createObj;
                }else{
                    isFound = false;
                }
            }
            if(!isFound){
                createObj.facObj  = new Object();
                createObj.isExist = false;
                return createObj;
            }
        }
        else{
            createObj.facObj  = new Object();
            createObj.isExist = false;
            return createObj;
        }

    }
        $scope.filldefaultValuesForRenewal = function(){
            for(var i=0;i<$scope.creditScore.facilityList.length;i++){
                     debugger;
                    if($scope.creditScore.facilityList[i].Facilities__r != undefined)
                    for(var j=0;j<$scope.creditScore.facilityList[i].Facilities__r.records.length;j++){
                        if(($scope.creditScore.facilityList[i].Facilities__r.records[j].Role__c).includes($scope.creditScore.loggedInUser.Designation__c)){


                            $scope.saveFacilityObj =  $scope.checkFacilityId($scope.creditScore.facilityList[i].Facilities__r.records[j].Id);
                            $scope.saveFacilityObj.facObj.id = $scope.creditScore.facilityList[i].Facilities__r.records[j].Id;
                            $scope.saveFacilityObj.facObj.MCLR_Rate__c = $scope.creditScore.facilityList[i].MCLR_Rate__c;
                            $scope.saveFacilityObj.facObj.Facility__c = $scope.creditScore.facilityList[i].Facilities__r.records[j].Facility__c;
                            $scope.saveFacilityObj.facObj.CL_Product__c = $scope.creditScore.facilityList[i].CL_Product__r.clcommon__Product_Name__c;
                            $scope.saveFacilityObj.facObj.Role__c       = $scope.creditScore.facilityList[i].Facilities__r.records[j].Role__c;
                            $scope.saveFacilityObj.facObj.Product_Category__c = $scope.creditScore.facilityList[i].CL_Product__r.Facility_Category__c;
                            $scope.saveFacilityObj.facObj.Product_Schematic__c = $scope.creditScore.facilityList[i].CL_Product__r.Schematic_Loan__c;
                            $scope.saveFacilityObj.facObj.Higher_Authority_Order__c =  $scope.creditScore.facilityList[i].Facilities__r.records[j].Higher_Authority_Order__c;
                            $scope.saveFacilityObj.facObj.Type__c = $scope.creditScore.facilityList[i].Type__c;

                            //Filling recommended Limit
                            if($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c!= null && $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c != undefined)
                            $scope.saveFacilityObj.facObj.Recommended_Limit__c = $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c;
                            //Filling Processing Charges
                            if($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c != null && $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c != undefined)
                            $scope.saveFacilityObj.facObj.Recommended_Processing_Charge__c = $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c;
                            //Filling reccomended Rate
                            if($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c != null && $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c != undefined)
                            $scope.saveFacilityObj.facObj.Recommended_Rate__c   = $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c;
                            if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_AdHoc'){
                                $scope.saveFacilityObj.facObj.Recommended_Processing_Charge__c = 0.0;
                            }
                            //Filling Existing Processing Charges
                            if($scope.creditScore.facilityList[i].Existing_Processing_Charge__c != null && $scope.creditScore.facilityList[i].Existing_Processing_Charge__c != undefined)
                            $scope.saveFacilityObj.facObj.Existing_Processing_Charge__c = $scope.creditScore.facilityList[i].Existing_Processing_Charge__c;
                            //Filling Existing Rate
                            $scope.saveFacilityObj.facObj.BRE_Processing_Charge__c = $scope.creditScore.facilityList[i].BRE_Processing_Charge__c != undefined ?$scope.creditScore.facilityList[i].BRE_Processing_Charge__c :0.0;

                            $scope.saveFacilityObj.facObj.BRE_Limit__c = $scope.creditScore.facilityList[i].BRE_Limit__c;

                            $scope.saveFacilityObj.facObj.BRE_Rate__c               = $scope.creditScore.facilityList[i].BRE_Rate__c != undefined ? $scope.creditScore.facilityList[i].BRE_Rate__c :0.0;
                            $scope.saveFacilityObj.facObj.BRE_Spread__c                 = $scope.creditScore.facilityList[i].BRE_Spread__c != undefined ? $scope.creditScore.facilityList[i].BRE_Spread__c:0.0;

                            // May be there would be a problem
                            $scope.saveFacilityObj.facObj.Recommended_Spread__c     =$scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c!=undefined? $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c - $scope.creditScore.facilityList[i].MCLR_Rate__c:0.0;


                            if($scope.creditScore.facilityList[i].Facilities__r.records[j].Margin__c != null || $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin__c != undefined){
                                $scope.saveFacilityObj.facObj.Margin__c                 = $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin__c;
                            }
                            if($scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Receivables__c != null || $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Receivables__c != undefined){
                                $scope.saveFacilityObj.facObj.Margin_Receivables__c                 = $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Receivables__c;
                            }
                            if($scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Stock_Trading__c != null || $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Stock_Trading__c != undefined){
                                $scope.saveFacilityObj.facObj.Margin_Stock_Trading__c                   = $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Stock_Trading__c;
                            }
                            if($scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Stock_Manufacturing__c != null || $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Stock_Manufacturing__c != undefined){
                                $scope.saveFacilityObj.facObj.Margin_Stock_Manufacturing__c                 = $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Stock_Manufacturing__c;
                            }

                            if(!$scope.saveFacilityObj.isExist){
                                $scope.facilitySaveList.push($scope.saveFacilityObj.facObj);
                            }
                        }

                    }

            }
         }
    $scope.filldefaultValuesForRenewal();
    $scope.changeAppStageToInsufficientColl = function(){
        debugger;
        var appInfo = {Id:appId,Sub_Stage__c:'Insufficient collateral coverage'};
        console.log('appInfo'+appInfo);
        Visualforce.remoting.Manager.invokeAction(
            "Underwriting_CTRL.updateApplicationStage",appInfo ,
            function(result, event) {
                if(result != undefined){
                    console.log(result);
                    swal({title:'',text:result},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                }
            },
            {escape: false} // No escaping, please
        );

    }
    $scope.completeFinalSanction = function(){
        Visualforce.remoting.Manager.invokeAction(
            "Underwriting_CTRL.updateApplicationStagetoFinalSanction",appId ,
            function(result, event) {
                if(result != undefined){
                    console.log(result);
                    swal({title:'',text:result},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                }
            },
            {escape: false} // No escaping, please
        );
    }
    $scope.validateRecommendation =function(saveorSubmit){

        $scope.saveBMReview('noChangeInStage',saveorSubmit);
    }
    $scope.askForAdditionalCollateral = function(){
        $scope.appSubStage= 'Insufficent collateral coverage';
    }
    $scope.increase =function(){
        $scope.listOfComments.length =$scope.listOfComments.length+1;
        console.log($scope.listOfComments);
    }
    $scope.increasePreDis =function(){
        $scope.listOfCommentsPreDis.length =$scope.listOfCommentsPreDis.length+1;
        console.log($scope.listOfCommentsPreDis);
    }
    $scope.increasePreDisBM =function(){
        $scope.listOfCommentsPreDisBM.push({"Terms_and_Conditions__c":"","Complied__c":"","Reason__c":""});
    }
    $scope.testMethod = function(){
    }
    $scope.exposure =function(){
        $scope.showExposure =true;
    }

    $scope.closeExposure =function(){
        $scope.showExposure =false;
    }

    $scope.decrease =function(index){
        $scope.listOfComments.splice(index,1);
        $scope.termsAndConditions[index]='';
    }
    $scope.decreasePreDis =function(index){
        $scope.listOfCommentsPreDis.splice(index,1);
    }
    $scope.decreasePreDisBM =function(index){
            $scope.listOfCommentsPreDisBM.splice(index,1);
    }

    $scope.showScores = function(index){
        for(var i=0;i<$scope.creditScore.creditScores.length;i++){
            if(i==index){
                $scope.show[index] = !$scope.show[index];
            }
        }
    }
    $scope.disabledRHA = function(){
        $scope.isApprRej = true;
        $scope.isRHA = false;

    }
    $scope.disabledApprRej= function(){
        $scope.isApprRej = false;
        $scope.isRHA = true;
    }

    $scope.showHistory = function(){

        $scope.history = !$scope.history;
    }

    $scope.showSanctionHistory = function(){
        $scope.sanctionHistory = !$scope.sanctionHistory;
    }
    $scope.renewalList = {defaultOption:creditScore.pendingPreRenewalList[0]};

    $scope.recommend = function(){
        console.log($scope.comments);
    }


    $scope.saveBMReview = function(isStageChangerequired,saveorSubmit){

        //debugger;
        $scope.saveData ={};
        /*if(!$scope.creditScore.facilityList[0].Is_Save_Operation_Done__c){
            console.log('Save Operation');
            $scope.saveData.isSaveOrSubmit = 'SAVE';
        }else{
            console.log('Submit Operation');
            $scope.saveData.isSaveOrSubmit = 'SUBMIT';
        }*/
        if(saveorSubmit !=''){
            $scope.saveData.isSaveOrSubmit = saveorSubmit;
        }
        $scope.saveData.actionPerformed = 'BM-Reccomendation';
        $scope.saveData.applicationInfo = {};
        $scope.saveData.facility = [];
        $scope.saveData.bmCommentsList = [];
        $scope.saveData.termsAndConditions = [];
        $scope.saveData.preDisbersementtermsAndConditions = [];
        $scope.saveData.appId = appId;
        $scope.saveData.applicationInfo.Id = appId;
        $scope.saveData.IsFinalAuthority = $scope.sancProcess.isFinalAuhtority;
        debugger;

        var nonRunFlag = false;
       /* if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan' && $scope.sancProcess.isNewDashboardNeeded == true  && $scope.creditScore.applicationInfo.New_to_Business__c){
            nonRunFlag = true;
        }*/
        
		$scope.saveData.facility = $scope.facilitySaveList;
        // Added by Souvik -- 10.12.2018
        if( saveorSubmit =='SUBMIT'){
			debugger;
            if($scope.creditScore.applicationInfo.RecordType.DeveloperName =='SME_NEW_Loan'){
                if($scope.creditScore.applicationInfo.New_to_Business__c || $scope.creditScore.applicationInfo.Type__c == 'ETB-CA - New to credit' || $scope.creditScore.applicationInfo.Type__c == 'NTB - New to credit'){
                    debugger;
                    var hasNewLoanComaprablefacilityExceeded = $scope.hasNewLoanComaprablefacilityExceeded();
                    if(hasNewLoanComaprablefacilityExceeded)
                    return;
                    
                }
                else{
                    var hasfacilityExceeded = $scope.validateFacilityLimitAmount();
                    if(hasfacilityExceeded)
                    return;
                }
                
            }
            else{
                var hasfacilityExceeded = $scope.validateFacilityLimitAmount();
                if(hasfacilityExceeded)
                return;
            }
        }



        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan' ){
            $scope.saveData.applicationInfo.Type__c = $scope.creditScore.applicationInfo.Type__c;
            if($scope.creditScore.applicationInfo.New_to_Business__c)
            nonRunFlag = true;
        }
        if(this.flagValidation.$invalid && !nonRunFlag){
            alert('Please provide comment for each flags.');
            return;
        }

        //var saveData = new Object();



        if($scope.saveData.IsFinalAuthority){
                    $scope.preDisbursementCommentsAndComplianceList = [];

                    for(var i=0;i<$scope.listOfCommentsPreDisBM.length;i++){
                        if($scope.listOfCommentsPreDisBM[i].Terms_and_Conditions__c != ""){
                            var tandcobj = new Object();
                            tandcobj.Application__c = appId;
                            tandcobj.RecordtypeId = $scope.prerTCTypeID;
                            tandcobj.Terms_and_Conditions__c =$scope.listOfCommentsPreDisBM[i].Terms_and_Conditions__c;
                            tandcobj.Complied__c =$scope.listOfCommentsPreDisBM[i].Complied__c;
                            tandcobj.Reason__c =$scope.listOfCommentsPreDisBM[i].Reason__c;
                            tandcobj.User__c = $scope.creditScore.loggedInUser.Id;
                            $scope.preDisbursementCommentsAndComplianceList.push(tandcobj);
                        }
                    }

                    console.log($scope.preDisbursementCommentsAndComplianceList);
                    for (var key in $scope.termsAndConditions) {
                        if ($scope.termsAndConditions.hasOwnProperty(key)) {
                            console.log(key + " -> " + $scope.termsAndConditions[key]);

                            var tandcobj = new Object();
                            tandcobj.Application__c = appId;
                            tandcobj.RecordtypeId = $scope.tcRtypeId;
                            tandcobj.Terms_and_Conditions__c =$scope.termsAndConditions[key];
                            tandcobj.User__c = $scope.creditScore.loggedInUser.Id;
                            if(tandcobj.Terms_and_Conditions__c!=undefined && tandcobj.Terms_and_Conditions__c !='')
                                $scope.termsAndConditionList.push(tandcobj);
                        }
                    }

                    $scope.saveData.preDisbersementtermsAndConditions =  $scope.preDisbursementCommentsAndComplianceList;

                    //$scope.saveData.termsAndConditions =  $scope.termsAndConditionList;
        }
        if($scope.SanctionAuthorityComment != '' && $scope.SanctionAuthorityComment != undefined){
            var tandcobj = new Object();
            tandcobj.Sanction_Authority_Comment__c = $scope.SanctionAuthorityComment;
            tandcobj.Application__c = appId;
            tandcobj.RecordtypeId = $scope.sancAuthRTypeId;
            tandcobj.RecordtypeId = $scope.sancAuthRTypeId;
            tandcobj.User__c = $scope.creditScore.loggedInUser.Id;
            if(tandcobj.Sanction_Authority_Comment__c != undefined && tandcobj.Sanction_Authority_Comment__c !='')
                $scope.termsAndConditionList.push(tandcobj);
        }
        $scope.saveData.termsAndConditions =  $scope.termsAndConditionList;
        $scope.bmCommentsList = [];
        $scope.saveData.bmCommentsList=[];
        if($scope.sancProcess.isBranchRole){
            debugger;
            $scope.referback = true;
            if(Object.keys($scope.comments).length > 0){
                for (var key in $scope.comments) {
                                if ($scope.comments.hasOwnProperty(key)) {
                                    console.log(key + " -> " + $scope.comments[key]);

                                    var commentsobj = new Object();
                                    commentsobj.id = key;
                                    commentsobj.Comments__c =$scope.comments[key];
                                    $scope.bmCommentsList.push(commentsobj);
                                }
                }
            }else{
                   angular.forEach($scope.creditScore.creditScores, function(scores) {
                   debugger;

                   angular.forEach(scores.childFlags, function(valueFlags) {

                           var commentsobj = new Object();
                           commentsobj.id = valueFlags.Id;
                           commentsobj.Comments__c =valueFlags.Comments__c;
                           $scope.bmCommentsList.push(commentsobj);

                   });
                });
                console.log($scope.bmCommentsList );
            }

        }
        $scope.saveData.bmCommentsList = $scope.bmCommentsList;
        console.log('@@@@@@@@ Comment List');
        console.log($scope.saveData.bmCommentsList);
        $scope.saveData.isStageChanged= 'NO';

        
       
            /*var hasfacilityExceeded = $scope.validateFacilityLimitAmount();
            if(hasfacilityExceeded)
            return;*/
               
        var isLessThanEightyFive = $scope.validateFacilityLimitAmountByExistingLimit();
        if (isLessThanEightyFive) {
            return;
        }
        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan'){

            var hasTwoCaroreLimitExceeded = $scope.validateFacilityrecLimitByTwoCarore();
            if (hasTwoCaroreLimitExceeded) {
                        return;
            }
        }


        var hasProcessingExceeded = $scope.validateProcessingCharges();
        if (hasProcessingExceeded) {
            return;
        }
        var isBlank = false;

        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_AdHoc'){
            if($scope.sancProcess.isEmeBMReviewer && !$scope.sancProcess.isFinalAuhtority){
                if( $scope.BMNoOfDaysRecom==undefined || $scope.BMNoOfDaysRecom <1){
                    swal({title:'',text:'Please fill No of days'});
                    return;
                }else if($scope.BMNoOfDaysRecom >180 && $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_AdHoc'){
                    swal({title:'',text:'No of days for Adhoc request should not be greater than 180'});
                    return;
                }
                if($scope.saveData.facility.length > 0){
                            for(var key in $scope.saveData.facility){
                                if ($scope.saveData.facility.hasOwnProperty(key)) {
                                    if($scope.saveData.facility[key].Higher_Authority_Order__c == "1")
                                    $scope.saveData.facility[key].Recommended_Days__c = $scope.BMNoOfDaysRecom;
                                }
                            }
                }


            }
            else if($scope.sancProcess.isEmeBMReviewer && $scope.sancProcess.isFinalAuhtority &&  $scope.BMNoOfDaysRecom <1){
                 if($scope.BMNoOfDaysRecom==undefined ||   $scope.BMNoOfDaysRecom <1){
                     swal({title:'',text:'Please fill No of days'});
                     return;
                 }else if($scope.BMNoOfDaysRecom >180 && $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_AdHoc'){
                     swal({title:'',text:'No of days for Adhoc request should not be greater than 180'});
                     return;
                 }
                 if($scope.saveData.facility.length > 0){
                             for(var key in $scope.saveData.facility){
                                 if ($scope.saveData.facility.hasOwnProperty(key)) {
                                    if($scope.saveData.facility[key].Higher_Authority_Order__c == "1")
                                    $scope.saveData.facility[key].Recommended_Days__c = $scope.BMNoOfDaysRecom;
                                 }

                             }
                 }
            }


        }
        if($scope.saveData.facility.length > 0){
            for(var key in $scope.saveData.facility){
                if ($scope.saveData.facility.hasOwnProperty(key)) {
                    $scope.saveData.facility[key].Is_Save_Operation_Done__c = true;
                    if($scope.saveData.facility[key].Recommended_Limit__c == undefined || $scope.saveData.facility[key].Recommended_Limit__c == ''
                        || $scope.saveData.facility[key].Recommended_Limit__c == null){
                        isBlank = true;
                    }
                    /*new change disbale rate box before save recommendation ::: added by KISHAN. 
                    if($scope.saveData.facility[key].Recommended_Rate__c == undefined || $scope.saveData.facility[key].Recommended_Rate__c == ''
                        || $scope.saveData.facility[key].Recommended_Rate__c == null){
                        isBlank = true;
                    }*/
                    if($scope.saveData.facility[key].Recommended_Limit__c == undefined || $scope.saveData.facility[key].Recommended_Limit__c == ''
                        || $scope.saveData.facility[key].Recommended_Limit__c == null){
                        isBlank = true;
                    }
                    if(($scope.saveData.facility[key].Recommended_Processing_Charge__c == undefined || $scope.saveData.facility[key].Recommended_Processing_Charge__c == ''
                       || $scope.saveData.facility[key].Recommended_Processing_Charge__c == null) && $scope.saveData.facility[key].Recommended_Processing_Charge__c != 0){
                        isBlank = true;
                    }
                    if(($scope.saveData.facility[key].Margin__c == undefined || $scope.saveData.facility[key].Margin__c == ''
                        || $scope.saveData.facility[key].Margin__c == null) && ($scope.saveData.facility[key].Margin_Receivables__c == undefined || $scope.saveData.facility[key].Margin_Receivables__c == ''
                        || $scope.saveData.facility[key].Margin_Receivables__c == null) && ($scope.saveData.facility[key].Margin_Stock_Manufacturing__c == undefined || $scope.saveData.facility[key].Margin_Stock_Manufacturing__c == ''
                        || $scope.saveData.facility[key].Margin_Stock_Manufacturing__c == null) && ($scope.saveData.facility[key].Margin_Stock_Trading__c  == undefined || $scope.saveData.facility[key].Margin_Stock_Trading__c == ''
                        || $scope.saveData.facility[key].Margin_Stock_Trading__c == null)){
                        isBlank = true;
                    }
                }
            }
        }else{
            if(!$scope.RecommendationDone) isBlank = true;
        }
        if((!isBlank || $scope.RecommendationDone)){

            Visualforce.remoting.Manager.invokeAction(
                "Underwriting_CTRL.checkSecurityCoverage",appId ,$scope.saveData,
                function(result, event) {
                    if(result != undefined){
                        console.log(result);

                        if(result=='SUFFICIENT_COVERAGE'){
                            Visualforce.remoting.Manager.invokeAction(
                                "Underwriting_CTRL.saveUnderWrite",$scope.saveData ,
                                function(result, event) {
                                    if(result != undefined){
                                        console.log(result);
                                        if(saveorSubmit == 'SUBMIT')
                                        swal({title:'',text:result.message},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                                        else if(saveorSubmit == 'SAVE')
                                        window.location.reload();
                                        else
                                        alert('Some Error OCCURRED');
                                        //window.location.reload();

                                    }

                                },
                                {escape: false}
                            );
                        }else if(result.includes('Insufficient coverage')){
                            $scope.showLessSecurityCoveragePopup(result);
                        }
                        else{
                            swal({title:'',text:result},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                        }
                    }

                },
                {escape: false}
            );
        }else{
            if(!$scope.RecommendationDone)
                swal({title:'',text:'Please fill all recommendations correctly.'});
        }

    }

    // Added by Souvik -- 10.12.2018
	$scope.hasNewLoanComaprablefacilityExceeded = function(){
        for(var key in $scope.saveData.facility){
            if ($scope.saveData.facility.hasOwnProperty(key)) {
                if( $scope.saveData.facility[key].Recommended_Limit__c){
                    currentRecommendedValue =$scope.saveData.facility[key].Recommended_Limit__c;
                }
            }
        }
        $scope.sancProcess.mbfpValue = $scope.sancProcess.mbfpValue * 100000;
        if( $scope.sancProcess.mbfpValue < currentRecommendedValue){
            swal({title:'Limit Recommendation !!!!',text:'The maximum eligible MPBF is Rs.'+($scope.sancProcess.mbfpValue/100000)+' Lakhs.'});
            $scope.sancProcess.mbfpValue = $scope.sancProcess.mbfpValue / 100000;
            return true;
        }else{
            return false;
        }
		/*if($scope.sancProcess.newLoanComparableValue > 0){
                      swal({title:'Limit Exceeded !!!!',text:'Limit exceeded by '+$scope.sancProcess.newLoanComparableValue+' since the application is new to credit.'});
					  return true;
        }else{
            return false;
        }*/

	}

    $scope.getChangeFacility = function(item){

        debugger;
        $scope.saveFacilityObj =  $scope.checkFacilityId(item.currentTarget.getAttribute('data-id'));
        $scope.saveFacilityObj.facObj.id = item.currentTarget.getAttribute('data-id');
        $scope.saveFacilityObj.facObj.MCLR_Rate__c = item.currentTarget.getAttribute('data-mclrRate');
        $scope.saveFacilityObj.facObj.Role__c = item.currentTarget.getAttribute('data-role');
        $scope.saveFacilityObj.facObj.Facility__c = item.currentTarget.getAttribute('data-facility');
        $scope.saveFacilityObj.facObj.CL_Product__c = item.currentTarget.getAttribute('data-facilityName');
        $scope.saveFacilityObj.facObj.Product_Category__c = item.currentTarget.getAttribute('data-facilityCategory');
        $scope.saveFacilityObj.facObj.Product_Schematic__c = item.currentTarget.getAttribute('data-productType');
        $scope.saveFacilityObj.facObj.Higher_Authority_Order__c =  item.currentTarget.getAttribute('data-roleSize');
        $scope.saveFacilityObj.facObj.Type__c = item.currentTarget.getAttribute('data-facilityType');
        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan' ){
            $scope.saveFacilityObj.facObj.Takeover__c = item.currentTarget.getAttribute('data-isTakeOver');
        }

        if( item.currentTarget.getAttribute('data-apiName')=='Recommended_Limit__c'){
            console.log(item.currentTarget.value);
            console.log($scope.convertNumberToWords(item.currentTarget.value));
            document.getElementById('word').innerHTML = $scope.convertNumberToWords(item.currentTarget.value);
            $scope.saveFacilityObj.facObj.Recommended_Limit__c = item.currentTarget.value;
            $scope.saveFacilityObj.facObj.Highest_Authority__c = item.currentTarget.getAttribute('data-higherAuth');
            if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_AdHoc'){
                $scope.saveFacilityObj.facObj.Recommended_Rate__c = item.currentTarget.getAttribute('data-recomendedRate');
                $scope.saveFacilityObj.facObj.Recommended_Processing_Charge__c = item.currentTarget.getAttribute('data-processingCharge');
            }
        }
        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Enhancement'){
            $scope.saveFacilityObj.facObj.CL_Product__c = item.currentTarget.getAttribute('data-clproduct');
        }
        if( item.currentTarget.getAttribute('data-apiName')=='Margin_Stock_Trading__c'){
            $scope.saveFacilityObj.facObj.Margin_Stock_Trading__c = item.currentTarget.value;
            $scope.saveFacilityObj.facObj.Industry__c   = 'TRADING';
            if(item.currentTarget.getAttribute('data-breMarginStoTrad') != "" && item.currentTarget.getAttribute('data-breMarginStoTrad') != undefined)
                $scope.saveFacilityObj.facObj.BRE_Margin_Stock_Trading__c = item.currentTarget.getAttribute('data-breMarginStoTrad');
            else
                $scope.saveFacilityObj.facObj.BRE_Margin_Stock_Trading__c = "0";
        }
        if( item.currentTarget.getAttribute('data-apiName')=='Margin_Stock_Manufacturing__c'){
            $scope.saveFacilityObj.facObj.Margin_Stock_Manufacturing__c = item.currentTarget.value;
            $scope.saveFacilityObj.facObj.Industry__c   = 'Manufacturing';
            if(item.currentTarget.getAttribute('data-breMarginSto') != "" && item.currentTarget.getAttribute('data-breMarginSto') != undefined)
                $scope.saveFacilityObj.facObj.BRE_Margin_Stock_Manufacturing__c = item.currentTarget.getAttribute('data-breMarginSto');
            else
                $scope.saveFacilityObj.facObj.BRE_Margin_Stock_Manufacturing__c = "0";
        }
        if( item.currentTarget.getAttribute('data-apiName')=='Margin__c'){
            $scope.saveFacilityObj.facObj.Margin__c = item.currentTarget.value;
            if(item.currentTarget.getAttribute('data-breMargin') != "" && item.currentTarget.getAttribute('data-breMargin') != undefined)
                $scope.saveFacilityObj.facObj.BRE_Margin__c  = item.currentTarget.getAttribute('data-breMargin');
            else
                $scope.saveFacilityObj.facObj.BRE_Margin__c  = "0";
        }
        if( item.currentTarget.getAttribute('data-apiName')=='Margin_Receivables__c'){
            $scope.saveFacilityObj.facObj.Margin_Receivables__c = item.currentTarget.value;
            if(item.currentTarget.getAttribute('data-breMarginRec') != "" && item.currentTarget.getAttribute('data-breMarginRec') != undefined)
                $scope.saveFacilityObj.facObj.BRE_Margin_Receivables__c = item.currentTarget.getAttribute('data-breMarginRec');
            else
                $scope.saveFacilityObj.facObj.BRE_Margin_Receivables__c = "0";
        }
        if( item.currentTarget.getAttribute('data-apiName')=='Recommended_Processing_Charge__c'){
            $scope.saveFacilityObj.facObj.Recommended_Processing_Charge__c = item.currentTarget.value;
            if(item.currentTarget.getAttribute('data-breMarginProcess') != "" && item.currentTarget.getAttribute('data-breMarginProcess') != undefined)
                $scope.saveFacilityObj.facObj.BRE_Processing_Charge__c = item.currentTarget.getAttribute('data-breMarginProcess');
            else
                $scope.saveFacilityObj.facObj.BRE_Processing_Charge__c = "0";
        }
        if(item.currentTarget.getAttribute('data-apiName')=='Recommended_Rate__c'){
                    debugger;
                    $scope.saveFacilityObj.facObj.Recommended_Rate__c = item.currentTarget.value;
                    //removing BRE rate condition because it would be always same == BRE_Rate__c
                    $scope.saveFacilityObj.facObj.BRE_Rate__c =  (! isNaN(parseFloat(item.currentTarget.getAttribute('data-breRate'))) ? parseFloat(item.currentTarget.getAttribute('data-breRate')):0) ;
                    $scope.saveFacilityObj.facObj.BRE_Spread__c =  ( ! isNaN(parseFloat(item.currentTarget.getAttribute('data-breSpread')) ) ? parseFloat(item.currentTarget.getAttribute('data-breSpread')):0) ;

                    /*if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_AdHoc')
                    $scope.saveFacilityObj.facObj.BRE_Rate__c =  (parseFloat(item.currentTarget.getAttribute('data-breRate')) != undefined ? parseFloat(item.currentTarget.getAttribute('data-breRate')):0) ;
                    if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Enhancement')
                                        $scope.saveFacilityObj.facObj.Existing_Rate__c =  (parseFloat(item.currentTarget.getAttribute('data-existingVal')) != undefined  ? parseFloat(item.currentTarget.getAttribute('data-existingVal')):0);
                    *//*if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan')
                                                            $scope.saveFacilityObj.facObj.Existing_Rate__c =  (parseFloat(item.currentTarget.getAttribute('data-existingVal')) != undefined  ? parseFloat(item.currentTarget.getAttribute('data-existingVal')):0);
                    */
                    // removing Reccomended spread(Only if Bre Spread has'nt been calculated yet)
                    //otherwise removing don't remove it because it will be auto calulated by backend s formula field
                    $scope.saveFacilityObj.facObj.Recommended_Spread__c = (item.currentTarget.value - item.currentTarget.getAttribute('data-mclrRate')).toFixed(2);
                    if($scope.creditScore.facilityList[0].Is_Save_Operation_Done__c){
                        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Enhancement')
                        document.getElementById('recSpreadEnhancement').value = (item.currentTarget.value - item.currentTarget.getAttribute('data-mclrRate')).toFixed(2) ;
                        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan')
                          document.getElementById('recSpreadNewLoan').value = (item.currentTarget.value - item.currentTarget.getAttribute('data-mclrRate')).toFixed(2) ;

                        //$scope.saveFacilityObj.facObj.Recommended_Spread__c =  (parseFloat(item.currentTarget.getAttribute('data-recSpread')) != undefined ? parseFloat(item.currentTarget.getAttribute('data-recSpread')):0) ;

                    }


        }
        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Enhancement' || $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan'){
           $scope.saveFacilityObj.facObj.BRE_Spread__c =  (! isNaN(parseFloat(item.currentTarget.getAttribute('data-breSpread'))) ? parseFloat(item.currentTarget.getAttribute('data-breSpread')):0) ;

        }



        if(!$scope.saveFacilityObj.isExist){
            $scope.facilitySaveList.push($scope.saveFacilityObj.facObj);
        }

    }

    $scope.saveUnderWritingData = function(acrionPerform){
        var nonRunFlag = false;
        $scope.saveData = new Object();
        $scope.saveData.facility = $scope.facilitySaveList;
        $scope.saveData.applicationInfo = {};
        /*if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan' && $scope.sancProcess.isNewDashboardNeeded == true  && $scope.creditScore.applicationInfo.New_to_Business__c){
            nonRunFlag = true;
        }*/
        if(!$scope.creditScore.facilityList[0].Is_Save_Operation_Done__c){
            console.log('Save Operation');
            $scope.saveData.isSaveOrSubmit = 'SAVE';
        }else{
            console.log('Submit Operation');
            $scope.saveData.isSaveOrSubmit = 'SUBMIT';
        }
        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan' ){
            $scope.saveData.applicationInfo.Type__c = $scope.creditScore.applicationInfo.Type__c;
            if($scope.creditScore.applicationInfo.New_to_Business__c)
            nonRunFlag = true;
        }
        if(this.flagValidation.$invalid && !nonRunFlag){
            alert('Please provide comment for each flags.');
            return;
        }

        // Added by Souvik -- 10.12.2018
        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan'){
            if( $scope.sancProcess.isFinalAuhtority && ($scope.creditScore.applicationInfo.New_to_Business__c || $scope.creditScore.applicationInfo.Type__c == 'ETB-CA - New to credit' || $scope.creditScore.applicationInfo.Type__c == 'NTB - New to credit')){
            		var hasNewLoanComaprablefacilityExceeded = $scope.hasNewLoanComaprablefacilityExceeded();
                    if(hasNewLoanComaprablefacilityExceeded)
                    return; 
            }
            else if($scope.sancProcess.isFinalAuhtority){
                var hasfacilityExceeded = $scope.validateFacilityLimitAmount();
                if(hasfacilityExceeded)
                return;
            }
            
        }
        /*if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan' ){
            if($scope.sancProcess.isFinalAuhtority){
                var hasfacilityExceeded = $scope.validateFacilityLimitAmount();
                if(hasfacilityExceeded)
                return;
            }
        }*/

        var hasProcessingExceeded = $scope.validateProcessingCharges();
        if (hasProcessingExceeded) {
            return;
        }

        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan'){

            var hasTwoCaroreLimitExceeded = $scope.validateFacilityrecLimitByTwoCarore();
            if (hasTwoCaroreLimitExceeded) {
                        return;
            }
        }


        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan' ){
            var isReccomendedMarginLessThanExisting = $scope.validateMarginForNewLoanApplication();
            if (isReccomendedMarginLessThanExisting) {
                return;
            }
            /*var hasfacilityExceeded = $scope.validateFacilityLimitAmountByExistingLimit();
            if (hasfacilityExceeded) {
                return;
            }*/
        }
        var isLessThanEightyFive = $scope.validateFacilityLimitAmountByExistingLimit();
        if (isLessThanEightyFive) {
            return;
        }
        $scope.saveData.appId = appId;
        $scope.saveData.IsFinalAuthority = $scope.sancProcess.isFinalAuhtority;
        $scope.saveData.isReadOnly = $scope.sancProcess.isReadOnly;
        //Wrapper build for comments
        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_AdHoc'){

            if(! $scope.sancProcess.isEmeBMReviewer && $scope.sancProcess.isFinalAuhtority ){
                  if($scope.HigherAuthNoOfDaysRecom==undefined ||   $scope.HigherAuthNoOfDaysRecom <1){
                      swal({title:'',text:'Please fill No of days'});
                      return;
                  }else if($scope.HigherAuthNoOfDaysRecom >180 && $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_AdHoc'){
                      swal({title:'',text:'No of  days for Adhoc request should not be greater than 180'});
                      return;
                  }
                  if($scope.saveData.facility.length > 0){
                           for(var key in $scope.saveData.facility){
                               if ($scope.saveData.facility.hasOwnProperty(key)) {
                                    if($scope.saveData.facility[key].Highest_Authority__c)
                                    $scope.saveData.facility[key].Recommended_Days__c = $scope.HigherAuthNoOfDaysRecom;

                               }
                           }
                  }
            }

        }
        if($scope.sancProcess.isBranchRole){
            $scope.referback = true;
            for (var key in $scope.comments) {
                if ($scope.comments.hasOwnProperty(key)) {
                    console.log(key + " -> " + $scope.comments[key]);

                    var commentsobj = new Object();
                    commentsobj.id = key;
                    commentsobj.Comments__c =$scope.comments[key];
                    $scope.bmCommentsList.push(commentsobj);
                }
            }
        }
        debugger;
        $scope.preDisbursementCommentsAndComplianceList = [];
        for (var key in $scope.preDisbursementCommentsAndCompliance){
            if ($scope.preDisbursementCommentsAndCompliance.hasOwnProperty(key)) {
                if($scope.preDisbursementCommentsAndCompliance[key] != ""){
                    console.log(key + " -> " + $scope.preDisbursementCommentsAndCompliance[key]);

                    var tandcobj = new Object();
                    tandcobj.Application__c = appId;
                    tandcobj.RecordtypeId = $scope.prerTCTypeID;
                    tandcobj.Terms_and_Conditions__c =$scope.preDisbursementCommentsAndCompliance[key];
                    tandcobj.User__c = $scope.creditScore.loggedInUser.Id;
                    $scope.preDisbursementCommentsAndComplianceList.push(tandcobj);
                }

            }
        }

        console.log($scope.preDisbursementCommentsAndComplianceList);
        for (var key in $scope.termsAndConditions) {
            if ($scope.termsAndConditions.hasOwnProperty(key)) {
                console.log(key + " -> " + $scope.termsAndConditions[key]);

                var tandcobj = new Object();
                tandcobj.Application__c = appId;
                tandcobj.RecordtypeId = $scope.tcRtypeId;
                tandcobj.Terms_and_Conditions__c =$scope.termsAndConditions[key];
                tandcobj.User__c = $scope.creditScore.loggedInUser.Id;
                if(tandcobj.Terms_and_Conditions__c!=undefined && tandcobj.Terms_and_Conditions__c !='')
                    $scope.termsAndConditionList.push(tandcobj);
            }
        }

        $scope.saveData.bmCommentsList = $scope.bmCommentsList;

        if($scope.SanctionAuthorityComment != '' && $scope.SanctionAuthorityComment != undefined){
            var tandcobj = new Object();
            tandcobj.Sanction_Authority_Comment__c = $scope.SanctionAuthorityComment;
            tandcobj.Application__c = appId;
            tandcobj.RecordtypeId = $scope.sancAuthRTypeId;
            tandcobj.RecordtypeId = $scope.sancAuthRTypeId;
            tandcobj.User__c = $scope.creditScore.loggedInUser.Id;
            if(tandcobj.Sanction_Authority_Comment__c != undefined && tandcobj.Sanction_Authority_Comment__c !='')
                $scope.termsAndConditionList.push(tandcobj);
        }
        $scope.saveData.preDisbersementtermsAndConditions =  $scope.preDisbursementCommentsAndComplianceList;

        $scope.saveData.termsAndConditions =  $scope.termsAndConditionList;
        $scope.saveData.actionPerformed = acrionPerform;
        debugger;
        $scope.isredirect = acrionPerform;


        var isBlank = false;
        if($scope.saveData.facility.length > 0){
            for(var key in $scope.saveData.facility){
                if ($scope.saveData.facility.hasOwnProperty(key)) {
                    $scope.saveData.facility[key].Is_Save_Operation_Done__c = true;
                    if($scope.saveData.facility[key].Recommended_Limit__c == undefined || $scope.saveData.facility[key].Recommended_Limit__c == ''
                       || $scope.saveData.facility[key].Recommended_Limit__c == null){
                        isBlank = true;
                    }
                    if($scope.saveData.facility[key].Recommended_Rate__c == undefined || $scope.saveData.facility[key].Recommended_Rate__c == ''
                       || $scope.saveData.facility[key].Recommended_Rate__c == null){
                        isBlank = true;
                    }
                    if($scope.saveData.facility[key].Recommended_Limit__c == undefined || $scope.saveData.facility[key].Recommended_Limit__c == ''
                       || $scope.saveData.facility[key].Recommended_Limit__c == null){
                        isBlank = true;
                    }
                    if(($scope.saveData.facility[key].Recommended_Processing_Charge__c == undefined || $scope.saveData.facility[key].Recommended_Processing_Charge__c == ''
                       || $scope.saveData.facility[key].Recommended_Processing_Charge__c == null) && $scope.saveData.facility[key].Recommended_Processing_Charge__c != 0){
                        isBlank = true;
                    }
                    if(($scope.saveData.facility[key].Margin__c == undefined || $scope.saveData.facility[key].Margin__c == ''
                       || $scope.saveData.facility[key].Margin__c == null) && ($scope.saveData.facility[key].Margin_Receivables__c == undefined || $scope.saveData.facility[key].Margin_Receivables__c == ''
                       || $scope.saveData.facility[key].Margin_Receivables__c == null) && ($scope.saveData.facility[key].Margin_Stock_Manufacturing__c == undefined || $scope.saveData.facility[key].Margin_Stock_Manufacturing__c == ''
                       || $scope.saveData.facility[key].Margin_Stock_Manufacturing__c == null) && ($scope.saveData.facility[key].Margin_Stock_Trading__c  == undefined || $scope.saveData.facility[key].Margin_Stock_Trading__c == ''
                       || $scope.saveData.facility[key].Margin_Stock_Trading__c == null)){
                        isBlank = true;
                    }
                }
            }
        }else{
            if(!$scope.RecommendationDone) isBlank = true;
        }
        if((!isBlank || $scope.RecommendationDone)){
            Visualforce.remoting.Manager.invokeAction(
                "Underwriting_CTRL.saveUnderWrite",$scope.saveData ,
                function(result, event) {
                    if(result != undefined){
                        console.log(result);
                        swal({title:'',text:result.message},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                    }
                },
                {escape: false} // No escaping, please
            );
        }else{
            //$scope.isErrorsanction  = true;
            if(!$scope.RecommendationDone)
                swal({title:'',text:'Please fill all recommendations correctly.'});
        }
    }
    $scope.refferBack = function(){
        debugger;
        $scope.saveData ={};
        $scope.termsAndConditionList=[];
        if($scope.SanctionAuthorityComment != '' && $scope.SanctionAuthorityComment != undefined){
            var tandcobj = new Object();
            tandcobj.Sanction_Authority_Comment__c = 'Reffered Back Comment - '+$scope.SanctionAuthorityComment;
            tandcobj.Application__c = appId;
            tandcobj.RecordtypeId = $scope.sancAuthRTypeId;
            tandcobj.RecordtypeId = $scope.sancAuthRTypeId;
            tandcobj.User__c = $scope.creditScore.loggedInUser.Id;
            if(tandcobj.Sanction_Authority_Comment__c != undefined && tandcobj.Sanction_Authority_Comment__c !='')
                $scope.termsAndConditionList.push(tandcobj);
        }
        $scope.saveData.termsAndConditions =  $scope.termsAndConditionList;
        $scope.saveData.appId = appId;
        //$scope.saveCommentBtmAfterRefferBack();
        Visualforce.remoting.Manager.invokeAction(
            "Underwriting_CTRL.createTaskForPreviousAuthority",$scope.saveData,
            function(result, event) {

                if(result != undefined){
                    console.log(result);
                    swal({title:'',text:result},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                }

            },
            {escape: false} // No escaping, please
        );
    }
    $scope.updatePreDisbersementComments = function(){
        if($scope.sancProcess.isOwner) {
            debugger;
            $scope.preDisbursementCommentsAndComplianceList = [];
            console.log($scope.creditScore.preDisbursementComments);
            for (var key in $scope.creditScore.preDisbursementComments) {
                if ($scope.creditScore.preDisbursementComments.hasOwnProperty(key)) {
                    console.log(key + " -> " + $scope.creditScore.preDisbursementComments[key]);

                    var tandcobj = new Object();
                    tandcobj.Id = $scope.creditScore.preDisbursementComments[key].Id;

                    tandcobj.Complied__c = $scope.creditScore.preDisbursementComments[key].Complied__c;
                    tandcobj.Reason__c = $scope.creditScore.preDisbursementComments[key].Reason__c;

                    $scope.preDisbursementCommentsAndComplianceList.push(tandcobj);
                }

            }
            Visualforce.remoting.Manager.invokeAction(
                "Underwriting_CTRL.savePreDisbursementComments",$scope.preDisbursementCommentsAndComplianceList ,appId,
                function(result, event) {

                    if(result != undefined){
                        console.log(result);
                        swal({title:'',text:result},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                    }

                },
                {escape: false} // No escaping, please
            );

        }

    }


    $scope.showPendingRenewal = function(){
        $scope.obj.showPRA = !$scope.obj.showPRA;
    }

    $scope.disableAllFun = function(){
        if($scope.sancProcess.isApplnReadOnly){
            $scope.disableAll       = true;
            $scope.facilityFIeldSet = true;
            $scope.commentsFieldset = true;
            $scope.isRHA            = false;
            $scope.btnFields        = true;
            $scope.isApproved       = false
        }else if( $scope.sancProcess.isReadOnly && !$scope.sancProcess.isDeviationApprover
                 && !$scope.sancProcess.isSanctionApproval){
            $scope.disableAll = true;
            $scope.facilityFIeldSet = true;
            $scope.commentsFieldset = true;
            $scope.disableAllshow   = true;
            $scope.btnFields        = true;
            $scope.isRHA            = false;
            $scope.isApproved       = false;
        }else if($scope.sancProcess.isSanctionApproval){
            console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2');
            $scope.disableAll           = true;
            $scope.facilityFIeldSet     = true;
            $scope.disableAllshow       = false;
            $scope.commentsFieldset     = true;
            $scope.btnFields            = true;
            $scope.onlyAppRej           = true;
            $scope.isApproved           = false;
            $scope.showReviewCommt      = true;
        }else if($scope.sancProcess.isDeviationApprover){
            $scope.disableAll       = true;
            $scope.facilityFIeldSet = true;
            $scope.disableAllshow   = false;
            $scope.commentsFieldset = true;
            $scope.btnFields        = true;
            $scope.onlyAppRej       = true;
            $scope.isApproved       = false;
            $scope.showReviewCommt  = true;
        }else if($scope.sancProcess.isFinalAuhtority){
            $scope.disableAll = true;
            $scope.onLoadRBCheck = true;
            $scope.onLoadisHRACheck = true;
            $scope.showReviewCommt  = true;
        }else if( $scope.sancProcess.isPartOfHierarchy ){
            $scope.disableAll           = true;
            $scope.commentsFieldset     = true;
            $scope.onLoadRBCheck        = true  ;
            $scope.onLoadApproveCheck   = true;
            $scope.onLoadMARCheck       = true;
            $scope.onLoadisHRACheck     = true;
            $scope.isRHA                = true;
            $scope.isApproved           = false
        }else if( $scope.sancProcess.isBranchRole ){
            $scope.disableAll           = true;
            $scope.commentsFieldset = true;
            $scope.onLoadRBCheck        = true  ;
            $scope.onLoadApproveCheck   = true;
            $scope.onLoadisHRACheck = false;
            $scope.isRHA = false;
            $scope.showReviewCommt  = true;
        }else if(!$scope.sancProcess.isSanctionApproval || !$scope.sancProcess.isReadOnly  || !$scope.sancProcess.isFinalAuhtority ){
            console.log('@@@@@ 702');
            $scope.disableAll = true;
            $scope.facilityFIeldSet = true;
            $scope.btnFields = true;
            $scope.commentsFieldset = true;
            $scope.isRHA = false;
            $scope.isApproved       = false;
        }
        if($scope.sancProcess.isPreDisbersementOpenTaskExist && $scope.sancProcess.isPreDisbersementCountExcceded){
            console.log('Approve');
            $scope.isApproved = true;
        }
        if($scope.sancProcess.isPreDisbersementEnabled == false && $scope.sancProcess.isOwner){
             $scope.commentsFieldset = false;
        }
        if($scope.sancProcess.isConditionRejected){
            $scope.commentsFieldset = false;
        }
        if($scope.sancProcess.isLimitEditable){
            $scope.facilityFIeldSet = false;
        }
    }
    if($scope.riskUser){

        $scope.disableAll = true;
    }
    else{
        $scope.isriskUser = false;
    }

    $scope.disableAllFun();

    $scope.saveCommentBtm = function(){
        Visualforce.remoting.Manager.invokeAction(
            "Underwriting_CTRL.otherAuthoritySubmit",$scope.creditScore.applicationInfo.Id,$scope.commentNotRec ,
            function(result, event) {

                if(result != undefined){
                    console.log(result);
                    swal({title:'',text:result.message},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                }
            },
            {escape: false} // No escaping, please
        );
    }
    $scope.saveCommentBtmAfterRefferBack = function(){
            Visualforce.remoting.Manager.invokeAction(
                "Underwriting_CTRL.otherAuthorityReferBack",$scope.creditScore.applicationInfo.Id,$scope.commentNotRec ,
                function(result, event) {

                    if(result != undefined){
                        console.log(result);
                        swal({title:'',text:result},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                    }
                },
                {escape: false} // No escaping, please
            );
        }

    $scope.onlyApproveRej = function(actionPerfomred){

        debugger;
        console.log('comments');
        console.log($scope.termsAndConditions);

        // Added by Souvik -- 10.12.2018
        if($scope.creditScore.applicationInfo.RecordType.DeveloperName =='SME_NEW_Loan' && ($scope.creditScore.applicationInfo.New_to_Business__c || $scope.creditScore.applicationInfo.Type__c == 'ETB-CA - New to credit' || $scope.creditScore.applicationInfo.Type__c == 'NTB - New to credit')){
            var hasNewLoanComaprablefacilityExceeded = $scope.hasNewLoanComaprablefacilityExceeded();
            if(hasNewLoanComaprablefacilityExceeded)
            return;           
        }

        $scope.termsAndConditionList = [];
        for (var key in $scope.termsAndConditions) {
            if ($scope.termsAndConditions.hasOwnProperty(key)) {
                if($scope.termsAndConditions[key] != ''){
                    console.log(key + " -> " + $scope.termsAndConditions[key]);

                    var tandcobj = new Object();
                    tandcobj.Application__c = appId;
                    tandcobj.RecordtypeId = $scope.tcRtypeId;
                    tandcobj.Terms_and_Conditions__c =$scope.termsAndConditions[key];
                    tandcobj.User__c = $scope.creditScore.loggedInUser.Id;
                    if(tandcobj.Terms_and_Conditions__c!=undefined && tandcobj.Terms_and_Conditions__c !='')
                        $scope.termsAndConditionList.push(tandcobj);
                }

            }
        }

        var tandcobj = new Object();
        if($scope.SanctionAuthorityComment != '' && $scope.SanctionAuthorityComment != undefined){
            tandcobj.Sanction_Authority_Comment__c = $scope.SanctionAuthorityComment;
            tandcobj.Application__c = appId;
            tandcobj.RecordtypeId = $scope.sancAuthRTypeId;
            tandcobj.User__c = $scope.creditScore.loggedInUser.Id;
        }

         Visualforce.remoting.Manager.invokeAction(
               "Underwriting_CTRL.updatedeviationApproverTermsAndCondition",appId,$scope.termsAndConditionList,
               function(result, event) {

                   if(result != undefined){
                       console.log(result);
                       //swal({title:'',text:result});
                       if(result=='Terms and Conditions have been Updated.')
                           console.log(result);
                   }

               },
               {escape: false}
            );

        Visualforce.remoting.Manager.invokeAction(
            "Underwriting_CTRL.sanctionApprovalSubmit",$scope.creditScore.applicationInfo.Id,actionPerfomred,$scope.sancProcess,tandcobj,
            function(result, event) {
                if(result != undefined){
                    console.log(result);
                    swal({title:'',text:result.message},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                }
            },
            {escape: false} // No escaping, please
        );
    }


    $scope.rejectExceedingAdhoc = function(){
        Visualforce.remoting.Manager.invokeAction(
            "Underwriting_CTRL.rejectExceedingAdhoc",appId,
            function(result, event) {

                if(result != undefined){
                    console.log(result);
                    swal({title:'',text:result},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                }

            },
            {escape: false} // No escaping, please
        );
    }
    $scope.rejectEnhancement = function(){

        Visualforce.remoting.Manager.invokeAction(
            "Underwriting_CTRL.rejectEnhancement",appId,
            function(result, event) {

                if(result != undefined){
                    console.log(result);
                    swal({title:'',text:result},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                }

            },
            {escape: false} // No escaping, please
        );
    }

    //New Loan Application Rejected Scenerio
    $scope.rejectNewLoan = function(){

        Visualforce.remoting.Manager.invokeAction(
            "Underwriting_CTRL.rejectNewLoan",appId,
            function(result, event) {

                if(result != undefined){
                    console.log(result);
                    swal({title:'',text:result},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                }

            },
            {escape: false} // No escaping, please
        );
    }

    
    $scope.rejecthelper = function(){
        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_AdHoc'){
            $scope.rejectExceedingAdhoc();
        }else if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Enhancement'){
            $scope.rejectEnhancement();
        }else if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_NEW_Loan'){
            $scope.rejectNewLoan();
        }
    }
    $scope.showLessSecurityCoveragePopup = function(message){
        swal({
          title: message,
          text: "Do you still want to proceed ?",
          type: "warning",
          showCancelButton: true,
          confirmButtonClass: "btn-danger",
          confirmButtonText: "Ask For Additional collateral",
          cancelButtonText: "Proceed",
          closeOnConfirm: false,
          closeOnCancel: true
        },
        function(isConfirm) {
          if (isConfirm) {

            $scope.changeAppStageToInsufficientColl();
          } else {

             //alert('Proceeding');
             $scope.BMEditable = true;
             $scope.$apply();
          }
        });
    }
    $scope.getLimitAfterNegatingTermLoanExpo = function(){
        debugger;
        var termLoanExpo = $scope.creditScore.termLoanExposure;
        console.log('termLoanExpo');
        console.log(termLoanExpo);
        var limitAmount = 0;
        for(var key in $scope.creditScore.roleWiseLimitAmount){
            if(key == $scope.creditScore.loggedInUser.Designation__c)
            limitAmount =$scope.creditScore.roleWiseLimitAmount[key];
        }
        console.log('termLoanExpo');
        console.log(limitAmount);
        return limitAmount - termLoanExpo;

    }
    $scope.validateFacilityLimitAmount = function(){
        var recommendedLimitAggregate = 0;
        for(var key in $scope.saveData.facility){
            if ($scope.saveData.facility.hasOwnProperty(key)) {
                      recommendedLimitAggregate += parseInt($scope.saveData.facility[key].Recommended_Limit__c);
            }
        }

        if(recommendedLimitAggregate > $scope.getLimitAfterNegatingTermLoanExpo()){
            var exAmnt= recommendedLimitAggregate - $scope.getLimitAfterNegatingTermLoanExpo();
            swal({title:'Limit Exceeded !!!!',text:'You have exceeded your recommended limit of Rs. '+exAmnt});
            return true;
        }else{
            return false;
        }

    }
    $scope.validateProcessingCharges = function(){
        if($scope.saveData.facility.length > 0){
            for(var key in $scope.saveData.facility){

                if ($scope.saveData.facility.hasOwnProperty(key)) {
                    if($scope.saveData.facility[key].Recommended_Processing_Charge__c != undefined && $scope.saveData.facility[key].Recommended_Processing_Charge__c >1){
                        swal({title:'Processing Charge Exceeded !!!!',text:'Processing Charge can not exceed more than 1 %'});
                        return true;
                    }
                }
            }
        }
        return false;
    }
    $scope.validateMarginForNewLoanApplication = function(){
        if($scope.saveData.facility.length > 0){
            for(var key in $scope.saveData.facility){

                if ($scope.saveData.facility.hasOwnProperty(key)) {
                    if($scope.saveData.facility[key].Takeover__c == true && $scope.saveData.facility[key].Margin_Receivables__c != undefined &&  $scope.saveData.facility[key].Margin_Receivables__c <$scope.saveData.facility[key].Existing_Margin_Receivables__c){
                        swal({title:'Reccomended Margin is less !!!!',text:'Reccomended Margin should not be less than Existing Margin'});
                        return true;
                    }
                    if($scope.saveData.facility[key].Takeover__c == true && $scope.saveData.facility[key].Margin__c != undefined &&  $scope.saveData.facility[key].Margin__c <$scope.saveData.facility[key].Approved_Margin__c){
                        swal({title:'Reccomended Margin is less !!!!',text:'Reccomended Margin should not be less than Existing Margin'});
                        return true;
                    }
                    if($scope.saveData.facility[key].Takeover__c == true && $scope.saveData.facility[key].Margin_Stock_Trading__c != undefined &&  $scope.saveData.facility[key].Margin_Stock_Trading__c <$scope.saveData.facility[key].Existing_Margin_Stock_Trading__c){
                        swal({title:'Reccomended Margin is less !!!!',text:'Reccomended Margin should not be less than Existing Margin'});
                        return true;
                    }
                    if($scope.saveData.facility[key].Takeover__c == true && $scope.saveData.facility[key].Margin_Stock_Manufacturing__c != undefined &&  $scope.saveData.facility[key].Margin_Stock_Manufacturing__c <$scope.saveData.facility[key].Existing_Margin_Stock_Manufacturing__c){
                        swal({title:'Reccomended Margin is less !!!!',text:'Reccomended Margin should not be less than Existing Margin'});
                        return true;
                    }

                }
            }
        }
        return false;
    }
    $scope.updateSpecialTermsAndCondition = function(){
           debugger;
           $scope.termsAndConditionList = [];
           for (var key in $scope.termsAndConditions) {
               if ($scope.termsAndConditions.hasOwnProperty(key)) {
                   console.log(key + " -> " + $scope.termsAndConditions[key]);

                   var tandcobj = new Object();
                   tandcobj.Application__c = appId;
                   tandcobj.RecordtypeId = $scope.tcRtypeId;
                   tandcobj.Terms_and_Conditions__c =$scope.termsAndConditions[key];
                   tandcobj.User__c = $scope.creditScore.loggedInUser.Id;
                   if(tandcobj.Terms_and_Conditions__c!=undefined && tandcobj.Terms_and_Conditions__c !='')
                       $scope.termsAndConditionList.push(tandcobj);
               }
           }

           Visualforce.remoting.Manager.invokeAction(
               "Underwriting_CTRL.updateFinalAuthTermsAndCondition",appId,$scope.termsAndConditionList,
               function(result, event) {

                   if(result != undefined){
                       console.log(result);
                       swal({title:'',text:result},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                   }

               },
               {escape: false}
           );

    }
    $scope.updateLimitAmount = function(){
        $scope.saveData ={};
        $scope.saveData.actionPerformed = 'LIMIT_UPDATION';
        $scope.saveData.appId = appId;
        $scope.saveData.applicationInfo = {};
        $scope.saveData.applicationInfo.Id = appId;

        $scope.saveData.facility = $scope.facilitySaveList;

        var LimitExceeded = $scope.validateLimitAmount();
        if(LimitExceeded)
        return;
        Visualforce.remoting.Manager.invokeAction(
            "Underwriting_CTRL.saveUnderWrite",$scope.saveData,
            function(result, event) {
                if(result != undefined){
                    console.log(result);
                    swal({title:'',text:result.message},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});


                }

            },
            {escape: false}
        );
    }
    $scope.validateLimitAmount = function(){
          debugger;
          for(var j = 0;j<$scope.saveData.facility.length;i++){
              for(var i=0;i<$scope.creditScore.facilityList.length;i++){
                    return $scope.validateLimitAmountHelper($scope.saveData.facility[j],$scope.creditScore.facilityList[i]);
              }
          }
          return false;

    }
    $scope.validateLimitAmountHelper = function(childFacility,ParentFacility){
        debugger;
        var HighAuthRec = {};
        var facilityFoundInParent = false;
        if(ParentFacility.Facilities__r != undefined){
            for(var i=0;i<ParentFacility.Facilities__r.records.length;i++){
                if(childFacility.id == ParentFacility.Facilities__r.records[i].Id)
                facilityFoundInParent = true;
                if(ParentFacility.Facilities__r.records[i].Highest_Authority__c)
                HighAuthRec = ParentFacility.Facilities__r.records[i];
            }
        }
        if(facilityFoundInParent){
            if(childFacility.Recommended_Limit__c > HighAuthRec.Recommended_Limit__c){
                swal({title:'Limit Exceeded',text:'Limit Amount is more than Approved by Final Authority'});
                return true;

            }
        }
        return false;

    }
    $scope.saveProfileDataForNewSourcing = function(){
        debugger;
        var createObj = new Object();
        createObj.Id = appId;

        createObj.Company_Profile__c = $scope.creditScore.applicationInfo.Company_Profile__c;
        createObj.Key_Management_Profile__c = $scope.creditScore.applicationInfo.Key_Management_Profile__c;
        createObj.Beuro_Profile__c = $scope.creditScore.applicationInfo.Beuro_Profile__c;
        createObj.Market_Profile__c = $scope.creditScore.applicationInfo.Market_Profile__c;

        console.log('createObj');
        console.log(createObj);
        Visualforce.remoting.Manager.invokeAction(
            "Underwriting_CTRL.saveProfileDataForNewSourcing",createObj,
            function(result, event) {
                if(result != undefined){
                    console.log(result);
                    swal({title:'',text:result},function(isConfirm) {window.location.href    = '/apex/UnderwritingDashboard_EAE?id='+$scope.creditScore.applicationInfo.Id;});

                }

            },
            {escape: false}
        );
    }
    $scope.validateFacilityLimitAmountByExistingLimit = function(){
            for(var key in $scope.saveData.facility){
                for(var i=0;i<$scope.creditScore.facilityList.length;i++) {

                    if ($scope.creditScore.facilityList[i].Facilities__r != undefined) {

                       // for (var j = 0; j < $scope.creditScore.facilityList[i].Facilities__r.records.length; j++) {
                            if($scope.saveData.facility[key].Facility__c == $scope.creditScore.facilityList[i].Id ){
                                /*if($scope.creditScore.facilityList[i].Existing_Limit__c == undefined *//*&& $scope.saveData.facility[key].Recommended_Limit__c!=''*//*){
//                                    *//*swal({title:'Limit Exceeded !!!!',text:'Recommended Limit can not exceed Exiting Limit'});
//                                    return true;*//*
                                }else if( $scope.saveData.facility[key].Recommended_Limit__c > $scope.creditScore.facilityList[i].Existing_Limit__c){
                                    swal({title:'Limit Exceeded !!!!',text:'Recommended Limit can not exceed Exiting Limit'});
                                                                        return true;
                                }*/
                                if( $scope.saveData.facility[key].Recommended_Limit__c < ($scope.creditScore.facilityList[i].New_Limit_Amount__c * 85)/100 ){
                                    /*swal({title:'Limit Error !!!!',text:'Recommended Limit is very less'});
                                    return true;*/
                                    if ($window.confirm("Recommended Limit is very less ? Do you still want to proceed")) {
                                        return false;
                                    } else {
                                        return true;
                                    }
                                }

                                /*else{
                                    return false;
                                }*/

                            }

                        }
                    //}
                }


            }
            return false;
    }
    $scope.validateFacilityrecLimitByTwoCarore = function(){
            for(var key in $scope.saveData.facility){
                if ($scope.saveData.facility.hasOwnProperty(key)) {
                   if( $scope.saveData.facility[key].Recommended_Limit__c > 20000000){
                     swal({title:'Limit Exceeded !!!!',text:'Recommended Limit can not exceed 2 carore limit'});
                     return true;
                   }
                }

            }
            return false;
    }


    /*//Added by Souvik -- 10.12.2018
    $scope.validateFacilityLimitAmountForNewToCredit = function(){
		 debugger;
         Visualforce.remoting.Manager.invokeAction(
            "Underwriting_CTRL_Helper.getFinalAuthorityRecommedationForNewToCreditType",$scope.creditScore.applicationInfo.Id,$scope.facilitySaveList,
            function(result,event){
                debugger;
                if(result != undefined && result > 0){
                    console.log('---> resp from getFinalAuthorityRecommedationForNewToCreditType'+result);
                    swal({title:'Limit Exceeded !!!!',text:'Limit exceeded by '+result+' since the application is new to credit.'});
                    return true;
                }else{
                    return false;
                }
            },
            {escape: false}
        );                
    }
    ///////////////////// Completed /////////////////*/



    $scope.convertNumberToWords = function (amount) {
        var words = new Array();
        words[0] = '';
        words[1] = 'One';
        words[2] = 'Two';
        words[3] = 'Three';
        words[4] = 'Four';
        words[5] = 'Five';
        words[6] = 'Six';
        words[7] = 'Seven';
        words[8] = 'Eight';
        words[9] = 'Nine';
        words[10] = 'Ten';
        words[11] = 'Eleven';
        words[12] = 'Twelve';
        words[13] = 'Thirteen';
        words[14] = 'Fourteen';
        words[15] = 'Fifteen';
        words[16] = 'Sixteen';
        words[17] = 'Seventeen';
        words[18] = 'Eighteen';
        words[19] = 'Nineteen';
        words[20] = 'Twenty';
        words[30] = 'Thirty';
        words[40] = 'Forty';
        words[50] = 'Fifty';
        words[60] = 'Sixty';
        words[70] = 'Seventy';
        words[80] = 'Eighty';
        words[90] = 'Ninety';
        amount = amount.toString();
        var atemp = amount.split(".");
        var number = atemp[0].split(",").join("");
        var n_length = number.length;
        var words_string = "";
        if (n_length <= 9) {
            var n_array = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0);
            var received_n_array = new Array();
            for (var i = 0; i < n_length; i++) {
                received_n_array[i] = number.substr(i, 1);
            }
            for (var i = 9 - n_length, j = 0; i < 9; i++, j++) {
                n_array[i] = received_n_array[j];
            }
            for (var i = 0, j = 1; i < 9; i++, j++) {
                if (i == 0 || i == 2 || i == 4 || i == 7) {
                    if (n_array[i] == 1) {
                        n_array[j] = 10 + parseInt(n_array[j]);
                        n_array[i] = 0;
                    }
                }
            }
            value = "";
            for (var i = 0; i < 9; i++) {
                if (i == 0 || i == 2 || i == 4 || i == 7) {
                    value = n_array[i] * 10;
                } else {
                    value = n_array[i];
                }
                if (value != 0) {
                    words_string += words[value] + " ";
                }
                if ((i == 1 && value != 0) || (i == 0 && value != 0 && n_array[i + 1] == 0)) {
                    words_string += "Crores ";
                }
                if ((i == 3 && value != 0) || (i == 2 && value != 0 && n_array[i + 1] == 0)) {
                    words_string += "Lakhs ";
                }
                if ((i == 5 && value != 0) || (i == 4 && value != 0 && n_array[i + 1] == 0)) {
                    words_string += "Thousand ";
                }
                if (i == 6 && value != 0 && (n_array[i + 1] != 0 && n_array[i + 2] != 0)) {
                    words_string += "Hundred and ";
                } else if (i == 6 && value != 0) {
                    words_string += "Hundred ";
                }
            }
            words_string = words_string.split("  ").join(" ");
        }
        console.log('@@@@@@@');
        console.log(words_string);
        return words_string;
    }

})