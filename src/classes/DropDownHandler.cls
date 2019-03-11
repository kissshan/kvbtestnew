public with sharing class DropDownHandler {

	public DropDownHandler() {
		
	}

	public static List<String> getPicklistEntries(String objectApiName, String fieldApiName){

		List<String> picklistValues = new List<String>();

		/* get object type*/
		Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
		Schema.SObjectType objectType = globalDescribe.get(objectApiName); 

		Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();
		List<Schema.PicklistEntry> picklistEntries = fieldMap.get(fieldApiName).getDescribe().getPickListValues();

		for (Schema.PicklistEntry picklistEntry : picklistEntries) {
			picklistValues.add(picklistEntry.getValue());
		}

		return picklistValues;
	}
}