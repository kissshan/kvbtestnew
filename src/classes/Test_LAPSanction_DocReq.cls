@isTest
public class Test_LAPSanction_DocReq {
@isTest
    public static void method1(){
         LAPSanction_DocReq obj=new LAPSanction_DocReq();
        LAPSanction_DocReq.cls_inputVariables inputobj=new LAPSanction_DocReq.cls_inputVariables();
        inputobj.in_msg='testmsg';
        inputobj.unique_key='uu';
        inputobj.pdf_unique_key='skl';
        LAPSanction_DocReq.cls_inputmap input1obj=new LAPSanction_DocReq.cls_inputmap();
        input1obj.Building_Society_Name_No_1='uu';
        LAPSanction_DocReq.cordWrapClass cordobj1=new LAPSanction_DocReq.cordWrapClass();
        LAPSanction_DocReq.cordWrapClass cordobj=new LAPSanction_DocReq.cordWrapClass(8.999,7.808,6.597,5.33);
    }
}