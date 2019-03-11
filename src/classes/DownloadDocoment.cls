/*
* Name          : DownloadDocoment
* Description   : WS Class to create Digio Doc Download request
* Author        : Amritesh
*/ 
public class DownloadDocoment {
    public class DOC_Request{
        public String exe_tenantId;// = 'cuecent_tenant'
        public String owner_tenantId;
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables{
        public String in_msg;
        public String documentId;
        //public cls_inputVariables(){}
    }
}