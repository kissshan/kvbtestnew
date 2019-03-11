/**
 * Created by ET-MARLABS on 08-06-2018.
 */

public with sharing class YTDAnalysisHelper {

    public static Integer currentYear                                   = Utility.getCurrentYear();
    public static String cyString                                       = String.valueOf(currentYear);
    public static String currFiscalYear                                 = (currentYear-1)+'-'+Integer.valueOf(cyString.subString(cyString.length()-2,cyString.length()));
    public static String nthFiscalYear                                  = (currentYear-2)+'-'+Integer.valueOf(String.valueOf(currentYear-1).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));
    public static String n_1_FiscalYear                                 = (currentYear-3)+'-'+Integer.valueOf(String.valueOf(currentYear-2).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));
    public static String n_2_FiscalYear                                 = (currentYear-4)+'-'+Integer.valueOf(String.valueOf(currentYear-3).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));
    public static String nextEstFiscalYear                              = currentYear+'-'+Integer.valueOf(String.valueOf(currentYear+1).subString(String.valueOf(currentYear+1).length()-2,String.valueOf(currentYear+1).length()));
    public static String nextProjFiscalYear                             = (currentYear+1)+'-'+Integer.valueOf(String.valueOf(currentYear+2).subString(String.valueOf(currentYear+2).length()-2,String.valueOf(currentYear+2).length()));
    public static Map<String , Decimal> ytdAnalysisValueMap             = new Map<String, Decimal>();
    public static Map<String , String> ytdAnalysisRangeMap             = new Map<String, String>();
    public static String getEstimateSalesAnalysis(String losCustId,String appId){
        try{
            M68_Balance_Sheet_Analysis__c m68DataEstimated              = new M68_Balance_Sheet_Analysis__c();
            M68_Balance_Sheet_Analysis__c m68DataProjected              = new M68_Balance_Sheet_Analysis__c();
            M68_Balance_Sheet_Analysis__c m68YTDRecord                  = new M68_Balance_Sheet_Analysis__c();
            List<M68_Balance_Sheet_Analysis__c> m68DataList             = new List<M68_Balance_Sheet_Analysis__c>();
            List<String> fyList                                         = new List<String>{nthFiscalYear,n_1_FiscalYear,n_2_FiscalYear,currFiscalYear,nextProjFiscalYear,nextEstFiscalYear};
           system.debug('fyList==++'+fyList);
             m68DataList                                                 = SOQL_Util.getM68Data(losCustId,fyList);
           system.debug('m68DataList==++'+m68DataList);
            Decimal salesForN_1,salesForN_2,purchaseForN_1,purchaseForN_2;
            Integer flag=0;
            M68_Balance_Sheet_Analysis__c nthYearData                   = new M68_Balance_Sheet_Analysis__c();
            M68_Balance_Sheet_Analysis__c n_1_thYearData                = new M68_Balance_Sheet_Analysis__c();
            M68_Balance_Sheet_Analysis__c n_2_thYearData                = new M68_Balance_Sheet_Analysis__c();

            if(m68DataList != null && !m68DataList.isEmpty()) {
                for (M68_Balance_Sheet_Analysis__c m68Data : m68DataList) {

                    if(m68Data.Fiscal_Year__c == currFiscalYear && m68Data.Financial_type__c == 'Actual') {

                        salesForN_1                                     = m68Data.Net_sales__c;
                        purchaseForN_1                                  = m68Data.Purchases__c;
                        nthYearData                                     =m68Data;
                        flag++;

                    }else if (m68Data.Fiscal_Year__c == nthFiscalYear && m68Data.Financial_type__c == 'Actual') {
                        //newly added by souvik on 07.06.2018
                        n_1_thYearData                                  = m68Data;
                        flag++;
                    }
                    else if (m68Data.Fiscal_Year__c == n_1_FiscalYear && m68Data.Financial_type__c == 'Actual') {

                        salesForN_2                                     = m68Data.Net_sales__c;
                        purchaseForN_2                                  = m68Data.Purchases__c;
                        n_2_thYearData                                  = m68Data;
                        flag++;
                        system.debug('flag==++'+flag);
                    }else if (m68Data.Fiscal_Year__c == nextEstFiscalYear && m68Data.Financial_type__c == 'Estimated') {
                        m68DataEstimated                                = m68Data;
                    }else if (m68Data.Fiscal_Year__c == nextProjFiscalYear && m68Data.Financial_type__c == 'Projected') {
                        m68DataProjected                                = m68Data;
                    }else if (m68Data.Fiscal_Year__c == nextEstFiscalYear && m68Data.Financial_type__c == 'YTD') {
                        m68YTDRecord                                    = m68Data;
                    }

                }
            }
            if(flag == 3){
                if(m68DataEstimated !=null){
                      system.debug('m68DataEstimated==++'+m68DataEstimated);
                    If(m68DataEstimated.Net_sales__c !=null){
                        Boolean estimatedSalesAnalysisFlag      = YTDAnalysisHelper.getSalesAnalysisFlag(salesForN_1,salesForN_2,m68DataEstimated.Net_sales__c,'EST');

                        If(estimatedSalesAnalysisFlag !=null){
                             YTDAnalysisController.ytdAnalysisMap.put('Estimated Sales (Rs.)',estimatedSalesAnalysisFlag);
                             ytdAnalysisValueMap.put('Estimated Sales (Rs.)',(m68DataEstimated.Net_sales__c).setScale(2));
                            ytdAnalysisRangeMap.put('Estimated Sales (Rs.)','Must be consistent with historical trend');
                        }
                           
                    }

                    If(m68DataEstimated.Purchases__c !=null){

                        Boolean estimatedpurchaseAnalysisFlag   = YTDAnalysisHelper.getPurchaseAnalysisFlag(purchaseForN_1,purchaseForN_2,m68DataEstimated.Purchases__c,'EST');

                        If(estimatedpurchaseAnalysisFlag !=null){
                            YTDAnalysisController.ytdAnalysisMap.put('Estimated Purchase (Rs.)',estimatedpurchaseAnalysisFlag);
                            ytdAnalysisValueMap.put('Estimated Purchase (Rs.)',(m68DataEstimated.Purchases__c).setScale(2));
                            ytdAnalysisRangeMap.put('Estimated Purchase (Rs.)','Must be consistent with historical trend');
                        }
                            
                    }

                }
                if(m68DataProjected !=null){
                    If(m68DataProjected.Net_sales__c !=null){
                        Boolean ProjectedSalesAnalysisFlag      = YTDAnalysisHelper.getSalesAnalysisFlag(salesForN_1,salesForN_2,m68DataProjected.Net_sales__c,'PROJ');
                        If(ProjectedSalesAnalysisFlag !=null){
                            YTDAnalysisController.ytdAnalysisMap.put('Projected Sales (Rs.)',ProjectedSalesAnalysisFlag);
                            ytdAnalysisValueMap.put('Projected Sales (Rs.)',(m68DataProjected.Net_sales__c).setScale(2));
                            ytdAnalysisRangeMap.put('Projected Sales (Rs.)','Must be consistent with historical trend');
                        }
                            
                    }
                    If(m68DataProjected.Purchases__c !=null){

                        Boolean ProjectedpurchaseAnalysisFlag   = YTDAnalysisHelper.getPurchaseAnalysisFlag(purchaseForN_1,purchaseForN_2,m68DataProjected.Purchases__c,'PROJ');
                        If(ProjectedpurchaseAnalysisFlag !=null){
                            YTDAnalysisController.ytdAnalysisMap.put('Projected Purchase (Rs.)',ProjectedpurchaseAnalysisFlag);
                            ytdAnalysisValueMap.put('Projected Purchase (Rs.)',(m68DataProjected.Purchases__c).setScale(2));
                            ytdAnalysisRangeMap.put('Projected Purchase (Rs.)','Must be consistent with historical trend');
                        }
                            
                    }
                }
                If(nthYearData !=null && n_1_thYearData !=null && n_2_thYearData !=null && m68DataEstimated.Sundry_Creditors__c!=null && m68DataEstimated.Purchases__c !=null && m68DataEstimated.Sundry_Debtors__c !=null && m68DataEstimated.Net_sales__c !=null){

                    Boolean ECVA = getDeltaFlag(calculateVelocity(nthYearData,'CREDITOR'),calculateVelocity(n_1_thYearData,'CREDITOR'),calculateVelocity(n_2_thYearData,'CREDITOR'),m68DataEstimated.Sundry_Creditors__c/m68DataEstimated.Purchases__c);
                    Boolean EDVA = getDeltaFlag(calculateVelocity(nthYearData,'DEBITOR'),calculateVelocity(n_1_thYearData,'DEBITOR'),calculateVelocity(n_2_thYearData,'DEBITOR'),m68DataEstimated.Sundry_Debtors__c/m68DataEstimated.Net_sales__c);
                    Boolean PCVA = getDeltaFlag(calculateVelocity(nthYearData,'CREDITOR'),calculateVelocity(n_1_thYearData,'CREDITOR'),calculateVelocity(n_2_thYearData,'CREDITOR'),m68DataProjected.Sundry_Creditors__c/m68DataProjected.Purchases__c);
                    Boolean PDVA = getDeltaFlag(calculateVelocity(nthYearData,'DEBITOR'),calculateVelocity(n_1_thYearData,'DEBITOR'),calculateVelocity(n_2_thYearData,'DEBITOR'),m68DataProjected.Sundry_Debtors__c/m68DataProjected.Net_sales__c);
                    If(ECVA !=null){
                        System.debug('####ECVA'+ECVA);
                        YTDAnalysisController.ytdAnalysisMap.put('Estimated Creditors Velocity (days)',ECVA);
                        ytdAnalysisValueMap.put('Estimated Creditors Velocity (days)',(calculateVelocity(m68DataEstimated,'CREDITOR')).setScale(2));
                        ytdAnalysisRangeMap.put('Estimated Creditors Velocity (days)','Non increasing / consistent trend ');
                    }
                        
                    If(EDVA !=null){
                        YTDAnalysisController.ytdAnalysisMap.put('Estimated Debtors Velocity (days)',EDVA);
                        ytdAnalysisValueMap.put('Estimated Debtors Velocity (days)',(calculateVelocity(m68DataEstimated,'DEBITOR')).setScale(2));
                        ytdAnalysisRangeMap.put('Estimated Debtors Velocity (days)','Non increasing / consistent trend');
                    }
                        
                    If(PCVA !=null){
                        YTDAnalysisController.ytdAnalysisMap.put('Projected Creditors Velocity (days)',PCVA);
                        ytdAnalysisValueMap.put('Projected Creditors Velocity (days)',(calculateVelocity(m68DataProjected,'CREDITOR')).setScale(2));
                        ytdAnalysisRangeMap.put('Projected Creditors Velocity (days)','Non increasing / consistent trend ');
                    }
                        
                    If(PDVA !=null){
                        YTDAnalysisController.ytdAnalysisMap.put('Projected Debtors Velocity (days)',PDVA);
                        ytdAnalysisValueMap.put('Projected Debtors Velocity (days)',(calculateVelocity(m68DataProjected,'DEBITOR')).setScale(2));
                        ytdAnalysisRangeMap.put('Projected Debtors Velocity (days)','Non increasing / consistent trend ');
                    }
                        

                }
                if(m68YTDRecord != null && m68DataEstimated != null){
                    Boolean ytdSalesFlag= YTDAnalysisHelper.getYTDAnalysis(m68YTDRecord,'SALES',m68DataEstimated.Net_sales__c);
                    If(ytdSalesFlag !=null){
                        YTDAnalysisController.ytdAnalysisMap.put('YTD Sales (Rs. )',ytdSalesFlag);
                        ytdAnalysisValueMap.put('YTD Sales (Rs. )',(m68YTDRecord.Net_sales__c).setScale(2));
                        ytdAnalysisRangeMap.put('YTD Sales (Rs. )',String.valueOf((m68DataEstimated.Net_sales__c).setScale(2))+' (Estimated Sales) must be consistent with YTD sales');
                    }

                    Boolean ytdPurchaseFlag= YTDAnalysisHelper.getYTDAnalysis(m68YTDRecord,'PURCHASE',m68DataEstimated.Purchases__c);
                    If(ytdPurchaseFlag !=null){
                        YTDAnalysisController.ytdAnalysisMap.put('YTD Purchase (Rs.)',ytdPurchaseFlag);
                        ytdAnalysisValueMap.put('YTD Purchase (Rs.)',(m68YTDRecord.Purchases__c).setScale(2));
                        ytdAnalysisRangeMap.put('YTD Purchase (Rs.)',String.valueOf((m68DataEstimated.Purchases__c).setScale(2))+' (Estimated Purchase) must be consistent with YTD purchase');
                    }

                }
                return null;
            }else{
                return 'Last three year m68 data is missing ';
            }


        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber());
            return null;
        }
    }
    //Get flag of creditors and Debtors.
    public static List<Credit_Underwriting__c> getCreditorDebitorsFlag(String losCustId){
        Boolean debtorAnalysis = getDebitorsAnalysis(losCustId);
        If(debtorAnalysis !=null){
            YTDAnalysisController.creditorDebtorsAnalysisMap.put('Top 5 debtors concentration (%)',debtorAnalysis);
        }
        Boolean creditorsAnalysis = getCreditorsAnalysis(losCustId);
        If(creditorsAnalysis !=null){
            YTDAnalysisController.creditorDebtorsAnalysisMap.put('Top 5 creditors concentration (%)',creditorsAnalysis);
        }
            

        String appraisal = 'Debtors/Creditors Analysis';
        String applicationScoreRecType = SOQL_Util.getRecordTypeId('Child_Application_Score');
        String childFlagRecType = SOQL_Util.getRecordTypeId('Child_Flag');

        If(YTDAnalysisController.creditorDebtorsAnalysisMap !=null){
            List<Credit_Underwriting__c> listOfCredit   =   new List<Credit_Underwriting__c>();
            for(String str    : YTDAnalysisController.creditorDebtorsAnalysisMap.keySet()){
                If(str !=null && str !=''){
                    // Application Score Records
                    if(!YTDAnalysisController.creditorDebtorsAnalysisMap.get(str)){
                        Credit_Underwriting__c creditUnderObj   = new Credit_Underwriting__c();
                        creditUnderObj.RecordTypeId             = applicationScoreRecType;
                        creditUnderObj.Appraisal__c             = appraisal;
                        creditUnderObj.Variable_type__c         = str;
                        creditUnderObj.Application_Value__c     = String.valueOf(YTDAnalysisHelper.ytdAnalysisValueMap.get(str));
                        creditUnderObj.Threshold_breached__c    = false;
                        listOfCredit.add(creditUnderObj);
                    }
                    

                    if(YTDAnalysisController.creditorDebtorsAnalysisMap.get(str)){
                        Credit_Underwriting__c creditUnderObjChild               = new Credit_Underwriting__c();
                        creditUnderObjChild.RecordTypeId                         = childFlagRecType;
                        creditUnderObjChild.Appraisal__c                         = appraisal;
                        creditUnderObjChild.Variable_type__c                     = str;
                        creditUnderObjChild.Flags_Value__c                       = String.valueOf(YTDAnalysisHelper.ytdAnalysisValueMap.get(str));
                        creditUnderObjChild.Flags_Range__c                       = String.valueOf(YTDAnalysisHelper.ytdAnalysisRangeMap.get(str));
                        creditUnderObjChild.Threshold_breached__c                = YTDAnalysisController.creditorDebtorsAnalysisMap.get(str);
                        listOfCredit.add(creditUnderObjChild);
                    }
                }
            }
            If(!listOfCredit.isEmpty()){
                return listOfCredit;
            }
        }
        return new List<Credit_Underwriting__c>();
    }
    //Creditors Analysis
    public static Boolean getCreditorsAnalysis(String losCustId){
        try{
            String financial_Type   ='Actual';
            Double sumOfFiveAmount = 0;
            Double concentration   = 0;
            Boolean flag=false;
            Set<String> setName                                = new Set<String>();
            List<String> listOfFiscalYear                      = new List<String>{currFiscalYear,nextEstFiscalYear};
            List<Sundry_Creditors__c>   listSundryCreditors    = [select id,Age__c,Amount_To_Be_Paid__c,Fiscal_Year__c,Name_Of_Trade_Creditors__c from Sundry_Creditors__c  where Account__c =: losCustId AND Fiscal_Year__c IN :listOfFiscalYear];
            M68_Balance_Sheet_Analysis__c   objOfM68           = [select id,Sundry_Creditors__c,Fiscal_Year__c,Financial_type__c from M68_Balance_Sheet_Analysis__c where Account__c =:losCustId AND Fiscal_Year__c =:currFiscalYear AND Financial_type__c =:financial_Type];
            system.debug('objOfM68---->'+objOfM68);
            If(listSundryCreditors !=null){
                for(Sundry_Creditors__c  sundryCreditorsObj        : listSundryCreditors){
                    If(sundryCreditorsObj !=null && sundryCreditorsObj.Amount_To_Be_Paid__c !=null && sundryCreditorsObj.Name_Of_Trade_Creditors__c !=null && sundryCreditorsObj.Fiscal_Year__c ==currFiscalYear){
                        setName.add(sundryCreditorsObj.Name_Of_Trade_Creditors__c);
                        sumOfFiveAmount += sundryCreditorsObj.Amount_To_Be_Paid__c;
                    }
                }
            }
            If(sumOfFiveAmount >0 && objOfM68 !=null && objOfM68.Sundry_Creditors__c !=null && objOfM68.Sundry_Creditors__c > 0){
                concentration = (sumOfFiveAmount/objOfM68.Sundry_Creditors__c)*100;

                //Double temp = (sumOfFiveAmount*50)/100;
                If(concentration > 0){
                    //return concentration>50?true:false;
                    YTDAnalysisHelper.ytdAnalysisValueMap.put('Top 5 creditors concentration (%)',Decimal.valueOf(concentration).setScale(2));
                    ytdAnalysisRangeMap.put('Top 5 creditors concentration (%)','<50');
                    flag = concentration>50?true:false;
                }
            }

            If(listSundryCreditors !=null){
                for(Sundry_Creditors__c  sundryCreditorsObj        : listSundryCreditors){
                    If(sundryCreditorsObj !=null && sundryCreditorsObj.Name_Of_Trade_Creditors__c !=null && sundryCreditorsObj.Fiscal_Year__c ==nextEstFiscalYear){
                        If(setName.contains(sundryCreditorsObj.Name_Of_Trade_Creditors__c)){
                            //return true;
                            flag = true;
                        }
                    }
                }
            }   
            //return false;
            return flag == true?true:flag;
        }catch(Exception ex){
            system.debug('Exeption In::'+ex.getCause()+'--------'+ex.getLineNumber()+ex.getMessage());
            return null;
        }
    }
    //Debitors Analysis
    public static Boolean getDebitorsAnalysis(String losCustId){
        try{
            system.debug('losCustId==++'+losCustId);
            String financial_Type   ='Actual';
            Double sumOfFiveAmount = 0;
            Double concentration   = 0;
            Boolean flag=false;
            Set<String> setName                                = new Set<String>();
            List<String> listOfFiscalYear                      = new List<String>{currFiscalYear,nextEstFiscalYear};
            System.debug('listOfFiscalYear----> ' + listOfFiscalYear);
            List<Debtors__c>    listDebitors                   = [select id,Age__c,Amount_Collected__c,Fiscal_Year__c,Customer_Name__c from Debtors__c  where Account__c =: losCustId AND Fiscal_Year__c IN :listOfFiscalYear];
            System.debug('listDebitors---> ' + listDebitors);
            M68_Balance_Sheet_Analysis__c   objOfM68           = [select id,Sundry_Debtors__c,Fiscal_Year__c,Financial_type__c from M68_Balance_Sheet_Analysis__c where Account__c =:losCustId AND Fiscal_Year__c =:currFiscalYear AND Financial_type__c =:financial_Type];
            System.debug('objOfM68---> ' + objOfM68);
            If(listDebitors !=null){
                System.debug('---Inside If---');
                System.debug('listDebitors---> ' + listDebitors);
                for(Debtors__c  debtorsObj                     : listDebitors){
                    If(debtorsObj !=null && debtorsObj.Amount_Collected__c !=null && debtorsObj.Customer_Name__c !=null && debtorsObj.Fiscal_Year__c ==currFiscalYear){
                        setName.add(debtorsObj.Customer_Name__c);
                        System.debug('setName---> ' + setName);
                        sumOfFiveAmount += debtorsObj.Amount_Collected__c;
                    }
                }
                System.debug('sumOfFiveAmount---> ' + sumOfFiveAmount);
            }
            If(sumOfFiveAmount >0 && objOfM68.Sundry_Debtors__c !=null && objOfM68.Sundry_Debtors__c > 0){
                concentration = (sumOfFiveAmount/objOfM68.Sundry_Debtors__c)*100;
                System.debug('concentration---> ' + concentration);
                If(concentration > 0){
                   // return concentration>50? true:false;
                    YTDAnalysisHelper.ytdAnalysisValueMap.put('Top 5 debtors concentration (%)',Decimal.valueOf(concentration).setScale(2));
                    ytdAnalysisRangeMap.put('Top 5 debtors concentration (%)','<50');
                   flag = concentration>50? true:false;
                }
            }   

            If(listDebitors !=null){
                for(Debtors__c  debtorsObj     : listDebitors){
                    If(debtorsObj !=null && debtorsObj.Customer_Name__c !=null && debtorsObj.Fiscal_Year__c ==nextEstFiscalYear){
                        System.debug('setName---> ' + setName);
                        If(setName.contains(debtorsObj.Customer_Name__c)){
                            System.debug('setName---> ' + setName);
                           // return true;
                           flag = true;
                        }
                    }
                }
            }
            //return false;
            System.debug('flag---> ' + flag);
            return flag == true?true:flag;
        }catch(Exception ex){
            system.debug('Exeption In::'+ex.getCause()+'--------'+ex.getLineNumber()+ex.getMessage());
            return null;
        }
    }

    public static Boolean getSalesAnalysisFlag(Decimal salesfor_n_year, Decimal salesfor_n_2_year,Decimal currYearSalesEstimate,String estOrProj){
        try{

            Decimal cagrValue = compoundAnnualGrowthRate(salesfor_n_year,salesfor_n_2_year);
            Decimal idealEstimate = calculateIdealEstimate(salesfor_n_year,cagrValue);
            Decimal allowedValue = calculateAllowedValues(idealEstimate,'SALES',estOrProj);

            return currYearSalesEstimate > allowedValue ? TRUE : FALSE;
        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }

    public static Boolean getPurchaseAnalysisFlag(Decimal salesfor_n_year, Decimal salesfor_n_2_year,Decimal currYearPurchasesEstimate,String estOrProj){
        try{

            Decimal cagrValue = compoundAnnualGrowthRate(salesfor_n_year,salesfor_n_2_year);
            Decimal idealEstimate = calculateIdealEstimate(salesfor_n_year,cagrValue);
            Decimal allowedValue = calculateAllowedValues(idealEstimate,'PURCHASE',estOrProj);

            return currYearPurchasesEstimate > allowedValue ? TRUE : FALSE;

        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }

    private static Decimal compoundAnnualGrowthRate(Decimal salesfor_n_year, Decimal salesfor_n_2_year){
        // CAGR = (Sales (for Year n)/Sales ( for Year n-2) ^0.5)-1

        try{
            If(salesfor_n_year !=null && salesfor_n_2_year !=null && salesfor_n_2_year !=0){
                return math.pow(Double.valueOf(salesfor_n_year/salesfor_n_2_year),Double.valueOf(0.5))-1;

            }else{
                return null;
            }

        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }

    private static Decimal calculateIdealEstimate(Decimal salesfor_n_year,Decimal cagr){
        //Sales (Year n) *(1+CAGR)
        try{
            If(salesfor_n_year !=null && cagr !=null){
                return salesfor_n_year * (1+ cagr);
            }else{
                return null;
            }
        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber());
            return null;
        }
    }

    private static Decimal calculateAllowedValues(Decimal idealEstimate, String isSalesorPurchase,String estOrProj){
        // Allowed value = Ideal Estimated Value *0.8214+81.6942 ->For Sales
        // Allowed value =  Ideal Estimated Value *0.8849+71.0160 --> for purchase
        try{
            if(idealEstimate !=null){
                if(isSalesorPurchase == 'SALES'){
                    if(estOrProj == 'EST')
                        return ((idealEstimate * 0.8214)+81.6942);
                    else if(estOrProj == 'PROJ')
                        return ((idealEstimate * 0.8220)+92.8884);
                    else
                            return null;
                }else if(isSalesorPurchase == 'PURCHASE'){
                    if(estOrProj == 'EST')
                        return ((idealEstimate * 0.8849)+71.0160);
                    else if(estOrProj == 'PROJ')
                        return ((idealEstimate * 0.7895)+93.9755);
                    else
                            return null;
                }else{
                    return null;
                }

            }else{
                return null;
            }
        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }

    public static Decimal calculateVelocity(M68_Balance_Sheet_Analysis__c m68Data ,String credOrDeb){

        try{
            if (m68Data != null) {
                if(credOrDeb =='CREDITOR' && m68Data.Sundry_Creditors__c != null && m68Data.Purchases__c  != null){
                    return m68Data.Sundry_Creditors__c / m68Data.Purchases__c ;
                }else if (credOrDeb =='DEBITOR' && m68Data.Sundry_Debtors__c != null && m68Data.Net_sales__c  != null) {
                    return m68Data.Sundry_Debtors__c / m68Data.Net_sales__c ;
                }else{
                    return null;
                }
            }else{
                return null;
            }
        }catch(Exception e){
            system.debug('Exeption In:::::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return  null;
        }
    }

    public static Boolean getDeltaFlag(Decimal cred_velocity_n,Decimal cred_velocity_n_1,Decimal cred_velocity_n_2,Decimal est_proj_cred_deb){
        try{
            //Decimal delta_1,delta_2,delta_3;

            Decimal delta_1;
            Decimal delta_2;
            Decimal delta_3;

            if(cred_velocity_n_1 != null && cred_velocity_n_2 != null)
                delta_1 = cred_velocity_n_1 - cred_velocity_n_2;
            if(cred_velocity_n != null && cred_velocity_n_1 != null)
                delta_2 = cred_velocity_n - cred_velocity_n_1;
            if(est_proj_cred_deb != null && cred_velocity_n_1 != null)
                delta_3 = est_proj_cred_deb - cred_velocity_n;
            System.debug('@@@@@@@@@@ delta_1'+delta_1);
            System.debug('@@@@@@@@@@ delta_1'+delta_2);
            System.debug('@@@@@@@@@@ delta_1'+delta_3);
            if(delta_3 != null && delta_3 > 0){
                System.debug('@@@@@@@@@@@ inside if');
                return true;
            }else if((delta_1 != null && delta_2 != null && delta_3 != null) && delta_1 > 0 && delta_2 >0 && delta_3 < 0){
                System.debug('@@@@@@@@@@ inside else if');
                return true;
            }else{
                System.debug('@@@@@@@@@@ inside else');
                return false;
            }

        }catch(Exception e){
            system.debug('Exeption In::::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }

    public static boolean getYTDAnalysis(M68_Balance_Sheet_Analysis__c ytdm68Data, String purchaseOrSales,Decimal estimatedSalesOrPurchase){
        try{

            Decimal annualizedYTD;

            if(ytdm68Data != null && ytdm68Data.Net_sales__c != null && ytdm68Data.Month__c != null){
                if(purchaseOrSales == 'SALES')
                    annualizedYTD = ((ytdm68Data.Net_sales__c)*12)/Utility.convertYearToDateToNumber(ytdm68Data.Month__c);
                else if(purchaseOrSales == 'PURCHASE')
                    annualizedYTD = ((ytdm68Data.Purchases__c)*12)/Utility.convertYearToDateToNumber(ytdm68Data.Month__c);
            }
            if(annualizedYTD != null && estimatedSalesOrPurchase != null){
                return estimatedSalesOrPurchase < 0.9 * annualizedYTD ? TRUE : estimatedSalesOrPurchase > 1.1 * annualizedYTD ? TRUE:FALSE;
            }
            else {
                return null;
            }
        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }

    /**
     * Method to check if new limit aggregate of all facilities under a application is <= 50 L
     *
     * @param appId
     *
     * @Boolean flag
     */
    public static boolean isExceedingAdhocLessThanFifty(String appId){
        List<Facility__c> allfacilities                         = new List<Facility__c>();
        Decimal aggregateNewLimit                               = 0;

        try {

            allfacilities                                       = SanctionMatrixControllerHelper_EA.getAllFacilities(appId);
            aggregateNewLimit                                   = SanctionMatrixControllerHelper_EA.getNewLimitAggregate(allfacilities);

            return aggregateNewLimit < 5000000 ? true : false;
        }catch (Exception e) {
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }
    public static Map<String,Boolean> getGstflags(String losCustId,String appId){
        If(losCustId !=null && losCustId !='' && appId !=null && appId !=''){
			Map<String,Boolean> mapOfBooleans	= new Map<String,Boolean>();
            try{
                String currentYear 					= YearDataConstant.currFiscalYear; 
                String nextEstimatedYear 			= YearDataConstant.nextEstFiscalYear;
                List<String> listOfcurrentYear		= currentYear.split('-');
                String currentYearGST				= listOfcurrentYear[0]+'-'+'20'+listOfcurrentYear[1]; 
                List<String> listOfEstimatedYear	= nextEstimatedYear.split('-');
                String estimatedYearGST				= listOfEstimatedYear[0]+'-'+'20'+listOfEstimatedYear[1];
                List<String> listOfFiscalYear		= new List<String>{currentYear,nextEstimatedYear};
                List<String> listOfFiscalType		= new List<String>{'Actual','YTD','Estimated'};
                Decimal totalSalesCurrentYear		= 0.0;
                Decimal totalSalesEstimateYear		= 0.0;
                Decimal netSalesCurrentYear			= 0.0;
                Decimal netSalesEstimateYear		= 0.0;
                Integer noOfTermCurrent				= 0;
                Integer noOfTermEstimate			= 0;
                Map<String,Object>	mapOfGstObject	= new Map<String,Object>();
                Map<String,Object>	mapOfEstimateObject	= new Map<String,Object>();
                system.debug('mapOfGstObject==++'+mapOfGstObject);
                List<M68_Balance_Sheet_Analysis__c> listOfM68	= [Select id,Net_sales__c,Financial_type__c,Fiscal_Year__c,Account__c from M68_Balance_Sheet_Analysis__c where Account__c =:losCustId AND Fiscal_Year__c IN : listOfFiscalYear AND Financial_type__c IN : listOfFiscalType];
                system.debug('listOfM68==++'+listOfM68);
                List<GSTN_Info__c> listOfGstnInfo	=	[Select id,Parent__r.Application__c,Total_Sales__c,Months__c,Year__c from GSTN_Info__c where Parent__r.Application__c =:appId];
                system.debug('listOfGstnInfo==++'+listOfGstnInfo);
                If(listOfM68 !=null && listOfM68.size() > 0 && listOfGstnInfo !=null && listOfGstnInfo.size() > 0){

                    If(mapOfGstObject !=null){
                        If(mapOfGstObject.containsKey('TOTAL_SALES_FOR_CURRENT_YEAR')){
                        	totalSalesCurrentYear = (Decimal)mapOfGstObject.get('TOTAL_SALES_FOR_CURRENT_YEAR');		    
                        }
						If(mapOfGstObject.containsKey('NO_OF_TERM_FOR_CURRENT')){
							noOfTermCurrent	= (Integer)mapOfGstObject.get('NO_OF_TERM_FOR_CURRENT');
						}
						If(mapOfGstObject.containsKey('TOTAL_SALES_FOR_ESTIMATED_YEAR')){
                        	totalSalesEstimateYear = (Decimal)mapOfGstObject.get('TOTAL_SALES_FOR_ESTIMATED_YEAR');		    
                        }
						If(mapOfGstObject.containsKey('NO_OF_TERM_FOR_ESTIMATED')){
                        	noOfTermEstimate = (Integer)mapOfGstObject.get('NO_OF_TERM_FOR_ESTIMATED');		    
                        }	
                    }
                    mapOfEstimateObject = getM68Data(listOfM68, currentYear, nextEstimatedYear);
                    system.debug('mapOfEstimateObject==++'+mapOfEstimateObject);
                   If(mapOfEstimateObject !=null){
						If(mapOfEstimateObject.containsKey('TOTAL_NET_SALES_CURRENT')){
                        	netSalesCurrentYear = (Decimal)mapOfEstimateObject.get('TOTAL_NET_SALES_CURRENT');		    
                        }
						If(mapOfEstimateObject.containsKey('TOTAL_NET_SALES_ESTIMATED')){
                        	netSalesEstimateYear = (Decimal)mapOfEstimateObject.get('TOTAL_NET_SALES_ESTIMATED');		    
                        }
                   }
					If(totalSalesCurrentYear !=null && noOfTermCurrent !=null && netSalesCurrentYear !=null){
						mapOfBooleans.put('Previous Year Sales Triangulation',getCalculatedNetSales(totalSalesCurrentYear,netSalesCurrentYear, noOfTermCurrent));
					}
					If(totalSalesEstimateYear !=null && noOfTermEstimate !=null && netSalesEstimateYear !=null){
						mapOfBooleans.put('Current Year Sales Triangulation',getCalculatedNetSales(totalSalesEstimateYear,netSalesEstimateYear, noOfTermEstimate));
					}
                }
				If(!mapOfBooleans.isEmpty()){
					return mapOfBooleans;
				}				
            }catch(Exception ex){
              System.debug('Exception'+ex.getStackTraceString());  
            }
        }
         return null;
    }
    public static boolean getCalculatedNetSales(Decimal totalSale,Decimal netSale, Integer noOfTerm){
		If(noOfTerm !=null &&  noOfTerm != 0){
			If(totalSale !=null && netSale !=null){
				If(noOfTerm == 12){
					Decimal deviation	= ((netSale - totalSale) / netSale)*100;
					If(deviation > 15){
						return true;
					}
				}else{
					Decimal extrapulateSales = (totalSale/noOfTerm)*12;
					If(extrapulateSales !=null){
						Decimal deviation	= ((netSale - extrapulateSales) / netSale)*100;
						If(deviation > 15){
							return true;
						}
					}
				}	
			}	
		}
        return false;
    }
    
    public static Map<String,Object> getGSTR3TData(List<GSTN_Info__c> listOfGstnInfo, String currentYearGST, String estimatedYearGST){
        
        Map<String,Object> mapOfObject	= new Map<String,Object>();
        
        If(listOfGstnInfo !=null && listOfGstnInfo.size() > 0){
            for(GSTN_Info__c gstnChildInfoObj	:	listOfGstnInfo){
                if(gstnChildInfoObj.Year__c !=null && gstnChildInfoObj.Year__c == currentYearGST) {
                    if(gstnChildInfoObj.Total_Sales__c !=null){
                        mapOfObject.put('TOTAL_SALES_FOR_CURRENT_YEAR',gstnChildInfoObj.Total_Sales__c);
                    }
                    if(gstnChildInfoObj.Months__c !=null){
                        mapOfObject.put('NO_OF_TERM_FOR_CURRENT',Integer.valueOf(gstnChildInfoObj.Months__c));
                    }
                }else  if(gstnChildInfoObj.Year__c !=null && gstnChildInfoObj.Year__c == estimatedYearGST){
                    if(gstnChildInfoObj.Total_Sales__c !=null){
                        mapOfObject.put('TOTAL_SALES_FOR_ESTIMATED_YEAR',gstnChildInfoObj.Total_Sales__c);
                    }
                    if(gstnChildInfoObj.Months__c !=null){
                        mapOfObject.put('NO_OF_TERM_FOR_ESTIMATED',Integer.valueOf(gstnChildInfoObj.Months__c));
                    }
                }    
            }
            If(!mapOfObject.isEmpty()){
                return mapOfObject;
            }
        }
        return null;
    }
    public static Map<String,Object> getM68Data(List<M68_Balance_Sheet_Analysis__c> listOfM68, String currentYear, String nextEstimatedYear){
        Map<String,Object> mapOfObject	= new Map<String,Object>();
		Decimal totalNetSales	= 0.0;
		If(listOfM68 !=null && listOfM68.size() > 0){
            for(M68_Balance_Sheet_Analysis__c m68Obj	:	listOfM68){
                If(m68Obj !=null){
					If(m68Obj.Fiscal_Year__c !=null && m68Obj.Fiscal_Year__c == currentYear && m68Obj.Financial_type__c !=null && m68Obj.Financial_type__c == 'Actual'){
						If(m68Obj.Net_sales__c !=null){
							mapOfObject.put('TOTAL_NET_SALES_CURRENT',m68Obj.Net_sales__c);	
						}		
					}else if(m68Obj.Fiscal_Year__c !=null && m68Obj.Fiscal_Year__c == nextEstimatedYear && (m68Obj.Financial_type__c == 'YTD' || m68Obj.Financial_type__c =='Estimated')){
						If(m68Obj.Net_sales__c !=null){
							totalNetSales = totalNetSales + m68Obj.Net_sales__c;
						}
					}
					If(totalNetSales > 0.0 && totalNetSales > 0){
						mapOfObject.put('TOTAL_NET_SALES_ESTIMATED',totalNetSales);
					}					
                }    
            }
			If(!mapOfObject.isEmpty()){
				return mapOfObject;
			}
			 
        }
        return null;    
    }
}