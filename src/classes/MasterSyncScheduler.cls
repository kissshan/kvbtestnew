/*
* Name      : MasterSyncScheduler.
* Company   : ET Marlabs
* Purpose   : Used to call the MasterSyncBatch based on the day of week
* Author    : Ashik Shetty
*/

global class MasterSyncScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        String dayofWeek = getDayOfWeek();
        
        if(dayofWeek == 'Mon'){
            callMasterSyncBatch('City');  
            
        }else if(dayofWeek == 'Tue'){
            callMasterSyncBatch('State');
            
        }else if(dayofWeek == 'Wed'){
            callMasterSyncBatch('Country');
            
        }else if(dayofWeek == 'Thu'){
            callMasterSyncBatch('Branch');
            
        }else if(dayofWeek == 'Fri'){
            callMasterSyncBatch('Product');
            
        }else if(dayofWeek == 'Sat'){
            callMasterSyncBatch('DSA');
            
        }else if(dayofWeek == 'Sun'){
            callMasterSyncBatch('MCLR');
            callMasterSyncBatch('Employee');
        }  
    } 
    
    public static string getDayOfWeek(){
        Datetime dt = System.now();
        return dt.format('EEEE');
    }
    
    public static void callMasterSyncBatch(String classIdentity){
        MasterSyncBatch masterBatch = new MasterSyncBatch(classIdentity);
        Database.executeBatch(masterBatch);
        
    }
}