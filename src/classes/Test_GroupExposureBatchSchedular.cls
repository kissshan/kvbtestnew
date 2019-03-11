@isTest
public class Test_GroupExposureBatchSchedular {
    
    @isTest
    public static void method1(){
        
        
        Test.startTest();
        String sch = '0 0 23 * * ?';
        GroupExposureBatchSchedular abs= new GroupExposureBatchSchedular();
        String jobId = System.schedule('myJobTestJobName', sch, abs);
        abs.execute(null);
        Test.stopTest();
        
    }
}