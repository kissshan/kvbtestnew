@isTest
public class Test_SanctionMatrix_Calc_Batch_Scheduler {

    @isTest
    public static void method1(){
        Test.startTest();
        String sch = '0 0 23 * * ?';
        SanctionMatrix_Calc_Batch_Scheduler abs= new SanctionMatrix_Calc_Batch_Scheduler();
        String jobId = System.schedule('myJobTestJobName', sch, abs);
        abs.execute(null);
        Test.stopTest();
    }
}