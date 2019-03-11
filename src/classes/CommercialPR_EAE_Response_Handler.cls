/*
* Name      : CommercialPR_EAE_Response_Handler
* Company   : ET Marlabs
* Purpose   : Handler class of CommercialPR_EAE_Response. 
* Author    : Raushan
*/

public class CommercialPR_EAE_Response_Handler {
    
    public static void getResponse(CommercialPR_EAE_Response    commercialPR_EAE_Obj){
        
        If(commercialPR_EAE_Obj !=null){
            system.debug('commercialPR_EAE_Obj==++'+commercialPR_EAE_Obj);
            CommercialPR_EAE_Response.cls_ContextData   contextDataObj  =   commercialPR_EAE_Obj.ContextData;
            If(contextDataObj !=null){
                List<CommercialPR_EAE_Response.cls_Applicants>  listApplicants  =   contextDataObj.Applicants;
                If(!listApplicants.isEmpty() && listApplicants !=null){
                    for(CommercialPR_EAE_Response.cls_Applicants applicantsObj  :   listApplicants) {
                        If(applicantsObj !=null){
                            
                            CommercialPR_EAE_Response.cls_DsCommercialCIR   dsCommercialCIRObject   =   applicantsObj.DsCommercialCIR;
                            If(dsCommercialCIRObject !=null){
                                
                                CommercialPR_EAE_Response.cls_RawResponse   rawResponseObj          =    dsCommercialCIRObject.RawResponse;
                                If(rawResponseObj !=null){
                                    CommercialPR_EAE_Response_Helper.getCommercialPRDetails(rawResponseObj);   
                                }
                            }
                            CommercialPR_EAE_Response.cls_DsCibilBureau     dsCibilBureauObj            =   applicantsObj.DsCibilBureau;
                            If(dsCibilBureauObj !=null){
                                System.debug('dsCibilBureauObj'+dsCibilBureauObj);
                                CommercialPR_EAE_Response.cls_DsCibilBureauStatus   dsCibilBureauStatusObj  =   dsCibilBureauObj.DsCibilBureauStatus;
                                If(dsCibilBureauStatusObj !=null){
                                    //dsCibilBureauStatusObj.Trail;
                                }
                                CommercialPR_EAE_Response.cls_DsCibilResponse   dsCibilResponseObj      =   dsCibilBureauObj.DsCibilResponse;
                                If(dsCibilResponseObj !=null){
                                    System.debug('dsCibilResponseObj'+dsCibilResponseObj);
                                    CommercialPR_EAE_Response.cls_CibilBureauResponse   cibilBureauResponseObj  =   dsCibilResponseObj.CibilBureauResponse;
                                    If(cibilBureauResponseObj !=null){
                                        System.debug('cibilBureauResponseObj'+cibilBureauResponseObj);
                                        CommercialPR_EAE_Response.cls_BureauResponseXml  bureauResponseXmlObj   =   cibilBureauResponseObj.BureauResponseXml;
                                        If(bureauResponseXmlObj !=null){
                                            System.debug('bureauResponseXmlObj'+bureauResponseXmlObj);
                                            CommercialPR_EAE_Response.cls_CreditReport   creditReportObj        =   bureauResponseXmlObj.CreditReport;
                                            If(creditReportObj !=null){
                                                System.debug('creditReportObj'+creditReportObj);
                                                CommercialPR_EAE_Individual_Helper.getRequest(creditReportObj);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}