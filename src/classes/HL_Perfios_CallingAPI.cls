/*   Final
* Name          : HL_Perfios_CallingAPI
* Description   : Calling perfios stautas and report through APIGEE
* Author        : Venu Gopal
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
V1.1    06-Sep-2018    Braj           #VL717:Updating party level Perfios_Captured__c to true according to ITR/Form 26A
V2      01_10_2018	   Venu            Perfios chanegs of the acticve upload tyoe bank acc no
*******************************************************************************************/
public class HL_Perfios_CallingAPI {
    
    // For Perfios Report
    public static PerfiosReportResponseHL callReport(string TxnID){
        try{
            system.debug('TxnID === '+TxnID);
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
            HTTPResponse response                                   = new HTTPResponse();
            String endPoint                                         = Utility.getFullEndpoints('Perfios_Report');
            endPoint          = endPoint+TxnID;
            response = HttpUtility.sendHTTPRequest(endPoint, 'GET', null,null,headerMap,null);
            system.debug('$$$$'+response.getBody());
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsona = response.getBody();
                
                system.debug('jsona'+jsona);
                PerfiosReportResponseHL res = (PerfiosReportResponseHL)Json.deserialize(jsona,PerfiosReportResponseHL.class);
                system.debug('res'+res);
                return res;
            }else{
                throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
            }
        }catch(Exception e){
            system.debug(e.getLineNumber()+'sss'+e.getStackTraceString());
        }
        
        return null;
    }
    
    
    
    // For Status Call
    
    public static PerfiosStatusReportHL callStatus(string TxnID){
        try{
            system.debug('TxnID === '+TxnID);
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
            HTTPResponse response                                   = new HTTPResponse();
            String endPoint                                         = Utility.getFullEndpoints('Perfios_Status');
            endPoint          = endPoint+TxnID;
            response = HttpUtility.sendHTTPRequest(endPoint, 'GET', null,null,headerMap,null);
            system.debug('$$$$'+response.getBody());
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();
                system.debug('jsonString'+jsonString);
                PerfiosStatusReportHL res = (PerfiosStatusReportHL)Json.deserialize(jsonString,PerfiosStatusReportHL.class);
                system.debug('res'+res);
                return res;
            }else{
                throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
            }
        }catch(Exception e){
            system.debug(e.getLineNumber()+'sss'+e.getStackTraceString());
        }
        
        
        return null;
        
    }
    
    // For parsing Status Response
    
    public static StatusReport parseStatusResponse(PerfiosStatusReportHL SReport){
        system.debug('Status Report'+SReport);
        try{
            string ErrorValue;
            
            StatusReport stRe=new StatusReport();
            if(SReport!=null){
                PerfiosStatusReportHL.cls_Status cStat=SReport.Status;
                if(cStat!=null){
                    PerfiosStatusReportHL.cls_Part cpart=cStat.Part;
                    if(cpart!=null){
                        stRe.TxnID=Utility.getBlankStringIfNull(cpart.perfiosTransactionId);
                        if(!Utility.ISStringBlankorNull(cpart.errorCode)){
                            if(cpart.errorCode==Constants.E_Amount || cpart.errorCode==Constants.E_NAccept){
                                stRe.ErrorMsg=Constants.IBSPtry;
                            }
                            else if(cpart.errorCode==Constants.E_Api || cpart.errorCode==Constants.E_othe || cpart.errorCode==Constants.E_SITE || cpart.errorCode==Constants.E_sys || cpart.errorCode==Constants.E_UAct || cpart.errorCode==Constants.E_usCanc || cpart.errorCode==Constants.E_uSExpir ){
                                stRe.ErrorMsg=Constants.Pta;
                            }
                            else if(cpart.errorCode==Constants.E_N_Accnt ){
                                stRe.ErrorMsg=Constants.IBAPtanothAcc;
                            }
                            else if(cpart.errorCode==Constants.E_NErr ){
                                stRe.ErrorMsg=Constants.NoErr;
                            }
                            else if(cpart.errorCode==Constants.E_usBloc || cpart.errorCode==Constants.E_wCredent){
                                stRe.ErrorMsg=Constants.ILCPta24;
                            }
                        }
                    }
                }
            }
            return stRe;
        }
        catch(exception e){
            system.debug('Error'+e.getStackTraceString()+'Line Number'+e.getLineNumber()+'ErrorMsg : '+e.getMessage());
            HandleBusinessException.captureError('HL_Perfios_CallingAPI', 'parseStatusResponse', e);
        }
        
        return null;
    }
    
    // For parsing Report
    // Start V2
    public static void parseReportResponse(PerfiosReportResponseHL RReport, List<Perfios__c> PFList,string appID,string accID){
        system.debug('Status Report'+RReport);
         system.debug('PerfiosID'+PFList);
        try{
            List<Monthly_Detials_Perfios__c>   listMDP= new List<Monthly_Detials_Perfios__c>();
            List<Regular_Credits__c>   listRcred= new List<Regular_Credits__c>();
            Decimal EmiIssue = 0;
            Decimal SlefEmpNMI = 0;
            Decimal TotalSalary =0;
            string PerfiosID;
            string errorMessage;
            List<Perfios__c> UPerfios =new List<Perfios__c>();
            set<String> BankNumList=new set<String>();
            Perfios__c pf=new Perfios__c();
            genesis__Applications__c applicationData = new genesis__Applications__c();
  //          AppAccountNMIJunction__c accAppNMIJunction = new AppAccountNMIJunction__c();
            if(RReport!=null){
                PerfiosReportResponseHL.cls_customerInfo CustInfo=RReport.customerInfo;
                PerfiosReportResponseHL.cls_summaryInfo CsummInfo=RReport.summaryInfo;
                PerfiosReportResponseHL.cls_AdditionalForm26ASInfo CAddForm26Info=RReport.AdditionalForm26ASInfo;
                //added to get NMI for selfemployed customer.
                PerfiosReportResponseHL.cls_AdditionalSummaryDetails addSummDetails = RReport.AdditionalSummaryDetails;
                if(!Utility.ISStringBlankorNull(string.valueOf(addSummDetails.avgEstimatedIncome)))
                    SlefEmpNMI = decimal.valueOf(addSummDetails.avgEstimatedIncome);
                
                system.debug('##### SlefEmpNMI '+SlefEmpNMI);
                if(CustInfo!=null){
                    If(!Utility.ISStringBlankorNull(CustInfo.name))
                        pf.Customer_Name__c=  CustInfo.name;
                    If(!Utility.ISStringBlankorNull(CustInfo.address))
                        pf.Customer_Address__c=  CustInfo.address;
                    If(!Utility.ISStringBlankorNull(CustInfo.landline))
                        pf.Customer_Landline__c=  CustInfo.landline;
                    If(!Utility.ISStringBlankorNull(CustInfo.mobile))
                        pf.Customer_Mobile__c=  CustInfo.mobile;
                    If(!Utility.ISStringBlankorNull(CustInfo.email))
                        pf.Customer_Email__c=  CustInfo.email;
                    If(!Utility.ISStringBlankorNull(CustInfo.pan))
                        pf.Customer_Pan__c=  CustInfo.pan;
                    If(!Utility.ISStringBlankorNull(CustInfo.perfiosTransactionId))
                        pf.Customer_PerfiosTransactionID__c=  CustInfo.perfiosTransactionId;
                    If(!Utility.ISStringBlankorNull(CustInfo.customerTransactionId))
                        pf.Customer_Transaction_ID__c=  CustInfo.customerTransactionId;
                    If(!Utility.ISStringBlankorNull(CustInfo.bank))
                        pf.Customer_Bank__c=  CustInfo.bank;
                    If(!Utility.ISStringBlankorNull(string.valueOf(CustInfo.instId)))
                        pf.InstID__c=  string.valueOf(CustInfo.instId);
                     If(!Utility.ISStringBlankorNull(string.valueOf(CustInfo.errorCode)))
                      string errorCode  =  string.valueOf(CustInfo.errorCode);
                    If(!Utility.ISStringBlankorNull(string.valueOf(CustInfo.errorMessage)))
                     errorMessage  =  string.valueOf(CustInfo.errorMessage);
                    
                    if(Utility.ISStringBlankorNull(errorMessage)){
                if(!Utility.ISStringBlankorNull(string.valueOf(addSummDetails.avgEstimatedIncome)))
                    SlefEmpNMI = decimal.valueOf(addSummDetails.avgEstimatedIncome);
                system.debug('PerfiosID'+PerfiosID);
                system.debug('##### SlefEmpNMI '+SlefEmpNMI);
                 List<PerfiosReportResponseHL.cls_accNo> listBankAccNum;
                listBankAccNum=CsummInfo.accNo;
                if(listBankAccNum!=null && listBankAccNum.size()>0){
                    for(PerfiosReportResponseHL.cls_accNo Acc:listBankAccNum){
                        BankNumList.add(Acc.bankAccNo);
                    }
                }
                if(!Utility.ISStringBlankorNull(CsummInfo.primaryAccNo)){
                    if(PFList!=null && PFList.size()>0){
                    for(Perfios__c perfi:PFList){
                        if(perfi.Bank_Account_Number__c==CsummInfo.primaryAccNo){
							PerfiosID   =  perfi.id;                       
                        }
                        else{
                            if(BankNumList!=null && BankNumList.size()>0){
                                if(BankNumList.contains(perfi.Bank_Account_Number__c)){
                                     perfi.Upload_Bank_Statement__c=false;
                                }
                            }
                           perfi.Active__c=false;
                            UPerfios.add(perfi);
                        }
                    }
                   
                    }
                }
                   system.debug('##### PerfiosID '+PerfiosID);   
             /*  if(Utility.ISStringBlankorNull(PerfiosID)){
                    PerfiosID=PFList[0].id;
                    }
                */ // Commented by venu 01_10_18
             system.debug('##### PerfiosID '+BankNumList);    
		 system.debug('##### PerfiosID '+PerfiosID);
                
                List<PerfiosReportResponseHL.cls_monthlyDetails> listMDetails;
                listMDetails=RReport.monthlyDetails;
                if(listMDetails!=null && listMDetails.size()>=0){
                    Integer year = -1;
                    Integer month = -1;
                    for(PerfiosReportResponseHL.cls_monthlyDetails Mont:listMDetails){
                        /* code Added for latest emi issues */
                        if(!Utility.ISStringBlankorNull(Mont.monthName)){
                            String yearrr = (Mont.monthName).substring(((Mont.monthName).length()-2));
                            Integer monthaValue = Utility.convertMonthTextToNumber((Mont.monthName).substring(0,3));
                            
                            if(year <Integer.valueOf(yearrr)){
                                year = Integer.valueOf(yearrr);
                                if(month <monthaValue){
                                    month = monthaValue;
                                    EmiIssue = Mont.totalEmiIssue;
                                }
                            }
                        }
                        // End code
                        Monthly_Detials_Perfios__c mD=new Monthly_Detials_Perfios__c();
                        if(!Utility.ISStringBlankorNull(string.valueOf(Mont.totalEmiIssue)))
                            mD.Total_EMI_issue__c =Mont.totalEmiIssue;
                        if(!Utility.ISStringBlankorNull(string.valueOf(Mont.totalSalary)))
                            TotalSalary =Mont.totalSalary;
                        if(!Utility.ISStringBlankorNull(Mont.monthName)){
                            mD.Month_Name__c =(Mont.monthName).substring(0,3);
                            MD.Year__c=(Mont.monthName).substring(((Mont.monthName).length()-2));
                            system.debug(' mD.Month_Name__c'+ mD.Month_Name__c);
                            system.debug(' mD.Month_Name__c'+ MD.Year__c);
                        }
                        MD.Perfios__c=PerfiosID;
                        MD.Total_Salary__c= TotalSalary;
                        listMDP.add(MD);
                        
                        
                    }
                }
                
                
                List<PerfiosReportResponseHL.cls_regularCredits> listRcredits;
                listRcredits=RReport.regularCredits;
                Decimal RegularCredits = 0;
                Date todayDate = system.today();
                todayDate = todayDate.addMonths(-6);
                integer yer = -1;
                integer mnth = -1;
                Date regDate;
                integer MonthsCounter = 6;
                List<String> excludeCatg = new List<String>{'Salary','Reimbursement',
                    'Fixed Deposit','Dividend',
                    'Insurance','Interest',
                    'Investment Income','MF Redemption',
                    'Share Sell','Small Savings',
                    'Commodity Sell'};
                        Map<String,Set<Integer>> catCountMap = new Map<String,Set<Integer>>();
                Set<Integer> strList = new Set<Integer>();
                if(listRcredits!=null && listRcredits.size()>=0){
                    for(PerfiosReportResponseHL.cls_regularCredits ReCre:listRcredits){
                        if(!Utility.ISStringBlankorNull(ReCre.category) && !Utility.ISStringBlankorNull(ReCre.regularChangeDate)){
                            if(!excludeCatg.contains(ReCre.category) &&  (Date.valueOf(ReCre.regularChangeDate) >= todayDate)){
                                
                                if(catCountMap.keySet().contains(ReCre.category)){
                                    Set<Integer> monthList = new Set<Integer>();
                                    monthList = catCountMap.get(ReCre.category);
                                    monthList.add(Date.valueOf(ReCre.regularChangeDate).month());
                                    catCountMap.put(ReCre.category,monthList);
                                }else{
                                    catCountMap.put(ReCre.category,new Set<Integer>{Date.valueOf(ReCre.regularChangeDate).month()});
                                }   System.debug('catCountMap::'+catCountMap);
                            }
                        }
                    }
                    
                    for(String key:catCountMap.keySet().clone()){
                        strList = catCountMap.get(key);
                        system.debug('##### MonthCount '+ strList);
                        if(strList.size() < 6){
                            system.debug('##### key before remove '+ key);
                            catCountMap.remove(key);
                            system.debug('##### key '+ key);
                        }
                    }
                    system.debug('##### Final Map '+ catCountMap);
                }
                if(listRcredits!=null && listRcredits.size()>=0){
                    for(PerfiosReportResponseHL.cls_regularCredits ReCre:listRcredits){
                        if(!Utility.ISStringBlankorNull(ReCre.category) && !Utility.ISStringBlankorNull(ReCre.regularChangeDate)){
                            
                            if(catCountMap.containsKey(ReCre.category)){
                                system.debug('##### inside RC containsKey '+ ReCre.category);
                                Regular_Credits__c Rc=new Regular_Credits__c();
                                if(!Utility.ISStringBlankorNull(string.valueOf(ReCre.amount))){
                                    Rc.Amount__c =string.valueof(ReCre.amount);
                                    RegularCredits=RegularCredits + Decimal.valueOf(ReCre.amount);
                                }
                                if(!Utility.ISStringBlankorNull(string.valueOf(ReCre.balance)))
                                    Rc.Balance__c =string.valueOf(ReCre.balance);
                                if(!Utility.ISStringBlankorNull(ReCre.category))
                                    Rc.Category__c =ReCre.category;
                                if(!Utility.ISStringBlankorNull(ReCre.chqNo))
                                    Rc.Cheq_No__c    =ReCre.chqNo;
                                
                                if(!Utility.ISStringBlankorNull(string.valueOf(ReCre.regularChangeDate)))
                                    Rc.Date__c =string.valueOf(ReCre.regularChangeDate);
                                if(!Utility.ISStringBlankorNull(string.valueOf(ReCre.regularChangeGroup)))
                                    Rc.Group__c =string.valueOf(ReCre.regularChangeGroup);
                                if(!Utility.ISStringBlankorNull(ReCre.narration))
                                    Rc.Narration__c =ReCre.narration;
                                Rc.Perfios__c=PerfiosID;
                                listRcred.add(Rc);
                            }
                        }
                    }
                    
                    
                    if(RegularCredits!=null){
                        pf.Regular_Credits__c=RegularCredits/12; // total amount of 12 months - chnages on 2018-05-08
                    }
                }
                if(!Utility.ISStringBlankorNull(string.valueOf(RReport.AdditionalSummaryDetails.avgBalanceOf6Months)))
                    pf.AvgBalance_Of_6_Months__c =RReport.AdditionalSummaryDetails.avgBalanceOf6Months;
                if(!Utility.ISStringBlankorNull(string.valueOf(CsummInfo.total.inwBounces)))
                    pf.Cheque_Bounces__c =CsummInfo.total.inwBounces;
                system.debug('PerfiosID'+PerfiosID);
				system.debug('EmiIssue'+EmiIssue);
                system.debug('SlefEmpNMI'+SlefEmpNMI);
				system.debug('pf'+pf);
            
                try{
                pf.id=PerfiosID;
                pf.Upload_Bank_Statement__c = False;
                pf.EMI_for_Latest_Month__c = EmiIssue;
                pf.SelfEmpNMI__c = SlefEmpNMI;
                  // if(!pf.Active__c)
                pf.Active__c=true; 
                UPerfios.add(pf);
                    system.debug(UPerfios);
                    if(UPerfios!=null && UPerfios!=null){
               				 update UPerfios;
                    }
            }
                catch(exception e){
                     system.debug('Error'+e.getStackTraceString()+'Line Number'+e.getLineNumber()+'ErrorMsg : '+e.getMessage());
                }
                // No need itr upload in case of only bank statement.
                //applicationData.id = appID;
                //applicationData.ITR_Uploaded__c = False;
                //update applicationData;
                
                
                //accAppNMIJunction.Application__c = appID;
                //insert accAppNMIJunction;
                // } <---commented to update perfios for RC and Monthdetail as common update call.
                if(CAddForm26Info!=null){
                    system.debug('123');
                }
                else{
                    system.debug('Error');
                }
                if(listMDP.size()>0){
                    Database.insert(listMDP, false);
                }
                if(listRcred.size()>0){
                    Database.insert(listRcred, false);
                }
				}
                    else{
                       for(Perfios__c perfi:PFList){
                           Perfios__c p=new Perfios__c();
                           p.Error_Message__c=errorMessage;
                           p.id=perfi.id;
                            UPerfios.add(p);
                       
                       }
                        if(UPerfios!=null && UPerfios.size()>0){
                           update UPerfios;
                        }
                    }
            }
                       
            }
            
        }
        catch(exception e){
            system.debug('Error::'+e.getStackTraceString()+'Line Number'+e.getLineNumber()+'ErrorMsg : '+e.getMessage());
            system.debug('Error::'+e);
            HandleBusinessException.captureError('HL_Perfios_CallingAPI', 'parseReportResponse', e);
        }
        
        
    }
    // END V2
    // for parsing the ITR
    // apps parameter added to update ITRuploaded checkbox True
    public static perfiosUpdate ParseITRResponse(ITRResponseHL ITResponse,string accID,string appID){
        system.debug('ITR Response'+ITResponse);
        perfiosUpdate perUP    = new perfiosUpdate();
        try{
            genesis__Applications__c application = [Select Id,Branch_Code__c,Additional_Income_Approval__c,Record_Type_Name__c,Sub_Stage__c From genesis__Applications__c where Id =:appID];
             
            if(ITResponse!=null){
                System.debug('inside response if');
                List<ITRResponseHL.cls_itrvDetails> listitrVDetails;
                listitrVDetails=ITResponse.itrvDetails;
                if(listitrVDetails!=null && listitrVDetails.size()>=0){
                    decimal NIY1,NIY2,NIY;
                    decimal AgriAsPerITR =0;
                    decimal Agric1,Agric2,Agric3, intrestPay1, netPay1,intrestPay2, netPay2,intrestPay3, netPay3;
                    decimal capitalGain1 =0;
                    decimal capitalGain2 =0;
                    decimal capitalGain3 =0;
                    decimal interestIncome1 =0;
                    decimal interestIncome2 =0;
                    decimal interestIncome3 =0;
                    decimal grossIncome1 =0;
                    decimal grossIncome2 =0;
                    decimal grossIncome3 =0;
                    decimal Statutory1 =0;
                    decimal Statutory2 =0;
                    decimal Statutory3 =0;
                    decimal dividend1 =0;
                    decimal dividend2 =0;
                    decimal dividend3 =0;
                    Decimal ShareOfProfit1 = 0;
                    Decimal ShareOfProfit2 = 0;
                    Decimal ShareOfProfit3 = 0;
                    String Year1;
                    String Year2;
                    String Year3;
                    string form1,form2,form3;
                    //ITR 3&4 SOP
                    decimal firmShare, aopboiShare;
                    integer indx;
                    // account acc=new account();
                    
                    genesis__Application_Parties__c parobj=new genesis__Application_Parties__c();
                    //quert parties
                    genesis__Application_Parties__c par=queryService.PartieswithAcc(accID,appID);
                    // parobj.genesis__Party_Account_Name__c=par.genesis__Party_Account_Name__c;
                    parobj.id=par.id;
                    System.debug('**parties account after query'+parobj);
                    
                    genesis__Applications__c applicationData = new genesis__Applications__c();
  //                  AppAccountNMIJunction__c accAppNMIJunction = new AppAccountNMIJunction__c();
                    //   acc.id=accID;
                    applicationData.id = appID;
                    
                    
                    for(integer i=0; i<listitrVDetails.size(); i++){
                        
                        if(!Utility.ISStringBlankorNull(listitrVDetails[i].financialYear) && i+1 < listitrVDetails.size() && !Utility.ISStringBlankorNull(listitrVDetails[i+1].financialYear) ){
                            system.debug('#####');
                            if(listitrVDetails[i].financialYear == listitrVDetails[i+1].financialYear){
                                system.debug('ITR file two time in same fiscal year..');
                                if(Date.valueOf(listitrVDetails[i].dateOfSubmission) > Date.valueOf(listitrVDetails[i+1].dateOfSubmission)){
                                    indx = i+1;
                                    ++i;
                                    system.debug('ITR same fiscal year jump..' + indx);
                                }
                                else {
                                    indx = i;  system.debug('Date of submission less ..' +indx);
                                }
                                
                            }
                            else{
                                indx = 0;
                            }
                        }
                        
                        
                        if(i==indx){
                            system.debug('ITR index map ' + indx +' '+listitrVDetails[i].financialYear +' '+listitrVDetails[i].dateOfSubmission);
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].financialYear)){
                                parobj.Year1__c=listitrVDetails[i].financialYear;
                                Year1 =parobj.Year1__c;
                            }
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].formNumber)){
                               form1=listitrVDetails[i].formNumber;
                            }
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.exemptIncome.agriculture))
                                Agric1=decimal.valueOf(listitrVDetails[i].incomeDetail.exemptIncome.agriculture) ;
                            
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.grossTotalIncome))
                                grossIncome1=Decimal.valueOf(listitrVDetails[i].incomeDetail.grossTotalIncome);
                            //if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.taxPayable))
                            //acc.Statutory_Deductions1__c=Decimal.valueOf(listitrVDetails[i].incomeDetail.taxPayable);
                            //Computation chnages replace taxPayable with interestPayable+netTaxPayable Dated 2018-May-08
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.interestPayable))
                                intrestPay1 = Decimal.valueOf(listitrVDetails[i].incomeDetail.interestPayable);
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.netTaxPayable))
                            {   netPay1 =  Decimal.valueOf(listitrVDetails[i].incomeDetail.netTaxPayable);}
                            Statutory1 = (intrestPay1 + netPay1);
                            form1=form1.remove('-');
                           ITRResponseHL.cls_itrDetails ITRRespo= ITResponse.itrDetails;
                            if(ITRRespo!=null){
                     		List<ITRResponseHL.cls_itr2> Itrr2List;
                            List<ITRResponseHL.cls_itr1> Itrr1List;
                            List<ITRResponseHL.cls_itr3> Itrr3List;
                            List<ITRResponseHL.cls_itr4> Itrr4List;
                            // ITR 2
                              Itrr2List=ITRRespo.itr2;
                             if(Itrr2List!=null && Itrr2List.size()>=0){
                                for(ITRResponseHL.cls_itr2 it2: Itrr2List){
                                    if(it2.fy==listitrVDetails[i].financialYear){
                                        if(!Utility.ISStringBlankorNull(string.valueOf(it2.partBTI.capGain.totalCapGains)))
                                            capitalGain1=Decimal.valueOf(it2.partBTI.capGain.totalCapGains);
                                        if(!Utility.ISStringBlankorNull(string.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.interestGross)))
                                            interestIncome1=Decimal.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.interestGross);
                                        if(!Utility.ISStringBlankorNull(string.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.dividendGross)))
                                            dividend1=Decimal.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.dividendGross);
                                        
                                    }
                                }
                             
                             }
                           // ITR 1 
                           Itrr1List=ITRRespo.itr1;
                            if(Itrr1List!=null && Itrr1List.size()>=0){
                                for(ITRResponseHL.cls_itr1 it1: Itrr1List){
                                    if(it1.fy==listitrVDetails[i].financialYear){
                                         if(!Utility.ISStringBlankorNull(string.valueOf(it1.itr1IncomeDeductions.incomeOthSrc)))
                                            interestIncome1=Decimal.valueOf(it1.itr1IncomeDeductions.incomeOthSrc);
                                    }
                                }
                            }
                                
                           // ITR 3
                           Itrr3List=ITRRespo.itr3;
                            if(Itrr3List!=null && Itrr3List.size()>=0){
                                for(ITRResponseHL.cls_itr3 it3: Itrr3List){
                                     if(it3.fy==listitrVDetails[i].financialYear){
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc)))
                                        firmShare = Decimal.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc);
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc)))
                                        aopboiShare= Decimal.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc);
                                    //Share of Profit
                                    //acc.Annual_Share_of_Profit_Firm_ITR__c = firmShare + aopboiShare;
                                    ShareOfProfit1 = firmShare + aopboiShare;
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.partBTI.capGain.totalCapGains)))
                                        capitalGain1=Decimal.valueOf(it3.partBTI.capGain.totalCapGains);
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.interestGross)))
                                        interestIncome1=Decimal.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.interestGross);
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.dividendGross)))
                                        dividend1=Decimal.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.dividendGross);
                                     }
                                }
                            }
                              // iTR 4  
                                Itrr4List=ITRRespo.itr4;
                            if(Itrr4List!=null && Itrr4List.size()>=0){
                                    for (ITRResponseHL.cls_itr4 it4 : Itrr4List) {
                                         if(it4.fy==listitrVDetails[i].financialYear){
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc)))
                                            firmShare = Decimal.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc);
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc)))
                                            aopboiShare = Decimal.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc);
                                        //Share of Profit
                                        //acc.Annual_Share_of_Profit_Firm_ITR__c = firmShare + aopboiShare;
                                        ShareOfProfit1 = firmShare + aopboiShare;
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.partBTI.capGain.totalCapGains)))
                                            capitalGain1 = Decimal.valueOf(it4.partBTI.capGain.totalCapGains);
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.interestGross)))
                                            interestIncome1 = Decimal.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.interestGross);
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.dividendGross)))
                                            dividend1 = Decimal.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.dividendGross);
                                         }
                                    }
                                
                            }
                            }
                        }
                        if(i==1 && indx == 0){
                            system.debug('ITR index map i==1 idx 0 ' +listitrVDetails[i].financialYear);
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.exemptIncome.agriculture))
                                Agric2=decimal.valueOf(listitrVDetails[i].incomeDetail.exemptIncome.agriculture) ;
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].financialYear))
                                parobj.Year2__c=listitrVDetails[i].financialYear;
                                Year2 = parobj.Year2__c;
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.grossTotalIncome))
                                grossIncome2=Decimal.valueOf(listitrVDetails[i].incomeDetail.grossTotalIncome);
                            // if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.taxPayable))
                            // acc.Statutory_Deductions2__c=Decimal.valueOf(listitrVDetails[i].incomeDetail.taxPayable);
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.interestPayable))
                                intrestPay2 = Decimal.valueOf(listitrVDetails[i].incomeDetail.interestPayable);
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.netTaxPayable))
                            {   netPay2 =  Decimal.valueOf(listitrVDetails[i].incomeDetail.netTaxPayable);}
                            Statutory2 = (intrestPay2 + netPay2);
                            ITRResponseHL.cls_itrDetails ITRRespo= ITResponse.itrDetails;
                            if(ITRRespo!=null){
                     		List<ITRResponseHL.cls_itr2> Itrr2List;
                            List<ITRResponseHL.cls_itr1> Itrr1List;
                            List<ITRResponseHL.cls_itr3> Itrr3List;
                            List<ITRResponseHL.cls_itr4> Itrr4List;
                            // ITR 2
                              Itrr2List=ITRRespo.itr2;
                             if(Itrr2List!=null && Itrr2List.size()>=0){
                                for(ITRResponseHL.cls_itr2 it2: Itrr2List){
                                    if(it2.fy==listitrVDetails[i].financialYear){
                                        if(!Utility.ISStringBlankorNull(string.valueOf(it2.partBTI.capGain.totalCapGains)))
                                            capitalGain2=Decimal.valueOf(it2.partBTI.capGain.totalCapGains);
                                        if(!Utility.ISStringBlankorNull(string.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.interestGross)))
                                            interestIncome2=Decimal.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.interestGross);
                                        if(!Utility.ISStringBlankorNull(string.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.dividendGross)))
                                            dividend2=Decimal.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.dividendGross);
                                        
                                    }
                                }
                             
                             }
                           // ITR 1 
                           Itrr1List=ITRRespo.itr1;
                            if(Itrr1List!=null && Itrr1List.size()>=0){
                                for(ITRResponseHL.cls_itr1 it1: Itrr1List){
                                    if(it1.fy==listitrVDetails[i].financialYear){
                                         if(!Utility.ISStringBlankorNull(string.valueOf(it1.itr1IncomeDeductions.incomeOthSrc)))
                                            interestIncome2=Decimal.valueOf(it1.itr1IncomeDeductions.incomeOthSrc);
                                    }
                                }
                            }
                                
                           // ITR 3
                           Itrr3List=ITRRespo.itr3;
                            if(Itrr3List!=null && Itrr3List.size()>=0){
                                for(ITRResponseHL.cls_itr3 it3: Itrr3List){
                                     if(it3.fy==listitrVDetails[i].financialYear){
                                         system.debug('Utility.ISStringBlankorNull(string.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc)):-'+Utility.ISStringBlankorNull(string.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc)));
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc)))
                                        firmShare = Decimal.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc);
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc)))
                                        aopboiShare= Decimal.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc);
                                    //Share of Profit
                                    //acc.Annual_Share_of_Profit_Firm_ITR__c = firmShare + aopboiShare;
                                    ShareOfProfit2 = firmShare + aopboiShare;
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.partBTI.capGain.totalCapGains)))
                                        capitalGain2=Decimal.valueOf(it3.partBTI.capGain.totalCapGains);
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.interestGross)))
                                        interestIncome2=Decimal.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.interestGross);
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.dividendGross)))
                                        dividend2=Decimal.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.dividendGross);

                                     }
                                }
                            }
                                system.debug('gg');
                              // iTR 4  
                                Itrr4List=ITRRespo.itr4;
                            if(Itrr4List!=null && Itrr4List.size()>=0){
                                    for (ITRResponseHL.cls_itr4 it4 : Itrr4List) {
                                         if(it4.fy==listitrVDetails[i].financialYear){
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc)))
                                            firmShare = Decimal.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc);
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc)))
                                            aopboiShare = Decimal.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc);
                                        //Share of Profit
                                        //acc.Annual_Share_of_Profit_Firm_ITR__c = firmShare + aopboiShare;
                                        ShareOfProfit2 = firmShare + aopboiShare;
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.partBTI.capGain.totalCapGains)))
                                            capitalGain2 = Decimal.valueOf(it4.partBTI.capGain.totalCapGains);
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.interestGross)))
                                            interestIncome2 = Decimal.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.interestGross);
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.dividendGross)))
                                            dividend2 = Decimal.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.dividendGross);
                                         }
                                    }
                                
                            }
                            }
                            
                        }
                        if(i==2 && indx == 1){
                            system.debug('ITR index map i==2 idx 1 ' +listitrVDetails[i].financialYear);
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.exemptIncome.agriculture))
                                Agric1=decimal.valueOf(listitrVDetails[i].incomeDetail.exemptIncome.agriculture) ;
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].financialYear))
                                parobj.Year1__c=listitrVDetails[i].financialYear;
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.grossTotalIncome))
                                grossIncome1=Decimal.valueOf(listitrVDetails[i].incomeDetail.grossTotalIncome);
                            // if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.taxPayable))
                            // acc.Statutory_Deductions2__c=Decimal.valueOf(listitrVDetails[i].incomeDetail.taxPayable);
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.interestPayable))
                                intrestPay1 = Decimal.valueOf(listitrVDetails[i].incomeDetail.interestPayable);
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.netTaxPayable))
                            {   netPay1 =  Decimal.valueOf(listitrVDetails[i].incomeDetail.netTaxPayable);}
                            Statutory1= (intrestPay1 + netPay1);
                             ITRResponseHL.cls_itrDetails ITRRespo= ITResponse.itrDetails;
                                 
                              if(ITRRespo!=null){
                     		List<ITRResponseHL.cls_itr2> Itrr2List;
                            List<ITRResponseHL.cls_itr1> Itrr1List;
                            List<ITRResponseHL.cls_itr3> Itrr3List;
                            List<ITRResponseHL.cls_itr4> Itrr4List;
                            // ITR 2
                              Itrr2List=ITRRespo.itr2;
                             if(Itrr2List!=null && Itrr2List.size()>=0){
                                for(ITRResponseHL.cls_itr2 it2: Itrr2List){
                                    if(it2.fy==listitrVDetails[i].financialYear){
                                        if(!Utility.ISStringBlankorNull(string.valueOf(it2.partBTI.capGain.totalCapGains)))
                                            capitalGain1=Decimal.valueOf(it2.partBTI.capGain.totalCapGains);
                                        if(!Utility.ISStringBlankorNull(string.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.interestGross)))
                                            interestIncome1=Decimal.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.interestGross);
                                        if(!Utility.ISStringBlankorNull(string.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.dividendGross)))
                                            dividend1=Decimal.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.dividendGross);
                                        
                                    }
                                }
                             
                             }
                                  
                           // ITR 1 
                           Itrr1List=ITRRespo.itr1;
                            if(Itrr1List!=null && Itrr1List.size()>=0){
                                for(ITRResponseHL.cls_itr1 it1: Itrr1List){
                                    if(it1.fy==listitrVDetails[i].financialYear){
                                         if(!Utility.ISStringBlankorNull(string.valueOf(it1.itr1IncomeDeductions.incomeOthSrc)))
                                            interestIncome1=Decimal.valueOf(it1.itr1IncomeDeductions.incomeOthSrc);
                                    }
                                }
                            }
                                
                           // ITR 3
                           Itrr3List=ITRRespo.itr3;
                            if(Itrr3List!=null && Itrr3List.size()>=0){
                                for(ITRResponseHL.cls_itr3 it3: Itrr3List){
                                     if(it3.fy==listitrVDetails[i].financialYear){
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc)))
                                        firmShare = Decimal.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc);
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc)))
                                        aopboiShare= Decimal.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc);
                                    //Share of Profit
                                    //acc.Annual_Share_of_Profit_Firm_ITR__c = firmShare + aopboiShare;
                                    ShareOfProfit2 = firmShare + aopboiShare;
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.partBTI.capGain.totalCapGains)))
                                        capitalGain1=Decimal.valueOf(it3.partBTI.capGain.totalCapGains);
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.interestGross)))
                                        interestIncome1=Decimal.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.interestGross);
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.dividendGross)))
                                        dividend1=Decimal.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.dividendGross);
                                     }
                                }
                            }
                              // iTR 4  
                                Itrr4List=ITRRespo.itr4;
                            if(Itrr4List!=null && Itrr4List.size()>=0){
                                    for (ITRResponseHL.cls_itr4 it4 : Itrr4List) {
                                         if(it4.fy==listitrVDetails[i].financialYear){
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc)))
                                            firmShare = Decimal.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc);
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc)))
                                            aopboiShare = Decimal.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc);
                                        //Share of Profit
                                        //acc.Annual_Share_of_Profit_Firm_ITR__c = firmShare + aopboiShare;
                                        ShareOfProfit2 = firmShare + aopboiShare;
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.partBTI.capGain.totalCapGains)))
                                            capitalGain1 = Decimal.valueOf(it4.partBTI.capGain.totalCapGains);
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.interestGross)))
                                            interestIncome1 = Decimal.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.interestGross);
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.dividendGross)))
                                            dividend1 = Decimal.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.dividendGross);
                                         }
                                    }
                                
                            }
                            }
                          
                            
                        }
                        if(i==2 && indx == 0){
                            system.debug('ITR index map i==2 LAP ' +listitrVDetails[i].financialYear);
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.exemptIncome.agriculture))
                                Agric3=decimal.valueOf(listitrVDetails[i].incomeDetail.exemptIncome.agriculture) ;
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].financialYear))
                                parobj.Year3__c=listitrVDetails[i].financialYear;
                                Year3 = parobj.Year3__c;
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.grossTotalIncome))
                                grossIncome3=Decimal.valueOf(listitrVDetails[i].incomeDetail.grossTotalIncome);
                            // if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.taxPayable))
                            // acc.Statutory_Deductions2__c=Decimal.valueOf(listitrVDetails[i].incomeDetail.taxPayable);
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.interestPayable))
                                intrestPay3 = Decimal.valueOf(listitrVDetails[i].incomeDetail.interestPayable);
                            if(!Utility.ISStringBlankorNull(listitrVDetails[i].incomeDetail.netTaxPayable))
                            {   netPay3 =  Decimal.valueOf(listitrVDetails[i].incomeDetail.netTaxPayable);}
                            Statutory3= (intrestPay3 + netPay3);
                             ITRResponseHL.cls_itrDetails ITRRespo= ITResponse.itrDetails;
                                 
                              if(ITRRespo!=null){
                     		List<ITRResponseHL.cls_itr2> Itrr2List;
                            List<ITRResponseHL.cls_itr1> Itrr1List;
                            List<ITRResponseHL.cls_itr3> Itrr3List;
                            List<ITRResponseHL.cls_itr4> Itrr4List;
                            // ITR 2
                              Itrr2List=ITRRespo.itr2;
                             if(Itrr2List!=null && Itrr2List.size()>=0){
                                for(ITRResponseHL.cls_itr2 it2: Itrr2List){
                                    if(it2.fy==listitrVDetails[i].financialYear){
                                        if(!Utility.ISStringBlankorNull(string.valueOf(it2.partBTI.capGain.totalCapGains)))
                                            capitalGain3=Decimal.valueOf(it2.partBTI.capGain.totalCapGains);
                                        if(!Utility.ISStringBlankorNull(string.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.interestGross)))
                                            interestIncome3=Decimal.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.interestGross);
                                        if(!Utility.ISStringBlankorNull(string.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.dividendGross)))
                                            dividend3=Decimal.valueOf(it2.scheduleOS.incOthThanOwnRaceHorse.dividendGross);
                                        
                                    }
                                }
                             
                             }
                                  
                           // ITR 1 
                           Itrr1List=ITRRespo.itr1;
                            if(Itrr1List!=null && Itrr1List.size()>=0){
                                for(ITRResponseHL.cls_itr1 it1: Itrr1List){
                                    if(it1.fy==listitrVDetails[i].financialYear){
                                         if(!Utility.ISStringBlankorNull(string.valueOf(it1.itr1IncomeDeductions.incomeOthSrc)))
                                            interestIncome3=Decimal.valueOf(it1.itr1IncomeDeductions.incomeOthSrc);
                                    }
                                }
                            }
                                
                           // ITR 3
                           Itrr3List=ITRRespo.itr3;
                            if(Itrr3List!=null && Itrr3List.size()>=0){
                                for(ITRResponseHL.cls_itr3 it3: Itrr3List){
                                     if(it3.fy==listitrVDetails[i].financialYear){
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc)))
                                        firmShare = Decimal.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc);
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc)))
                                        aopboiShare= Decimal.valueOf(it3.itr3ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc);
                                    //Share of Profit
                                    //acc.Annual_Share_of_Profit_Firm_ITR__c = firmShare + aopboiShare;
                                    ShareOfProfit3 = firmShare + aopboiShare;
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.partBTI.capGain.totalCapGains)))
                                        capitalGain3=Decimal.valueOf(it3.partBTI.capGain.totalCapGains);
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.interestGross)))
                                        interestIncome3=Decimal.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.interestGross);
                                    if(!Utility.ISStringBlankorNull(string.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.dividendGross)))
                                        dividend3=Decimal.valueOf(it3.scheduleOS.incOthThanOwnRaceHorse.dividendGross);
                                     }
                                }
                            }
                              // iTR 4  
                                Itrr4List=ITRRespo.itr4;
                            if(Itrr4List!=null && Itrr4List.size()>=0){
                                    for (ITRResponseHL.cls_itr4 it4 : Itrr4List) {
                                         if(it4.fy==listitrVDetails[i].financialYear){
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc)))
                                            firmShare = Decimal.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.firmShareInc);
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc)))
                                            aopboiShare = Decimal.valueOf(it4.itr4ScheduleBP.businessIncOthThanSpec.incCredPL.aopboiSharInc);
                                        //Share of Profit
                                        //acc.Annual_Share_of_Profit_Firm_ITR__c = firmShare + aopboiShare;
                                        ShareOfProfit3 = firmShare + aopboiShare;
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.partBTI.capGain.totalCapGains)))
                                            capitalGain3 = Decimal.valueOf(it4.partBTI.capGain.totalCapGains);
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.interestGross)))
                                            interestIncome3 = Decimal.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.interestGross);
                                        if (!Utility.ISStringBlankorNull(string.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.dividendGross)))
                                            dividend3 = Decimal.valueOf(it4.scheduleOS.incOthThanOwnRaceHorse.dividendGross);
                                         }
                                    }
                                
                            }
                            }
                          
 
                        }
                        }
                    
                    
                    NIY1=grossIncome1-Statutory1-capitalGain1-interestIncome1-dividend1;
                    System.debug('-->'+NIY1);
                    NIY2=grossIncome2-Statutory2-capitalGain2-interestIncome2-dividend2;
                    System.debug('--->'+NIY2);
                    NIY =grossIncome3-statutory3-capitalGain3-interestIncome3-dividend3;
                    System.debug('---->'+NIY);
                    // parobj
                    parobj.Gross_Income1__c = grossIncome1;
                    parobj.Annual_Tax1__c = Statutory1;
                    parobj.Gross_Income2__c = grossIncome2;
                    parobj.Annual_Tax2__c =Statutory2;
                    
                    //for lap
                    parobj.Gross_Income3__c = grossIncome3;
                    parobj.Annual_Tax3__c = statutory3;
                    
                    parobj.Annual_Capital_Gain1__c = capitalGain1;
                    parobj.Interest_Income1__c = interestIncome1;
                    parobj.Dividend_Income1__c = dividend1;
                    
                    parobj.Annual_Capital_Gain2__c = capitalGain2;
                    parobj.Interest_Income2__c = interestIncome2;
                    parobj.Dividend_Income2__c = dividend2;
                    
                    
                    //for lap
                    parobj.Annual_Capital_Gain3__c = capitalGain3;
                    parobj.Interest_income3__c = interestIncome3;
                    parobj.Dividend_income3__c = dividend3;
                    
                    
                    // Added by venu
                    parobj.Agriculture_ITR1__c = Agric1;
                    parobj.Agriculture_ITR2__c = Agric2;
                    parobj.Agriculture_ITR3__c = Agric3;
                    
                    parobj.Share_of_Profit_1__c = ShareOfProfit1;
                    parobj.Share_of_Profit_2__c = ShareOfProfit2;
                    parobj.Share_of_Profit_3__c = ShareOfProfit3;
                    
                    System.debug('===>'+parobj);
                    
                    decimal EstimatedIncomeITr = 0;
                    decimal NMIasperITR = 0;
                    decimal TotalShareOfProfit = 0;
                    decimal EstiAgriITR =0;
                    //for lap
                    if(application <> null && application.Record_Type_Name__c == Constants.LAPLOAN){
                        System.debug('FOR LAP RECORD TYPE');
                        EstimatedIncomeITr=math.min(((NIY1+NIY2+NIY)/3), NIY1);
                        System.debug('###>'+EstimatedIncomeITr);
                        AgriAsPerITR=math.min(((Agric1+Agric2+Agric3)/3), Agric1);
                        TotalShareOfProfit = math.min(((ShareOfProfit1+ShareOfProfit2+ShareOfProfit3)/3), ShareOfProfit1);
                    }else{
                        EstimatedIncomeITr=math.min(((NIY1+NIY2)/2), NIY1);
                        System.debug('####>>'+EstimatedIncomeITr);
                        AgriAsPerITR=math.min(((Agric1+Agric2)/2), Agric1);
                        TotalShareOfProfit = math.min(((ShareOfProfit1+ShareOfProfit2)/2), ShareOfProfit1);
                    }
                    
                    
                    
                    
                    parobj.Annual_Agriculture_Income_ITR__c=AgriAsPerITR;
                    parobj.Annual_Share_of_Profit_Firm_ITR__c = TotalShareOfProfit;
                    
                    // account ac=[select id,Employment_Type__c from account where id=:accID limit 1];
                    
                    genesis__Application_Parties__c par1=queryService.PartieswithAcc(accID,appID);
                    
                    System.debug('**parties after query'+par1);
                    
                    
                    if(par1.Employment_Types__c==Constants.EmpType_Agricul){
                        System.debug('Check Employment type');
                        EstiAgriITR =0;
                    }else{
                        //EstiAgriITR=Math.min(Math.min(decimal.valueOf(system.label.EstAgriTwo_Lacs), AgriAsPerITR),(EstimatedIncomeITr+EstShareOfProfit)/0.70);
                        // updated on 3-may-2018 multiply by 0.30 as per document Perfios income computation-v2
                        EstiAgriITR=Math.min(Math.min(decimal.valueOf(system.label.EstAgriTwo_Lacs), AgriAsPerITR),(EstimatedIncomeITr/0.70)*0.30);
                        System.debug('@@@-----> '+EstiAgriITR);
                    }
                    
                    //for lap
                    if(application <> null && application.Record_Type_Name__c == Constants.LAPLOAN){
                        System.debug('LAP LAP LAP LAP LAP');
                        NMIasperITR=(EstiAgriITR+TotalShareOfProfit+EstimatedIncomeITr)/12;
                        System.debug('!!!!!!!!>>>>'+NMIasperITR);
                    }else{
                        NMIasperITR=(EstiAgriITR+TotalShareOfProfit+EstimatedIncomeITr)/12;
                        System.debug('!!!!!!!!>>>>'+NMIasperITR);
                    }
                    
                    parobj.NMI_as_per_ITR__c=NMIasperITR;
                    parobj.ITR_Uploaded__c = false;
                    
                    
                    applicationData.ITR_Uploaded__c = False;
                    system.debug('account update ' +parobj);
                 
                    update parobj;
                    update applicationData;
     //             
                    
                    System.debug('accaccaccacc'+parobj);
                    System.debug(''+applicationData);
              		 perUp.grIncome1        = String.valueOf(grossIncome1);
                     perUp.grIncome2        = String.valueOf(grossIncome2);
                     perUp.grIncome3        = String.valueOf(grossIncome3);
                     perUp.intIncome1       = String.valueOf(interestIncome1);
                     perUp.intIncome2       = String.valueOf(interestIncome2);
                     perUp.intIncome3       = String.valueOf(interestIncome3);
                     perUp.ShareProfit1     = String.valueOf(ShareOfProfit1);
                     perUp.ShareProfit2     = String.valueOf(ShareOfProfit2);
                     perUp.ShareProfit3     = String.valueOf(ShareOfProfit3);
                     perUp.div1             = String.valueOf(dividend1);
                     perUp.div2             = String.valueOf(dividend2);
                     perUp.div3             = String.valueOf(dividend3);
                     perUp.tax1             = String.valueOf(Statutory1);
                     perUp.tax2             = String.valueOf(Statutory2);
                     perup.tax3             = String.valueOf(Statutory3);
                     perUp.Agr1             = String.valueOf(Agric1);
                     perUp.Agr2             = String.valueOf(Agric2);
                     perUp.Agr3             = String.valueOf(Agric3);
                     perUp.capGain1         = String.valueOf(capitalGain1);
                     perUp.capGain2         = String.valueOf(capitalGain2);
                     perUp.capGain3         = String.valueOf(capitalGain3);
                     perUp.AgriperITR       = String.valueOf(AgriAsPerITR);
                     perUp.TotalShareProfit = String.valueOf(TotalShareOfProfit);
                     perUp.year1            = Year1;
                     perUp.year2            = Year2;
                     perUp.year3            = Year3;
                   	 perUp.EstimatedAgriITR=String.valueOf(EstiAgriITR );
                     perUp.EstimatedIncomeITR=String.valueOf(EstimatedIncomeITr) ;
                    // perUp.finYear          =;
                

                }
                
            }
        }
        catch(exception e){
            system.debug('e:'+e.getStackTraceString()+'	line number:-'+e.getLineNumber());
            HandleBusinessException.captureError('HL_Perfios_CallingAPI', 'ParseITRResponse', e);
            system.debug('Error'+e.getStackTraceString()+'Line Number'+e.getLineNumber() +'ErrorMsg : '+e.getMessage());
        }
        
        return perUP;
        
    }
    
    // form 26 AS
    public static void ParseForm26ASchange(Form26asResponse FResp,string accID,string appID){
        
        System.debug(FResp);
        try{
            if(FResp!=null){
                
                Form_26_As__c formobj=new Form_26_As__c();
                Form26asResponse.cls_form26ASDetails   fres=FResp.form26ASDetails;
                List<Form26asResponse.cls_form26asInfo>  fplist=fres.form26asInfo;
                
                Form26asResponse.cls_personalInfo perinfo=fres.personalInfo;
                List<TdsDetail__c> tddetailslist=new List<TdsDetail__c>();
                System.debug('****test account'+accID);
                formobj.Applicant__c=accID;
                if(appID!=null){
                formobj.Application__c=appID;
                }
                if(!Utility.ISStringBlankorNull(perinfo.pan))
                    formobj.PAN__c=perinfo.pan;
                if(!Utility.ISStringBlankorNull(perinfo.panStatus))
                    formobj.Pan_Status__c=perinfo.panStatus;
                if(!Utility.ISStringBlankorNull(perinfo.name))
                    formobj.Name__c=perinfo.name;
                if(!Utility.ISStringBlankorNull(perinfo.dob))
                    formobj.Dob__c=perinfo.dob;
                if(!Utility.ISStringBlankorNull(perinfo.address))
                    formobj.address__c=perinfo.address;
                insert  formobj;
                
                String  formobjid=formobj.id;
                
                System.debug('fplist'+fplist);
                List<Form26asResponse.cls_nonTdsList> nontdlistin;
                List<Form26asResponse.cls_tdsList> tdlist;
                
                if(fplist!=null){
                    
                    //List<Form26info__c> infolist=new List<Form26info__c>();
                    
                    for(Form26asResponse.cls_form26asInfo fp:fplist){
                        
                        tdlist  =fp.tdsList;
                        nontdlistin=fp.nonTdsList;
                        
                        Form26info__c forminfoobj=new Form26info__c();
                        
                        ///assign value
                        if(!Utility.ISStringBlankorNull(fp.assessmentYear))
                            forminfoobj.Assessment_year__c=fp.assessmentYear;
                        if(!Utility.ISStringBlankorNull(fp.financialYear))
                            forminfoobj.Financial_Year__c= fp.financialYear;  
                        forminfoobj.Form_26_As__c=formobjid;
                        
                        insert forminfoobj;
                        String  forminfoobjid=forminfoobj.id;
                        
                        for(Form26asResponse.cls_nonTdsList nontd: nontdlistin){
                            
                            TdsDetail__c nontddet=new TdsDetail__c();
                            if(!Utility.ISStringBlankorNull(nontd.tax))
                                nontddet.Tax__c=nontd.tax;
                            if(!Utility.ISStringBlankorNull(nontd.bsrCode))
                                nontddet.Bsr_Code__c=nontd.bsrCode;
                            if(!Utility.ISStringBlankorNull(nontd.minorHead))
                                nontddet.minorHead__c=nontd.minorHead;
                            
                            if(!Utility.ISStringBlankorNull(nontd.majorHead))
                                nontddet.Major_Head__c=nontd.majorHead;
                            nontddet.RecordTypeId = Schema.SObjectType.TdsDetail__c.getRecordTypeInfosByName().get('NonTdsList').getRecordTypeId();
                            
                            nontddet.Form26info__c=forminfoobjid;
                            tddetailslist.add(nontddet);
                        }
                        
                        for(Form26asResponse.cls_tdsList Td1: tdlist){
                            
                            
                            TdsDetail__c tddet=new TdsDetail__c();
                            if(Td1.section==Constants.form26Section){
                            if(!Utility.ISStringBlankorNull(Td1.amount))
                                tddet.Amount__c =Td1.amount;
                            
                            if(!Utility.ISStringBlankorNull(Td1.deductor))
                                tddet.Deductor__c =Td1.deductor;
                            if(!Utility.ISStringBlankorNull(Td1.section))
                                tddet.Section__c =Td1.section;
                            if(!Utility.ISStringBlankorNull(Td1.tan))
                                tddet.Tan__c =Td1.tan;
                            if(!Utility.ISStringBlankorNull(Td1.taxDeducted))
                                tddet.taxDeducted__c=Td1.taxDeducted;
                             if(!Utility.ISStringBlankorNull(Td1.tdsDate))
                                tddet.tdsDate__c=Date.valueOf(Td1.tdsDate);
                            tddet.RecordTypeId = Schema.SObjectType.TdsDetail__c.getRecordTypeInfosByName().get('TDSList').getRecordTypeId();
                            
                            tddet.Form26info__c=forminfoobjid;
                            
                            tddetailslist.add(tddet);
                        }
                      }                        
                        
                        
                    }
                }
                
                Database.insert(tddetailslist);
            }
            
            //// start calculation
            List<Form_26_As__c> FormList=[select id,PAN__c,Applicant__c,Date__c,(select id from Form26infos__r) from Form_26_As__c where Applicant__c=:accID AND Application__c=:appID order by Date__c ];
            System.debug('FormList'+FormList);
            set<id> infoidset=new set<id>();
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
            /*for(TdsDetail__c tddetailcapture : tdlist){

system.debug('**amount'+tddetailcapture.amount__c);
system.debug('**tax'+tddetailcapture.Tax__c);
}*/
            /*
decimal I1,I2,I3,Q1,Q2,Q3;
for(integer i=0; i<tdlist.size(); i++){
if(i==0){
I1=Decimal.valueOf(tdlist[i].amount__c);
System.debug(I1);
}
if(i==1){
I2=Decimal.valueOf(tdlist[i].amount__c);
System.debug(I2);
}
if(i==2){
I3=Decimal.valueOf(tdlist[i].amount__c);
}
if(i==3){
Q1=Decimal.valueOf(tdlist[i].taxDeducted__c);
}
if(i==4){
Q2=Decimal.valueOf(tdlist[i].taxDeducted__c);
}
if(i==5){
Q3=Decimal.valueOf(tdlist[i].taxDeducted__c);
}


}*/
            Decimal I1=0.0,Q1=0.0;
            
            for(TdsDetail__c td :tdlist){
                if(!Utility.ISStringBlankorNull(td.amount__c)){
                    I1=I1+Decimal.valueOf(td.amount__c);
                    
                }
                if(!Utility.ISStringBlankorNull(td.taxDeducted__c)){
                    Q1=Q1+Decimal.valueOf(td.taxDeducted__c);
                    
                }
                
            }
            System.debug(I1);
            System.debug(Q1);
            if(I1!=null && length > 0){
                Decimal AmountPaid=I1;
                Decimal TaxDecucted=Q1;
                Decimal EstimatedIncome=AmountPaid-TaxDecucted;
                Decimal NMIAsPer26AS=(EstimatedIncome/length).setscale(2);
                
                System.debug('NMIAsPer26AS'+NMIAsPer26AS);
  //              AppAccountNMIJunction__c accAppNMIJunction = queryService.getNMIJunction(accID,appID);//new AppAccountNMIJunction__c();
                // stroing info acc will comment later
                genesis__Application_Parties__c parobj=new genesis__Application_Parties__c();
                //quert parties
                genesis__Application_Parties__c par=queryService.PartieswithAcc(accID,appID);
                parobj.id=par.id;
                System.debug('**parties account after query'+parobj);
                parobj.NMI_as_per_26AS__c=NMIAsPer26AS;
                parobj.Amount_Paid__c = AmountPaid; // Discussed with Akshya updated on 2018/10/04
                parobj.Tax_Deducted__c = TaxDecucted;
                update parobj;
    //            accAppNMIJunction.NMI_as_per_26AS__c = NMIAsPer26AS;
   //             update accAppNMIJunction;
                
            }
        }
        
        
        
        catch(Exception e){
            HandleBusinessException.captureError('HL_Perfios_CallingAPI', 'ParseForm26ASchange', e);
            System.debug('error'+e.getLineNumber()+'Error msg'+e.getStackTraceString()+'Msg'+e.getMessage() );
           
        }
        
        
        
    }
    

    public class perfiosUpdate {
        public String grIncome1;
        public String grIncome2;
        public String grIncome3;
        public String intIncome1;
        public String intIncome2;
        public String intIncome3;
        public String ShareProfit1;
        public String ShareProfit2;
        public String ShareProfit3;
        public String div1;
        public String div2;
        public String div3;
        public String tax1;
        public String tax2;
        public String tax3;
        public String Agr1;
        public String Agr2;
        public String Agr3;
        public String capGain1;
        public String capGain2;
        public String capGain3;
        public String AgriperITR; 
        public String TotalShareProfit;
        public String year1;
        public String year2;
        public String year3;
        public string EstimatedAgriITR;
         public string EstimatedIncomeITR;
        
    }
    
    
    ////change 
    public class StatusReport{
        public string TxnID;
        public string ErrorMsg;
    }
    
}