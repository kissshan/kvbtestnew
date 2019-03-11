/*
* Name     : MasterSyncBatch
* Company  : ET Marlabs
* Purpose  : Used to Call the Master Classes
* Author   : Ashik Shetty
*/
global class MasterSyncBatch implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts{
    public String masterSyncName = '';
    
    public MasterSyncBatch(String masterSyncName){
        this.masterSyncName = masterSyncName;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        String userQuery = 'SELECT id FROM User LIMIT 1';
        return Database.getQueryLocator(userQuery); 
        
    }
    
    global void execute(Database.BatchableContext BC, List<User> userList){
        
    }
    
    global void finish(Database.BatchableContext BC){
        if(masterSyncName != null || masterSyncName!= ''){
            if(masterSyncName == 'City'){
                WS_CITY_Master.masterRequest();

            }else if(masterSyncName == 'State'){
                WS_State_Master.masterRequest();
                
            }else if(masterSyncName == 'Country'){
                WS_COUNTRY_Master.masterRequest();
                
            }else if(masterSyncName == 'Branch'){
                WS_BRANCH_MASTER.masterRequest();
                
            }else if(masterSyncName == 'Product'){
                WS_Product_Master.masterRequest();
                
            }else if(masterSyncName == 'DSA'){
                WS_DSA_MASTER.masterRequest();
                
            }else if(masterSyncName == 'MCLR'){
                WS_MCLR_Master.masterRequest();
                
            }else if(masterSyncName == 'Employee'){
                WS_EMPLOYEE_Master.masterRequest();
            }   
        }
        
    }
    
    
}