/**
 * Created by ET-MARLABS on 27-07-2018.
 */

public class AuthSessionController {
    public List<AuthSession> loogedInUserAuthSessions {get;set;}
    public String sessionIdToBedeleted{get;set;}
    public void AuthSessionController(){
        //System.debug('@@@@@@'+loogedInUserAuthSessions);
        loogedInUserAuthSessions    = new List<AuthSession>();
        sessionIdToBedeleted = '';
        //System.debug('@@@@@@'+loogedInUserAuthSessions);
        loogedInUserAuthSessions= [SELECT CreatedDate,Id,IsCurrent,LastModifiedDate,LoginGeoId,LoginHistoryId,LoginType,LogoutUrl,NumSecondsValid,ParentId,SessionSecurityLevel,SessionType,SourceIp,UsersId,UserType FROM AuthSession where UsersId=:UserInfo.getUserId() order by createddate desc];
        //System.debug('@@@@@@'+loogedInUserAuthSessions);
    }
    public void getRecords(){
        loogedInUserAuthSessions    = new List<AuthSession>();
        System.debug('@@@@@@'+loogedInUserAuthSessions);
        loogedInUserAuthSessions= [SELECT CreatedDate,Id,IsCurrent,LastModifiedDate,LoginGeoId,LoginHistoryId,LoginType,LogoutUrl,NumSecondsValid,ParentId,SessionSecurityLevel,SessionType,SourceIp,UsersId,UserType FROM AuthSession where UsersId=:UserInfo.getUserId() order by createddate desc];
        System.debug('@@@@@@'+loogedInUserAuthSessions);
    }
    public void deleteSession(){
        System.debug('@@@@@@'+sessionIdToBedeleted);
        //Database.delete(sessionIdToBedeleted);
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setMethod('DELETE');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionID());
        req.setEndpoint('https://kvb--sit.cs58.my.salesforce.com//services/data/v39.0/sobjects/AuthSession/'+sessionIdToBedeleted);

        HttpResponse res = h.send(req); // JSON string is generated at this point

        system.debug('---res.getBody()--'+res.getBody());
    }
    public void deleteAllOtherSession(){
        loogedInUserAuthSessions= [SELECT CreatedDate,Id,IsCurrent,LastModifiedDate,LoginGeoId,LoginHistoryId,LoginType,LogoutUrl,NumSecondsValid,ParentId,SessionSecurityLevel,SessionType,SourceIp,UsersId,UserType FROM AuthSession where UsersId=:UserInfo.getUserId() order by createddate desc];
        List<String> IdsToBeDeleted = new List<String>();
        String currentUserIp = loogedInUserAuthSessions[0].SourceIp;
        for(AuthSession allRec:loogedInUserAuthSessions){
            if(allRec.SourceIp != currentUserIp /*&& allRec.LoginType == 'Application'*/){
                IdsToBeDeleted.add(allRec.Id);
            }
        }
        if(!IdsToBeDeleted.isEmpty()){
            for(String iddd:IdsToBeDeleted){
                deleteHttpRequest(iddd);
            }
        }
    }
    public void deleteHttpRequest(String idToBeDeleted){
        /*System.debug('@@@@@@'+idToBeDeleted);
        //Database.delete(sessionIdToBedeleted);
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setMethod('DELETE');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionID());
        req.setEndpoint('https://kvb--sit.cs58.my.salesforce.com//services/data/v39.0/sobjects/AuthSession/'+idToBeDeleted);

        HttpResponse res = h.send(req); // JSON string is generated at this point

        system.debug('---res.getBody()--'+res.getBody());*/
    }
}