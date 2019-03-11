@isTest
public class Test_RecordsSharingAccess {
@isTest
    public static void method1(){
       User u=VL_Test_Utility.createUser('Niladri70030841@gmail.com');
       insert u;
        Account acc=VL_Test_Utility.createparentAccount('TestuserFirst','TestuserLast','teststreet','700075','a','b@gmail.com','c','e','d','e','f');
        insert acc;
        set<id> accid=new set<id>();
        accid.add(acc.id);
        RecordsSharingAccess.accountRecordsShare(accid,u);
        RecordsSharingAccess.removeAccountRecordsShare(accid,u);
    }
}