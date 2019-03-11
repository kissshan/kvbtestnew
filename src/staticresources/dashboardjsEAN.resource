var app=angular.module('dashboadrdApp', ['ngRoute','ngAnimate','ngScrollable']);

app.controller('dashboadrdCtrl', function($scope, $timeout, $window, $location ){
	$scope.show =[];
    $scope.isFlags = [];
    $scope.showExposure =false;
    $scope.riskUser = riskUser;
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
    alert('AA');

});