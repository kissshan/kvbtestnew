/*
* Name    		: Button_Utility_Retail
* purpose 		: Class use for all retail product to call apex class from skuid page
* Author   		: Braj
* Created Date 	: 29-Oct-2018
*/
global class Button_Utility_Retail {

    webService static void genVLAckDoc(String appId){
        VL_Digio_Services.docGenAndSignDocVL(appId,Constants.VLDEALERACK);
    }

    webService static void genAllVLDoc(String appId){
        VL_Digio_Services.docGenAndSignDocVL(appId,Constants.VLSANCTIONLETTER);
    }

}