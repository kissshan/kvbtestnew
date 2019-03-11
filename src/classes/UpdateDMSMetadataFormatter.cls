/*
* Name          : UpdateDMSMetadata
* Description   : Structure for updating metadata to DMS
* Author        : Laxman
*/
public class UpdateDMSMetadataFormatter {
   public updateMetadataReq[] updateMetadataReq; 
    /* DocumentProcess Req and Res- Start */
    public class updateMetadataReq{
        public Integer uuid; 
        public metadataProps properties;      
    }
    public class metadataProps{
        public String applicationType;
        public String applicationId;
        public String customerId;
        public String documentType;
        public String accountNumbers;
    }
    public class updateMetadataRes{
        public Integer status;
        public Data data;
        public String errorMessage;
        public Integer errorCode;
    }
    public class Data {
		public List<String> Failed_ErrorMsg;
		public List<Integer> Failed_UUID;
		public List<Integer> Success_UUID;
	}
}