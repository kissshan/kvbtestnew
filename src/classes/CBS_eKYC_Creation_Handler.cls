public class CBS_eKYC_Creation_Handler{
	public String exe_tenantId;	//cuecent_tenant
	public String owner_tenantId;	//cuecent_tenant
	public cls_inputVariables inputVariables;
	public class cls_inputVariables {
		public cls_in_msg in_msg;
	}
	public class cls_in_msg {
		public String ApplicationId;
        public String serviceName; //EKYCUpdation_HL
        public EKYCDetails[] EKYCDetails;
	}
    public class EKYCDetails{
        public String ApplicantID;        
        public String PrimaryPassword;	//
		public String BankCode;	//53
		public String ExternalBatchNumber;	//
		public String ExternalReferenceNo;	//
		public String ExternalSystemAuditTrailNumber;	//
		public String LocalDateTimeText;	//
		public String OriginalReferenceNo;	//
		public String OverridenWarnings;	//
		public String PostingDateText;	//
		public String ServiceCode;	//
		public String SessionTicket;	//
		public String TransactionBranch;	//9999
		public String UserId;	//SYSTEM01
		public String UserReferenceNumber;	//
		public String ValueDateText;	//
		public String CodCustIc;	//KS00091
		public String FlgCustTyp;	//R
		public String CodCustId;	//
		public String CodCustUniqueId;	//538714064339
		public String FlgPanCard;	//Y
		public String CodPanCard;	//CMUPK3245D
		public String FlgVoterId;	//N
		public String CodVoterId;	//
		public String FlgPassport;	//N
		public String CodPassport;	//
		public String FlgDriveLiscense;	//N
		public String CodDriveLiscense;	//
		public String FlgNatIdCard;	//N
		public String CodNatIdCard;	//
		public String FlgLetterRecogAuth;	//N
		public String CodLetterRecogAuth;	//
		public String FlgOthers;	//N
		public String CodOthers;	//
		public String FlgPhotoObtained;	//Y
		public String DatPhotoObtained;	//07/11/2014
		public String DatCustIdData;	//07/11/2014
		public String CodCustRiskCat;	//3
		public String DatRiskCatReview;	//07/11/2014
		public String CodReasonRiskCat;	//
		public String FlgTeleBillIndiv;	//Y
		public String FlgBankStmtIndiv;	//Y
		public String FlgLtrRcgAuthInd;	//Y
		public String FlgElecBillIndiv;	//N
		public String FlgRationCardIndiv;	//N
		public String FlgEmpLetterIndiv;	//N
		public String CodOtherDocindiv;	//
		public String FlgSameIdProofIndiv;	//N
		public String FlgIncorpCertifComp;	//N
		public String FlgMoaComp;	//N
		public String FlgAoaComp;	//N
		public String FlgBodResolutionComp;	//N
		public String FlgPoaDocumentComp;	//N
		public String FlgTelephoneBillComp;	//N
		public String FlgPancrdAltLetComp;	//N
		public String CodOtherDocComp;	//2
		public String FlgRegisterCertifPf;	//N
		public String FlgPartnershipDeedPf;	//N
		public String FlgPoaDocumentPf;	//N
		public String CodOffValidDocPf;	//3
		public String FlgTelephoneBillPf;	//N
		public String FlgRegisterCertifTf;	//N
		public String FlgPoaDocumentTf;	//N
		public String CodOffValidDocTf;	//4
		public String FlgResolMangBodyTf;	//N
		public String FlgTelephoneBillTf;	//N
		public String FlgTelBillOthers;	//N
		public String FlgElecBillOthers;	//N
		public String FlgRegCertifOthers;	//N
		public String CodOtherDocOthers;	//162
		public String ThresholdPct;	//50
		public String FlgThresholdAlert;	//Y
		public String AnualTurnOver;	//7896325
		public String FormStatus;	//
		public String FlgEkyc;	//Y
		public String EkycRefNo;	//24701708154
        public String channel;	//        
    }
    
    //Response structure
    public class CBS_eKYC_Response{
        public String bpms_error_code;	//00
        public cls_out_msg out_msg;
        public String bpms_error_msg;
    }
    public class cls_out_msg {
        public String Status_Desc;
        public String Status_Code;
    }
}