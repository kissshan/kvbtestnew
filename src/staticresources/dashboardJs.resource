var app=angular.module('dashboadrdApp', ['ngRoute','ngAnimate','ngScrollable']);

app.controller('dashboadrdCtrl', function($scope, $timeout, $window, $location ) {
    $scope.show =[];
    $scope.isFlags = [];
    $scope.showExposure =false;
    //$scope.riskUser = riskUser;
    $scope.riskUser = riskUser;
    $scope.isriskUser = true;
    $scope.isApproved = true;
    $scope.listOfComments =[];
    $scope.listOfComments.length=1;
    console.log('@@@@@@@@@@@@@@@');
    $scope.creditScore =creditScore;
    console.log($scope.creditScore);
    $scope.obj = new Object();
    $scope.sancProcess = JSON.parse(sancProcess);
    console.log($scope.sancProcess);
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
    $scope.applicationId = appId;
    $scope.locationURL = window.location.origin;
    $scope.isRole = false;
    $scope.BMNoOfDaysRecom = 0;
    $scope.BMRole = '';
    $scope.HigherAuthRole = '';
    $scope.HigherAuthNoOfDaysRecom = 0;

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
    for(var key in $scope.creditScore.facilityList){
         if ($scope.creditScore.facilityList.hasOwnProperty(key)) {
            $scope.creditScore.facilityList[key].MCLR_Rate__c = $scope.creditScore.mclrRate;
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

    if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
        for(var key in $scope.creditScore.facilityList){
            debugger;
            if(key=='0'){
                if($scope.creditScore.facilityList[0].Facilities__r != undefined)
                for(var j=0;j<$scope.creditScore.facilityList[0].Facilities__r.records.length;j++){

                    if($scope.creditScore.facilityList[key].Facilities__r.records[j].Higher_Authority_Order__c==1){
                        $scope.BMRole = $scope.creditScore.facilityList[key].Facilities__r.records[j].Role__c;
                        if($scope.creditScore.facilityList[key].Facilities__r.records[j].Recommended_Days__c!= null)
                        $scope.BMNoOfDaysRecom = $scope.creditScore.facilityList[key].Facilities__r.records[j].Recommended_Days__c;
						$scope.HigherAuthNoOfDaysRecom = $scope.BMNoOfDaysRecom;

                    }else if($scope.creditScore.facilityList[key].Facilities__r.records[j].Higher_Authority_Order__c==2){
                        $scope.HigherAuthRole = $scope.creditScore.facilityList[key].Facilities__r.records[j].Role__c;
                        /*if($scope.creditScore.facilityList[key].Facilities__r.records[j].Recommended_Days__c!= null)
                        $scope.HigherAuthNoOfDaysRecom = $scope.creditScore.facilityList[key].Facilities__r.records[j].Recommended_Days__c;*/
                    }
                }
            }

        }
    }
     /*
            Pre-Population Starts Here
        */
        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Renewal' || $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding' ){
                for(var i=0;i<$scope.creditScore.facilityList.length;i++){
                    debugger;
                        if($scope.creditScore.facilityList[i].Facilities__r != undefined)
                        for(var j=0;j<$scope.creditScore.facilityList[i].Facilities__r.records.length;j++){
                            if(($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c==null || $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c==undefined) && ($scope.creditScore.facilityList[i].Facilities__r.records[j].Role__c).includes('BR') || ( ($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Renewal' && $scope.creditScore.facilityList[i].Facilities__r.records[j].Higher_Authority_Order__c>=2)||($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding' && $scope.creditScore.facilityList[i].Facilities__r.records[j].Higher_Authority_Order__c>=2))){

                                $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c =   $scope.creditScore.facilityList[i].BRE_Limit__c ;

                                $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c =   $scope.creditScore.facilityList[i].BRE_Processing_Charge__c ;

                                if($scope.creditScore.facilityList[i].Type__c == 'Funded' && $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c == null)
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
        Pre-population ends here

        */
    if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
                for(var i=0;i<$scope.creditScore.facilityList.length;i++){
                    debugger;
                        if($scope.creditScore.facilityList[i].Facilities__r != undefined)
                        for(var j=0;j<$scope.creditScore.facilityList[i].Facilities__r.records.length;j++){
                            if(($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c==null || $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c==undefined) ){



                                //$scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c =   $scope.creditScore.facilityList[i].Existing_Processing_Charge__c ;

                                //$scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c =   ($scope.creditScore.facilityList[i].Existing_Spread__c != undefined ?$scope.creditScore.facilityList[i].Existing_Spread__c:0) + ($scope.creditScore.facilityList[i].MCLR_Rate__c != undefined ?$scope.creditScore.facilityList[i].MCLR_Rate__c:0) + 3 ;

                            }
                        }


                }
    }
    /*
    */
   /* if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Renewal'){
        for(var i=0;i<$scope.creditScore.facilityList.length;i++){
            debugger;
                if($scope.creditScore.facilityList[i].Facilities__r != undefined)
                for(var j=0;j<$scope.creditScore.facilityList[i].Facilities__r.records.length;j++){
                    if(($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c==null || $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c==undefined) && ($scope.creditScore.facilityList[i].Facilities__r.records[j].Role__c).includes('BR')){

                        $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c =   $scope.creditScore.facilityList[i].Existing_Limit__c ;

                        $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c =   $scope.creditScore.facilityList[i].Existing_Processing_Charge__c ;

                        if($scope.creditScore.facilityList[i].Type__c == 'Funded')
                            $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c =   $scope.creditScore.facilityList[i].Existing_Spread__c + $scope.creditScore.facilityList[i].MCLR_Rate__c ;
                        if($scope.creditScore.facilityList[i].Type__c == 'Non-Funded')
                            $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c =   $scope.creditScore.facilityList[i].Existing_Rate__c ;

                        if($scope.creditScore.facilityList[i].CL_Product__r.Facility_Category__c.indexOf('OCC') < 0 ){
                            $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin__c =   $scope.creditScore.facilityList[i].Approved_Margin__c ;
                        }
                        else if($scope.creditScore.facilityList[i].CL_Product__r.Facility_Category__c.indexOf('OCC') >= 0 ){

                            $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Receivables__c = $scope.creditScore.facilityList[i].Existing_Margin_Receivables__c;
                            if(($scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='Trading') || ($scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='TRADING')){
                                $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Stock_Trading__c = $scope.creditScore.facilityList[i].Existing_Margin_Stock_Trading__c;
                            }
                            if(( $scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='Manufacturing') || ($scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='MANUFACTURING')){
                                $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Stock_Manufacturing__c = $scope.creditScore.facilityList[i].Existing_Margin_Stock_Manufacturing__c;
                            }

                        }
                    }
                }


        }
    }*/



    /*
    Handling Pre Population for DO_LEVEL when BM recommendation is null
    */


    /*if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Renewal'){

            for(var i=0;i<$scope.creditScore.facilityList.length;i++){
                    *//*debugger;*//*
                    if($scope.creditScore.facilityList[i].Facilities__r != undefined){
                        var BMRec = [];
                        $scope.isBMRecAvailable = false;
                        for(var j=0;j<$scope.creditScore.facilityList[i].Facilities__r.records.length;j++){
                            BMRec = [];
                            $scope.isBMRecAvailable = false;
                            if(($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c!=null || $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c!=undefined) && ($scope.creditScore.facilityList[i].Facilities__r.records[j].Role__c).includes('BR')){
                                BMRec = $scope.creditScore.facilityList[i].Facilities__r.records[j];
                                $scope.isBMRecAvailable = true;

                            }
                        }
                        for(var j=0;j<$scope.creditScore.facilityList[i].Facilities__r.records.length;j++){
                            if(($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c==null || $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c==undefined) && $scope.creditScore.facilityList[i].Facilities__r.records[j].Higher_Authority_Order__c==3 && ($scope.creditScore.facilityList[i].Facilities__r.records[j].Role__c).includes($scope.creditScore.loggedInUser.Designation__c)){
                                if($scope.isBMRecAvailable){
                                    $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c =   BMRec.Recommended_Limit__c ;

                                    $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c =   BMRec.Recommended_Processing_Charge__c ;

                                    $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c =   BMRec.Recommended_Rate__c ;
                                    if($scope.creditScore.facilityList[i].CL_Product__r.Facility_Category__c.indexOf('OCC') < 0 ){
                                        $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin__c =   BMRec.Margin__c ;
                                    }
                                    else if($scope.creditScore.facilityList[i].CL_Product__r.Facility_Category__c.indexOf('OCC') >= 0 ){

                                        $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Receivables__c = BMRec.Margin_Receivables__c;
                                        if(($scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='Trading') || ($scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='TRADING')){
                                            $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Stock_Trading__c = BMRec.Margin_Stock_Trading__c;
                                        }
                                        if(( $scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='Manufacturing') || ($scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='MANUFACTURING')){
                                            $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Stock_Manufacturing__c = BMRec.Margin_Stock_Manufacturing__c;
                                        }

                                    }
                                }else{
                                    $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c =   $scope.creditScore.facilityList[i].Existing_Limit__c ;

                                    $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c =   $scope.creditScore.facilityList[i].Existing_Processing_Charge__c ;
                                    if($scope.creditScore.facilityList[i].Type__c == 'Funded')
                                        $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c =   $scope.creditScore.facilityList[i].Existing_Spread__c + $scope.creditScore.facilityList[i].MCLR_Rate__c ;
                                    if($scope.creditScore.facilityList[i].Type__c == 'Non-Funded')
                                        $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c =   $scope.creditScore.facilityList[i].Existing_Rate__c ;

                                    if($scope.creditScore.facilityList[i].CL_Product__r.Facility_Category__c.indexOf('OCC') < 0 ){
                                        $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin__c =   $scope.creditScore.facilityList[i].Approved_Margin__c ;
                                    }
                                    else if($scope.creditScore.facilityList[i].CL_Product__r.Facility_Category__c.indexOf('OCC') >= 0 ){

                                        $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Receivables__c = $scope.creditScore.facilityList[i].Existing_Margin_Receivables__c;
                                        if(($scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='Trading') || ($scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='TRADING')){
                                            $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Stock_Trading__c = $scope.creditScore.facilityList[i].Existing_Margin_Stock_Trading__c;
                                        }
                                        if(( $scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='Manufacturing') || ($scope.creditScore.facilityList[i].Application__r.genesis__Account__r.Industry_Type__c =='MANUFACTURING')){
                                            $scope.creditScore.facilityList[i].Facilities__r.records[j].Margin_Stock_Manufacturing__c = $scope.creditScore.facilityList[i].Existing_Margin_Stock_Manufacturing__c;
                                        }

                                    }
                                }
                            }
                        }
                    }


            }
        }*/
     $scope.filldefaultValuesForRenewal = function(){
        for(var i=0;i<$scope.creditScore.facilityList.length;i++){
                 debugger;
                if($scope.creditScore.facilityList[i].Facilities__r != undefined)
                for(var j=0;j<$scope.creditScore.facilityList[i].Facilities__r.records.length;j++){
                    if(($scope.creditScore.facilityList[i].Facilities__r.records[j].Role__c).includes($scope.creditScore.loggedInUser.Designation__c)){


                        $scope.saveFacilityObj =  $scope.checkFacilityId($scope.creditScore.facilityList[i].Facilities__r.records[j].Id);
                        $scope.saveFacilityObj.facObj.id = $scope.creditScore.facilityList[i].Facilities__r.records[j].Id;
                        $scope.saveFacilityObj.facObj.Facility__c = $scope.creditScore.facilityList[i].Facilities__r.records[j].Facility__c;
                        $scope.saveFacilityObj.facObj.CL_Product__c = $scope.creditScore.facilityList[i].CL_Product__r.clcommon__Product_Name__c;
                        $scope.saveFacilityObj.facObj.Role__c       = $scope.creditScore.facilityList[i].Facilities__r.records[j].Role__c;
                        $scope.saveFacilityObj.facObj.Product_Category__c = $scope.creditScore.facilityList[i].CL_Product__r.Facility_Category__c;
                        $scope.saveFacilityObj.facObj.Product_Schematic__c = $scope.creditScore.facilityList[i].CL_Product__r.Schematic_Loan__c;
                        $scope.saveFacilityObj.facObj.Higher_Authority_Order__c =  $scope.creditScore.facilityList[i].Facilities__r.records[j].Higher_Authority_Order__c;
                        $scope.saveFacilityObj.facObj.Type__c = $scope.creditScore.facilityList[i].Type__c;
                        $scope.saveFacilityObj.facObj.Highest_Authority__c =  $scope.creditScore.facilityList[i].Facilities__r.records[j].Highest_Authority__c;


                        //Filling recommended Limit
                        if($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c!= null && $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c != undefined)
                        $scope.saveFacilityObj.facObj.Recommended_Limit__c = $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c;
                        //Filling Processing Charges
                        if($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c != null && $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c != undefined)
                        $scope.saveFacilityObj.facObj.Recommended_Processing_Charge__c = $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c;
                        //Filling reccomended Rate
                        if($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c != null && $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c != undefined)
                        $scope.saveFacilityObj.facObj.Recommended_Rate__c   = $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c;

                        //Filling Existing Processing Charges
                        /*if($scope.creditScore.facilityList[i].Existing_Processing_Charge__c != null && $scope.creditScore.facilityList[i].Existing_Processing_Charge__c != undefined)
                        $scope.saveFacilityObj.facObj.Existing_Processing_Charge__c = $scope.creditScore.facilityList[i].Existing_Processing_Charge__c;*/
                        //Filling Existing Rate
                        $scope.saveFacilityObj.facObj.BRE_Processing_Charge__c =  $scope.creditScore.facilityList[i].BRE_Processing_Charge__c != undefined ? $scope.creditScore.facilityList[i].BRE_Processing_Charge__c:0.0;

                        $scope.saveFacilityObj.facObj.BRE_Limit__c = $scope.creditScore.facilityList[i].BRE_Limit__c;

                        $scope.saveFacilityObj.facObj.BRE_Rate__c               = $scope.creditScore.facilityList[i].BRE_Rate__c != undefined ? $scope.creditScore.facilityList[i].BRE_Rate__c : 0.0;
                        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Renewal'){
                            $scope.saveFacilityObj.facObj.BRE_Spread__c                 = $scope.creditScore.facilityList[i].BRE_Spread__c;
                            $scope.saveFacilityObj.facObj.Recommended_Spread__c     = $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c - $scope.creditScore.facilityList[i].MCLR_Rate__c;

                        }
                        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
                            if($scope.creditScore.facilityList[i].BRE_Rate__c != undefined){
                                $scope.saveFacilityObj.facObj.BRE_Spread__c                 = $scope.creditScore.facilityList[i].BRE_Rate__c - $scope.creditScore.facilityList[i].MCLR_Rate__c;
                                $scope.saveFacilityObj.facObj.Recommended_Spread__c         = $scope.creditScore.facilityList[i].BRE_Rate__c - $scope.creditScore.facilityList[i].MCLR_Rate__c;
                            }
                            $scope.saveFacilityObj.facObj.BRE_Processing_Charge__c =  $scope.creditScore.facilityList[i].BRE_Processing_Charge__c != undefined ? $scope.creditScore.facilityList[i].BRE_Processing_Charge__c:0.0;
                            $scope.saveFacilityObj.facObj.Recommended_Processing_Charge__c= "0";

                        }

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
                        /*//Filling recommended Limit
                        if($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c!= null && $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c != undefined)
                        $scope.saveFacilityObj.facObj.Recommended_Limit__c = $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c;
                        //Filling Processing Charges
                        if($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c != null && $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c != undefined)
                        $scope.saveFacilityObj.facObj.Recommended_Processing_Charge__c = $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c;
                        //Filling reccomended Rate
                        if($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c != null && $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c != undefined)
                        $scope.saveFacilityObj.facObj.Recommended_Rate__c   = $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c;

                        //Filling Existing Processing Charges
                        if($scope.creditScore.facilityList[i].Existing_Processing_Charge__c != null && $scope.creditScore.facilityList[i].Existing_Processing_Charge__c != undefined)
                        $scope.saveFacilityObj.facObj.Existing_Processing_Charge__c = $scope.creditScore.facilityList[i].Existing_Processing_Charge__c;
                        //Filling Existing Rate

                        $scope.saveFacilityObj.facObj.Existing_Rate__c              = $scope.creditScore.facilityList[i].Existing_Spread__c + $scope.creditScore.facilityList[i].MCLR_Rate__c;

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
                        }*/

                        if(!$scope.saveFacilityObj.isExist){
                            $scope.facilitySaveList.push($scope.saveFacilityObj.facObj);
                        }
                    }

                }

        }
     }
        $scope.filldefaultValuesForRenewal();
    if(dashType !='' && dashType != undefined){
        $scope.dashboardType    = '('+dashType+')';
    }

    if($scope.creditScore.kvbCompanyDetails != null){
        $scope.tandcHelpText = $scope.creditScore.kvbCompanyDetails.Special_Sanction_Help_Text__c;
        $scope.Overall_score__c = $scope.creditScore.kvbCompanyDetails.Overall_score__c;
    }

    $scope.RecommendationDone   = false;
    for(var iCount=0; iCount < $scope.creditScore.facilityList.length; iCount++){

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
                       debugger;
                    if($scope.sancProcess.isBranchRole && $scope.creditScore.facilityList[iCount].Facilities__r.records[rCount].Higher_Authority_Order__c == 1)
                        $scope.RecommendationDone = true;
                    if($scope.sancProcess.isFinalAuhtority)
                        $scope.RecommendationDone = true;

                }

            }
            $scope.isRole = true;

        }
    }

    $scope.increase =function(){
        $scope.listOfComments.length =$scope.listOfComments.length+1;
    }

    $scope.exposure =function(){
        $scope.showExposure =true;
    }

    $scope.closeExposure =function(){
        $scope.showExposure =false;
    }

    $scope.decrease =function(index){
        $scope.listOfComments.splice(index,1);
        //$scope.termsAndConditions.splice(index,1);
        $scope.termsAndConditions[index]='';
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



    $scope.getChangeFacility = function(item){


        $scope.saveFacilityObj =  $scope.checkFacilityId(item.currentTarget.getAttribute('data-id'));
        $scope.saveFacilityObj.facObj.id = item.currentTarget.getAttribute('data-id');
        $scope.saveFacilityObj.facObj.Role__c = item.currentTarget.getAttribute('data-role');
        $scope.saveFacilityObj.facObj.Facility__c = item.currentTarget.getAttribute('data-facility');
        $scope.saveFacilityObj.facObj.CL_Product__c = item.currentTarget.getAttribute('data-facilityName');
        $scope.saveFacilityObj.facObj.Product_Category__c = item.currentTarget.getAttribute('data-facilityCategory');
        $scope.saveFacilityObj.facObj.Product_Schematic__c = item.currentTarget.getAttribute('data-productType');
        $scope.saveFacilityObj.facObj.Higher_Authority_Order__c =  item.currentTarget.getAttribute('data-roleSize');
        $scope.saveFacilityObj.facObj.Type__c = item.currentTarget.getAttribute('data-facilityType');
        if( item.currentTarget.getAttribute('data-apiName')=='Recommended_Limit__c'){
            $scope.saveFacilityObj.facObj.Recommended_Limit__c = item.currentTarget.value;
            if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
                $scope.saveFacilityObj.facObj.Recommended_Processing_Charge__c = item.currentTarget.getAttribute('data-processingCharge');
                if(item.currentTarget.getAttribute('data-recomendedRate') != '')
                $scope.saveFacilityObj.facObj.Recommended_Rate__c = item.currentTarget.getAttribute('data-recomendedRate');
                else
                $scope.saveFacilityObj.facObj.Recommended_Rate__c =0;
            }
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
        if($scope.creditScore.applicationInfo.RecordType.DeveloperName == 'SME_Exceeding'){

            $scope.saveFacilityObj.facObj.BRE_Processing_Charge__c =  $scope.creditScore.facilityList[i].BRE_Processing_Charge__c != undefined ? $scope.creditScore.facilityList[i].BRE_Processing_Charge__c:0.0;
            $scope.saveFacilityObj.facObj.Recommended_Processing_Charge__c= "0";

        }


        else if(item.currentTarget.getAttribute('data-apiName')=='Recommended_Rate__c'){
            $scope.saveFacilityObj.facObj.Recommended_Rate__c = item.currentTarget.value;
            $scope.saveFacilityObj.facObj.BRE_Rate__c =  (parseFloat(item.currentTarget.getAttribute('data-breRate')) != undefined ? parseFloat(item.currentTarget.getAttribute('data-breRate')):0) ;
            $scope.saveFacilityObj.facObj.BRE_Spread__c =  (parseFloat(item.currentTarget.getAttribute('data-breSpread')) != undefined ? parseFloat(item.currentTarget.getAttribute('data-breSpread')):0) ;
            document.getElementById(item.currentTarget.getAttribute('data-childFacId')).value = item.currentTarget.value - item.currentTarget.getAttribute('data-mclrRate');
            $scope.saveFacilityObj.facObj.Recommended_Spread__c = item.currentTarget.value- item.currentTarget.getAttribute('data-mclrRate');
            //$scope.saveFacilityObj.facObj.Existing_Rate__c =  item.currentTarget.getAttribute('data-existingVal');
        }

        if(!$scope.saveFacilityObj.isExist){
            $scope.facilitySaveList.push($scope.saveFacilityObj.facObj);
        }

    }
    $scope.saveModStatus =function(){
        Visualforce.remoting.Manager.invokeAction(
                    "Underwriting_CTRL.updateModStatus",appId,$scope.creditScore.applicationInfo.Is_Mod_Required ,
                    function(result, event) {

                        if(result != undefined){
                            console.log('MOD RESULT');
                            console.log(result);
                            //swal({title:'',text:result.message});
                        }
                        //window.location.href  = '/'+$scope.creditScore.applicationInfo.Id;
                    },
                    {escape: false} // No escaping, please
                );
    }

    $scope.saveUnderWritingData = function(acrionPerform,secondAction){
            debugger;
            if(this.flagValidation.$invalid){
                alert('Please provide comment for each flags.');
                return;
            }

            //Newly Added
            var partymobileDoesNotExist = $scope.validateIfAllPartyHasMobileNo();
                if(partymobileDoesNotExist){
                    return;
            }

            $scope.saveData = new Object();
            //$scope.saveData.isSaveOrSubmit = 'SUBMIT';
            console.log('secondAction');
            console.log(secondAction);
            if(secondAction != ''){
                //console.log('Save Operation');
                $scope.saveData.isSaveOrSubmit = secondAction;
            }/*else{
                console.log('Submit Operation');
                $scope.saveData.isSaveOrSubmit = 'SUBMIT';
            }*/
            $scope.saveData.isMoreThanTenDays = false;
            $scope.saveData.facility = $scope.facilitySaveList;
            if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Renewal'){
                /*if($scope.sancProcess.isFinalAuhtority){
                    var hasfacilityExceeded = $scope.validateFacilityLimitAmount();
                    if(hasfacilityExceeded)
                    return;
                }*/

            }

            var hasfacilityExceeded = $scope.validateFacilityLimitAmountByExistingLimit();
            if (hasfacilityExceeded) {
                return;
            }

            $scope.saveData.appId = appId;
            $scope.saveData.IsFinalAuthority = $scope.sancProcess.isFinalAuhtority;
            $scope.saveData.isReadOnly = $scope.sancProcess.isReadOnly;
            //Wrapper build for comments
            if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
                    if($scope.sancProcess.isEmeBMReviewer && !$scope.sancProcess.isFinalAuhtority){
                        if( $scope.BMNoOfDaysRecom==undefined || $scope.BMNoOfDaysRecom <1){
                            swal({title:'',text:'Please fill No of days'});
                            return;
                        }
                        if($scope.BMNoOfDaysRecom >90 && $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
                            swal({title:'',text:'No of days for exceeding request should not be greater than 90'});
                            return;
                        }
                        if($scope.saveData.facility.length > 0){
                                    for(var key in $scope.saveData.facility){
                                        if ($scope.saveData.facility.hasOwnProperty(key)) {
                                            if($scope.saveData.facility[key].Higher_Authority_Order__c == "1"){
                                                $scope.saveData.facility[key].Recommended_Days__c = $scope.BMNoOfDaysRecom;
                                                if($scope.BMNoOfDaysRecom>10)
                                                $scope.saveData.isMoreThanTenDays = true;
                                                else
                                                $scope.saveData.isMoreThanTenDays = false;

                                            }
                                            else if($scope.saveData.facility[key].Higher_Authority_Order__c == "2")
                                            $scope.saveData.facility[key].Recommended_Days__c = $scope.HigherAuthNoOfDaysRecom;
                                        }
                                    }
                        }


                    }
                    else if($scope.sancProcess.isEmeBMReviewer && $scope.sancProcess.isFinalAuhtority ){
                         if($scope.BMNoOfDaysRecom==undefined ||   $scope.BMNoOfDaysRecom <1){
                             swal({title:'',text:'Please fill No of days'});
                             return;
                         }
                         if($scope.BMNoOfDaysRecom >90 && $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
                             swal({title:'',text:'No of days for exceeding request should not be greater than 90'});
                             return;
                         }
                         if($scope.saveData.facility.length > 0){
                                     for(var key in $scope.saveData.facility){
                                         if ($scope.saveData.facility.hasOwnProperty(key)) {
                                            if($scope.saveData.facility[key].Higher_Authority_Order__c == "1"){
                                                $scope.saveData.facility[key].Recommended_Days__c = $scope.BMNoOfDaysRecom;
                                                if($scope.BMNoOfDaysRecom>10)
                                                $scope.saveData.isMoreThanTenDays = true;
                                                else
                                                $scope.saveData.isMoreThanTenDays = false;

                                            }
                                            else if($scope.saveData.facility[key].Higher_Authority_Order__c == "2")
                                            $scope.saveData.facility[key].Recommended_Days__c = $scope.HigherAuthNoOfDaysRecom;
                                         }

                                     }
                         }
                    }
                    else if(! $scope.sancProcess.isEmeBMReviewer && $scope.sancProcess.isFinalAuhtority ){
                          if($scope.HigherAuthNoOfDaysRecom==undefined ||   $scope.HigherAuthNoOfDaysRecom <1){
                              swal({title:'',text:'Please fill No of days'});
                              return;
                          }
                          if($scope.HigherAuthNoOfDaysRecom >90 && $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
                              swal({title:'',text:'No of days for exceeding request should not be greater than 90'});
                              return;
                          }
                          if($scope.saveData.facility.length > 0){
                                   for(var key in $scope.saveData.facility){
                                       if ($scope.saveData.facility.hasOwnProperty(key)) {
                                            if($scope.saveData.facility[key].Higher_Authority_Order__c == "1"){
                                                $scope.saveData.facility[key].Recommended_Days__c = $scope.BMNoOfDaysRecom;
                                                if($scope.BMNoOfDaysRecom>10)
                                                $scope.saveData.isMoreThanTenDays = true;
                                                else
                                                $scope.saveData.isMoreThanTenDays = false;

                                            }
                                            else if($scope.saveData.facility[key].Higher_Authority_Order__c == "2")
                                            $scope.saveData.facility[key].Recommended_Days__c = $scope.HigherAuthNoOfDaysRecom;

                                       }
                                   }
                          }
                    }
                    /*if($scope.saveData.facility[key].Recommended_Processing_Charge__c == undefined || $scope.saveData.facility[key].Recommended_Processing_Charge__c == ''
                                           || $scope.saveData.facility[key].Recommended_Processing_Charge__c == null){

                    }*/
                }

            $scope.bmCommentsList = []
            $scope.saveData.bmCommentsList = [];
            if($scope.sancProcess.isBranchRole){ //$scope.creditScore.loggedInUser.Designation__c == 'BM'
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
            //wrapper build for terms & conditions

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
            $scope.termsAndConditionList = [];
            if($scope.SanctionAuthorityComment != '' && $scope.SanctionAuthorityComment != undefined){
                var tandcobj = new Object();
                tandcobj.Sanction_Authority_Comment__c = $scope.SanctionAuthorityComment;
                tandcobj.Application__c = appId;
                tandcobj.RecordtypeId = $scope.sancAuthRTypeId;
                tandcobj.User__c = $scope.creditScore.loggedInUser.Id;
                if(tandcobj.Sanction_Authority_Comment__c != undefined && tandcobj.Sanction_Authority_Comment__c !='')
                    $scope.termsAndConditionList.push(tandcobj);
            }

            $scope.saveData.termsAndConditions =  $scope.termsAndConditionList;
            $scope.saveData.actionPerformed = acrionPerform;
            debugger;
            $scope.isredirect = acrionPerform;
            /*
            Specific to exceeding and adhoc
            */
            /* if($scope.saveData.facility.length > 0){
                        for(var key in $scope.saveData.facility){

                            if ($scope.saveData.facility.hasOwnProperty(key)) {
                                *//*
                                Specific to exceeding and adhoc
                                *//*
                                if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
                                    debugger;
                                    if($scope.saveData.facility[key].Recommended_Processing_Charge__c == undefined || $scope.saveData.facility[key].Recommended_Processing_Charge__c == ''){
                                        for(var key in $scope.creditScore.facilityList){
                                            if($scope.creditScore.facilityList[key].Id == $scope.saveData.facility[key].Facility__c){
                                                $scope.saveData.facility[key].Recommended_Processing_Charge__c = $scope.creditScore.facilityList[key].Existing_Processing_Charge__c;
                                                $scope.saveData.facility[key].Recommended_Rate__c = $scope.creditScore.facilityList[key].Existing_Spread__c + $scope.creditScore.facilityList[key].MCLR_Rate__c + 3 ;
                                            }

                                        }
                                    }
                                }
                            }
                        }
             }*/
             /*if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
                             for(var i=0;i<$scope.creditScore.facilityList.length;i++){
                                 debugger;
                                     if($scope.creditScore.facilityList[i].Facilities__r != undefined)
                                     for(var j=0;j<$scope.creditScore.facilityList[i].Facilities__r.records.length;j++){
                                         if(($scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c==null || $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Limit__c==undefined) ){



                                             $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Processing_Charge__c =   $scope.creditScore.facilityList[i].Existing_Processing_Charge__c ;

                                             $scope.creditScore.facilityList[i].Facilities__r.records[j].Recommended_Rate__c =   ($scope.creditScore.facilityList[i].Existing_Spread__c != undefined ?$scope.creditScore.facilityList[i].Existing_Spread__c:0) + ($scope.creditScore.facilityList[i].MCLR_Rate__c != undefined ?$scope.creditScore.facilityList[i].MCLR_Rate__c:0) + 3 ;

                                         }
                                     }


                             }
            }*/

            var isBlank = false;
            if($scope.saveData.facility.length > 0){
                for(var key in $scope.saveData.facility){

                    if ($scope.saveData.facility.hasOwnProperty(key)) {
                        debugger;
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
                        if($scope.saveData.facility[key].Recommended_Processing_Charge__c == undefined || $scope.saveData.facility[key].Recommended_Processing_Charge__c == ''
                           || $scope.saveData.facility[key].Recommended_Processing_Charge__c == null){
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
                            if(secondAction == 'SUBMIT'){
                                if(result.finalAuthMessage != null && result.finalAuthMessage != undefined &&  $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding' && !(result.message).includes('Deviation'))
                                 swal({title:'',text:'Final authority for this application is '+result.finalAuthMessage},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                                 else{
                                     swal({title:'',text:result.message},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                                     window.location.href   = '/'+$scope.creditScore.applicationInfo.Id;
                                 }

                            }else{
                                window.location.reload();
                            }


                            //alert(result.message);
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
    $scope.saveUnderWriteHelper = function(acrionPerform){
        $scope.saveData.appId = appId;
        //$scope.saveData.isSaveOrSubmit = 'SUBMIT';
        if(!$scope.creditScore.facilityList[0].Is_Save_Operation_Done__c){
            console.log('Save Operation');
            $scope.saveData.isSaveOrSubmit = 'SAVE';
        }else{
            console.log('Submit Operation');
            $scope.saveData.isSaveOrSubmit = 'SUBMIT';
        }
        $scope.saveData.IsFinalAuthority = $scope.sancProcess.isFinalAuhtority;
        $scope.saveData.isReadOnly = $scope.sancProcess.isReadOnly;
        //Wrapper build for comments
        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
            $scope.saveData.isMoreThanTenDays = false;
            if($scope.sancProcess.isEmeBMReviewer && !$scope.sancProcess.isFinalAuhtority){
                if( $scope.BMNoOfDaysRecom==undefined || $scope.BMNoOfDaysRecom <1){
                    swal({title:'',text:'Please fill No of days'});
                    return;
                }else if($scope.BMNoOfDaysRecom >90 && $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
                    swal({title:'',text:'No of days for exceeding request should not be greater than 90'});
                    return;
                }
                if($scope.saveData.facility.length > 0){
                    for(var key in $scope.saveData.facility){
                        if ($scope.saveData.facility.hasOwnProperty(key)) {
                            if($scope.saveData.facility[key].Higher_Authority_Order__c == "1"){
                                $scope.saveData.facility[key].Recommended_Days__c = $scope.BMNoOfDaysRecom;
                                if($scope.BMNoOfDaysRecom>10)
                                $scope.saveData.isMoreThanTenDays = true;
                                else
                                $scope.saveData.isMoreThanTenDays = false;

                            }else if($scope.saveData.facility[key].Higher_Authority_Order__c == "2")
                                $scope.saveData.facility[key].Recommended_Days__c = $scope.HigherAuthNoOfDaysRecom;
                        }
                    }
                }


            }
            else if($scope.sancProcess.isEmeBMReviewer && $scope.sancProcess.isFinalAuhtority &&  $scope.BMNoOfDaysRecom <1){
                if($scope.BMNoOfDaysRecom==undefined ||   $scope.BMNoOfDaysRecom <1){
                    swal({title:'',text:'Please fill No of days'});
                    return;
                }else if($scope.BMNoOfDaysRecom >90 && $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
                    swal({title:'',text:'No of days for exceeding request should not be greater than 90'});
                    return;
                }
                if($scope.saveData.facility.length > 0){
                    for(var key in $scope.saveData.facility){
                        if ($scope.saveData.facility.hasOwnProperty(key)) {
                            if($scope.saveData.facility[key].Higher_Authority_Order__c == "1"){
                                $scope.saveData.facility[key].Recommended_Days__c = $scope.BMNoOfDaysRecom;
                                if($scope.BMNoOfDaysRecom>10)
                                $scope.saveData.isMoreThanTenDays = true;
                                else
                                $scope.saveData.isMoreThanTenDays = false;

                            }
                            else if($scope.saveData.facility[key].Higher_Authority_Order__c == "2")
                                $scope.saveData.facility[key].Recommended_Days__c = $scope.HigherAuthNoOfDaysRecom;
                        }

                    }
                }
            }
            else if(! $scope.sancProcess.isEmeBMReviewer && $scope.sancProcess.isFinalAuhtority ){
                if($scope.HigherAuthNoOfDaysRecom==undefined ||   $scope.HigherAuthNoOfDaysRecom <1){
                    swal({title:'',text:'Please fill No of days'});
                    return;
                }else if($scope.HigherAuthNoOfDaysRecom >90 && $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
                    swal({title:'',text:'No of days for exceeding request should not be greater than 90'});
                    return;
                }
                if($scope.saveData.facility.length > 0){
                    for(var key in $scope.saveData.facility){
                        if ($scope.saveData.facility.hasOwnProperty(key)) {
                            if($scope.saveData.facility[key].Higher_Authority_Order__c == "1"){
                                $scope.saveData.facility[key].Recommended_Days__c = $scope.BMNoOfDaysRecom;
                                if($scope.BMNoOfDaysRecom>10)
                                $scope.saveData.isMoreThanTenDays = true;
                                else
                                $scope.saveData.isMoreThanTenDays = false;

                            }
                            else if($scope.saveData.facility[key].Higher_Authority_Order__c == "2")
                                $scope.saveData.facility[key].Recommended_Days__c = $scope.HigherAuthNoOfDaysRecom;

                        }
                    }
                }
            }

        }

        $scope.bmCommentsList = []
        $scope.saveData.bmCommentsList = [];
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
        //wrapper build for terms & conditions

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
            tandcobj.User__c = $scope.creditScore.loggedInUser.Id;
            if(tandcobj.Sanction_Authority_Comment__c != undefined && tandcobj.Sanction_Authority_Comment__c !='')
                $scope.termsAndConditionList.push(tandcobj);
        }

        $scope.saveData.termsAndConditions =  $scope.termsAndConditionList;
        $scope.saveData.actionPerformed = acrionPerform;
        debugger;
        $scope.isredirect = acrionPerform;

        var isBlank = false;
        if($scope.saveData.facility.length > 0){
            for(var key in $scope.saveData.facility){

                if ($scope.saveData.facility.hasOwnProperty(key)) {
                    debugger;
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
                    if($scope.saveData.facility[key].Recommended_Processing_Charge__c == undefined || $scope.saveData.facility[key].Recommended_Processing_Charge__c == ''
                        || $scope.saveData.facility[key].Recommended_Processing_Charge__c == null){
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
                         if(result.finalAuthMessage != null && result.finalAuthMessage != undefined &&  $scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding' && !(result.message).includes('Deviation'))
                         swal({title:'',text:'Final authority for this application is '+result.finalAuthMessage},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                         else
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
            //$scope.facilityFIeldSet = true;
            $scope.disableAllshow   = false;
            $scope.commentsFieldset = true;
            $scope.btnFields        = true;
            $scope.onlyAppRej       = true;
            $scope.isApproved       = false;
            $scope.showReviewCommt  = true;
        }else if($scope.sancProcess.isFinalAuhtority){
            $scope.disableAll = true;
            //$scope.commentsFieldset = true;
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
            $scope.disableAll = true;
            // $scope.commentsFieldset = true;
            $scope.onLoadRBCheck = true ;
            $scope.onLoadApproveCheck = true;
            if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Renewal')
            $scope.onLoadMARCheck = true;
            $scope.onLoadisHRACheck = false;
            $scope.isRHA = false;
            $scope.showReviewCommt  = true;
        }else if(!$scope.sancProcess.isSanctionApproval || !$scope.sancProcess.isReadOnly  || !$scope.sancProcess.isFinalAuhtority ){
           // alert('AAAA');
            $scope.disableAll = true;
            $scope.facilityFIeldSet = true;
            $scope.btnFields = true;
            $scope.commentsFieldset = true;
            $scope.isRHA = false;
            //$scope.isApproved       = false
        }
        /* if($scope.sancProcess.isSaveOperationDone){
            $scope.showReviewCommt      = true;
        }*/
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
                //window.location.href  = '/'+$scope.creditScore.applicationInfo.Id;
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

                $scope.saveData = new Object();
          $scope.saveData.appId = appId;
          $scope.saveData.facility = $scope.facilitySaveList;

          // check if following has to be done for exceeding
          var hasfacilityExceeded = $scope.validateFacilityLimitAmountByExistingLimit();
          if (hasfacilityExceeded) {
           return;
          }
          var isBlank = false;
          if($scope.saveData.facility.length > 0 && $scope.sancProcess.isDeviationApprover){

               for(var key in $scope.saveData.facility){

                            if ($scope.saveData.facility.hasOwnProperty(key)) {
                                debugger;
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
                                if($scope.saveData.facility[key].Recommended_Processing_Charge__c == undefined || $scope.saveData.facility[key].Recommended_Processing_Charge__c == ''
                                   || $scope.saveData.facility[key].Recommended_Processing_Charge__c == null){
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
          if(!$scope.sancProcess.isDeviationApprover){
                            isBlank = false;
                        }
          if((!isBlank || $scope.RecommendationDone)){
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
            "Underwriting_CTRL.sanctionApprovalSubmitRefactor",$scope.creditScore.applicationInfo.Id,actionPerfomred,$scope.sancProcess,tandcobj,$scope.saveData,
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
        $scope.saveData.appId = appId;
        $scope.saveData.actionPerformed = 'REFFER_BACK';

        Visualforce.remoting.Manager.invokeAction(
            "Underwriting_CTRL.createTaskForPreviousAuthority",$scope.saveData,
            function(result, event) {

                if(result != undefined){
                    console.log(result);
                    swal({title:'',text:result},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                    //if(result=='Task has been cretaed for previous authority')
                       // window.location.href  = '/'+$scope.creditScore.applicationInfo.Id;
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
    $scope.rejecthelper = function(){
        if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding'){
            $scope.rejectExceedingAdhoc();
        }
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
                      recommendedLimitAggregate += $scope.saveData.facility[key].Recommended_Limit__c;
            }
        }
        if($scope.sancProcess.isFinalAuhtority){
            if(recommendedLimitAggregate > $scope.getLimitAfterNegatingTermLoanExpo()){
                swal({title:'Limit Exceeded !!!!',text:'You have exceeded your recommended limit'});
                return true;
            }else{
                return false;
            }
        }
        
    }
    $scope.validateFacilityLimitAmountByExistingLimit = function(){
        for(var key in $scope.saveData.facility){
            for(var i=0;i<$scope.creditScore.facilityList.length;i++) {

                if ($scope.creditScore.facilityList[i].Id != undefined) {

                   // for (var j = 0; j < $scope.creditScore.facilityList[i].Facilities__r.records.length; j++) {
                        if($scope.creditScore.facilityList[i].Id == $scope.saveData.facility[key].Facility__c){

                            if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Renewal') {
                                if( $scope.saveData.facility[key].Recommended_Limit__c > $scope.creditScore.facilityList[i].Existing_Limit__c){
                                    swal({title:'Limit Exceeded !!!!',text:'Recommended Limit can not exceed Exiting Limit'});
                                    return true;
                                }
                            }
                            if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Renewal')
                            if( $scope.saveData.facility[key].Recommended_Limit__c < ($scope.creditScore.facilityList[i].Existing_Limit__c * 85)/100 ){
                                if ($window.confirm("Recommended Limit is very less ? Do you still want to proceed")) {
                                    return false;
                                } else {
                                    return true;
                                }

                            }
                            if($scope.creditScore.applicationInfo.RecordType.DeveloperName=='SME_Exceeding')
                            if( $scope.saveData.facility[key].Recommended_Limit__c < ($scope.creditScore.facilityList[i].New_Limit_Amount__c * 85)/100 ){

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

                   // }
                }
            }


        }
        return false;
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
    $scope.validateFacilityMargin = function(){

        debugger;
        var minimumPercentageRecord = {};
        for(var key in $scope.creditScore.reccomendationCappingDetails){
            if($scope.creditScore.reccomendationCappingDetails[key].MasterLabel == 'MD & CEO'){
                minimumPercentageRecord = $scope.creditScore.reccomendationCappingDetails[key];
            }
        }

        for(var key in $scope.saveData.facility){
            // check if margin value is not below Lower(MD & CEO) limit

            // For Branch manger And Do_DM This limit is 40/25
            //
            // if it is not lower than Lower Limit, Than compare each of 4 values and check for next Deviation Approver.
            //For OCC
            if($scope.saveData.facility[key].Industry__c == 'TRADING'){

                if($scope.saveData.facility[key].Margin_Stock_Trading__c != undefined && $scope.saveData.facility[key].Margin_Stock_Trading__c != null ){
                    if($scope.saveData.facility[key].Margin_Stock_Trading__c < 40) {
                        var hasLowerLimitExceeded = $scope.validateLowerMDAndCeoLimit(minimumPercentageRecord, 'OCC-TRADING', $scope.saveData.facility[key].Margin_Stock_Trading__c);
                        if (hasLowerLimitExceeded) {
                            return hasLowerLimitExceeded;
                        } else {

                            var isNextDeviationApproverExist = $scope.getNextDeviationApprover($scope.saveData.facility[key].Margin_Stock_Trading__c, 'OCC-TRADING');
                            if (isNextDeviationApproverExist != 'No Margin Deviation') {
                                return isNextDeviationApproverExist;
                            }
                        }
                    }

                }
            }
            // For OCC
            if($scope.saveData.facility[key].Industry__c == 'Manufacturing'){
                if($scope.saveData.facility[key].Margin_Stock_Manufacturing__c != undefined && $scope.saveData.facility[key].Margin_Stock_Manufacturing__c != null){
                    if($scope.saveData.facility[key].Margin_Stock_Manufacturing__c < 25) {
                        var hasLowerLimitExceeded = $scope.validateLowerMDAndCeoLimit(minimumPercentageRecord, 'OCC-MANUFACTURING', $scope.saveData.facility[key].Margin_Stock_Manufacturing__c);
                        if (hasLowerLimitExceeded) {
                            return hasLowerLimitExceeded;
                        } else {

                            var isNextDeviationApproverExist = $scope.getNextDeviationApprover($scope.saveData.facility[key].Margin_Stock_Manufacturing__c, 'OCC-MANUFACTURING');
                            if (isNextDeviationApproverExist != 'No Margin Deviation') {
                                return isNextDeviationApproverExist;
                            }
                        }
                    }

                }
                if($scope.saveData.facility[key].Margin_Receivables__c != undefined && $scope.saveData.facility[key].Margin_Receivables__c != null){
                    if($scope.saveData.facility[key].Margin_Receivables__c < 40) {
                        var hasLowerLimitExceeded = $scope.validateLowerMDAndCeoLimit(minimumPercentageRecord, 'OCC-RECIEVEABLE', $scope.saveData.facility[key].Margin_Receivables__c);
                        if (hasLowerLimitExceeded) {
                            return hasLowerLimitExceeded;
                        } else {

                            var isNextDeviationApproverExist = $scope.getNextDeviationApprover($scope.saveData.facility[key].Margin_Receivables__c, 'OCC-RECIEVEABLE');
                            if (isNextDeviationApproverExist != 'No Margin Deviation') {
                                return isNextDeviationApproverExist;
                            }
                        }
                    }


                }
            }
            // For SOD
            if($scope.saveData.facility[key].Margin__c != undefined && $scope.saveData.facility[key].Margin__c != null){

                if($scope.saveData.facility[key].Margin__c < 40){
                    var hasLowerLimitExceeded = $scope.validateLowerMDAndCeoLimit(minimumPercentageRecord,'SOD',$scope.saveData.facility[key].Margin__c);
                    if(hasLowerLimitExceeded){
                        return hasLowerLimitExceeded;
                    }else{
                        var isNextDeviationApproverExist = $scope.getNextDeviationApprover($scope.saveData.facility[key].Margin__c,'SOD');
                        if(isNextDeviationApproverExist != 'No Margin Deviation'){
                            return isNextDeviationApproverExist;
                        }
                    }
                }



            }

        }
        return 'No Margin Deviation';
    }

    $scope.getNextDeviationApprover = function(valuetoCompare,whatToCompare){
        debugger;
        var index = -1;
        var difference = 10000000;
        for(var key in $scope.creditScore.reccomendationCappingDetails){
            if(whatToCompare == 'SOD'){
                if($scope.creditScore.reccomendationCappingDetails[key].Margin_SOD__c - parseFloat(valuetoCompare) < difference){
                    difference = parseFloat(valuetoCompare) - $scope.creditScore.reccomendationCappingDetails[key].Margin_SOD__c ;
                    index = key;
                }
            }else if(whatToCompare == 'OCC-TRADING'){
                if($scope.creditScore.reccomendationCappingDetails[key].Margin_OCC_Trading_Stock__c - parseFloat(valuetoCompare) < difference){
                    difference =  parseFloat(valuetoCompare) - $scope.creditScore.reccomendationCappingDetails[key].Margin_OCC_Trading_Stock__c ;
                    index = key;
                }
            }else if(whatToCompare == 'OCC-MANUFACTURING'){
                if($scope.creditScore.reccomendationCappingDetails[key].Margin_OCC_Manufacturing_Stock__c - parseFloat(valuetoCompare) < difference){
                    difference = parseFloat(valuetoCompare) - $scope.creditScore.reccomendationCappingDetails[key].Margin_OCC_Manufacturing_Stock__c ;
                    index = key;
                }
            }else if(whatToCompare == 'OCC-RECIEVEABLE'){
                if($scope.creditScore.reccomendationCappingDetails[key].Margin_OCC_Manufacturing_Receivables__c - parseFloat(valuetoCompare) < difference){
                    difference = parseFloat(valuetoCompare) - $scope.creditScore.reccomendationCappingDetails[key].Margin_OCC_Manufacturing_Receivables__c ;
                    index = key;
                }
            }


        }
        console.log('Margin Deviation will go to '+$scope.creditScore.reccomendationCappingDetails[index].MasterLabel);
        if(index != -1){
            return 'Margin Deviation will go to '+$scope.creditScore.reccomendationCappingDetails[index].MasterLabel;
        }
        else{
            return 'No Margin Deviation';
        }

    }
    $scope.validateLowerMDAndCeoLimit = function(mdCeoMetadata,whatToCompare,valueToCompare){
        debugger;
        if(whatToCompare == 'SOD'){
            if(mdCeoMetadata.Margin_SOD__c > parseFloat(valueToCompare)){
                //
                swal({title:'Margin Exceeded',text:'Margin can not be less than '+mdCeoMetadata.Margin_SOD__c});
                return true;
            }
        }else if(whatToCompare == 'OCC-TRADING'){
            if(mdCeoMetadata.Margin_OCC_Trading_Stock__c > parseFloat(valueToCompare) ){
                swal({title:'Margin Exceeded',text:'Margin can not be less than '+mdCeoMetadata.Margin_OCC_Trading_Stock__c});
                return true;
               //
            }
        }else if(whatToCompare == 'OCC-MANUFACTURING'){
            if(mdCeoMetadata.Margin_OCC_Manufacturing_Stock__c  > parseFloat(valueToCompare)){
                swal({title:'Margin Exceeded',text:'Margin can not be less than '+mdCeoMetadata.Margin_OCC_Manufacturing_Stock__c});
                return true;
                //
            }
        }else if(whatToCompare == 'OCC-RECIEVEABLE'){
            if(mdCeoMetadata.Margin_OCC_Manufacturing_Receivables__c > parseFloat(valueToCompare)){
                swal({title:'Margin Exceeded',text:'Margin can not be less than '+mdCeoMetadata.Margin_OCC_Manufacturing_Receivables__c});
                return true;

            }
        }
        return false;
    }
    $scope.validateROI = function () {

        for(var key in $scope.saveData.facility){
            for(var i=0;i<$scope.creditScore.facilityList.length;i++) {

                if ($scope.creditScore.facilityList[i].Facilities__r != undefined) {

                    for (var j = 0; j < $scope.creditScore.facilityList[i].Facilities__r.records.length; j++) {
                        if($scope.creditScore.facilityList[i].Facilities__r.records[j].id == $scope.saveData.facility[key].Id){
                            /*if( $scope.saveData.facility[key].Recommended_Limit__c > $scope.creditScore.facilityList[i].Existing_Limit__c){
                                swal({title:'Limit Exceeded !!!!',text:'Recommended Limit can not exceed Exiting Limit'});
                                return true;
                            }else{
                                return false;
                            }*/
                            var existingrate  = ($scope.creditScore.facilityList[i].Existing_Spread__c != undefined ?$scope.creditScore.facilityList[i].Existing_Spread__c:0) + ($scope.creditScore.facilityList[i].MCLR_Rate__c != undefined ?$scope.creditScore.facilityList[i].MCLR_Rate__c:0);
                            var diff = existingrate - $scope.saveData.facility[key].Recommended_Rate__c ;
                            if($scope.saveData.facility[key].Product_Schematic__c == 'Yes'){
                                if( diff > 0.75 ){
                                    swal({title:'ROI Limit Exceeded',text:'For Schematic, ROI difference can not be greater than 0.75 %'});
                                    return true;
                                }/*else{
                                    return false;
                                }*/
                            }else if($scope.saveData.facility[key].Product_Schematic__c == 'No'){
                                if( diff > 2 ){
                                    swal({title:'ROI Limit Exceeded',text:'For Schematic, ROI difference can not be greater than 2 %'});
                                    return true;
                                }/*else{
                                    return false;
                                }*/
                            }

                        }

                    }
                }
            }


        }
        return false;

    }

    //Newly Added
    $scope.validateIfAllPartyHasMobileNo = function(){
        if($scope.sancProcess.missingPartyMobileList != undefined && $scope.sancProcess.missingPartyMobileList.length > 0 ){
            debugger;
            var liList='<div style="text-align:center"><ol>';
            for(var i=0;i<$scope.sancProcess.missingPartyMobileList.length;i++){
                liList +='<li >'+$scope.sancProcess.missingPartyMobileList[i]+'</li><br/>';
            }
            liList+='</ol></div>';
            swal({html:true,title:'',text:'Mobile Number is missing for below Parties: '+liList});
            return true;
        }
        else return false;
    }

})