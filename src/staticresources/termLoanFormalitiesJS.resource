/* termLoanFormalitiesJS */
var app=angular.module('termLoanFormalitiesApp', ['ui.bootstrap','ngScrollable']);

app.controller('LBctrl', function($scope,$log,$q){

    $scope.oneAtATime           = false;
    $scope.loader               = false;
    $scope.DealerNames          = [];
    $scope.DealerInfoList       = [];

    $scope.errorMessage         = '';
	$scope.isPageNonEditable    = !termLoanWrap.isPageNonEditable;
	$scope.appRecord            = termLoanWrap.appRecord;

	console.log($scope.isPageNonEditable);

	$scope.loanCats             = termLoanWrap.catOfLoanPicklistValues;

	$scope.dealerKyc            =termLoanWrap.pangstPicklistValues;
	$scope.landAndBulidingCollat= abc;
    $scope.isAllCollateralSaved = [];

	angular.forEach($scope.landAndBulidingCollat, function(key, value){
	       //$scope.isAllCollateralSaved.push({"COLLID":key.Id,"SAVED":false});
		    delete $scope.landAndBulidingCollat[value]['attributes'];
		    $scope.landAndBulidingCollat[value]['editable'] = false;
	});
  var  allStateList= JSON.parse((termLoanWrap.pvStateList).replace(/&quot;/g,'"'));
  $scope.stateList = allStateList.result;
  var  allMakeList= JSON.parse((termLoanWrap.pvMakeList).replace(/&quot;/g,'"'));
  $scope.allMakeList = allMakeList.result;
  $scope.cityList = [];
  $scope.allModelList = [];
  $scope.allVersionList =[];
  $scope.PVDealerNames =[];

  $scope.allTruckmakeList =[];
  $scope.allBuskmakeList =[];

  $scope.allTruckCityList =[];
  $scope.allBuskCityList =[];

  $scope.allBusdealerInfo =[];
  $scope.alltruckdealerInfo =[];


  $scope.allBusdealerName =[];
  $scope.alltruckdealerName =[];

  $scope.allBusdealerAddress =[];
  $scope.alltruckdealerAddress =[];

    $scope.editCollRec = function(item){
        if(item.editable == false){
            $scope.isAllCollateralSaved.push({"COLLID":item.Id,"SAVED":false});
            item.editable = true;
        }else{
            //$scope.isAllCollateralSaved.push({"COLLID":item.Id,"SAVED":true});
            item.editable = false;
        }

    }

    $scope.getCitiesForPV = function(stateId){
    debugger;
      console.log(stateId);
       $scope.loader = true;
      termLoanFormalitiesCntrl.getAllPVCityInfo(parseInt(stateId),function(result, event){
            //alert(result);
           
           if(result == 'API Failed'){
            swal({title:'Error',text:result});
             $scope.loader = false;
              $scope.$apply();
          }
           else if(result != null){
              var  allCitiesList= JSON.parse((result).replace(/&quot;/g,'"'));
              $scope.cityList =allCitiesList.result;
              console.log($scope.cityList);
              if($scope.cityList.length == 0){
                
                swal({title:'Error',text:'No City Exist'});
              }
              $scope.loader = false;
              $scope.$apply();
               
               
           }else{
                swal({title:'Error',text:'Some Error Occurred while fetching citeis'});
            }
        });
    }
    $scope.getModelForPV = function(makeId){
    debugger;
      console.log(makeId);
       $scope.loader = true;
      termLoanFormalitiesCntrl.getAllPVModelInfo(parseInt(makeId),function(result, event){
            //alert(result);
           
           if(result == 'API Failed'){
            swal({title:'Error',text:result});
             $scope.loader = false;
              $scope.$apply();
          }
           else if(result != null){
              var  allCitiesList= JSON.parse((result).replace(/&quot;/g,'"'));
              $scope.allModelList =allCitiesList.result;
              console.log($scope.allModelList);
              if($scope.allModelList.length == 0){
                
                swal({title:'Error',text:'No Model Exist'});
              }
              $scope.loader = false;
              $scope.$apply();
               
               
           }else{
                swal({title:'Error',text:'Some Error Occurred while fetching model'});
            }
        });
    }
    $scope.getVersionForPV = function(modelId){
    debugger;
      console.log(modelId);
       $scope.loader = true;
       modelId = '1029';
      termLoanFormalitiesCntrl.getAllPVVersionInfo(parseInt(modelId),function(result, event){
            //alert(result);
          if(result == 'API Failed'){
            swal({title:'Error',text:result});
             $scope.loader = false;
              $scope.$apply();
              return;
          }
           else if(result != null){
              var  allVersionList= JSON.parse((result).replace(/&quot;/g,'"'));
              $scope.allVersionList =allVersionList.result;
              console.log($scope.allVersionList);
              if($scope.allVersionList.length == 0){
                
                swal({title:'Error',text:'No Version Exist'});
              }
              $scope.loader = false;
              $scope.$apply();
               
               
           }else{
                swal({title:'Error',text:'Some Error Occurred while fetching version'});
            }
        });
    }
    $scope.getPriceForPV = function(versionId,CityId,item){
        debugger;
        console.log(versionId);
        $scope.loader = true;
        modelId = '1029';
      termLoanFormalitiesCntrl.getAllPVPriceInfo(parseInt(versionId),parseInt(CityId),function(result, event){
            //alert(result);
          if(result == 'API Failed'){
            swal({title:'Error',text:result});
             $scope.loader = false;
              $scope.$apply();
              return;
          }
           else if(result != null){
              var  priceList= JSON.parse((result).replace(/&quot;/g,'"'));
              if(priceList.result.length == 0){
                $scope.loader = false;
                $scope.$apply();
                swal({title:'Error',text:'Price List Could not be fetched'});
              }
              angular.forEach(priceList.result,function(key,value){
                 console.log(key);
                 console.log(value);
                 //$scope.DealerNames.push(key.firstname);
                 if(key.isMetallic){
                  console.log(key.pricesList);
                  angular.forEach(key.pricesList, function(key1, value1){
                  	        if(key1.name == 'Ex-Showroom Price'){
                                console.log(key1.value);
                                item.ExshowRoomPrice_Api__c = key1.value;
                            }else{
                                item.ExshowRoomPrice_Api__c = item.ExShow_Room_Price__c;
                                //item.ExshowRoomPrice_Api__c =
                            }
                            if(key1.name == 'RTO'){

                                console.log(key1.value);
                                if(key1.value < item.Registration_cost__c)
                                item.Registration_cost__c = key1.value;
                            }
                            if(key1.name == 'Insurance'){
                                //console.log(key1.value);
                            }
                  	});

                 }

             });

              
              $scope.loader = false;
              $scope.$apply();
               
               
           }else{
                swal({title:'Error',text:'Some Error Occurred while fetching version'});
            }
        });
    }
    $scope.getDealersForPV = function(makeId,CityId){
    debugger;
    //makeId ='8';
    //CityId='176';
      console.log(makeId);
       $scope.loader = true;
      termLoanFormalitiesCntrl.getAllPVDealerInfo(parseInt(makeId),parseInt(CityId),function(result, event){
            //alert(result);
          if(result == 'API Failed'){
            swal({title:'Error',text:result});
             $scope.loader = false;
              $scope.$apply();
              return;
          }
           else if(result != null){
              var  pvdealerList= JSON.parse((result).replace(/&quot;/g,'"'));
              if(pvdealerList.result.length == 0){
                $scope.loader = false;
                $scope.$apply();
                swal({title:'Error',text:'Dealer List Could not be fetched'});
              }
              angular.forEach(pvdealerList.result,function(key,value){
                 console.log(key);
                 console.log(value);
                 $scope.PVDealerNames.push(key.name);
                 

             });

              
              $scope.loader = false;
              $scope.$apply();
               
               
           }else{
                swal({title:'Error',text:'Some Error Occurred while fetching version'});
            }
        });
    }

	$scope.getDealerInfo = function(item){
        if(item.Collateral_Record_Type__c == 'Passenger_Vehicle' || item.Collateral_Record_Type__c == 'Commercial_Vehicle'){
            // pass make state and city
            if(item.clcommon__Make__c == undefined || item.clcommon__City__c == undefined){
                swal({title:'Error ',text:'Make and City is required'});
                //alert('Make and City is required');
                return;
            }else{
                $scope.loader = true;
               Visualforce.remoting.Manager.invokeAction(
                           "termLoanFormalitiesCntrl.getDealerInformationByMakeAndCity",item.clcommon__Make__c,item.clcommon__City__c ,
                           function(result, event) {
                               if(result != undefined){

                                   var object = JSON.parse(result.replace(/&quot;/g,'"'));
                                   //var contact = JSON.parse(object);
                                   console.log(object);

                                   $scope.DealerInfoList = object.result;

                                     angular.forEach($scope.DealerInfoList,function(key,value){
                                          console.log(key);
                                          console.log(value);
                                          $scope.DealerNames.push(key.name);

                                      });
                                      console.log('all filled');
                                      console.log($scope.DealerNames);
                                      $scope.loader = false;
                                      console.log('all filled');
                                      $scope.$apply();
                                     /*angular.forEach(contact,function(key,value){
                                         console.log(key);
                                         console.log(value);
                                         $scope.DealerNames.push(key.firstname);

                                     });*/
                                   //swal({title:'',text:result},function(isConfirm) {window.location.href    = '/'+$scope.creditScore.applicationInfo.Id;});
                               }
                           },
                           {escape: false} // No escaping, please
                );
            }

        }else{
            if(item.GST_PAN__c != undefined){
                if(item.GST_PAN__c == 'GST'){
                    if(item.Dealer_GST_Number__c != undefined){

                        debugger;
                        Visualforce.remoting.Manager.invokeAction(
                                   "termLoanFormalitiesCntrl.getGSTInformation",item.Dealer_GST_Number__c ,
                                   function(result, event) {
                                       if(result != undefined){
                                          console.log(result);
                                         var object = JSON.parse(result.replace(/&quot;/g,'"'));
                                           console.log(object);
                                           $scope.DealerNames = [];
                                           //item.Dealer_Address__c = object.pradr.addr.flno +' '+object.pradr.addr.bnm +' '+object.pradr.addr.st +' '+object.pradr.addr.dst +' '+object.pradr.addr.stcd ;
                                           item.Dealer_Address__c ='Some random Add ';
                                           $scope.DealerNames.push(object.tradeNam) ;
                                           $scope.$apply();
                                           /*var contact = JSON.parse(object);
                                           console.log(contact);

                                            $scope.DealerInfoList = contact;
                                            debugger;
                                            debugger;
                                            $scope.$apply();
                                           angular.forEach(contact,function(key,value){
                                               console.log(key);
                                               console.log(value);
                                               $scope.DealerNames.push(key.firstname);

                                           });*/
                                       }
                                   },
                                   {escape: false} // No escaping, please
                        );
                    }else{
                        swal({title:'Error',text:'GST is required'});

                        return;
                    }
                }else if(item.GST_PAN__c == 'PAN'){
                    debugger;
                    if(item.Dealer_PAN_Number__c != undefined){



                        Visualforce.remoting.Manager.invokeAction(
                                   "termLoanFormalitiesCntrl.getPANInformation",item.Dealer_PAN_Number__c ,
                                   function(result, event) {
                                       if(result != undefined){
                                                console.log(result);
                                                $scope.DealerNames = [];
                                                var object = JSON.parse(result.replace(/&quot;/g,'"'));
                                                /*var contact = JSON.parse(object);
                                                console.log(contact);*/
                                                if(object.firstName != undefined && object.lastName != undefined)
                                                $scope.DealerNames.push(object.firstName+' '+object.lastName) ;

                                                $scope.$apply();
                                             /*angular.forEach(contact,function(key,value){
                                                 console.log(key);
                                                 console.log(value);
                                                 $scope.DealerNames.push(key.firstname);

                                             });*/
                                       }
                                   },
                                   {escape: false} // No escaping, please
                        );
                    }else{
                        swal({title:'Error ',text:'PAN is required'});
                        //alert('PAN is required');
                        return;
                    }
                }
            }

        }


	}

	$scope.changeAddress = function(dealerName){
	    debugger;
	    $scope.DealerAdd =[];
	   angular.forEach($scope.DealerInfoList,function(key,value){

           if(key.name == dealerName){
               $scope.allAdd=key.addressDetails;
              angular.forEach($scope.allAdd,function(key,value){
                   $scope.DealerAdd.push(key.address);
              });
           }

           //$scope.DealerAdd ;

       });
    }

    $scope.saveCollInfo=function(item,index){
        // Delete
        /*if(saveCollInfo)*/
           var validateAllFieldValues = $scope.validateAllFieldValues(item);
           if(validateAllFieldValues){
               return;
           }
        delete item.Collateral_Record_Type__c_CHANGED;
        delete item.$$hashKey;
        delete item.Collateral_Record_Type__c;
        delete item.RecordType;

        termLoanFormalitiesCntrl.saveCollInformation(JSON.stringify(item),function(result, event){
            //alert(result);
           if(result == 'Collateral Information Saved Successfully'){
               swal({title:'Success',text:result});
               angular.forEach($scope.isAllCollateralSaved, function(key, value){
                    if(key.COLLID == item.Id){
                        key.SAVED = true;
                    }
               });
               //$scope.isAllCollateralSaved.push()
           }else{
                swal({title:'Error',text:result});
            }
        });

    }
    $scope.getGSTInfo = function(){

    	termLoanFormalitiesCntrl.getGSTInformation(function(result, event){
	      debugger;
        	// Get DOM IDs for HTML and Visualforce elements like this
	       console.log(result);
	       var object = JSON.parse(result.replace(/&quot;/g,'"'));
	       console.log(object);
	       var GSTData = JSON.parse(object);
	       $scope.DealerNames.push(GSTData.tradeNam);

	        debugger;
	        debugger;
	        $scope.$apply();
	        $scope.DealerAdd =[];
	        var addMerg= GSTData.pradr.addr.bnm+','+GSTData.pradr.addr.flno+','+GSTData.pradr.addr.bno+','+GSTData.pradr.addr.loc+','+GSTData.pradr.addr.st+','+GSTData.pradr.addr.bno+','+GSTData.pradr.addr.dst+','+GSTData.pradr.addr.stcd+','+GSTData.pradr.addr.city+','+','+GSTData.pradr.addr.pncd;
	        $scope.DealerAdd.push(addMerg);
	   });
	}


	$scope.getPANInfo = function(){
		termLoanFormalitiesCntrl.getPANInformation(function(result, event){
	      debugger;
        	// Get DOM IDs for HTML and Visualforce elements like this
	       console.log(result);
	       var object = JSON.parse(result.replace(/&quot;/g,'"'));
	       console.log(object);
	       var PANData = JSON.parse(object);
	       $scope.DealerNames.push(PANData.firstName+' '+PANData.middleName+' '+PANData.lastName);
	        debugger;
	        debugger;
	        $scope.$apply();
	        $scope.DealerAdd =[];
	   });

	}
	$scope.validateAllFieldValues = function(item){

	    $scope.errorMessage = '';
	    debugger;
        if(item.GST_PAN__c == undefined && (item.Collateral_Record_Type__c != 'Passenger_Vehicle' && item.Collateral_Record_Type__c != 'Commercial_Vehicle')){
            $scope.errorMessage = 'Please Fill Mandatory fields. Dealer GST/PAN is mandatory';
        }
        if(item.GST_PAN__c != undefined){
            if(item.GST_PAN__c == 'GST'){
                if(item.Dealer_GST_Number__c == undefined && (item.Collateral_Record_Type__c != 'Passenger_Vehicle' && item.Collateral_Record_Type__c != 'Commercial_Vehicle')){
                     $scope.errorMessage = 'Please Fill Mandatory fields. Dealer GST is mandatory';
                }
            }else if(item.GST_PAN__c == 'PAN'){
                if(item.Dealer_PAN_Number__c == undefined && (item.Collateral_Record_Type__c != 'Passenger_Vehicle' && item.Collateral_Record_Type__c != 'Commercial_Vehicle')){
                     $scope.errorMessage = 'Please Fill Mandatory fields. Dealer PAN is mandatory';
                }
                /*if(item.Dealer_PAN_Number__c == undefined && (item.Collateral_Record_Type__c != 'Passenger_Vehicle' && item.Collateral_Record_Type__c != 'Commercial_Vehicle')){
                     $scope.errorMessage = 'Please Fill Mandatory fields. Dealer PAN is mandatory';
                }*/
            }
        }


        if((item.Collateral_Record_Type__c == 'Commercial_Machinery' || item.Collateral_Record_Type__c == 'Construction_Equipment'  || item.Collateral_Record_Type__c == 'Other' )){

            if(item.Installation_Cost__c == undefined){
                $scope.errorMessage = 'Please Fill Mandatory fields. Installation Cost is mandatory';
            }else if(item.Machinery_Cost__c == undefined){
                $scope.errorMessage = 'Please Fill Mandatory fields. Machinery Cost is mandatory';
            }else if(item.Tax__c == undefined){
                $scope.errorMessage = 'Please Fill Mandatory fields. Tax is mandatory';
            }else if(item.Other_Cost__c == undefined){
                $scope.errorMessage = 'Please Fill Mandatory fields. Other Cost is mandatory';
            }

        }else if((item.Collateral_Record_Type__c == 'Commercial_Vehicle')){

            if(item.Tax__c == undefined){
            $scope.errorMessage = 'Please Fill Mandatory fields. Tax is mandatory';
            }

            if(item.Chassis_Cost__c == undefined){
                $scope.errorMessage = 'Please Fill Mandatory fields. Chassis Cost is mandatory';
            }

            if(item.Body_Building_Cost__c == undefined ){
                $scope.errorMessage = 'Please Fill Mandatory fields. Body Building Cost is mandatory';
            }
            if(item.Other_Cost__c == undefined){
                $scope.errorMessage = 'Please Fill Mandatory fields. Other Cost is mandatory';
            }
            if(item.Dealer_name__c == undefined ){
                $scope.errorMessage = 'Please Fill Mandatory fields. Dealer Name is mandatory';
            }

            if(item.Dealer_Address__c == undefined){
                $scope.errorMessage = 'Please Fill Mandatory fields. Dealer Address is mandatory';
            }
        }
        else if((item.Collateral_Record_Type__c == 'Passenger_Vehicle')){

            if(item.Registration_cost__c == undefined){
                $scope.errorMessage = 'Please Fill Mandatory fields. Registration Cost is mandatory';
            }

            if(item.clcommon__Insurance_Amount__c == undefined){
                $scope.errorMessage = 'Please Fill Mandatory fields. Insurance is mandatory';
            }

            if(item.ExShow_Room_Price__c == undefined ){
                $scope.errorMessage = 'Please Fill Mandatory fields. Ex-Show Room Price is mandatory';
            }
            if(item.Accessories_value__c == undefined){
                $scope.errorMessage = 'Please Fill Mandatory fields. Accessory Cost is mandatory';
            }


        }
        if(item.Dealer_name__c == undefined ){
            $scope.errorMessage = 'Please Fill Mandatory fields. Dealer Name is mandatory';
        }

        if(item.Dealer_Address__c == undefined){
            $scope.errorMessage = 'Please Fill Mandatory fields. Dealer Address is mandatory';
        }

        if($scope.errorMessage != ''){
            swal({title:'Error ',text:$scope.errorMessage});

            //alert($scope.errorMessage);
            return true;
        }else{
            return false;
        }
    }

    $scope.closeTask = function(){
        debugger;
        // code to check if all collateral has been saved
        var count =0;
        console.log($scope.isAllCollateralSaved.length);
        angular.forEach($scope.isAllCollateralSaved, function(key, value){
            if(key.SAVED == false){
                swal({title:'Error ',text:'All Collateral information has not been saved successfully. Please Make required changes on all collateral'});
                return;
            }else{
                count++;

            }

        });
        if(count == $scope.isAllCollateralSaved.length){
            termLoanFormalitiesCntrl.closeCLPCTask(termLoanWrap.appId,function(result, event){
                swal({title:'',text:result});
                window.location.reload();
                      //alert(result);
            });
        }



    }

    $scope.refferBack = function(){
        termLoanFormalitiesCntrl.refferBackByCLPC(termLoanWrap.appId,function(result, event){
                	      swal({title:'',text:result});
        });
    }
    /* Api Call For CVS*/
    $scope.getMakeForCvBusAndTruck = function(){

              termLoanFormalitiesCntrl.getAllTruckMakeInfo(function(result, event){
                    //alert(result);

                   if(result == 'API Failed'){

                        swal({title:'Error',text:result});
                        $scope.loader = false;
                        $scope.$apply();

                   }else if(result != null){
                      var  allTruckmakeList= JSON.parse((result).replace(/&quot;/g,'"'));
                      allTruckmakeList = allTruckmakeList.data.list;
                      $scope.allTruckmakeList = allTruckmakeList;

                      $scope.$apply();


                   }else{
                        swal({title:'Error',text:'Some Error Occurred while fetching Truck Make'});
                    }
              });
              termLoanFormalitiesCntrl.getAllBUSMakeInfo(function(result, event){
                      //alert(result);

                     if(result == 'API Failed'){

                          swal({title:'Error',text:result});
                          $scope.loader = false;
                          $scope.$apply();

                     }else if(result != null){
                        var  allBuskmakeList= JSON.parse((result).replace(/&quot;/g,'"'));
                        allBuskmakeList = allBuskmakeList.data.list;
                        $scope.allBuskmakeList = allBuskmakeList;

                        $scope.$apply();


                     }else{
                          swal({title:'Error',text:'Some Error Occurred while fetching Bus Make'});
                      }
              });
    }
    $scope.getMakeForCvBusAndTruck();
    $scope.getCityCV = function(make,truckorBus){
        debugger;
        if(truckorBus == 'TRUCK'){
            $scope.loader = true;
            termLoanFormalitiesCntrl.getAllTruckCityInfo(make,function(result, event){
                  //alert(result);

                 if(result == 'API Failed'){

                      swal({title:'Error',text:result});
                      $scope.loader = false;
                      $scope.$apply();

                 }else if(result != null){
                    var  allTruckCityList= JSON.parse((result).replace(/&quot;/g,'"'));
                    if(allBuskCityList.data.length != 0){
                        allTruckCityList = allTruckCityList.data;
                        $scope.allTruckCityList = allTruckCityList;
                        $scope.loader = false;
                        $scope.$apply();
                    }else{
                         swal({title:'Error',text:'Can not find any city for this  make'});
                         $scope.loader = false;
                         $scope.$apply();
                    }



                 }else{
                      swal({title:'Error',text:'Some Error Occurred while fetching City Info'});
                      $scope.loader = false;
                      $scope.$apply();
                  }
             });
        }else if(truckorBus == 'BUS'){
            $scope.loader = true;
            termLoanFormalitiesCntrl.getAllBUSCityInfo(make,function(result, event){
                  //alert(result);

                 if(result == 'API Failed'){

                      swal({title:'Error',text:result});
                      $scope.loader = false;
                      $scope.$apply();

                 }else if(result != null){
                    var  allBuskCityList= JSON.parse((result).replace(/&quot;/g,'"'));
                    if(allBuskCityList.data.length != 0){
                        allBuskCityList = allBuskCityList.data;

                        $scope.allBuskCityList = allBuskCityList;
                        $scope.loader = false;
                        $scope.$apply();
                    }else{
                        swal({title:'Error',text:'Can not find any city for this  make'});
                        $scope.loader = false;
                        $scope.$apply();
                    }



                 }else{
                      swal({title:'Error',text:'Some Error Occurred while fetching City Info'});
                      $scope.loader = false;
                      $scope.$apply();
                  }
             });
        }
    }
    $scope.getCVModel = function(make,truckorBus){
            debugger;
            if(truckorBus == 'TRUCK'){
                $scope.loader = true;
                termLoanFormalitiesCntrl.getAllTruckModelInfo(make,function(result, event){
                      //alert(result);

                     if(result == 'API Failed'){

                          swal({title:'Error',text:result});
                          $scope.loader = false;
                          $scope.$apply();

                     }else if(result != null){
                        var  allTruckModelList= JSON.parse((result).replace(/&quot;/g,'"'));
                        if(allTruckModelList.data.length != 0){
                            allTruckModelList = allTruckModelList.data;
                            $scope.allTruckModelList = allTruckModelList;
                            $scope.loader = false;
                            $scope.$apply();
                        }else{
                             swal({title:'Error',text:'Can not find any model for this  make'});
                             $scope.loader = false;
                             $scope.$apply();
                        }



                     }else{
                          swal({title:'Error',text:'Some Error Occurred while fetching model Info'});
                          $scope.loader = false;
                          $scope.$apply();
                      }
                 });
            }else if(truckorBus == 'BUS'){
                $scope.loader = true;
                termLoanFormalitiesCntrl.getAllBUSModelInfo(make,function(result, event){
                      //alert(result);

                     if(result == 'API Failed'){

                          swal({title:'Error',text:result});
                          $scope.loader = false;
                          $scope.$apply();

                     }else if(result != null){
                        var  allBusModelList= JSON.parse((result).replace(/&quot;/g,'"'));
                        if(allBusModelList.data.length != 0){
                            allBusModelList = allBusModelList.data;

                            $scope.allBusModelList = allBusModelList;
                            $scope.loader = false;
                            $scope.$apply();
                        }else{
                            swal({title:'Error',text:'Can not find any city for this  make'});
                            $scope.loader = false;
                            $scope.$apply();
                        }



                     }else{
                          swal({title:'Error',text:'Some Error Occurred while fetching City Info'});
                          $scope.loader = false;
                          $scope.$apply();
                      }
                 });
            }
        }
        $scope.getCVVarient = function(make,model,truckorBus){
            debugger;
            if(truckorBus == 'TRUCK'){
                $scope.loader = true;
                termLoanFormalitiesCntrl.getAllTruckVariantInfo(make,model,function(result, event){
                      //alert(result);

                     if(result == 'API Failed'){

                          swal({title:'Error',text:result});
                          $scope.loader = false;
                          $scope.$apply();

                     }else if(result != null){
                        var  allCVTruckVarient= JSON.parse((result).replace(/&quot;/g,'"'));
                        if(allCVTruckVarient.data.length != 0){
                            allCVTruckVarient = allCVTruckVarient.data;
                            $scope.allCVTruckVarient = allCVTruckVarient;
                            $scope.loader = false;
                            $scope.$apply();
                        }else{
                             swal({title:'Error',text:'Can not find any varient for this  make and model selection'});
                             $scope.loader = false;
                             $scope.$apply();
                        }



                     }else{
                          swal({title:'Error',text:'Some Error Occurred while fetching varient Info'});
                          $scope.loader = false;
                          $scope.$apply();
                      }
                 });
            }else if(truckorBus == 'BUS'){
                $scope.loader = true;
                termLoanFormalitiesCntrl.getAllBUSVariantInfo(make,model,function(result, event){
                      //alert(result);

                     if(result == 'API Failed'){

                          swal({title:'Error',text:result});
                          $scope.loader = false;
                          $scope.$apply();

                     }else if(result != null){
                        var  allCVBusVarient= JSON.parse((result).replace(/&quot;/g,'"'));
                        if(allCVBusVarient.data.length != 0){
                            allCVBusVarient = allCVBusVarient.data;

                            $scope.allCVBusVarient = allCVBusVarient;
                            $scope.loader = false;
                            $scope.$apply();
                        }else{
                            swal({title:'Error',text:'Can not find any varient for this  make and model selection'});
                            $scope.loader = false;
                            $scope.$apply();
                        }



                     }else{
                          swal({title:'Error',text:'Some Error Occurred while fetching varient Info'});
                          $scope.loader = false;
                          $scope.$apply();
                      }
                 });
            }
        }

    $scope.getDealerInfoForCV = function(truckorBus,make,city){
        debugger;
            debugger;
            $scope.loader = true;
            if(truckorBus == 'TRUCK'){
                $scope.loader = true;
                termLoanFormalitiesCntrl.getAllTruckDealerInfo(make,city,function(result, event){
                      //alert(result);

                     if(result == 'API Failed'){

                          swal({title:'Error',text:result});
                          $scope.loader = false;
                          $scope.$apply();

                     }else if(result != null){
                        var  alltruckdealerInfo= JSON.parse((result).replace(/&quot;/g,'"'));
                        alltruckdealerInfo = alltruckdealerInfo.data.dealers;

                        if(alltruckdealerInfo.length >0){
                            $scope.alltruckdealerInfo = alltruckdealerInfo;

                            angular.forEach(alltruckdealerInfo,function(key,value){
                               console.log(key);
                               console.log(value);
                               $scope.alltruckdealerName.push(key.name);

                           });
                           $scope.loader = false;
                           $scope.$apply();
                        }



                     }else{
                          swal({title:'Error',text:'Some Error Occurred while fetching  Dealer info for selected make and city'});
                          $scope.loader = false;
                          $scope.$apply();
                      }
                 });
            }else if(truckorBus == 'BUS'){
                $scope.loader = true;
                termLoanFormalitiesCntrl.getAllBUSDealerInfo(make,city,function(result, event){
                      //alert(result);

                     if(result == 'API Failed'){

                          swal({title:'Error',text:result});
                          $scope.loader = false;
                          $scope.$apply();

                     }else if(result != null){
                        var  allCVBusDealerinfo= JSON.parse((result).replace(/&quot;/g,'"'));
                        allCVBusDealerinfo = allCVBusDealerinfo.data.dealers;

                        if(allCVBusDealerinfo.length >0){
                            $scope.allBusdealerInfo = allCVBusDealerinfo;

                            angular.forEach(allCVBusDealerinfo,function(key,value){
                               console.log(key);
                               console.log(value);
                               $scope.allBusdealerName.push(key.name);

                           });
                           $scope.loader = false;
                           $scope.$apply();
                        }


                     }else{
                          swal({title:'Error',text:'Some Error Occurred while fetching  Dealer info for selected make and city'});
                          $scope.loader = false;
                          $scope.$apply();
                      }
                 });
            }
        }
        $scope.changeCvdealerAdd = function(truckOrBus,dealername){

            if(truckOrBus == 'TRUCK'){
                angular.forEach($scope.alltruckdealerInfo,function(key,value){
                    if(key.name == dealername){
                        angular.forEach(key.addressDetails,function(addkey,addvalue){
                           $scope.alltruckdealerAddress.push(addkey.address);
                        });
                    }

               });
            }else if(truckOrBus == 'BUS'){
                angular.forEach($scope.allBusdealerInfo,function(key,value){
                    if(key.name == dealername){
                        angular.forEach(key.addressDetails,function(addkey,addvalue){
                           $scope.allBusdealerAddress.push(addkey.address);
                        });
                    }

               });
            }
        }

        $scope.fillValuesForCV = function(item,truckOrBus){
            debugger;
            if(truckOrBus == 'BUS'){

                 angular.forEach($scope.allCVBusVarient,function(key,value){
                    if(key.variantLinkRewrite == item.Variant__c){
                        //item.Variant__c = key.name;
                        if(key.variantBodyType != undefined){
                            item.Commercial_Vehicle_Category__c = key.variantBodyType;
                        }
                        if(key.variantPrice != undefined){
                            item.ExshowRoomPrice_Api__c = key.variantPrice;
                        }else{
                            item.ExshowRoomPrice_Api__c = item.Body_Building_Cost__c + item.Chassis_Cost__c;
                        }
                    }
                 });
            }else if(truckOrBus=='TRUCK'){
                angular.forEach($scope.allCVTruckVarient,function(key,value){
                    if(key.variantLinkRewrite == item.Variant__c){
                        //item.Variant__c = key.name;
                        if(key.variantBodyType != undefined){
                            item.Commercial_Vehicle_Category__c = key.variantBodyType;
                        }
                        if(key.variantPrice != undefined){
                            item.ExshowRoomPrice_Api__c = key.variantPrice;
                        }else{
                            item.ExshowRoomPrice_Api__c = item.Body_Building_Cost__c + item.Chassis_Cost__c;
                        }
                    }
                 });
            }
        }
        


});



app.filter('groupBy', function(){
		return function(list, group_by) {

		var filtered = [];
		var prev_item = null;
		var group_changed = false;
		// this is a new field which is added to each item where we append "_CHANGED"
		// to indicate a field change in the list
		var new_field = group_by + '_CHANGED';

		// loop through each item in the list
		angular.forEach(list, function(item) {

			group_changed = false;

			// if not the first item
			if (prev_item !== null) {

				// check if the group by field changed
				if (prev_item[group_by] !== item[group_by]) {
					group_changed = true;
				}

			// otherwise we have the first item in the list which is new
			} else {
				group_changed = true;
			}

			// if the group changed, then add a new field to the item
			// to indicate this
			if (group_changed) {
				item[new_field] = true;
			} else {
				item[new_field] = false;
			}

			filtered.push(item);
			prev_item = item;

		});

		return filtered;
		};

	})