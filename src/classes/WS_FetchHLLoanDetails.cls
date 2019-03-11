/*
* Name    : WS_FetchHLLoanDetails
* Company : ET Marlabs
* Purpose : This class is used to fetch and update Existing HL Loan details from CBS
* Author  : Braj Mohan
* CreatedDate  : 22-Jan-2019
*******************************************************************************************/
global class WS_FetchHLLoanDetails {
    
    public class cls_Response {
        public String status = Constants.WS_SUCCESS_STATUS;
        public String statusCode = Constants.WS_SUCCESS_CODE;
        public String errorMessage = '';
        public String successMessage = '';
        public Application_Response applicationDetails;
    }
    
    public class Application_Response{
        public String branchCode = '';
        public String branchName = '';
        public String branchCity = '';
        public String branchState = '';
    }

	public static cls_Response fetchLoanDetails(string loanAccNo,string facilityId, string appId) {
		System.debug('FetchLoanDetails***');
		WS_FetchHLLoanDetails.CBS_FetchHLLoanDetails cbs = new WS_FetchHLLoanDetails.CBS_FetchHLLoanDetails();
		if (loanAccNo != null) {
	        cbs.inputVariables = new WS_FetchHLLoanDetails.cls_inputVariables();
	        WS_FetchHLLoanDetails.cls_inputVariables cbsInput = new WS_FetchHLLoanDetails.cls_inputVariables();
	        cbsInput.in_msg = new WS_FetchHLLoanDetails.cls_in_msg();
	        cbs.inputVariables = cbsInput;
	        cbs.exe_tenantId = 'cuecent_tenant';
	        cbs.owner_tenantId = 'cuecent_tenant';
	        cbsInput.in_msg.LoanAccountNumber = loanAccNo;
		}

        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Fetch_HLLoanDetails');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,JSON.serialize(cbs),headerMap,label.CA_CERTIFICATE);   
        System.debug('#####'+response);
        System.debug('$$$$'+response.getBody());
        cls_Response res = new cls_Response();
		try {
	        If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonResponseString = response.getBody();
                CBS_HLLoanDetails_Response resps = (CBS_HLLoanDetails_Response)Json.deserialize(jsonResponseString,CBS_HLLoanDetails_Response.class);
                if (resps.out_msg != null && resps.out_msg.ErrorMessage == 'Success') {
	                Application_Response applnDetails = new Application_Response();
	                applnDetails = saveLoanDetails(resps,facilityId,appId);
	                res.applicationDetails = applnDetails;
                } else if (resps.out_msg != null) {
                	res.status          = 'ERROR';
		            res.statusCode  	= resps.out_msg.ErrorCode;
		            res.errorMessage  	= resps.out_msg.ErrorMessage;
                }
	            return res;
	        } else {
		        res.status          = 'ERROR';
	            res.statusCode  	= string.valueOf(response.getStatusCode());
	            res.errorMessage  	= string.valueOf(response.getStatus());
	            return res;
	        }
		} catch(Exception e) {
			System.debug('WS_FetchHLLoanDetails >>> '+e.getLineNumber()+e.getMessage());
	        res.status          = 'ERROR';
            res.statusCode  	= string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
            res.errorMessage  	= e.getMessage();
            return res;
		}
	}

	public static Application_Response saveLoanDetails(CBS_HLLoanDetails_Response res,String facilityId, String appId){
		System.debug('appId >>> '+appId);
		System.debug('facilityId >>> '+facilityId);
		if (res.out_msg != null) {
			Facility__c ft = new Facility__c();
			clcommon__Collateral__c coll = new clcommon__Collateral__c();
			Application_Response applnWrap = new Application_Response();

			//Application
			if (res.out_msg.ApplicationDetails !=null) {
				if(!Utility.ISStringBlankorNull(res.out_msg.ApplicationDetails.branchCode))
					applnWrap.branchCode = res.out_msg.ApplicationDetails.branchCode;
				if(!Utility.ISStringBlankorNull(res.out_msg.ApplicationDetails.branchName))
					applnWrap.branchName = res.out_msg.ApplicationDetails.branchName;
				if(!Utility.ISStringBlankorNull(res.out_msg.ApplicationDetails.branchCity))
					applnWrap.branchCity = res.out_msg.ApplicationDetails.branchCity;
				if(!Utility.ISStringBlankorNull(res.out_msg.ApplicationDetails.branchState))
					applnWrap.branchState = res.out_msg.ApplicationDetails.branchState;
			}
            
			//Facility
			if (res.out_msg.FacilityDetails !=null) {
				if(!Utility.ISStringBlankorNull(res.out_msg.FacilityDetails.OutstandingBalance))
					ft.Existing_HL_Oustanding_Balance__c = Decimal.Valueof(res.out_msg.FacilityDetails.OutstandingBalance);
				if(!Utility.ISStringBlankorNull(res.out_msg.FacilityDetails.OutstandingTenure))
					ft.Existing_HL_Outstanding_Tenure__c = Decimal.Valueof(res.out_msg.FacilityDetails.OutstandingTenure);
				if(!Utility.ISStringBlankorNull(res.out_msg.FacilityDetails.SanctionedTenure))
					ft.Existing_HL_Sanctioned_Tenure__c = Decimal.Valueof(res.out_msg.FacilityDetails.SanctionedTenure);
			}

			//Collateral
			if (res.out_msg.CollateralDetails != null && res.out_msg.CollateralDetails.size() > 0){
				if(!Utility.ISStringBlankorNull(res.out_msg.CollateralDetails[0].CollateralID))
					coll.CBS_Collateral_ID__c = res.out_msg.CollateralDetails[0].CollateralID;
				if(!Utility.ISStringBlankorNull(res.out_msg.CollateralDetails[0].OriginalValue))
					coll.Cost_Of_Flat_House__c = Decimal.Valueof(res.out_msg.CollateralDetails[0].OriginalValue);
				if(!Utility.ISStringBlankorNull(res.out_msg.CollateralDetails[0].DatLastValuation))
					coll.Valuation_Date__c = Date.Valueof(res.out_msg.CollateralDetails[0].DatLastValuation);
				if(!Utility.ISStringBlankorNull(res.out_msg.CollateralDetails[0].TotalArea))
					coll.Area_of_the_Land__c = Decimal.Valueof(res.out_msg.CollateralDetails[0].TotalArea);
				if(!Utility.ISStringBlankorNull(res.out_msg.CollateralDetails[0].TypeofProperty))
					coll.Nature_of_Property__c = res.out_msg.CollateralDetails[0].TypeofProperty;
					
				if(!Utility.ISStringBlankorNull(res.out_msg.CollateralDetails[0].PROPERTY_CITY))
					coll.clcommon__City__c = res.out_msg.CollateralDetails[0].PROPERTY_CITY;
				if(!Utility.ISStringBlankorNull(res.out_msg.CollateralDetails[0].PROP_PIN))
					coll.Property_Pincode__c = res.out_msg.CollateralDetails[0].PROP_PIN;
				if(!Utility.ISStringBlankorNull(res.out_msg.CollateralDetails[0].PROPERTY_STATE))
					coll.State__c = res.out_msg.CollateralDetails[0].PROPERTY_STATE;
				if(!Utility.ISStringBlankorNull(res.out_msg.CollateralDetails[0].PROPERTY_LANDMARK))
					coll.Landmark__c = res.out_msg.CollateralDetails[0].PROPERTY_LANDMARK;
				if(!Utility.ISStringBlankorNull(res.out_msg.CollateralDetails[0].PROPERTY_DISTRICT))
					coll.District_Name__c = res.out_msg.CollateralDetails[0].PROPERTY_DISTRICT;
				if(!Utility.ISStringBlankorNull(res.out_msg.CollateralDetails[0].PROP_AGE))
					coll.Age_Of_The_Building__c = Decimal.valueOf(res.out_msg.CollateralDetails[0].PROP_AGE);
				if(!Utility.ISStringBlankorNull(res.out_msg.CollateralDetails[0].PROP_HOUSENO))
					coll.Flat_Door_Shop_Bungalow_Nos__c = res.out_msg.CollateralDetails[0].PROP_HOUSENO;
				if(!Utility.ISStringBlankorNull(res.out_msg.CollateralDetails[0].PROPERTY_AREA))
					coll.TalukaTehsil__c = res.out_msg.CollateralDetails[0].PROPERTY_AREA;
					
				String PropertyAddress = (res.out_msg.CollateralDetails[0].PROPERTY_ADDRESS1 != null ? res.out_msg.CollateralDetails[0].PROPERTY_ADDRESS1 : '') + (res.out_msg.CollateralDetails[0].PROPERTY_ADDRESS2 != null ? res.out_msg.CollateralDetails[0].PROPERTY_ADDRESS2 : '') + (res.out_msg.CollateralDetails[0].PROPERTY_ADDRESS3 != null ? res.out_msg.CollateralDetails[0].PROPERTY_ADDRESS3 : '');
				System.debug('PropertyAddress>>> '+PropertyAddress);
				coll.Property_Address__c = PropertyAddress;
			}
			
			if (appId != null){
				coll.genesis__Application__c = appId;
				coll.clcommon__Collateral_Name__c = WS_UpdatemandatoryFieldsAcc.getRandomExternalIdForCollateral();
				insert coll;
			}
			
			if (facilityId != null) {
				ft.Id = facilityId;
				ft.Selected_for_Top_Up__c = true;
				update ft;
			}
            return applnWrap;
		}
        return null;
	}

	public class CBS_HLLoanDetails_Response{
        public HLLoanDetails out_msg;
        public String bpms_error_code;  //0
        public String bpms_error_msg;   //Success
    }

	public class HLLoanDetails{
		public cls_Application ApplicationDetails;
		public cls_Facility FacilityDetails;
		public cls_Collateral[] CollateralDetails;
		public String ErrorCode ;//0
		public String ErrorMessage ;//Success
	}

	public class cls_Application{
        public String branchCode = '';
        public String branchName = '';
        public String branchCity = '';
        public String branchState = '';
    }

	public class cls_Facility{
		public String OutstandingBalance = '';//4719931.24
		public String OutstandingTenure = '';//74
		public String SanctionedTenure = '';//84
	}

	public class cls_Collateral{
		public String CollateralID = '';//1697753489
		public String CollateralCode = '';//107
		public String TypeofCharge = '';//1
		public String OriginalValue = '';//1750000
		public String LastValue = '';//1750000
		public String MarketValue = '';//1750000
		public String DatOrginalValuation = '';//2014-04-16
		public String DatLastValuation = '';//2014-04-16
		public String DeedDetails = '';//804/2012 DT:06/02/2012
		public String Location = '';//PUDHUPALAYAM
		public String AreaUnit = '';//SQ FT
		public String TotalArea = '';//1188
		public String TypeofProperty = '';//1
		public String DescriptionProp1 = '';//1697753489 HSL
		public String DescriptionProp2 = '';//null

		public String PROPERTY_ADDRESS1 = '';
        public String PROPERTY_CITY = '';
        public String PROP_PIN = '';
        public String PROPERTY_ADDRESS2 = '';
        public String PROP_COMPLETION = '';
        public String PROPERTY_ADDRESS3 = '';
        public String PROPERTY_STATE = '';
        public String PROPERTY_LANDMARK = '';
        public String PROPERTY_DISTRICT = '';
        public String PROP_AGE = '';
        public String PROP_HOUSENO = '';
        public String PROPERTY_AREA = '';
	}

	public class CBS_FetchHLLoanDetails{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public cls_inputVariables inputVariables;
    }

    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }

    public class cls_in_msg {
        public String LoanAccountNumber;
    }
}