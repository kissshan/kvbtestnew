public class SME_TL_GL_ImplementationRequest {

    public String exe_tenantId;
    public String owner_tenantId;
    public inputvar inputVariables;
    
    public class inputvar{
        public inmsg in_msg;
        
    }
    
    public class inmsg{
        
        
        public String ReconNo;
        public String BranchCode;
    }
}