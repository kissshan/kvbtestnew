//uday---->100
@isTest
public class CommercialPR_EAE_Response_Utility_Test {
     @isTest
    public static void method1(){
        object obj;
        ints__TransUnion_Credit_Report__c tc=new ints__TransUnion_Credit_Report__c();
        CommercialPR_EAE_Response.YourInstitution cea=new CommercialPR_EAE_Response.YourInstitution();
        cea.current='Yes';
        cea.last24Months='Yes';
        CommercialPR_EAE_Response.YourInstitution_Y cey=new CommercialPR_EAE_Response.YourInstitution_Y();
        cey.wilfulDefault='10';
        cey.dishonoredCheque='5';
        //cey.numberOfSuitFiled='80';
        //cey.amt='882';
        Derogatory_Information__c di=new Derogatory_Information__c();
        CommercialPR_EAE_Response.SuitFilled ces=new CommercialPR_EAE_Response.SuitFilled();
         ces.numberOfSuitFiled='80';
         ces.amt='882';
        OustandingBalancebyCF__c ob=new OustandingBalancebyCF__c(); 
        CommercialPR_EAE_Response.DPD0 ced=new CommercialPR_EAE_Response.DPD0();
        ced.count='5';
        ced.value='10';
        CommercialPR_EAE_Response.STDVec cess=new CommercialPR_EAE_Response.STDVec();
        cess.DPD0=ced;
        cess.DPD1to30=ced;
        cess.DPD31to60=ced;
        cess.DPD61to90=ced;
        CommercialPR_EAE_Response.NONSTDVec cessn=new CommercialPR_EAE_Response.NONSTDVec();
        cessn.dbt=ced;
        cessn.DPD91to180=ced;
        cessn.greaterThan180DPD=ced;
        cessn.loss=ced;
        cessn.sub=ced;
        CommercialPR_EAE_Response.NonFunded cef=new CommercialPR_EAE_Response.NonFunded();
        cef.STDVec=cess;
        cef.NONSTDVec=cessn;
        cef.total=ced;
        Credit_Profile__c cp=new Credit_Profile__c();
        CommercialPR_EAE_Response.TotalCF cet=new CommercialPR_EAE_Response.TotalCF();
        cet.borrower='2';
        cet.borrowerPercentage='60';
        cet.guarantor='1';
        cet.guarantorPercentage='70';
        CommercialPR_EAE_Response.Total cett=new CommercialPR_EAE_Response.Total();
        cett.delinquentCF='2';
        cett.delinquentOutstanding='313';
        cett.latestCFOpenedDate='345';
        cett.openCF='23';
        cett.totalCF='32';
        cett.totalLenders='4';
        cett.totalOutstanding='25645';
        string json='';
        CommercialPR_EAE_Response.parse(json);
        Test.startTest();
        CommercialPR_EAE_Response_Utility.getYourInstitution(cea,tc);
        CommercialPR_EAE_Response_Utility.getOutsideInstitution(cea,tc);
        CommercialPR_EAE_Response_Utility.getYourInstitution_Y(cey,di);
        CommercialPR_EAE_Response_Utility.getSuitFilled(ces,di);
        CommercialPR_EAE_Response_Utility.getwrittenOff(ces,di);
        CommercialPR_EAE_Response_Utility.getSettled(ces,di);
        CommercialPR_EAE_Response_Utility.getInvoked(ces,di);
        CommercialPR_EAE_Response_Utility.getOverdueCF(ces,di);
        CommercialPR_EAE_Response_Utility.getNonFunded(cef,ob);
        CommercialPR_EAE_Response_Utility.getTotalCF(cet,cp);
        CommercialPR_EAE_Response_Utility.getDelinquentCF(cet,cp);
        CommercialPR_EAE_Response_Utility.getTotalOutstanding(cet,cp);
        CommercialPR_EAE_Response_Utility.getDelinquentOutstanding(cet,cp);
        CommercialPR_EAE_Response_Utility.getTotal(cett,cp);
        Test.stopTest();
    }
}