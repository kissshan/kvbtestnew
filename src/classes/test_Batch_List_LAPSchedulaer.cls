//auther--->uday 
//coverage--->100%
@isTest
public class test_Batch_List_LAPSchedulaer {
    public static testMethod void testschedule(){
        Batch_ListMatchingStatus_LAPSchedulaer bll=new Batch_ListMatchingStatus_LAPSchedulaer();
        string sch='0 0 23 * * ?';
        system.schedule('Batch_ListMatchingStatus_LAPSchedulaer', sch, bll);
    } 
}