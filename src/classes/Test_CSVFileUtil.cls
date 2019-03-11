@isTest
public class Test_CSVFileUtil {
    @isTest
    public static void method1(){
        Test.startTest();
        CSVFileUtil.parseCSV(null,false);
        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);
        CSVFileUtil.parseCSV(myBlob,false);
        
        Test.stopTest();
    }
}