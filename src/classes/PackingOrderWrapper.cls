global Class PackingOrderWrapper implements Comparable{
    global String facId {get;set;}
    global String CollId {get;set;}
    global String AppColId {get;set;}
    global String securityType {get;set;}
    global Integer priority {get;set;}
    global String productName {get;set;}

    global PackingOrderWrapper(String facId,String CollId,String AppColId,String securityType,Integer priority,String productName){
        this.facId = facId;
        this.CollId = CollId;
        this.AppColId = AppColId;
        this.securityType = securityType;
        this.priority = priority;
        this.productName = productName;
    }
    public enum SORT_BY {
        ByPriority,ByCollId
    }
    public static SORT_BY sortBy = SORT_BY.ByPriority;

    global Integer compareTo(Object ObjToCompare) {
        //return StudentName.CompareTo(((Student)ObjToCompare).StudentName);
        //return priority.CompareTo(((PackingOrderWrapper)ObjToCompare).priority);
        if(sortBy == SORT_BY.ByPriority){
           //return priority.compareTo(((PackingOrderWrapper)ObjToCompare).priority);
           return Integer.valueOf(priority - ((PackingOrderWrapper)objToCompare).priority);


        }else{
           return CollId.compareTo(((PackingOrderWrapper)ObjToCompare).CollId);

        }

    }

}