@isTest(seeAllData = false)
public class TestTestClass {
    @isTest
    static void  method1(){
        UserRole obj=new UserRole(Name= 'ABC'); 
        insert obj; 
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            Account acc = new Account(Name = 'test');
            insert acc;
            
        }
        
    }
    
}