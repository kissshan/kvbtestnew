/*
*   Name    : Stock_Model
*   purpose : Model for stocks
*   Author  : Numaan
*/ 
public class Stock_Model {
    
    public String customerId;
    public String month;
    public String year;
    public StockStatement stockStmnt;
    public SundryCreditors sundryCredit;
    public Debtors debts;
    
    public Stock_Model(){
        customerId = '';
        month = '';
        year = '';
        stockStmnt = new StockStatement();
        sundryCredit = new SundryCreditors();
        debts = new Debtors();
    }
    
    public class StockStatement{
        
        public String month = '';
        public String year = '';
        public List<StockData> data = new List<StockData>();
    }
    
    public class StockData{
        
        public String stockType = '';	//RM
        public String itemName = '';	//
        public String earliestStockReceiptDate = '';	//
        public String openingQty = '';	//10
        public String purchases = '';	//10
        public String sales = '';	//10
        public String closingQty = '';	//10
        public String price = '';	//1.2
        public String closingStockValue = '';	//
    }
    
    public class SundryCreditors{
        
        public String month = '';
        public String year = '';
        public List<SundryData> data = new List<SundryData>();
    }
    
    public class SundryData{
        
        public String nameOfTradeCreditors = '';	//RM
        public String amountToBePaid = '';	//
        
    }
    
    public class Debtors{
        
        public String month = '';
        public String year = '';
        public List<DebtorsData> data = new List<DebtorsData>();
    }
    
    public class DebtorsData{
        
        public String invoiceNo = '';	//
        public String invoiceDate = '';	//
        public String customerName = '';	//
        public String invoiceValue = '';	//
        public String amountCollected = '';	//
        public String amountToBeCollected = '';	//
        
    }
}