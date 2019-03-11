/**
 * Created by ET-MARLABS on 07-03-2019.
 */

public with sharing class UDDashboardModel {

    public static Set<String> getDashboardAccessdesignations(){
        Set<String> roleNames    = new Set<String>();
        try{
            for(Underwriting_Dashboard_Access__mdt mdt : [Select id,Label,developerName from Underwriting_Dashboard_Access__mdt]){
                roleNames.add(mdt.Label);
            }
        }catch(Exception e){}
        return roleNames;
    }
}