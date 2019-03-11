/*
*   Name    : Stocks_Service
*   purpose : Service class for WS_Stocks
*   Author  : Numaan
*/ 
public class Stocks_Service {
    
    /*
    * Method to save the stock statements 
    */
    public static WS_Stocks.Response saveStocks(Stock_Model stocks){
        System.debug('stocks:::'+stocks);
        WS_Stocks.Response res = new WS_Stocks.Response();
        Savepoint sp = Database.setSavepoint();

        try{
            
            if(stocks.customerId == null || stocks.customerId == ''){

                throw new CustomException('CustomerId is mandatory.');
            }
            
            Account a = [SELECT Id,CBS_Customer_ID__c FROM Account WHERE CBS_Customer_ID__c =: stocks.customerId LIMIT 1];

            if(stocks.month == null || stocks.month == ''){

                throw new CustomException('Month cannot be null');
            }

            if(stocks.year == null || stocks.year == ''){

                throw new CustomException('Year cannot be null');
            }

            String uniqueKey = stocks.customerId+'_'+stocks.month+'_'+stocks.year;
            Stocks__c st = new Stocks__c();
            System.debug('uniqueKey::'+uniqueKey);
            List<Stocks__c> stocksList = [SELECT Id,Unique_Key__c FROM Stocks__c WHERE Unique_Key__c =: uniqueKey LIMIT 1];
            System.debug('stocksList::'+stocksList);
            if(stocksList.isEmpty()){
                System.debug('Inside If');
                st.Account__c = a.Id;
                st.Month__c = stocks.month;
                st.Year__c = stocks.year;
                st.Unique_Key__c = uniqueKey;
                insert st;
            }else{
                st = stocksList[0];
            }


            if(stocks.stockStmnt != null && stocks.stockStmnt.data.size() > 0){
                checkAndInsertStock(stocks.stockStmnt.data,st.Id,uniqueKey);
            }
            if(stocks.sundryCredit != null && stocks.sundryCredit.data.size() > 0){
                checkAndInsertSundry(stocks.sundryCredit.data,st.Id,uniqueKey);
            }
            if(stocks.debts != null && stocks.debts.data.size() > 0){
                checkAndInsertDebts(stocks.debts.data,st.Id,uniqueKey);
            }
        }catch(Exception e){

            Database.rollback(sp);
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = e.getMessage();
            res.statusCode      = Constants.WS_ERROR_CODE;
            system.debug('Exception::'+e.getMessage());            
        }
        
        return res;
    }

    public static void checkAndInsertStock(List<Stock_Model.StockData> sList,String stockId,String uniqueKey){
        System.debug(sList.size()+'sList::'+sList+':::'+stockId+':::'+uniqueKey);
        List<Stock_Statement__c> ssList = new List<Stock_Statement__c>();
        Delete [SELECT Id,Unique_Key__c FROM Stock_Statement__c WHERE Unique_Key__c =: uniqueKey];
        for(Stock_Model.StockData sd:sList){

            Stock_Statement__c st = new Stock_Statement__c();
            st.Closing_Qty__c = sd.closingQty != null ? Integer.valueOf(replaceString(sd.closingQty)) : 0;
            st.Closing_Stock_Value__c = sd.closingStockValue != null ? Decimal.valueOf(replaceString(sd.closingStockValue)) : 0;
            st.Earliest_Stock_Receipt_Date__c = sd.earliestStockReceiptDate != null ? sd.earliestStockReceiptDate : '';
            st.Item_Name__c = sd.itemName != null ? sd.itemName : '';
            st.Opening_Qty__c = sd.openingQty != null ? Integer.valueOf(replaceString(sd.openingQty)) : 0; 
            st.Price__c = sd.price != null ? Decimal.valueOf(replaceString(sd.price)) : 0; 
            st.Purchases__c = sd.purchases != null ? Integer.valueOf(replaceString(sd.purchases)) : 0;
            st.Sales__c = sd.sales != null ? Integer.valueOf(replaceString(sd.sales)) : 0; 
            st.Stocks__c = stockId; 
            st.Stock_Type__c = sd.stockType != null ? sd.stockType : '';
            ssList.add(st);
        }

        insert ssList;
    }


    public static void checkAndInsertSundry(List<Stock_Model.SundryData> sList,String stockId,String uniqueKey){

        List<Sundry_Creditors__c> ssList = new List<Sundry_Creditors__c>();
        Delete [SELECT Id,Unique_Key__c FROM Sundry_Creditors__c WHERE Unique_Key__c =: uniqueKey];
        for(Stock_Model.SundryData sd:sList){

            Sundry_Creditors__c st = new Sundry_Creditors__c();
            st.Amount_To_Be_Paid__c = sd.amountToBePaid != null ? Decimal.valueOf(replaceString(sd.amountToBePaid)) : 0;
            st.Name_Of_Trade_Creditors__c = sd.nameOfTradeCreditors != null ? sd.nameOfTradeCreditors : '';
            st.Stocks__c = stockId; 

            ssList.add(st);
        }

        insert ssList;
    }

    public static void checkAndInsertDebts(List<Stock_Model.DebtorsData> sList,String stockId,String uniqueKey){

        List<Debtors__c> ssList = new List<Debtors__c>();
        Delete [SELECT Id,Unique_Key__c FROM Debtors__c WHERE Unique_Key__c =: uniqueKey];
        for(Stock_Model.DebtorsData sd:sList){

            Debtors__c st = new Debtors__c();
            st.Amount_Collected__c = sd.amountCollected != null ? Decimal.valueOf(replaceString(sd.amountCollected)) : 0;
            st.Amount_To_Be_Collected__c = sd.amountToBeCollected != null ? Decimal.valueOf(replaceString(sd.amountToBeCollected)): 0;
            st.Customer_Name__c = sd.customerName != null ?  sd.customerName: '';
            st.Invoice_Date__c = sd.invoiceDate != null ? sd.invoiceDate: '';
            st.Invoice_No__c = sd.invoiceNo != null ? Integer.valueOf(replaceString(sd.invoiceNo)): 0; 
            st.Invoice_Value__c = sd.invoiceValue != null ? Decimal.valueOf(replaceString(sd.invoiceValue)): 0; 
            st.Stocks__c = stockId; 
            ssList.add(st);
        }
        insert ssList;
    }

    /*Check for comma and empty string. Empty string replaced by 0*/
    public static String replaceString(String str){
        String rk = '0';
        if(str.length() > 0 && str != '' && str != ' '){
            rk = str.replace(',','');
        }
        return rk;
    }
}