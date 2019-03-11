/*
* Name          : M68C_Controller
* Description   : Controller to prepare data for M68C dashboard against customer id from url
* Author        : Dushyant
*/
global class M68C_Controller {
    public String currentFY_DS{get;set;}
    public String prevFY_DS{get;set;}
    public String estimatedFY_DS{get;set;}
    public String projectedFY_DS{get;set;}
    public String accName{get;set;}
    public String branchCode{get;set;}
    public string appId     {get;set;}
    public String PFY{get;set;}
    public String CFY{get;set;}
    public String EFY{get;set;}
    public String PRFY{get;set;}
    
    //Method to pass data over to M68C page on page load
    global void onLoad(){
        //Get customer data from url parameter
        Id accId = apexpages.currentpage().getparameters().get('id');
        appId   =   apexpages.currentpage().getparameters().get('appid');
        //Getting account details
        Account acc = [SELECT Name,Branch_Code__c FROm Account WHERE Id =: accId];
        accName = JSON.serialize(acc.Name);
        branchCode = JSON.serialize(acc.Branch_Code__c);
        
        //Financial year definantion
        Integer currentYear = Utility.getCurrentYear();
        String cyString = String.valueOf(currentYear);
        
        String currentFY = (currentYear-1)+'-'+Integer.valueOf(cyString.subString(cyString.length()-2,cyString.length()));
        String prevFY = (currentYear-2)+'-'+Integer.valueOf(String.valueOf(currentYear-1).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));
        String estimatedFY = currentYear+'-'+Integer.valueOf(String.valueOf(currentYear+1).subString(String.valueOf(currentYear+1).length()-2,String.valueOf(currentYear+1).length()));
        String projectedFY = (currentYear+1)+'-'+Integer.valueOf(String.valueOf(currentYear+2).subString(String.valueOf(currentYear+2).length()-2,String.valueOf(currentYear+2).length()));
        M68_Balance_Sheet_Analysis__c currentFYData = new M68_Balance_Sheet_Analysis__c();
        M68_Balance_Sheet_Analysis__c prevFYData  = new M68_Balance_Sheet_Analysis__c();
        M68_Balance_Sheet_Analysis__c estimatedFYData  = new M68_Balance_Sheet_Analysis__c();
        M68_Balance_Sheet_Analysis__c projectedFYData  = new M68_Balance_Sheet_Analysis__c();
        
        PFY = JSON.serialize('31.03.'+prevFY.subString(prevFY.length()-2,prevFY.length()));//
        CFY = JSON.serialize('31.03.'+currentFY.subString(currentFY.length()-2,currentFY.length()));
        EFY = JSON.serialize('31.03.'+estimatedFY.subString(estimatedFY.length()-2,estimatedFY.length()));
        PRFY = JSON.serialize('31.03.'+projectedFY.subString(projectedFY.length()-2,projectedFY.length()));
        //Dynamic query formation
        String query;
        try{
            currentFYData = Database.query(getQuery(currentFY,'Actual',accId));
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }
        try{
            prevFYData = Database.query(getQuery(prevFY,'Actual',accId));
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }
        try{
            estimatedFYData = Database.query(getQuery(estimatedFY,'Estimated',accId));
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }
        try{
            projectedFYData = Database.query(getQuery(projectedFY,'Projected',accId));
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }
        
        //serializing Data to be displayed on the page
        currentFY_DS    = JSON.serialize(currentFYData);
        prevFY_DS       = JSON.serialize(prevFYData);
        estimatedFY_DS = JSON.serialize(estimatedFYData);
        projectedFY_DS = JSON.serialize(projectedFYData);
    }
    
    //Helper method to return dynamic query
    public static String getQuery(String fiscalYear,String financialType, Id accId){
        //preparing query string
        String query   = 'Select ';
        //get all field for M68C analysis object
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get( 'M68_Balance_Sheet_Analysis__c' ).getDescribe().fields.getMap();
        
        for(Schema.SObjectField s : accountFieldMap.values()){
            query = query + s.getDescribe().getName()+',';    
        }
        query   = query.removeEnd(',');
        query   = query + ' from M68_Balance_Sheet_Analysis__c WHERE Fiscal_Year__c =\''+fiscalYear+'\' AND Financial_type__c = \''+financialType+'\' AND Account__c = \''+accId+'\' ORDER BY CreatedDate DESC LIMIT 1';
        RETURN query;
    }
}