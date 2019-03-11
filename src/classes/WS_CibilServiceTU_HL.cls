/******************************************************************************************
*  Name        : WS_CibilServiceTU_HL
*  
*  Company     : Et marlabs
*    
*  Purpose     : This webservice calls the CibilTransunion with applicants  information and stores the response
* 
*  Developer   : Venu gopal
* 
*  Version     : 1.0 
----------------------------------------------------------------------
*/

public class WS_CibilServiceTU_HL {
    
    public class response{
        public CibilRequestTU_HL CibilRequestTU_HL;
        
    }
    
    //calling Cibil service
    
    public static CibilResponseTU_HL callCibil(CibilRequestTU_HL cibilRequest){
        try{
            cibilRequest.Applicants[0].Addresses.Address[0].AddressLine1 = cibilRequest.Applicants[0].Addresses.Address[0].AddressLine1.replace('\r\n',' ');
            String body = json.serialize(cibilRequest,true);
            system.debug('bureauRequest==='+body);
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
            HTTPResponse response                                   = new HTTPResponse();
            String endPoint                                         = Utility.getFullEndpoints('Cibil_TU');
            response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,body,headerMap,null);
            system.debug('$$$$'+response.getBody());
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201 || response.getStatusCode() == 400){
                try{
                    String jsonString = response.getBody();
                    System.debug('jsonString:::'+jsonString);
                    CibilResponseTU_HL res = (CibilResponseTU_HL)Json.deserialize(jsonString,CibilResponseTU_HL.class);
                    system.debug('res'+res);
                    return res;
                }
                catch(Exception e){
                    RETURN null;
                }
            }
            else{
                throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
            }
        }catch(Exception e){
            system.debug(e.getLineNumber()+'sss'+e.getStackTraceString());
        }  
        
        return null;
        
    }
    
    // parsing Cibil request for given Applicants
    public static CibilRequestTU_HL prepareRequest(Account Acc,String ServiceType){
        try{
            CibilRequestTU_HL cibilService = new CibilRequestTU_HL(); 
            cibilService.Applicants = new   List<CibilRequestTU_HL.cls_Applicants>();
            cibilService.ApplicationData = new CibilRequestTU_HL.cls_ApplicationData();
            List<CibilRequestTU_HL.cls_Identifier> IdList;
            List<CibilRequestTU_HL.cls_Telephone> TelephoneList;
            List<CibilRequestTU_HL.cls_Address> AddressList;
            
            CibilRequestTU_HL.cls_Applicants Applist=new  CibilRequestTU_HL.cls_Applicants();
            Applist.ApplicantType='Main';
            string TName,LName,MName,FName;
            
            if(!Utility.ISStringBlankorNull(acc.Full_Name__c)){
                TName=acc.Full_Name__c;
            }
            else{
                TName=Utility.getBlankStringIfNull(acc.Name);
            }
            string[] ListNames=TName.split(' +');
            if(ListNames.size()==1){
                FName=Utility.getBlankStringIfNull(ListNames[0]);
            }
            else if(ListNames.size()==2){
                  FName=Utility.getBlankStringIfNull(ListNames[0]);
                //MName=Utility.getBlankStringIfNull(ListNames[1]);
                // last name is mandate comnted above code on 2018-05-04
                LName=Utility.getBlankStringIfNull(ListNames[1]);
              
            }
            else if(ListNames.size()==3){
                 FName=Utility.getBlankStringIfNull(ListNames[0]);
                MName=Utility.getBlankStringIfNull(ListNames[1]);
                LName=Utility.getBlankStringIfNull(ListNames[2]);
            }
            else if(ListNames.size()>3){ 
              FName=Utility.getBlankStringIfNull(ListNames[0])+' '+Utility.getBlankStringIfNull(ListNames[1]);
                MName=Utility.getBlankStringIfNull(ListNames[2]);
                LName=Utility.getBlankStringIfNull(ListNames[3]);
            }
            Applist.ApplicantFirstName=Utility.getBlankStringIfNull(FName);
            Applist.ApplicantLastName=Utility.getBlankStringIfNull(LName);
            Applist.ApplicantMiddleName=Utility.getBlankStringIfNull(MName);
            Applist.Gender=Utility.getBlankStringIfNull(acc.Gender__pc);
            if(acc.PersonBirthdate!=null){
                Applist.DateOfBirth=getdate(acc.PersonBirthdate);
            }
            Applist.Identifiers =new CibilRequestTU_HL.cls_Identifiers();
            Applist.Telephones =new CibilRequestTU_HL.cls_Telephones();
            Applist.Addresses =new CibilRequestTU_HL.cls_Addresses();
            
            // Identifiers
            CibilRequestTU_HL.cls_Identifiers CIDs=new CibilRequestTU_HL.cls_Identifiers();
            CIDs.Identifier=new List<CibilRequestTU_HL.cls_Identifier>();
            
            if(acc.Aadhaar_Number__pc!=null){
                CibilRequestTU_HL.cls_Identifier CId1=new  CibilRequestTU_HL.cls_Identifier();
                CId1.IdNumber=Utility.getBlankStringIfNull(acc.Aadhaar_Number__pc);
                CId1.IdType='UID_REFERENCE_KEY';
                CIDs.Identifier.add(CId1);
            }
            
            if(acc.Pan_Number__c!=null){
                CibilRequestTU_HL.cls_Identifier CId2=new  CibilRequestTU_HL.cls_Identifier();
                CId2.IdNumber=Utility.getBlankStringIfNull(acc.Pan_Number__c);
                CId2.IdType='Pan Card';
                CIDs.Identifier.add(CId2);
            }
            
            // Telephones
            CibilRequestTU_HL.cls_Telephones CTPs=new CibilRequestTU_HL.cls_Telephones();
            CTPs.Telephone=new List<CibilRequestTU_HL.cls_Telephone>();
            
            CibilRequestTU_HL.cls_Telephone Tphone=new  CibilRequestTU_HL.cls_Telephone();
            Tphone.TelephoneExtension='';
            Tphone.TelephoneNumber=Utility.getBlankStringIfNull(acc.PersonMobilePhone);
            Tphone.TelephoneType='Mobile Phone';
            CTPs.Telephone.add(Tphone);
            
            // Address
            CibilRequestTU_HL.cls_Addresses CADs=new CibilRequestTU_HL.cls_Addresses();
            CADs.Address=new List<CibilRequestTU_HL.cls_Address>();
            
            CibilRequestTU_HL.cls_Address Addres=new  CibilRequestTU_HL.cls_Address();
            Addres.AddressLine1=Utility.getBlankStringIfNull(acc.PersonMailingStreet);
            Addres.AddressLine2='';
            Addres.AddressLine3='';
            Addres.AddressLine4='';
            Addres.AddressLine5='';
            Addres.city        =Utility.getBlankStringIfNull(acc.PersonMailingCity);
            Addres.PinCode        =Utility.getBlankStringIfNull(acc.PersonMailingPostalCode);
            Addres.StateCode        =Utility.getBlankStringIfNull(acc.PersonMailingState);
            Addres.AddressType        = 'Permanent Address';
            Addres.ResidenceType        ='Owned';
            
            CADs.Address.add(Addres);
            //  Application Data
            CibilRequestTU_HL.cls_ApplicationData Cdata=new  CibilRequestTU_HL.cls_ApplicationData();
            Cdata.ReferenceNumber=Utility.getBlankStringIfNull(acc.id);
            Cdata.ConsumerConsentForUIDAIAuthentication='Y';
            
            Cdata.GSTStateCode=Utility.getBlankStringIfNull(Acc.PersonMailingState);
            Cdata.NTCProductType='';
            Cdata.CenterReferenceNo='';
            Cdata.BranchReferenceNo='';
            Cdata.DSTuNtcFlag='True';
            Cdata.MFIBureauFlag='True';
            Cdata.MFIPDFReport='Fasle';
            
            if(ServiceType==Constants.CIBIL){
                Cdata.CibilBureauFlag='False';
                Cdata.IDVerificationFlag='True';
                Cdata.CIBILPDFReport='True';
                Cdata.IDVPDFReport='False';
            }
            else if(ServiceType==Constants.IDVCall){
                Cdata.CibilBureauFlag='True';
                Cdata.IDVerificationFlag='False';
                Cdata.CIBILPDFReport='False';
                Cdata.IDVPDFReport='True';   
            }
            
            Applist.Addresses=CADs;
            Applist.Telephones=CTPs;
            Applist.Identifiers=CIDs;
            cibilService.ApplicationData=Cdata;
            cibilService.Applicants.add(Applist);
            return cibilService;                    
        }
        
        /*
*  Applist.cls_Identifiers Idf =Identifiers;
Applist.cls_Telephones TelP=Telephones;
Applist.cls_Addresses Addr=Addresses;
try{
CibilRequestTU_HL cibilService = new CibilRequestTU_HL();
cibilService.Applicants = new   List<CibilRequestTU_HL.cls_Applicants>();
// cibilService.
cibilService.ApplicationData = new CibilRequestTU_HL.cls_ApplicationData();

List<CibilRequestTU_HL.cls_Identifiers> IdList;
List<CibilRequestTU_HL.cls_Telephones> TelephoneList;
CibilRequestTU_HL.cls_Applicants Applist=new CibilRequestTU_HL.cls_Applicants();

Applist.ApplicantType='Main';
Applist.ApplicantFirstName=acc.FirstName;
Applist.ApplicantLastName=acc.LastName;
Applist.ApplicantMiddleName=acc.MiddleName;
Applist.Gender=acc.Gender__pc;
Applist.DateOfBirth=getdate(acc.PersonBirthdate);
Applist.Identifiers=new List<CibilRequestTU_HL.cls_Identifiers>();
Applist.Telephones=new List<CibilRequestTU_HL.cls_Telephones>();
Applist.Addresses=new List<CibilRequestTU_HL.cls_Addresses>();
// CibilRequestTU_HL.cls_Identifiers IdentifierList1=new CibilRequestTU_HL.cls_Identifiers();
CibilRequestTU_HL.cls_Identifiers IdentifierList2=new CibilRequestTU_HL.cls_Identifiers();

// Removing Adhar for Testingpurpose                
CibilRequestTU_HL.cls_Identifier CID=new CibilRequestTU_HL.cls_Identifier();

CID.IdNumber =acc.Aadhaar_Number__pc;
CID.IdType ='UID';


CibilRequestTU_HL.cls_Identifier CID1=new CibilRequestTU_HL.cls_Identifier();
CID1.IdNumber =acc.Pan_Number__c;
CID1.IdType ='Pan Card';
// IdentifierList1.Identifier=CID;
IdentifierList2.Identifier=CID1;
// telephone request
CibilRequestTU_HL.cls_Telephones Tphonelist=new  CibilRequestTU_HL.cls_Telephones();
CibilRequestTU_HL.cls_Telephone Tphone=new CibilRequestTU_HL.cls_Telephone();

Tphone.TelephoneExtension='';
Tphone.TelephoneNumber=acc.PersonMobilePhone;
Tphone.TelephoneType='Mobile Phone';
Tphonelist.Telephone=Tphone;
system.debug('Tphonelist'+Tphonelist);
// Address Request
CibilRequestTU_HL.cls_Addresses AddrList=new CibilRequestTU_HL.cls_Addresses();
CibilRequestTU_HL.cls_Address Addres=new CibilRequestTU_HL.cls_Address();
Addres.AddressLine1=acc.PersonMailingStreet;
Addres.AddressLine2='';
Addres.AddressLine3='';
Addres.AddressLine4='';
Addres.AddressLine5='';
Addres.city        =acc.PersonMailingCity;
Addres.PinCode        =acc.PersonMailingPostalCode;
Addres.StateCode        =acc.PersonMailingState;
Addres.AddressType        = 'Permanent Address';
Addres.ResidenceType        ='Owned';

AddrList.Address=Addres;
CibilRequestTU_HL.cls_ApplicationData Cdata=new  CibilRequestTU_HL.cls_ApplicationData();
Cdata.ReferenceNumber=acc.id;
Cdata.ConsumerConsentForUIDAIAuthentication='Y';

Cdata.GSTStateCode=Acc.PersonMailingState;
Cdata.NTCProductType='';
Cdata.CenterReferenceNo='';
Cdata.BranchReferenceNo='';
Cdata.DSTuNtcFlag='True';
Cdata.MFIBureauFlag='True';
Cdata.MFIPDFReport='Fasle';

if(ServiceType==Constants.CIBIL){
Cdata.CibilBureauFlag='False';
Cdata.IDVerificationFlag='True';
Cdata.CIBILPDFReport='True';
Cdata.IDVPDFReport='False';
}
else if(ServiceType==Constants.IDVCall){
Cdata.CibilBureauFlag='True';
Cdata.IDVerificationFlag='False';
Cdata.CIBILPDFReport='False';
Cdata.IDVPDFReport='True';   
}
Applist.Telephones.add(Tphonelist);
// Applist.Identifiers.add(IdentifierList1);
Applist.Identifiers.add(IdentifierList2);

system.debug('Tphonelist'+Applist);
Applist.Addresses.add(AddrList);
cibilService.ApplicationData=Cdata;
cibilService.Applicants.add(Applist);
system.debug(cibilService);

return cibilService;
}

*/
        catch(exception e){
            system.debug(e.getLineNumber()+'sss'+e.getStackTraceString());
        }
        return null;
    }
    
    
    public static string getdate(date d){
        string day1=string.valueOf(d.day());
        string month1=string.valueOf(d.month());
        string year1=string.valueOf(d.year());
        integer d1=day1.length();
        integer m1=month1.length();
        if(d1==1){
            day1='0'+day1;
        }
        if(m1==1){
            month1='0'+month1;
        }
        string i=String.valueOf(day1+''+month1+''+year1);
        
        return i;
    }
}