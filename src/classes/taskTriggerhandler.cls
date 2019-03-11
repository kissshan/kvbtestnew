/*#################################################################################################################################
* Name      : taskTrigger
* Company   : ET Marlabs
* Purpose   : Handler class for taskTriggerHelper 
* Author    : Shubham Shukla 
 ##################################################################################################################################*/
public class taskTriggerhandler {
    public static void calculateTAT(String appId, String ownerId,String oldownerId,String taskSubject, Task tsk){
        try{
		    genesis__Applications__c application = [Select Id,Branch_Code__c,OwnerId,Additional_Income_Approval__c,Record_Type_Name__c,Sub_Stage__c,FI_Status__c,Primary_Applicant__c From genesis__Applications__c where Id =:appId];
		    if(application<>null && (application.Record_Type_Name__c == Constants.HOMELOAN ||application.Record_Type_Name__c == Constants.LAPLOAN || application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W) && tsk.is_refer_back_allow__c){
		    	String usrId = getUserListss(application.Branch_Code__c,'Branch manager');
		    	if(tsk.Status=='Referred back' && tsk.is_refer_back_allow__c == true){
		    		if(application.OwnerId!=null){
		    			tsk.OwnerId = application.OwnerId;
		    			if(tsk.Parent_Owner_Id__c == null)
		    			tsk.Parent_Owner_Id__c = oldownerId;
		    			// Field for Rolling Up Comment
		    		}
                    	if(tsk != null && tsk.Status != 'Completed'){ 
				    		    updateTatRecord(tsk,ownerId,application);
		    		    }
		    			
		    	}else if(tsk.Status=='Assign to primary owner' && tsk.is_refer_back_allow__c == true){
						if(tsk.Parent_Owner_Id__c != null){
							tsk.OwnerId = tsk.Parent_Owner_Id__c;
						}
                    	if(tsk != null && tsk.Status != 'Completed'){
				    		    updateAssignTatRecord(tsk,ownerId,application);
		    		    }
				}else if(tsk.Status == 'Completed' && tsk.is_refer_back_allow__c == true){
					totalTimeCollapsed(tsk,application);
				}
				    	
	    	}else if(application<>null && (application.Record_Type_Name__c == Constants.HOMELOAN ||application.Record_Type_Name__c == Constants.LAPLOAN || application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W) && !tsk.is_refer_back_allow__c){
	    		if(tsk.Status == 'Completed' && tsk.is_refer_back_allow__c == false){
					turnAroundTimeForOtherTasks(tsk,application);
				}
	    	}
   	    }catch(Exception e){
            System.debug('e'+e);
             HandleBusinessException.captureError('taskTriggerHandler', 'calculateTAT', e);
   		}
    } 
    

    public static void parentTATInsert(List<Task> newList){
    	try{
	     		String parentRecord                 = Schema.SObjectType.Task_TAT__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();	
		    	Task kst = new Task();
		    	List<Task> kstList = new List<Task>();
		    	List<Task_TAT__c> parentTATInsert   = new List<Task_TAT__c>();
		    	Task_TAT__c tatTsk                  = new Task_TAT__c();
		    	Task_TAT__c tatTskchild                  = new Task_TAT__c();
		    	for(Task tt : newList){
			    		tatTsk.Task_Subject__c          = tt.Task_Subject__c;
			    		tatTsk.Task_Start_Time__c       = System.now();
			    		tatTsk.Current_User__c          = tt.OwnerId;
			    		tatTsk.RecordTypeId             = parentRecord;
			    		tatTsk.Application__c           = tt.WhatId;
			    		tatTsk.Primary_Owner__c         = tt.OwnerId;
			    		tatTsk.Parent_Record__c         = true;
			    		tatTsk.Last_Category_Selected__c= tt.Category__c;
			    		tatTsk.Task_Id__c               = tt.Id;
			    		kst.Id                          = tt.Id;
			    		kst.Parent_Owner_Id__c          = tt.OwnerId;

			    		kstList.add(kst);

			    		parentTATInsert.add(tatTsk);
		    		
		    	}
		    	  insert parentTATInsert;
		    	  update kstList;
		    	  firstChildforpaarentTat(parentTATInsert);
		}catch(Exception e){
            System.debug('e'+e);
             HandleBusinessException.captureError('taskTriggerHandler', 'parentTATInsert', e);
   		}
    	
    }
    public static void firstChildforpaarentTat(List<Task_TAT__c> parentTATList){
    	try{
    		Set<String> tskSubs  = new Set<String>();
    		List<Refer_back__mdt> referBackMdt = new list<Refer_back__mdt>();
       		referBackMdt = [SELECT id,Task_Subject__c,Is_Refer_back_Allow__c,controllingPickValue__c FROM Refer_back__mdt WHERE Is_Refer_back_Allow__c = true];

       			for(Refer_back__mdt mdt : referBackMdt){
       				tskSubs.add(mdt.Task_Subject__c);
       			}
    		List<Task_TAT__c>  ListInsertChild = new List<Task_TAT__c>();
    		Task_TAT__c insertChildRec         = new Task_TAT__c();
    			for(Task_TAT__c firstchildTat : parentTATList){
    				if(tskSubs.contains(firstchildTat.Task_Subject__c)){
			    		insertChildRec.Task_Subject__c          = firstchildTat.Task_Subject__c;
			    		insertChildRec.Task_Start_Time__c       = System.now();
			    		insertChildRec.Current_User__c          = firstchildTat.Current_User__c;
			    		insertChildRec.Application__c           = firstchildTat.Application__c;
			    		insertChildRec.Primary_Owner__c         = firstchildTat.Primary_Owner__c;
			    		insertChildRec.Parent_Record__c         = false;
			    		insertChildRec.Parent_TAT__c            = firstchildTat.Id;
			    		insertChildRec.Task_Id__c               = firstchildTat.Task_Id__c;

			    		ListInsertChild.add(insertChildRec);
		    		}

		    	}
		    	insert ListInsertChild;
    	}catch(Exception e){
            System.debug('e'+e);
             HandleBusinessException.captureError('taskTriggerHandler', 'updateTatRecord', e);
   		}  

    }
   public static void updateTatRecord(Task t, String ownerId, genesis__Applications__c application){
   	    try{
   	    		String cmt = 'Primary Owner Comment-->';
         		String cmmt= 'BM Comment-->';
         		Id loggedUser = UserInfo.getUserId();
		    	List<Task_TAT__c> childTAT  = new List<Task_TAT__c>();
		    	Task_TAT__c childRec        = new Task_TAT__c();
		    	Task ttt = new Task();
		    	List<Task> tskrecList       = new List<Task>();
		    	List<Task> tRecList = new List<Task>();
		    	String parentRecord         = Schema.SObjectType.Task_TAT__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
		        String childRecord          = Schema.SObjectType.Task_TAT__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
		        
		        Task_TAT__c parentTAT = [SELECT Id,Name,Application__c,Last_Category_Selected__c,Parent_Record__c,Full_Comments_History__c,Current_User__c,Task_Subject__c,Primary_Owner__c,Parent_TAT__c,Task_Start_Time__c,Task_End_Time__c,RecordTypeId FROM Task_TAT__c WHERE RecordTypeId =: parentRecord AND Task_Subject__c =: t.Task_Subject__c AND Parent_Record__c = true AND Application__c=:t.WhatId AND Task_End_Time__c = null LIMIT 1]; 
		    	childTAT  = [SELECT Id,Name,Application__c,Current_User__c,OwnerId,Last_Category_Selected__c,Parent_Record__c,Task_Subject__c,Task_Start_Time__c,Task_End_Time__c,Parent_TAT__c,RecordTypeId FROM Task_TAT__c WHERE Task_Subject__c =: t.Task_Subject__c AND Parent_Record__c = false AND Parent_TAT__c=:parentTAT.Id AND Application__c=:t.WhatId AND Task_End_Time__c = null];
		    	tskrecList= [SELECT ID,WhatId,OwnerId,Subject,Status FROM Task WHERE WhatId =:childTAT[0].Application__c AND Subject =: childTAT[0].Task_Subject__c];
		    			    	
		    		childRec.Parent_TAT__c      = parentTAT.Id;
		    		childRec.Task_Subject__c    = t.Task_Subject__c;
		    		childRec.Task_Start_Time__c = System.now();
		    		childRec.Current_User__c    = childTAT[0].OwnerId;
		    		childRec.Application__c     = t.WhatId;
		    		childRec.Primary_Owner__c   = childTAT[0].OwnerId;

		    		if(childRec.Current_User__c == t.Parent_Owner_Id__c){
		    			childRec.BM_Last_Comment__c = t.Current_Task__c; 
		    		}
		    		if(childRec.Current_User__c != t.Parent_Owner_Id__c){
		    			childRec.Primary_Owner_Last_Comment__c = t.Current_Task__c;
		    		}


		    		childTAT[0].Task_End_Time__c = System.now();
		    		childTAT[0].Current_User__c = t.Parent_Owner_id__c;

				    DateTime start = childTAT[0].Task_Start_Time__c;
			    	DateTime ends  = childTAT[0].Task_End_Time__c;

			 		Long tm= ends.getTime()-start.getTime();
					Decimal noOfsec = math.mod(tm/1000, 60);
					Decimal noOfmins = math.mod(((tm/1000)/60), 60);
					Decimal noOfhrs = math.mod(((tm/1000)/60)/60,24);
					Decimal noOfdays = math.mod((((tm/1000)/60)/60)/24,365);

					String totalTime = String.valueOf(noOfdays+' Days '+noOfhrs+' Hrs '+noOfmins+' Min '+noOfsec+' Sec ');
					if(parentTAT.Full_Comments_History__c == null || parentTAT.Full_Comments_History__c == 'null')
					parentTAT.Full_Comments_History__c = '';

				if(t.Parent_Owner_Id__c == childTAT[0].Current_User__c){
					childTAT[0].Primary_Owner_TAT__c = totalTime;
					childTAT[0].Days__c              = noOfdays;
					childTAT[0].Hours__c             = noOfhrs;
					childTAT[0].Minutes__c           = noOfmins;
					childTAT[0].Seconds__c           = noOfsec;
					childTAT[0].Primary_Owner_Last_Comment__c = t.Current_Task__c;
					parentTAT.Full_Comments_History__c = parentTAT.Full_Comments_History__c + '\n' + cmt + t.Current_Task__c + '\n';
					parentTAT.Primary_Owner_Last_Comment__c  = t.Current_Task__c;  
					parentTAT.Last_Category_Selected__c      = t.Category__c;
				}
				if(t.Parent_Owner_Id__c != childTAT[0].Current_User__c){
					childTAT[0].BM_TAT__c = totalTime;
					childTAT[0].Days__c              = noOfdays;
					childTAT[0].Hours__c             = noOfhrs;
					childTAT[0].Minutes__c           = noOfmins;
					childTAT[0].Seconds__c           = noOfsec;
					childTAT[0].BM_Last_Comment__c  = t.Current_Task__c;
					parentTAT.Full_Comments_History__c = parentTAT.Full_Comments_History__c + '\n' + cmmt + t.Current_Task__c + '\n';
					parentTAT.BM_Last_Comment__c   = t.Current_Task__c;
					parentTAT.Last_Category_Selected__c = t.Category__c;
				}
		    		update parentTAT;
		    		update childTAT;
		    		insert childRec;

		}catch(Exception e){
            System.debug('e'+e);
             HandleBusinessException.captureError('taskTriggerHandler', 'updateTatRecord', e);
   		}   	
    }
    
    public static void updateAssignTatRecord(Task t, String ownerId, genesis__Applications__c application){
   	    try{
   	    		String cmt = 'Primary Owner Comment-->';
         		String cmmt= 'BM Comment-->';
         		Id loggedUser = UserInfo.getUserId();
		    	List<Task_TAT__c> childTAT  = new List<Task_TAT__c>();
		    	Task_TAT__c childRec        = new Task_TAT__c();
		    	Task ttt = new Task();
		    	List<Task> tskrecList       = new List<Task>();
		    	List<Task> tRecList = new List<Task>();
		    	String parentRecord         = Schema.SObjectType.Task_TAT__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
		        String childRecord          = Schema.SObjectType.Task_TAT__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
		        
		        Task_TAT__c parentTAT = [SELECT Id,Name,Application__c,Last_Category_Selected__c,Parent_Record__c,Full_Comments_History__c,Current_User__c,Task_Subject__c,Primary_Owner__c,Parent_TAT__c,Task_Start_Time__c,Task_End_Time__c,RecordTypeId FROM Task_TAT__c WHERE RecordTypeId =: parentRecord AND Task_Subject__c =: t.Task_Subject__c AND Parent_Record__c = true AND Application__c=:t.WhatId AND Task_End_Time__c = null LIMIT 1];  
		    	childTAT  = [SELECT Id,Name,Application__c,Current_User__c,OwnerId,Last_Category_Selected__c,Parent_Record__c,Task_Subject__c,Task_Start_Time__c,Task_End_Time__c,Parent_TAT__c,RecordTypeId FROM Task_TAT__c WHERE Task_Subject__c =: t.Task_Subject__c AND Parent_Record__c = false AND Parent_TAT__c=:parentTAT.Id AND Application__c=:t.WhatId AND Task_End_Time__c = null];
		    	tskrecList= [SELECT ID,WhatId,OwnerId,Subject,Status FROM Task WHERE WhatId =:childTAT[0].Application__c AND Subject =: childTAT[0].Task_Subject__c];

		    	if(parentTAT.Id != null){
			    		childRec.Parent_TAT__c      = parentTAT.Id;
			    		childRec.Task_Subject__c    = t.Task_Subject__c;
			    		childRec.Task_Start_Time__c = System.now();
			    		childRec.Current_User__c    = application.OwnerId;
			    		childRec.Application__c     = t.WhatId;
			    		childRec.Primary_Owner__c   = application.OwnerId;
			    		if(childRec.Current_User__c == t.Parent_Owner_Id__c){
			    			childRec.Primary_Owner_Last_Comment__c = t.Current_Task__c;  
			    		}
			    		if(childRec.Current_User__c != t.Parent_Owner_Id__c){
			    			childRec.BM_Last_Comment__c = t.Current_Task__c; 
			    		}
			    		
			    		childTAT[0].Task_End_Time__c = System.now();
			    		childTAT[0].Current_User__c = application.OwnerId;

					    DateTime start = childTAT[0].Task_Start_Time__c;
				    	DateTime ends  = childTAT[0].Task_End_Time__c;

				 		Long tm= ends.getTime()-start.getTime();
						Decimal noOfsec = math.mod(tm/1000, 60);
						Decimal noOfmins = math.mod(((tm/1000)/60), 60);
						Decimal noOfhrs = math.mod(((tm/1000)/60)/60,24);
						Decimal noOfdays = math.mod((((tm/1000)/60)/60)/24,365);

						String totalTime = String.valueOf(noOfdays+' Days '+noOfhrs+' Hrs '+noOfmins+' Min '+noOfsec+' Sec ');
						if(parentTAT.Full_Comments_History__c == null || parentTAT.Full_Comments_History__c == 'null')
						parentTAT.Full_Comments_History__c = '';

					if(t.Parent_Owner_Id__c == childTAT[0].Current_User__c){
						childTAT[0].BM_TAT__c = totalTime;
						childTAT[0].Days__c              = noOfdays;
						childTAT[0].Hours__c             = noOfhrs;
						childTAT[0].Minutes__c           = noOfmins;
						childTAT[0].Seconds__c           = noOfsec;
						childTAT[0].Primary_Owner_Last_Comment__c = t.Current_Task__c;
						parentTAT.Full_Comments_History__c = parentTAT.Full_Comments_History__c + '\n' + cmt + t.Current_Task__c + '\n';
						parentTAT.Primary_Owner_Last_Comment__c  = t.Current_Task__c;
						parentTAT.Last_Category_Selected__c      = t.Category__c;
					}
					if(t.Parent_Owner_Id__c != childTAT[0].Current_User__c){
						childTAT[0].BM_TAT__c = totalTime;
						childTAT[0].Days__c              = noOfdays;
						childTAT[0].Hours__c             = noOfhrs;
						childTAT[0].Minutes__c           = noOfmins;
						childTAT[0].Seconds__c           = noOfsec;
						childTAT[0].BM_Last_Comment__c  = t.Current_Task__c;
						parentTAT.Full_Comments_History__c = parentTAT.Full_Comments_History__c + '\n' + cmmt + t.Current_Task__c + '\n';
						parentTAT.BM_Last_Comment__c   = t.Current_Task__c;
						parentTAT.Last_Category_Selected__c = t.Category__c;
					}

				}
		    		update parentTAT;
		    		update childTAT;
		    		insert childRec;

		}catch(Exception e){
            System.debug('e'+e);
             HandleBusinessException.captureError('taskTriggerHandler', 'updateTatRecord', e);
   		}   	
    }
    
    public static void totalTimeCollapsed(Task tk, genesis__Applications__c application){

    	Integer totSec = 0;
    	Integer totMin = 0;
    	Integer totHrs = 0;
    	Integer totDays = 0;
    	Integer sec = 0;
    	Integer min = 0;
    	Integer hrs = 0;
    	Integer day = 0;
    	Integer totSec1 = 0;
    	Integer totMin1 = 0;
    	Integer totHrs1 = 0;
    	Integer totDays1 = 0;
    	Integer sec1 = 0;
    	Integer min1 = 0;
    	Integer hrs1 = 0;
    	Integer day1 = 0;
    	integer i = 0;
    	DateTime startTm;
    	DateTime endsTm;

		try{
    	List<Task_TAT__c> allChildRec = new List<Task_TAT__c>();
    	List<Task_TAT__c> lastRecUpdate = new List<Task_TAT__c>();
    	Task_TAT__c parentTAT = new Task_TAT__c();
    	Task_TAT__c updateChiild = new Task_TAT__c();
    	List<Task_TAT__c> upChild = new List<Task_TAT__c>();
    	Task_TAT__c updateParent = new Task_TAT__c();
    	Task tasks = new Task();
    	Id logUser = UserInfo.getUserId();
    	String parentRecord         = Schema.SObjectType.Task_TAT__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        parentTAT = [SELECT Id,Name,Application__c,Last_Category_Selected__c,Parent_Record__c,Current_User__c,Total_Primary_Owner_TAT__c,Task_Subject__c,Parent_TAT__c,Task_Start_Time__c,Task_End_Time__c,RecordTypeId FROM Task_TAT__c WHERE RecordTypeId =: parentRecord AND Task_Subject__c =: tk.Task_Subject__c AND Parent_Record__c = true AND Application__c=:tk.WhatId LIMIT 1];
	    lastRecUpdate         = [SELECT Id,Name,Application__c,Last_Category_Selected__c,Parent_Record__c,Current_User__c,Days__c,Hours__c,Minutes__c,Seconds__c,Task_Subject__c,Parent_TAT__r.Id,Parent_TAT__c,Task_Start_Time__c,Task_End_Time__c,RecordTypeId FROM Task_TAT__c WHERE Task_Subject__c =: tk.Task_Subject__c AND Parent_Record__c = false AND Parent_TAT__c =: parentTAT.Id AND Application__c =:tk.WhatId AND Task_End_Time__c = null];

	    if(lastRecUpdate.size() > 0){
	    	
	    	updateChiild.Task_End_Time__c        = System.now();
		    startTm = lastRecUpdate[0].Task_Start_Time__c;
		    endsTm  = updateChiild.Task_End_Time__c;
			updateChiild.Current_User__c = tk.OwnerId;

		    Long tms= endsTm.getTime()-startTm.getTime();

		    Decimal noOfsecs = math.mod(tms/1000, 60);
					
			Decimal noOfminss = math.mod(((tms/1000)/60), 60);
					
			Decimal noOfhrss = math.mod(((tms/1000)/60)/60,24);
					
			Decimal noOfdayss = math.mod((((tms/1000)/60)/60)/24,365);

			String totalTimes = String.valueOf(noOfdayss+' Days '+noOfhrss+' Hrs '+noOfminss+' Min '+noOfsecs+' Sec ');

			if(tk.Parent_Owner_Id__c == updateChiild.Current_User__c){ //logUser //updateChiild.Current_User__c
				updateChiild.Primary_Owner_TAT__c = totalTimes;
			    updateChiild.Days__c              = noOfdayss;
				updateChiild.Hours__c             = noOfhrss;
				updateChiild.Minutes__c           = noOfminss;
				updateChiild.Seconds__c           = noOfsecs;
			}
			else if(tk.Parent_Owner_Id__c != updateChiild.Current_User__c){
				updateChiild.BM_TAT__c            = totalTimes;
				updateChiild.Days__c              = noOfdayss;
				updateChiild.Hours__c             = noOfhrss;
				updateChiild.Minutes__c           = noOfminss;
				updateChiild.Seconds__c           = noOfsecs;
			}
			updateChiild.Id                        = lastRecUpdate[0].Id;
		    upChild.add(updateChiild);
		}

			update upChild;

			
			allChildRec           = [SELECT Id,Name,Application__c,Last_Category_Selected__c,Primary_Owner__c,Parent_Record__c,Current_User__c,Days__c,Hours__c,Minutes__c,Seconds__c,Task_Subject__c,Parent_TAT__r.Id,Parent_TAT__c,Task_Start_Time__c,Task_End_Time__c,RecordTypeId FROM Task_TAT__c WHERE Task_Subject__c =: tk.Task_Subject__c AND Parent_Record__c = false AND Parent_TAT__c =: parentTAT.Id AND Application__c =:tk.WhatId];

	        if(allChildRec.size()>0){
		        for(Task_TAT__c tskTat: allChildRec){
		    	
					if(tskTat.Current_User__c == tk.Parent_Owner_Id__c){
						sec = Integer.valueOf(tskTat.Seconds__c);
						totSec += sec;
						min = Integer.valueOf(tskTat.Minutes__c);
						totMin += min;
						hrs = Integer.valueOf(tskTat.Hours__c);
						totHrs += hrs;
						day = Integer.valueof(tskTat.Days__c);
						totDays += day;

					}
					else if(tskTat.Current_User__c != tk.Parent_Owner_Id__c){
						sec1 = Integer.valueOf(tskTat.Seconds__c);
						totSec1 += sec1;
						min1 = Integer.valueOf(tskTat.Minutes__c);
						totMin1 += min1;
						hrs1 = Integer.valueOf(tskTat.Hours__c);
						totHrs1 += hrs1;
						day1 = Integer.valueOf(tskTat.Days__c);
						totDays1 += day1;	
					}
		   		}

				    Integer s = Math.mod(totSec,60);
				    Integer count = totSec/60;
				    Integer m = Math.mod(totMin,60);
				    Integer cnt = totMin/60;
				    Integer h = Math.mod(totHrs,24);
				    Integer ct = totHrs/24;
				    totSec = s;
				    totMin  += count;
				    totHrs += cnt;
				    totDays += ct;
				    String primeOwn = String.valueOf(totDays+' Days '+totHrs+' Hrs '+totMin+' Min '+totSec+' Sec ');

				    Integer s1 = Math.mod(totSec1,60);
				    Integer count1 = totSec1/60;
				    Integer m1 = Math.mod(totMin1,60);
				    Integer cnt1 = totMin1/60;
				    Integer h1 = Math.mod(totHrs1,24);
				    Integer ct1 = totHrs1/24;
				    totSec1 = s1;  
				    totMin1  += count1;
				    totHrs1 += cnt1;
				    totDays1 += ct1;
				    String bmOwn = String.valueOf(totDays1+' Days '+totHrs1+' Hrs '+totMin1+' Min '+totSec1+' Sec ');

				    parentTAT.Total_Primary_Owner_TAT__c = primeOwn;
				    parentTAT.Total_BM_TAT__c            = bmOwn;
				    parentTAT.Id                         = allChildRec[0].Parent_TAT__r.Id;
			    	parentTAT.Task_End_Time__c           = System.now();
			    	parentTAT.Primary_Owner_Last_Comment__c   = tk.Primary_Owner_BM_Comments__c;
			}

		    update parentTAT;

		}catch(Exception e){
            System.debug('e'+e);
             HandleBusinessException.captureError('taskTriggerHandler', 'totalTimeCollapsed', e);
   		}

    }
    public static void turnAroundTimeForOtherTasks(Task k, genesis__Applications__c application){
    	try{

    		DateTime startTm;
    	    DateTime endsTm;
    	    
		    Task_TAT__c otherParentTAT = new Task_TAT__c();
		    String parentRecord         = Schema.SObjectType.Task_TAT__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            otherParentTAT = [SELECT Id,Name,Application__c,Last_Category_Selected__c,Parent_Record__c,Current_User__c,Total_Primary_Owner_TAT__c,Task_Subject__c,Parent_TAT__c,Task_Start_Time__c,Task_End_Time__c,RecordTypeId FROM Task_TAT__c WHERE RecordTypeId =: parentRecord AND Task_Subject__c =: k.Task_Subject__c AND Parent_Record__c = true AND Application__c=:k.WhatId LIMIT 1];
            if(otherParentTAT != null){
	            otherParentTAT.Task_End_Time__c = System.now();
	            startTm = otherParentTAT.Task_Start_Time__c;
			    endsTm  = otherParentTAT.Task_End_Time__c;

			    Long tms= endsTm.getTime()-startTm.getTime();

			    Decimal noOfsecs = math.mod(tms/1000, 60);
						
				Decimal noOfminss = math.mod(((tms/1000)/60), 60);
						
				Decimal noOfhrss = math.mod(((tms/1000)/60)/60,24);
						
				Decimal noOfdayss = math.mod((((tms/1000)/60)/60)/24,365);

				String totalTimes = String.valueOf(noOfdayss+' Days '+noOfhrss+' Hrs '+noOfminss+' Min '+noOfsecs+' Sec ');
				
				otherParentTAT.Total_Primary_Owner_TAT__c = totalTimes;
			}
			
			UPDATE otherParentTAT;

		}catch(Exception e){
            System.debug('e'+e);
             HandleBusinessException.captureError('taskTriggerHandler', 'turnAroundTimeForOtherTasks', e);
   		}
    }
    
	public static String getUserListss(String branchCode, String Designation){
        
        List <User> usrList = new List <User>();
      
            Branch_Master__c brMaster = [Select Id, CODCCBRN__c,Linked_RLPC__c, Division_Code__c From Branch_Master__c Where CODCCBRN__c=:branchCode limit 1];
            
            if(Designation =='Branch manager'){
                usrList = [Select ID From User where Office_Code__c =:brMaster.CODCCBRN__c And Role_Name__c=:Designation AND IsActive =:True];
            }
            
        String UsrId = AssignTask.userAssign(usrList);
        if(UsrId == null){
            if(usrList.size()>0){
                UsrId = usrList[0].Id;
            }            
        } 
        return UsrId;
    }

}