/* 
* Name      : perfiosCalculations
* Purpose   : This class is used for Calculating the Bank Statement ITR values.
* Company   : ET Marlabs
* Author    : Venu
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
V1.1    06-Sep-2018    Braj          #VL717:Updating party level Perfios_Captured__c to true according to BS
V2      01_Oct_18	   Venu          Changes of calculations
*******************************************************************************************/
public class perfiosCalculations {
    public static void CalculateBS(string AccID, string AppID){
        list<Perfios__c> pF=[select id,Regular_Credits__c,Application__c,Application__r.Record_Type_Name__c,Upload_Bank_Statement__c,(select id,Year__c,Month_Name__c, Month_no__c from Monthly_Detials_Perfios__r) from Perfios__c where Applicant_Name__c=:AccID  and Application__c=:AppID and active__c=true];
        system.debug('pf:-'+pf);
        map<string,string> MonthYe=new map<string,string>();
        set<integer> Ye=new set<integer>();
        set<string> PFMIds=new set<string>();
        if(pF!=null && pF.size()>0){
        string RecType=pF[0].Application__r.Record_Type_Name__c;
        decimal RegCredit = 0;
        system.debug(pf.size());
        for(Perfios__c Pios:pF){
            RegCredit =+ Pios.Regular_Credits__c;
            PFMIds.add(Pios.id);
            for(Monthly_Detials_Perfios__c p:Pios.Monthly_Detials_Perfios__r){
                ye.add(integer.valueOf(p.Year__c));
            }
        }
        
        list<integer> yea= new list<integer>();
        integer s;
        integer s1;
        yea.addAll(ye);
        system.debug(ye);
        system.debug(yea);
        if(yea.size()>0){
            yea.sort();
            s=yea[(yea.size()-1)]; 
            if(yea.size()>=2){
                s1=yea[(yea.size()-2)];
            }
        }
        Boolean SalaryCont = false;
        decimal I1,I2,I3,I4,I5,I6=0;
        decimal SR1=0; Decimal SR2=0; Decimal SR3 =0; Decimal SR4 =0; Decimal SR5 =0; Decimal SR6 =0;
        decimal NMIasBS = 0;
        Decimal EMILastMonth =0;
        list<Perfios__c> pfList=new list<Perfios__c>();
        if(pF.size()>0){
            for(Perfios__c Pios:pF){
                system.debug('Pios ids:-'+Pios.id);
                Perfios__c p=new Perfios__c();
                list<Monthly_Detials_Perfios__c> mf=[select id,Total_Salary__c,Total_EMI_issue__c from Monthly_Detials_Perfios__c where perfios__c =:Pios.id order by Transaction_Date__c desc limit 6];
                if(mf.size() > 0){
                    system.debug('mf'+mf);
                    system.debug('mf'+mf.size());
                    system.debug('mf perfios size'+pf.size());
                    I1 = mf[0].Total_Salary__c;
                    I2 = mf[1].Total_Salary__c;
                    I3 = mf[2].Total_Salary__c;
                    I4 = mf[3].Total_Salary__c;
                    I5 = mf[4].Total_Salary__c;
                    I6 = mf[5].Total_Salary__c;
                    
                    system.debug('Salary values'+I1+','+I2+','+I3+','+I4+','+I5+','+I6);
                    EMILastMonth+=mf[0].Total_EMI_issue__c;
                    
                    SR1+=I1;
                    SR2+=I2;
                    SR3+=I3;
                    SR4+=I4;
                    SR5+=I5;
                    SR6+=I6;
                 // NMIasBS+=NMIasBS;
                }//else{
                //  NMIasBS = RegCredit;
                //}
            }  // V2
             genesis__Application_Parties__c par=queryService.PartieswithAcc(AccID, AppID);
if((RecType ==Constants.LAPLOAN && SR1 !=0 && SR2!=0 && SR3!=0 && SR4!=0 && SR5!=0 && SR6!=0) || ((RecType ==Constants.HOMELOAN || RecType ==Constants.LAPLOAN || RecType ==Constants.PERSONALLOAN || RecType ==Constants.VL4W || RecType ==Constants.VL2W ) && (SR1 !=0 && SR2!=0 && SR3!=0)) ){
		 Decimal Imax=1.3*(Math.min(Math.min(SR1, SR2 ), SR3 ));
   	    Decimal EstimatedSInc = (Math.min(SR1, Imax ) + Math.min(SR2, Imax ) + Math.min(SR3, Imax ))/3;
        NMIasBS+=EstimatedSInc;//+RegCredit; chnages to add regular credit in last update
    SalaryCont =true;
				}
            else{
               SalaryCont =false;
                            //prashant singh on 08-10-2018
              /*  if(par.Employment_Types__c==Constants.EmpType_Salaried){
                for(Perfios__c Pios:pF){
                    if(!Pios.Upload_Bank_Statement__c){
                Perfios__c p=new Perfios__c();
                    p.id=Pios.id;
               // p.Error_Message__c= 'Six/Three months continuous salary credit not present.';
            
            
                 pfList.add(p);
                    }
                }
                }*/
                //prashant  singh ends
            }
            //  account acc=new account();
           
            // crete parties object and assign value for ReModel
            genesis__Application_Parties__c parobj=new genesis__Application_Parties__c();
            //quert parties
           
            // parobj.genesis__Party_Account_Name__c=par.genesis__Party_Account_Name__c;
            parobj.id=par.id;
            System.debug('**parties account after query'+parobj);
             // ITR Flow
            list<ITR_Response__c> ITRList=[select id,Account__c,Agriculture_ITR1__c,Agriculture_ITR2__c,Agriculture_ITR3__c,Annual_Agriculture_Income_ITR__c,Annual_Capital_Gain1__c,Annual_Capital_Gain2__c,
                                          Annual_Capital_Gain3__c,Annual_Share_of_Profit_Firm_ITR__c,Annual_Tax1__c,Annual_Tax2__c,Annual_tax3__c,Application__c,Dividend_income1__c,
                                           Dividend_income2__c,Dividend_Income3__c,Estimated_Income_ITR__c,Estimated_Agriculture_ITR__c,Gross_Income1__c,Gross_income2__c,Gross_Income3__c,Interest_income1__c,Interest_income2__c,
                                           Interest_income3__c,Request_ID__c,Share_of_Profit1__c,Share_of_Profit2__c,Share_of_Profit3__c,Year1__c,Year2__c,
                                           Year3__c from ITR_Response__c where Application__c=:AppID and Account__c=:AccID order by name Desc ];
            if(ITRList!=null && ITRList.size()>0){
                decimal NMIasperITR=(ITRList[0].Estimated_Agriculture_ITR__c+ITRList[0].Annual_Share_of_Profit_Firm_ITR__c+ITRList[0].Estimated_Income_ITR__c)/12;
                    parobj.Year1__c = ITRList[0].Year1__c;
                    parobj.Year2__c = ITRList[0].Year2__c;
                    parobj.Year3__c = ITRList[0].Year3__c;
                    parobj.Gross_Income1__c = ITRList[0].Gross_Income1__c;
                    parobj.Annual_Tax1__c = ITRList[0].Annual_Tax1__c;
                    parobj.Gross_Income2__c = ITRList[0].Gross_income2__c;
                    parobj.Annual_Tax2__c = ITRList[0].Annual_Tax2__c;               
                	parobj.Gross_Income3__c = ITRList[0].Gross_Income3__c;
                    parobj.Annual_Tax3__c = ITRList[0].Annual_tax3__c;
                    parobj.Annual_Capital_Gain1__c = ITRList[0].Annual_Capital_Gain1__c;
                    parobj.Interest_Income1__c = ITRList[0].Interest_income1__c;
                    parobj.Dividend_Income1__c = ITRList[0].Dividend_income1__c;
                    parobj.Annual_Capital_Gain2__c = ITRList[0].Annual_Capital_Gain2__c;
                    parobj.Interest_Income2__c = ITRList[0].Interest_income2__c;
                    parobj.Dividend_Income2__c = ITRList[0].Dividend_income2__c;
                	parobj.Annual_Capital_Gain3__c = ITRList[0].Annual_Capital_Gain3__c;
                    parobj.Interest_income3__c = ITRList[0].Interest_income3__c;
                    parobj.Dividend_income3__c = ITRList[0].Dividend_Income3__c;
                    parobj.Agriculture_ITR1__c = ITRList[0].Agriculture_ITR1__c;
                    parobj.Agriculture_ITR2__c = ITRList[0].Agriculture_ITR2__c;
                    parobj.Agriculture_ITR3__c = ITRList[0].Agriculture_ITR3__c;
                    parobj.Share_of_Profit_1__c = ITRList[0].Share_of_Profit1__c;
                    parobj.Share_of_Profit_2__c = ITRList[0].Share_of_Profit2__c;
                    parobj.Share_of_Profit_3__c = ITRList[0].Share_of_Profit3__c;
                    parobj.Annual_Agriculture_Income_ITR__c = ITRList[0].Annual_Agriculture_Income_ITR__c;
                    parobj.Annual_Share_of_Profit_Firm_ITR__c = ITRList[0].Annual_Share_of_Profit_Firm_ITR__c;
                    parobj.NMI_as_per_ITR__c = NMIasperITR;
            }
            
            // Form 26AS flow
             List<Form_26_As__c> FormList=[select id,PAN__c,Applicant__c,Date__c,(select id from Form26infos__r) from Form_26_As__c where Applicant__c=:accID AND Application__c=:appID order by Date__c ];
            System.debug('FormList'+FormList);
            set<id> infoidset=new set<id>();
            if(FormList!=null && FormList.size()>0){
            for(Form_26_As__c form26: FormList){
                for(Form26info__c info : form26.Form26infos__r){
                    infoidset.add(info.id) ;
                }
            }
            String rtypeID=Schema.SObjectType.TdsDetail__c.getRecordTypeInfosByName().get('TDSList').getRecordTypeId();
            System.debug('info id set '+infoidset);
            genesis__Applications__c appform=[select id,Record_Type_Name__c from genesis__Applications__c where id=:appID];
             List<TdsDetail__c> tdlist;
            if(appform.Record_Type_Name__c=='LAP'){
            tdlist=[select id,amount__c,Tax__c,tdsDate__c,Form26info__c,taxDeducted__c from TdsDetail__c where     Form26info__c IN :infoidset  AND RecordTypeId =:rtypeID AND tdsDate__c <> null order by tdsDate__c desc limit 6];
            }
            else{
            tdlist=[select id,amount__c,Tax__c,tdsDate__c,Form26info__c,taxDeducted__c from TdsDetail__c where   Form26info__c IN :infoidset  AND RecordTypeId =:rtypeID AND tdsDate__c <> null order by tdsDate__c desc limit 3];
           
            }
            Integer length=tdlist.size();
            System.debug('**tdlist'+tdlist);
            System.debug('**length'+length);
            
            Decimal N1=0.0,Q1=0.0;
            
            for(TdsDetail__c td :tdlist){
                if(!Utility.ISStringBlankorNull(td.amount__c)){
                    N1=N1+Decimal.valueOf(td.amount__c);
                    
                }
                if(!Utility.ISStringBlankorNull(td.taxDeducted__c)){
                    Q1=Q1+Decimal.valueOf(td.taxDeducted__c);
                    
                }
                
            }
            System.debug(N1);
            System.debug(Q1);
            if(N1!=null && length >0){
                Decimal AmountPaid=N1;
                Decimal TaxDecucted=Q1;
                Decimal EstimatedIncome=AmountPaid-TaxDecucted;
                Decimal NMIAsPer26AS=(EstimatedIncome/length).setscale(2);
                
                System.debug('NMIAsPer26AS'+NMIAsPer26AS);
               
                // stroing info acc will comment later
                parobj.NMI_as_per_26AS__c=NMIAsPer26AS;
                parobj.Amount_Paid__c = AmountPaid; // Discussed with Akshya updated on 2018/10/04
                parobj.Tax_Deducted__c = TaxDecucted;
            }
            }
            if(Utility.ISStringBlankorNull(String.valueOf(RegCredit)))
            {
                RegCredit = 0;
            }
            parobj.NMI_as_per_BS__c=NMIasBS+RegCredit;
            //parobj.Perfios_Captured__c = true;//V1.1
            //  acc.id=AccID;
            
            parobj.EMI_of_Last_Month__c=EMILastMonth;
            parobj.Salary_Continous_Flag__c=SalaryCont;
            // Six Month Salary Credited
            parobj.Salary_Credited_1__c=SR1;
            parobj.Salary_Credited_2__c=SR2;
            parobj.Salary_Credited_3__c=SR3;
            parobj.Salary_Credited_4__c=SR4;
            parobj.Salary_Credited_5__c=SR5;
            parobj.Salary_Credited_6__c=SR6;
            
            parobj.Annual_Other_IncomeRecurring_CreditsITR__c  =RegCredit;
            // accAppNMIJunction = queryService.getNMIJunction(AccID,AppID);
            //  accAppNMIJunction.NMI_as_per_BS__c = NMIasBS+RegCredit;
            
            try{
                update parobj;
                if(pfList!=null && pfList.size()>0)
                    update pfList;
                //  update accAppNMIJunction;
            }catch(exception e){
                system.debug('Error'+e.getStackTraceString()+'Line Number'+e.getLineNumber() +'ErrorMsg : '+e.getMessage());
            }
        }
        }
    }
}