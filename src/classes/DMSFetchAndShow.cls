public class DMSFetchAndShow {
    public Transient String pdfContent{get;set;}
    public Transient Blob blobPdfContent{get;set;}
    public Transient String uuId = '';
    public Transient String verId = '';
    
    public DMSFetchAndShow() {
        uuId = ApexPages.currentPage().getParameters().get('uuid');
        verId = ApexPages.currentPage().getParameters().get('verId');
        blobPdfContent = DMS_Service_Handler.getDocById(uuid,'1');
        pdfContent = String.valueOf(blobPdfContent);    
    }
    public String pdf {
        get {
            return EncodingUtil.Base64Encode(blobPdfContent);
        }
    }
    public String pdfpdf {
        get {
            return EncodingUtil.Base64Encode(blobPdfContent);
        }
    }    
}