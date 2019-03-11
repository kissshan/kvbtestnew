/*
* @name        : Batch_Cal_CustomerDrawingPower
* @description : Compute customer drawing power based on stock uploaded data by Customer for OCC Product
* @author      : Amritesh
*/
public class Batch_Cal_CustomerDrawingPower implements Database.Batchable<sObject> {
    
    public static final Set<String> APP_STAGES          = new Set<String>{'Application close - enhancement','Limit renewed/Application close','Identified for renewal','Greater than 2Cr.','>6 months due for renewal'};
    public static final set<string> INDUSTRIES      	= new Set<String>{Constants.MANUFACTURING_INDUSTRY,Constants.TRADING_INDUSTRY};
    public List<String> customerIdList = new List<String>();
    
    public Batch_Cal_CustomerDrawingPower(List<String> custIdList){
        customerIdList = custIdList;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        string query = 'Select id,genesis__Account__c,genesis__Account__r.Industry_Type__c,Overall_Exposure__c,(select id,Existing_Margin_Receivables__c,'+
            +'Existing_Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Trading__c,Margin_Receivables__c,'+
            +'Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c,Application__r.genesis__Account__r.Industry_Type__c from Facilities__r) '+ 
            +'from genesis__Applications__c where Active__c = true AND RecordType.DeveloperName=\'SME_Renewal\' AND Application_Stage__c NOT IN : APP_STAGES AND '+
            +'genesis__Account__r.Industry_Type__c IN: INDUSTRIES AND '+'genesis__Account__c IN : customerIdList';
        
        return database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<genesis__Applications__c> records) {
        if(records[0].Overall_Exposure__c < 2500000){
            calculateDPLess(records[0]);
        }
        else{
            Set<String> accIds                  = new Set<String>();
            Map<String,Decimal> stockMaginMap   = new Map<String,Decimal>();
            Map<String,Decimal> recevMaginMap   = new Map<String,Decimal>();
            
            for(genesis__Applications__c app : records){
                if(app.genesis__Account__c != null){
                    accIds.add(app.genesis__Account__c);
                    Decimal stkMargin   = 0;
                    Decimal recvMargin  = 0;
                    stockMaginMap.put(app.genesis__Account__c, stkMargin);
                    recevMaginMap.put(app.genesis__Account__c, recvMargin);
                    for(Facility__c f : app.Facilities__r){                
                        if(f.Application__r.genesis__Account__r.Industry_Type__c==Constants.MANUFACTURING_INDUSTRY ){
                            if(f.Margin_Stock_Manufacturing__c !=null && f.Margin_Stock_Manufacturing__c > stkMargin){
                                stkMargin   = f.Margin_Stock_Manufacturing__c;
                                stockMaginMap.put(f.Application__r.genesis__Account__c, f.Margin_Stock_Manufacturing__c);                        
                            }else if(f.Existing_Margin_Stock_Manufacturing__c != null && f.Existing_Margin_Stock_Manufacturing__c > stkMargin){
                                stkMargin   = f.Existing_Margin_Stock_Manufacturing__c ;
                                stockMaginMap.put(f.Application__r.genesis__Account__c, f.Existing_Margin_Stock_Manufacturing__c);
                            }
                        }
                        if(f.Application__r.genesis__Account__r.Industry_Type__c==Constants.TRADING_INDUSTRY ){
                            if(f.Margin_Stock_Trading__c != null && f.Margin_Stock_Trading__c > stkMargin){
                                stkMargin   = f.Margin_Stock_Trading__c;
                                stockMaginMap.put(f.Application__r.genesis__Account__c, f.Margin_Stock_Trading__c);                        
                            }else if(f.Existing_Margin_Stock_Trading__c != null && f.Existing_Margin_Stock_Trading__c > stkMargin){
                                stkMargin   = f.Existing_Margin_Stock_Trading__c;
                                stockMaginMap.put(f.Application__r.genesis__Account__c, f.Existing_Margin_Stock_Trading__c);  
                            }
                        }
                        
                        if(f.Margin_Receivables__c != null &&f.Margin_Receivables__c > recvMargin){
                            recvMargin  = f.Margin_Receivables__c;
                            recevMaginMap.put(f.Application__r.genesis__Account__c, f.Margin_Receivables__c);
                        }else if(f.Existing_Margin_Receivables__c != null &&f.Existing_Margin_Receivables__c > recvMargin){
                            recvMargin  = f.Existing_Margin_Receivables__c;
                            recevMaginMap.put(f.Application__r.genesis__Account__c, f.Existing_Margin_Receivables__c);
                        }
                    }
                }           
            }
            Integer monthNo = Date.today().Month();
            String month    = Utility.getMonthName(monthNo);
            String year     = String.ValueOf(Date.today().Year());  
            
            List<Stock_Statement__c> stockList          = new List<Stock_Statement__c>();
            stockList                                   = getStockData(accIds,month, year);
            List<Debtors__c> debtorsList                = new List<Debtors__c>();
            debtorsList                                 = getDebtorsData(accIds,month, year);
            List<Sundry_Creditors__c> creditorsList     = new List<Sundry_Creditors__c>();
            creditorsList                               = getCreditorsData(accIds,month, year);
            
            Map<string, Decimal> accStockTotal          = getStockTotal(stockList);
            Map<string, Decimal> accDebtTotal           = getDebitorsTotal(debtorsList);
            Map<string, Decimal> accCredTotal           = getCreditorsTotal(creditorsList);
            
            List<Account> updateAccounts                = new List<Account>();
            
            for(string s : accIds){
                Decimal totalClosingStock   = 0;
                Decimal totalCredAnttoPaid  = 0;
                Decimal totalPaidStock      = 0;
                Decimal marginStockPaid     = 0;
                Decimal totalDrawngPwrStock = 0;
                Decimal totalDebtAmttoCllct = 0;
                Decimal marginDebtors       = 0;
                Decimal totalDrawngPwrDebt  = 0;
                
                if(accStockTotal.containsKey(s)){
                    totalClosingStock   = accStockTotal.get(s);
                } 
                if(accCredTotal.containsKey(s)){
                    totalCredAnttoPaid  = accCredTotal.get(s);
                } 
                if(totalClosingStock > totalCredAnttoPaid) totalPaidStock = totalClosingStock - totalCredAnttoPaid;
                
                if(stockMaginMap.containsKey(s)) marginStockPaid = stockMaginMap.get(s);
                
                totalDrawngPwrStock = totalPaidStock - (totalPaidStock * marginStockPaid);
                
                if(accDebtTotal.containsKey(s)){
                    totalDebtAmttoCllct = accDebtTotal.get(s);
                }
                
                if(recevMaginMap.containsKey(s)) marginDebtors  = recevMaginMap.get(s);
                totalDrawngPwrDebt  = totalDebtAmttoCllct - (totalDebtAmttoCllct * marginDebtors);
                
                updateAccounts.add(new Account(id= s,Drawing_Power__c = (totalDrawngPwrStock + totalDrawngPwrDebt)));
            }
            
            if(updateAccounts.size() > 0){
                AccountTriggerHandler.isAccountTrigger  = true;
                update updateAccounts;
            }  
        }
        
    }
    
    public static Map<string, Decimal> getStockTotal(List<Stock_Statement__c> stockList){
        Map<string, Decimal> accStockTotal          = new Map<string, Decimal>();
        for(Stock_Statement__c s : stockList){
            Decimal temp    = 0;
            if(accStockTotal.containsKey(s.Stocks__r.Account__c)){
                temp    = s.Closing_Stock_Value__c + accStockTotal.get(s.Stocks__r.Account__c);
                accStockTotal.put(s.Stocks__r.Account__c, temp);
            }else{
                accStockTotal.put(s.Stocks__r.Account__c, s.Closing_Stock_Value__c);
            }
        }
        return accStockTotal;
    }
    public static Map<string, Decimal> getDebitorsTotal(List<Debtors__c> debtorsList){
        Map<string, Decimal> accDebtTotal           = new Map<string, Decimal>();
        for(Debtors__c s : debtorsList){
            Decimal temp    = 0;
            if(accDebtTotal.containsKey(s.Stocks__r.Account__c)){
                temp    = s.Amount_To_Be_Collected__c + accDebtTotal.get(s.Stocks__r.Account__c);
                accDebtTotal.put(s.Stocks__r.Account__c, temp);
            }else{
                accDebtTotal.put(s.Stocks__r.Account__c, s.Amount_To_Be_Collected__c);
            }
        }
        return accDebtTotal;
    }
    
    public static Map<string, Decimal> getCreditorsTotal(List<Sundry_Creditors__c> creditorsList){
        Map<string, Decimal> accCredTotal           = new Map<string, Decimal>();
        for(Sundry_Creditors__c s : creditorsList){
            Decimal temp    = 0;
            if(accCredTotal.containsKey(s.Stocks__r.Account__c)){
                temp    = s.Amount_To_Be_Paid__c + accCredTotal.get(s.Stocks__r.Account__c);
                accCredTotal.put(s.Stocks__r.Account__c, temp);
            }else{
                accCredTotal.put(s.Stocks__r.Account__c, s.Amount_To_Be_Paid__c);
            }
        }
        return accCredTotal;
    }
    
    public List<Stock_Statement__c> getStockData(Set<String> accIds,string month, String year){
        return [Select id,Closing_Stock_Value__c,Stocks__r.Account__c from Stock_Statement__c 
                where Stocks__r.Account__c IN :accIds AND Stocks__r.Month__c =:month AND Stocks__r.Year__c =:year];
    }
    public List<Debtors__c> getDebtorsData(Set<String> accIds,string month, String year){
        return [Select id,Amount_To_Be_Collected__c,Stocks__r.Account__c from Debtors__c 
                where Stocks__r.Account__c IN :accIds AND Stocks__r.Month__c =:month AND Stocks__r.Year__c =:year];
    }
    public List<Sundry_Creditors__c> getCreditorsData(Set<String> accIds,string month, String year){
        return [Select id,Amount_To_Be_Paid__c,Stocks__r.Account__c from Sundry_Creditors__c 
                where Stocks__r.Account__c IN :accIds AND Stocks__r.Month__c =:month AND Stocks__r.Year__c =:year];
    }
    
    public void calculateDPLess(genesis__Applications__c app){
        String occProdCodes         = System.Label.OCC_Product_Codes;
        List<String> prodCodeList   = new List<String>();
        Facility__c facilityRec     = new Facility__c(); 
        Decimal stockCredit         = 0.0;
        Decimal stockDebit          = 0.0;
        Decimal stockVal            = 0.0;
        Decimal drawingPowerVal     = 0.0;
        
        List<Stocks__c> stockList = new List<Stocks__c>();
        stockList = [SELECT Id,Account__c,(SELECT Id,Opening_Stock__c,Purchases__c,Sales__c,Sundry_Creditors__c,Sundry_Debtors__c,CreatedDate FROM Stock_Below_Limit__r ORDER BY CreatedDate DESC
                                          ) FROM Stocks__c WHERE Account__c =: app.genesis__Account__c ORDER BY CreatedDate DESC];
        
        if(!stockList.isEmpty()){
            if(!stockList[0].Stock_Below_Limit__r.isEmpty()){
                List<Stock_Below_Limit__c> sblList = new List<Stock_Below_Limit__c>();
                sblList = stockList[0].Stock_Below_Limit__r;
                if(!sblList.isEmpty()){
                    stockVal        = calculateStock(Utility.isNullOrZeroDecimal(sblList[0].Opening_Stock__c), Utility.isNullOrZeroDecimal(sblList[0].Purchases__c), Utility.isNullOrZeroDecimal(sblList[0].Sales__c) );
                    stockCredit     = stockVal - Utility.isNullOrZeroDecimal(sblList[0].Sundry_Creditors__c);
                    stockDebit      = Utility.isNullOrZeroDecimal(sblList[0].Sundry_Debtors__c);
                }
                
                if(occProdCodes != null){
                    prodCodeList = (occProdCodes).split(',', 0);
                }
                
                facilityRec = [SELECT Id,Application__r.Industry_Type__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c,CL_Product__r.Margin_Receivables__c,CL_Product__r.Margin_Stock_Manufacturing__c,CL_Product__r.Margin_Stock_Trading__c
                               FROM Facility__c 
                               WHERE Application__c =: app.Id 
                               AND CL_Product__r.Product_Code__c IN : prodCodeList LIMIT 1];
                
                if(facilityRec != null){
                    if(facilityRec.Margin_Receivables__c != null){
                        drawingPowerVal = calcDrawingPower(Utility.isNullOrZeroDecimal(facilityRec.Margin_Receivables__c), Utility.isNullOrZeroDecimal(facilityRec.Margin_Stock_Manufacturing__c), Utility.isNullOrZeroDecimal(facilityRec.Margin_Stock_Trading__c),Utility.isNullOrZeroDecimal(stockDebit),Utility.isNullOrZeroDecimal(stockCredit),facilityRec.Application__r.Industry_Type__c);
                    }else if(facilityRec.CL_Product__r.Margin_Receivables__c != null ){
                        drawingPowerVal = calcDrawingPower(Utility.isNullOrZeroDecimal(facilityRec.CL_Product__r.Margin_Receivables__c), Utility.isNullOrZeroDecimal(facilityRec.CL_Product__r.Margin_Stock_Manufacturing__c), Utility.isNullOrZeroDecimal(facilityRec.CL_Product__r.Margin_Stock_Trading__c), Utility.isNullOrZeroDecimal(stockDebit),Utility.isNullOrZeroDecimal(stockCredit),facilityRec.Application__r.Industry_Type__c);
                    }
                    
                    drawingPowerVal = (drawingPowerVal < 0) ? 0.0 : drawingPowerVal;
                    Account accRec = new Account( Id = app.genesis__Account__c, Drawing_Power__c = drawingPowerVal );
                    try{
                        AccountTriggerHandler.isAccountTrigger  = true;
                        update accRec;
                    }
                    catch(Exception e){
                        throw new CustomException(e.getMessage());
                    }
                }  
            } 
        }
    }
    
    public decimal calculateStock(Decimal openingStock, Decimal purchases, Decimal sales){
        return openingStock + purchases - sales;
    }
    
    public decimal calcDrawingPower(decimal marginRecv, decimal marginManuf, decimal marginTrading, decimal stockDebit, decimal stockCredit, string applIndustryType){
        Decimal debitorVal     = 0.0;
        Decimal creditorVal    = 0.0;
        Decimal drawingPower   = 0.0; 
        debitorVal  = (((100 - marginRecv)/100) *  stockDebit);
        if(!Utility.ISStringBlankorNull(applIndustryType)){
            if(applIndustryType == 'TRADING'){
                creditorVal = (((100 - marginTrading)/100) * stockCredit);
            }else if(applIndustryType == 'Manufacturing'){
                creditorVal = (((100 - marginManuf)/100) * stockCredit);
            }
        }
        drawingPower = debitorVal + creditorVal;
        return drawingPower;
    }
    
    public void finish(Database.BatchableContext BC) {        
        
    }
}