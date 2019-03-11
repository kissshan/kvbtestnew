@isTest
public class Test_MIS_Update_Handler {
@isTest
    public static void methodMisUpdateHandler(){
      //  MIS_Update_Handler.cls_bpms_error_msg errMsg = null;
     //   MIS_Update_Handler.cls_out_msg outMsg = null;
        
        MIS_Update_Handler.MIS_Update_Response updateResp = new MIS_Update_Handler.MIS_Update_Response();
        updateResp.bpms_error_code = 'str123';
        updateResp.bpms_error_msg = null;
        updateResp.out_msg = null;
       
        MIS_Update_Handler.cls_in_msg clsInMsg = new MIS_Update_Handler.cls_in_msg();
        clsInMsg.AssetOwnership = 'Str12';
        clsInMsg.BankingActivities = 'st123';
        clsInMsg.BSRActivityCode = '9';
        clsInMsg.CategoryOfBorrowers = '99';
        clsInMsg.CheckerID = 'LAPSCHECKER';
        clsInMsg.CreditCardDetails = null;
        clsInMsg.ExportDocType = null;
        clsInMsg.ExportStatusHolder = null;
        clsInMsg.InvestmentPreference = null;
        clsInMsg.LoanDetails = null;
        clsInMsg.MakerID = 'LAPSMAKER';
        clsInMsg.Mnemonic = '1152753000002664';
        clsInMsg.MonthlyHouseHoldIncome = null;
        clsInMsg.NoOfDependents = null;
        clsInMsg.Nostro = 'NO_NOSTRO';
        clsInMsg.Occupation = '95019';
        clsInMsg.PresentLoanRequirements = null;
        clsInMsg.PrioritySectorCode = '517';
        clsInMsg.RBIPurpose = '99999';
        clsInMsg.ResidenceDetails = null;
        clsInMsg.Security = '19';
        clsInMsg.SelectedSecurityCode = '99';
        clsInMsg.SpouseIncome = null;
        
        MIS_Update_Handler.cls_inputVariables clsInputvar = new MIS_Update_Handler.cls_inputVariables();
        clsInputvar.in_msg = clsInMsg;
        
        MIS_Update_Handler misUpdateHandler = new MIS_Update_Handler();
        misUpdateHandler.owner_tenantId = 'cuecent_tenant';
        misUpdateHandler.exe_tenantId = 'cuecent_tenant';
        misUpdateHandler.inputVariables = clsInputvar;
    }
}