public class PassengerVehicleWrappers {
    
    public class dealerClass {
        public List<dealerResult> result;
        public dealerClass(){
            this.result = new List<dealerResult>();
        }
    }
    public class modelFourWheelerClass {
        public List<modelFourWheelerResult> result;
        public modelFourWheelerClass(){
            this.result = new List<modelFourWheelerResult>();
        }
    }
    public class versionByModelClass {
        public List<versionByModelResult> result;
        public versionByModelClass(){
            this.result = new List<versionByModelResult>();
        }
    }
    public class makeFourWheelerClass {
        public List<makeFourWheelerResult> result;
        public makeFourWheelerClass(){
            this.result = new List<makeFourWheelerResult>();
        }
    }
    public class vehiclePriceClass {
        public List<vehiclePriceResult> result;
        public vehiclePriceClass(){
            this.result = new List<vehiclePriceResult>();
        }
    }
    
    public class stateClass {
        public List<stateResult> result;
        public stateClass(){
            this.result = new List<stateResult>();
        }
    }
    
    public class cityClass {
        public List<cityResult> result;
        public cityClass(){
            this.result = new List<cityResult>();
        }
    }
    
    public class stateResult {
        public Integer StateId;
        public String StateName;
        public Object StateMaskingName;
    }
    
    public class cityResult {
		public Integer CityId;
		public String CityName;
	}
    
    public class makeFourWheelerResult {
		public Integer id;
		public String name;
	}
    
    public class PricesList {
		public Integer value ;
		public Integer type ;
		public Integer id ;
		public String name ;

	}
	
	public class vehiclePriceResult {
		public Boolean isMetallic ;
		public List<PricesList> pricesList ;
	}
    public class modelFourWheelerResult {
		public String model;
		public Integer Id;
		public List<Variants> variants;
	}
    public class Variants {
	}
    public class versionByModelResult {
		public Integer versionId;
		public String versionName;
        
	}
    public class dealerAddressDetails {
		public String id;
		public String address;
		public String city;
		public String make;
		public String email;
		public String phone;
		public String pincode;
		public String state;
	}

	public class dealerResult {
		public String name;
		public String make;
		public List<dealerAddressDetails> addressDetails;
	}
}