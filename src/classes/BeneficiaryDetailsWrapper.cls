global class BeneficiaryDetailsWrapper{

  public String exe_tenantId;
    public String owner_tenantId;
    public inputvar inputVariables;
    
    public class inputvar{
        public inmsg in_msg;
        
    }
    
    public class inmsg{
        
        
        public String Transaction_Ref_Number;
        public String Mode_Of_Payment;
    }

}