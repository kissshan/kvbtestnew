@RestResource(urlMapping='/GetPerfiosDetails')
global class Ws_PerfiosGetDetaisl {
    
    global class DetailResponse extends WS_Response{
      
        public perfiosDetails PDetails;
        public DetailResponse (){
            PDetails    = New perfiosDetails();
        }
    }
    public class perfiosDetails {
        public string Income;
        public List<BankAccNumber> BankAccountNumbers; 
        public string shouldUploadITR; 
        //public string isITRRequired;
        public string AdditionalIncome;
        public string ApplicationID;
         //prashant singh on 08-10-2018
        public string ErrorMessage;
        //prashnat singh ends 
        
    }
    public class BankAccNumber{
        
        public string BankName;
        public string ShouldUploadBS;
        public string ShouldRetryBS;
        public string BankAccountNumber;
    }
    @httpGet
    global static DetailResponse getDetails(){
        
        RestRequest req = Restcontext.Request;
        RestResponse restRes = Restcontext.response;
        try{ 
            DetailResponse res=new DetailResponse();
            string AccID=req.params.get('AccID');
            //Application ID
            string AppID = req.params.get('AppID');
            system.debug('#####'+AppID+'@@@@@@@@'+AccID);
            Decimal TotalAvgBalance6Month =0 ;
            Decimal TotalChequeBounce = 0;
            Decimal SelfEmpNMI = 0;
            
            perfiosCalculations.CalculateBS(AccID,AppID);
            
        //    account acc =[select id,ITR_Uploaded__c,Income_Computation_From__c,Computed_NMI__c,NMI_as_per_26AS__c,NMI_as_per_BS__c,NMI_as_per_ITR__c,Total_ChequeECS_bounces__c,Average_Balances6_months__c,Employment_Type__c,(select id,SelfEmpNMI__c,Failure_Reason__c,Bank_Name__c,AvgBalance_Of_6_Months__c,Cheque_Bounces__c,Bank_Account_Number__c,Upload_Bank_Statement__c from Perfios__r) from account where id=:AccID];
            //create parties object according to Remodel
             genesis__Application_Parties__c parobj=new genesis__Application_Parties__c();
                 //quert parties
                 genesis__Application_Parties__c par=queryService.PartieswithAcc(AccID, AppID);
                // parobj.genesis__Party_Account_Name__c=par.genesis__Party_Account_Name__c;
                parobj.id=par.id;
                 System.debug('**parties account after query'+parobj);

            List<Perfios__c> ListofPerfios = [Select SelfEmpNMI__c,Failure_Reason__c,Bank_Name__c,AvgBalance_Of_6_Months__c,Cheque_Bounces__c,Bank_Account_Number__c,Upload_Bank_Statement__c,Applicant_Name__c,Application__c from Perfios__c where Applicant_Name__c=:AccID AND Application__c=:AppID ];
            genesis__Applications__c apps = queryService.getApp(AppID);
             // Comented as per discussion with Nirali & Vivek dated: 2018_06_01
            /*if(acc.Employment_Type__c ==Constants.EmpType_Salaried){
                 res.PDetails.isITRRequired='false';
            }
            else{
                  res.PDetails.isITRRequired='true';

            }*/
            res.PDetails.shouldUploadITR=string.valueOf(par.ITR_Uploaded__c);
            res.PDetails.ApplicationID = string.valueOf(apps.id);
            res.PDetails.BankAccountNumbers= new list<BankAccNumber>();
            for(Perfios__c p:ListofPerfios){
                 system.debug('#####'+p);
                BankAccNumber b=new BankAccNumber();
                b.ShouldUploadBS=string.valueOf(p.Upload_Bank_Statement__c);
                b.ShouldRetryBS=string.valueOf(p.Failure_Reason__c);
                b.BankName=string.valueOf(p.Bank_Name__c);
                b.BankAccountNumber=string.valueOf(p.Bank_Account_Number__c);
                res.PDetails.BankAccountNumbers.add(b);
                if(!Utility.ISStringBlankorNull(String.valueOf(p.AvgBalance_Of_6_Months__c)))
                TotalAvgBalance6Month = TotalAvgBalance6Month + p.AvgBalance_Of_6_Months__c;
                if(!Utility.ISStringBlankorNull(String.valueOf(p.Cheque_Bounces__c)))
                TotalChequeBounce =TotalChequeBounce + p.Cheque_Bounces__c;
                if(!Utility.ISStringBlankorNull(String.valueOf(p.SelfEmpNMI__c)))
                SelfEmpNMI = SelfEmpNMI + p.SelfEmpNMI__c;
            }
            
            
            if(par.Employment_Types__c <>Constants.EmpType_Salaried && par.Employment_Types__c <> null){
                if(Utility.ISStringBlankorNull(String.valueOf(par.NMI_as_per_ITR__c)))
                  {   SelfEmpNMI = 0;
                    }else{SelfEmpNMI = Math.min(SelfEmpNMI, (par.NMI_as_per_ITR__c * 1.2));}
                parobj.NMI_as_per_BS__c = SelfEmpNMI;
                
            }
            parobj.Average_Balances_6_months__c = TotalAvgBalance6Month;
            parobj.Total_ChequeECS_bounces__c = TotalChequeBounce;
            
 				Decimal NmiITR,NmiBS,Nmi26AS=0;
            if(!Utility.ISStringBlankorNull(string.valueOf(par.NMI_as_per_ITR__c))){
               NmiITR=par.NMI_as_per_ITR__c;
            }
             if(!Utility.ISStringBlankorNull(string.valueOf(par.NMI_as_per_ITR__c))){
               NmiBS=par.NMI_as_per_ITR__c;
            }
             if(!Utility.ISStringBlankorNull(string.valueOf(par.NMI_as_per_ITR__c))){
               Nmi26AS=par.NMI_as_per_ITR__c;
            }
            Decimal mAxValue= math.max(math.max( NmiITR, NmiBS),Nmi26AS);
            if(mAxValue==NmiITR){
                 parobj.Income_Computation_From__c = 'ITR';
            }
            else if(mAxValue==NmiBS){
                parobj.Income_Computation_From__c = 'Bank Statement';
            }
            else if(mAxValue==Nmi26AS){
                parobj.Income_Computation_From__c = 'Form 26 AS';
            }
           
            if(!Utility.ISStringBlankorNull(String.valueOf(par.NMI_as_per_ITR__c)) && !Utility.ISStringBlankorNull(String.valueOf(par.Computed_NMI__c)) && (par.Computed_NMI__c == (par.NMI_as_per_ITR__c).SetScale(2) )){
                parobj.Income_Computation_From__c = 'ITR';
                }else if(!Utility.ISStringBlankorNull(String.valueOf(par.NMI_as_per_BS__c)) && !Utility.ISStringBlankorNull(String.valueOf(par.Computed_NMI__c)) && (par.Computed_NMI__c == (par.NMI_as_per_BS__c).SetScale(2))){
                 parobj.Income_Computation_From__c = 'Bank Statement';
                    }else if(!Utility.ISStringBlankorNull(String.valueOf(par.NMI_as_per_26AS__c))){
                        parobj.Income_Computation_From__c = 'Form 26 AS';
                        }
            
            
            update parobj;
        
            genesis__Application_Parties__c parties=queryService.PartieswithAcc(AccID, AppID);
          
               res.PDetails.Income=string.valueOf(parties.Computed_NMI__c);
            //prashant singh on 08-10-2018
         if(res.PDetails.Income=='0.00') res.PDetails.ErrorMessage='Six/Three months continuous salary credit not present.';     
            //prashant  singh ends
            return res;
        }
        catch(QueryException e){
            DetailResponse res = new DetailResponse();
            system.debug('Error'+e.getStackTraceString()+'Line Number'+e.getLineNumber());
            return res;
        }
       
    }
}