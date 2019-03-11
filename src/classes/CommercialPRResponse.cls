/*
 * Name    : CommercialPRResponse
 * Company  : ET Marlabs
 * Purpose   : TO used as a Response for WS_CommercialPRCallout. 
 * Author  : Raushan
*/

public class CommercialPRResponse {
  public List<Out_msg> out_msg;
  
  public class BorrwerDetails {
    public String name; 
    public String borrowersLegalConstitution; 
    public ClassOfActivityVec classOfActivityVec; 
    public String businessCategory; 
    public String businessIndustryType; 
    public String salesFigure; 
    public String numberOfEmployees; 
    public String dateOfIncorporation; 
    public String year; 
  }
  public class BorrwerAddressContactDetailsVec {
    public List<BorrwerAddressContactDetails> borrwerAddressContactDetails; 
  }
  public class TotalCF {
    public String borrower; 
    public String borrowerPercentage; 
    public String guarantor; 
    public String guarantorPercentage; 
  }
  public class LocationInformation {
    public String borrowerOfficeLocationType; 
    public String address; 
    public String firstReportedDate; 
    public String lastReportedDate; 
    public String numberOfInstitutions; 
  }
  public class Address {
    public String addressLine; 
    public String city; 
    public String state; 
    public String pinCode; 
  }
  public class BorrowerDelinquencyReportedOnBorrower {
    public YourInstitution yourInstitution; 
    public YourInstitution outsideInstitution; 
  }
  public class Dates {
    public String sanctionedDt; 
    public String loanExpiryDt; 
    public String loanRenewalDt; 
    public String suitFiledDt; 
    public String wilfulDefault; 
  }
    public class CreditFacilityGuarantorDetailsVec {
    public String message; 
    public List<CreditFacilityGuarantorDetails> creditFacilityGuarantorDetails; 
  }
  public class RelationshipInformation {
    public String name; 
    public String relatedType; 
    public String relationship; 
    public String percentageOfControl; 
    public String dateOfIncorporation; 
    public String dateOfBirth; 
    public String gender; 
    public String businessCategory; 
    public String businessIndustryType; 
    public String classOfActivity1; 
  }  
  public class BorrowerProfileSec {
    public BorrwerDetails borrwerDetails; 
    public BorrwerAddressContactDetails borrwerAddressContactDetails; 
    public BorrwerIDDetailsVec borrwerIDDetailsVec; 
    public BorrowerDelinquencyReportedOnBorrower borrowerDelinquencyReportedOnBorrower; 
    public BorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVec borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVec; 
  }
  public class CreditRatingSummaryVec {
    public String message; 
    public List<CreditRatingSummary> creditRatingSummary; 
  }
    public class EnquiryDetailsInLast24MonthVec {
    public String message; 
    public List<EnquiryDetailsInLast24Month> enquiryDetailsInLast24Month; 
  }
  public class BorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months {
    public String detail; 
    public String relationship; 
    public String tl_count; 
    public String tl_outstanding; 
    public String wc_count; 
    public String wc_outstanding; 
    public String nf_count; 
    public String nf_outstanding; 
    public String fx_count; 
    public String fx_outstanding; 
  }
  public class CountOfCreditFacilities {
    public NoOfCreditFacilities noOfCreditFacilities; 
    public NoOfCreditFacilities noOfCreditGrantors; 
  }
  public class LocationInformationVec {
    public List<LocationInformation> locationInformation; 
  }  
  public class OtherDetails {
    public String repaymentFrequency; 
    public String tenure; 
    public String weightedAverageMaturityPeriodOfContracts; 
    public String restructingReason; 
    public String assetBasedSecurityCoverage; 
    public String GuaranteeCoverage; 
  }
  public class SuitFiledVec {
    public String message; 
    public List<SuitFilled_Z> suitFilled; 
  }
  public class RelationshipDetails {
    public String relationshipHeader; 
    public RelationshipInformation relationshipInformation; 
    public BorrwerAddressContactDetails borrwerAddressContactDetails; 
    public BorrwerIDDetailsVec_Z borrwerIDDetailsVec; 
  }
  public class CreditFacilityDetailsasGuarantor {
    public List<CreditFacilityCurrentDetails> creditFacilityCurrentDetails; 
    public BorrwerInfo borrwerInfo; 
  }
  public class NONSTDVec {
    public DPD0 DPD91to180; 
    public DPD0 greaterThan180DPD; 
    public DPD0 sub; 
    public DPD0 dbt; 
    public DPD0 loss; 
  }
  public class SummaryOfCreditFacilitiesRec {
    public String creditType; 
    public String yourBank; 
    public String othersBank; 
  }
  public class CreditRatingSummary {
    public String creditRatingAgency; 
    public List<CreditRatingSummaryDetailsVec> creditRatingSummaryDetailsVec; 
  }
  public class CreditFacilitySecurityDetails {
    public String relatedType; 
    public String classification; 
    public String value; 
    public String amount; 
    public String validationDt; 
    public String lastReportedDt; 
  }
  public class SummaryOfCreditFacilitiesVec {
    public List<SummaryOfCreditFacilitiesRec> summaryOfCreditFacilitiesRec; 
  }
  public class SuitFilled_Z {
    public String suitFilledBy; 
    public String suitStatus; 
    public String suitRefNumber; 
    public String suitAmt; 
    public String dateSuit; 
  }
  public class NoOfEnquiries {
    public String month1; 
    public String month2to3; 
    public String month4to6; 
    public String month7to12; 
    public String month12to24; 
    public String greaterthan24Month; 
    public String total; 
    public String mostRecentDate; 
  }
  public class BorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVec {
    public String message; 
    public List<BorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months> borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months; 
  }
  public class RankVec {
    public String rankName; 
    public String rankValue; 
    public String exclusionReason; 
  }
  public class CreditFacilityDetailsasBorrowerSec {
    public String message; 
    public CreditFacilityCurrentDetailsVec creditFacilityCurrentDetailsVec; 
    public CFHistoryforACOrDPDupto24MonthsVec cFHistoryforACOrDPDupto24MonthsVec; 
    public CreditFacilityOverdueDetailsVec creditFacilityOverdueDetailsVec; 
    public ChequeDishounouredDuetoInsufficientFunds chequeDishounouredDuetoInsufficientFunds; 
    public CreditFacilitySecurityDetailsVec creditFacilitySecurityDetailsVec; 
    public CreditFacilityGuarantorDetailsVec creditFacilityGuarantorDetailsVec; 
  }
  public class CreditFacilitiesDetailsVec {
    public String message; 
    public List<CreditFacilitiesDetails> creditFacilitiesDetails; 
    public String total; 
  }
  public class YourInstitution_Y {
    public String wilfulDefault; 
    public SuitFilled suitFilled; 
    public SuitFilled writtenOff; 
    public SuitFilled settled; 
    public SuitFilled invoked; 
    public SuitFilled overdueCF; 
    public String dishonoredCheque; 
  }
  public class NonFunded {
    public STDVec STDVec; 
    public NONSTDVec NONSTDVec; 
    public DPD0 total; 
  }
  public class OustandingBalanceByCFAndAssetClasificationSec {
    public String message; 
    public YourInstitution_X yourInstitution; 
    public YourInstitution_X outsideInstitution; 
  }
  public class YourInstitution_X {
    public NonFunded nonFunded; 
    public NonFunded workingCapital; 
    public NonFunded termLoan; 
    public NonFunded forex; 
    public NonFunded total; 
  }
  public class CreditFacilitySecurityDetailsVec {
    public String message; 
    public List<CreditFacilitySecurityDetails> creditFacilitySecurityDetails; 
  }
  public class Out_msg {
    public ResponseReport responseReport; 
  }
  public class ReportHeaderRec {
    public String daysPasswordToExpire; 
    public String reportOrderNumber; 
    public String reportOrderDate; 
    public String reportOrderedBy; 
    public String memberDetails; 
    public String applicationReferenceNumber; 
    public String memberReferenceNumber; 
    public String inquiryPurpose; 
  }
  public class EnquiryInformationRec {
    public String borrowerName; 
    public String dateOfRegistration; 
    public String pan; 
    public String cin; 
    public String tin; 
    public String crn; 
    public String addressCount; 
    public AddressVec addressVec; 
  }
  public class CreditProfileSummarySec {
    public YourInstitution_Z yourInstitution; 
    public OutsideInstitution outsideInstitution; 
    public Total total; 
  }
  public class CreditFacilityCurrentDetailsVec {
    public CreditFacilityCurrentDetails creditFacilityCurrentDetails; 
  }
  public class EnquiryDetailsInLast24Month {
    public String creditLender; 
    public String enquiryDt; 
    public String enquiryPurpose; 
    public String enquiryAmt; 
  }
  public class DerogatoryInformationReportedOnGuarantedPartiesVec {
    public List<String> derogatoryInformationReportedOnGuarantedParties; 
  }
  public class LocationDetailsSec {
    public String message; 
    public LocationInformationVec locationInformationVec; 
    public String contactNumber; 
    public String faxNumber; 
  }
  public class ReportIssuesVec {
    public String code; 
    public String message; 
    public String description; 
  }

  public class CFHistoryforACOrDPDupto24MonthsVec {
    public List<CFHistoryforACOrDPDupto24Months> cFHistoryforACOrDPDupto24Months; 
  }
  public class ProductSec {
    public BorrowerProfileSec borrowerProfileSec; 
    public RankSec rankSec; 
    public CreditProfileSummarySec creditProfileSummarySec; 
    public EnquirySummarySec enquirySummarySec; 
    public DerogatoryInformationSec derogatoryInformationSec; 
    public OustandingBalanceByCFAndAssetClasificationSec oustandingBalanceByCFAndAssetClasificationSec; 
    public LocationDetailsSec locationDetailsSec; 
    public RelationshipDetailsVec relationshipDetailsVec; 
    public CreditFacilityDetailsasBorrowerSecVec creditFacilityDetailsasBorrowerSecVec; 
    public CreditFacilityDetailsasGuarantorVec creditFacilityDetailsasGuarantorVec; 
    public SuitFiledVec suitFiledVec; 
    public CreditRatingSummaryVec creditRatingSummaryVec; 
    public EnquiryDetailsInLast24MonthVec enquiryDetailsInLast24MonthVec; 
    public CreditFacilitiesDetailsVec creditFacilitiesDetailsVec; 
    public CreditFacilitiesSummary creditFacilitiesSummary; 
  }
  public class YourInstitution_Z {
    public String message; 
    public String totalLenders; 
    public TotalCF totalCF; 
    public String openCF; 
    public TotalCF totalOutstanding; 
    public String latestCFOpenedDate; 
    public TotalCF delinquentCF; 
    public TotalCF delinquentOutstanding; 
  }
  public class CreditFacilityGuarantorDetails {
    public GuarantorDetails guarantorDetails; 
    public BorrwerAddressContactDetails guarantorAddressContactDetails; 
    public GuarantorDetailsBorrwerIDDetailsVec guarantorDetailsBorrwerIDDetailsVec; 
  }
  public class OutsideInstitution {
    public String message; 
    public YourInstitution_Z otherPublicSectorBanks; 
    public YourInstitution_Z otherPrivateForeignBanks; 
    public YourInstitution_Z NBFC_Others; 
    public YourInstitution_Z OutsideTotal; 
  }
  public class CreditFacilityOverdueDetails {
    public String DPD1to30amt; 
    public String DPD31to60amt; 
    public String DPD61t090amt; 
    public String DPD91to180amt; 
    public String DPDabove180amt; 
  }
  public class CreditFacilitiesDetails {
    public String creditType; 
    public String group_Z; 
    public String ownership; 
    public String accountNo; 
    public String reportedBy; 
    public String currentBalance; 
    public String closedDate; 
    public String lastReported; 
  }
  public class NoOfCreditFacilities {
    public String yourBank; 
    public String others; 
    public String total; 
  }
  public class CreditRatingSummaryDetailsVec {
    public String creditRating; 
    public String ratingAsOn; 
    public String ratingExpiryDt; 
    public String lastReportedDt; 
  }
  public class DPD0 {
    public String count; 
    public String value; 
  }  
  public class RelationshipDetailsVec {
    public String message; 
    public List<RelationshipDetails> relationshipDetails; 
  }
  public class DerogatoryInformationBorrower {
    public YourInstitution_Y yourInstitution; 
    public YourInstitution_Y outsideInstitution; 
    public YourInstitution_Y total; 
  }
  public class SuitFilled {
    public String numberOfSuitFiled; 
    public String amt; 
  }
  public class AddressVec {
    public List<Address> address; 
  }
  public class RankSec {
    public String message; 
    public List<RankVec> rankVec; 
  }
  public class EnquiryYourInstitution {
    public NoOfEnquiries noOfEnquiries; 
  }
  public class CreditFacilityCurrentDetails {
    public String derivative; 
    public String accountNumber; 
    public String cfSerialNumber; 
    public String cfType; 
    public String cfMember; 
    public String assetClassificationDaysPastDueDpd; 
    public String status; 
    public String statusDate; 
    public String lastReportedDate; 
    public Amount amount; 
    public Dates dates; 
    public OtherDetails otherDetails; 
  }
  public class CreditFacilityDetailsasGuarantorVec {
    public String message; 
    public List<CreditFacilityDetailsasGuarantor> creditFacilityDetailsasGuarantor; 
  }
  public class BorrwerIDDetailsVec_Z {
    public String lastReportedDate; 
    public List<BorrwerIDDetails_Z> borrwerIDDetails; 
  }
  public class CreditFacilitiesSummary {
    public CountOfCreditFacilities countOfCreditFacilities; 
    public SummaryOfCreditFacilitiesVec summaryOfCreditFacilitiesVec; 
  }
  public class BorrwerIDDetailsVec {
    public String lastReportedDate; 
    public List<BorrwerIDDetails> borrwerIDDetails; 
  }
  public class YourInstitution {
    public String current; 
    public String last24Months; 
  }
  public class CreditFacilityDetailsasBorrowerSecVec {
    public String message; 
    public List<CreditFacilityDetailsasBorrowerSec> creditFacilityDetailsasBorrowerSec; 
  }
  public class Amount {
    public String amount; 
    public String sanctionedAmt; 
    public String drawingPower; 
    public String outstandingBalance; 
    public String markToMarket; 
    public String overdue; 
    public String highCredit; 
    public String installmentAmt; 
    public String suitFiledAmt; 
    public String lastRepaid; 
    public String writtenOFF; 
    public String settled; 
    public String naorc; 
    public String contractsClassifiedAsNPA; 
    public String notionalAmountOfContracts; 
  }
  public class GuarantorDetails {
    public String name; 
    public String relatedType; 
    public String dateOfBirth; 
    public String gender; 
    public String dateOfIncorporation; 
    public String businessCategory; 
    public String businessIndustryType; 
    public String message; 
  }
  public class ChequeDishounouredDuetoInsufficientFunds {
    public String message; 
    public String CD3monthcount; 
    public String CD4to6monthcount; 
    public String CD7to9monthcount; 
    public String CD10to12monthcount; 
  }
  public class BorrwerAddressContactDetails {
    public String address; 
    public String telephoneNumber; 
    public String faxNumber; 
    public String mobileNumber; 
  }
  public class EnquirySummarySec {
    public String message; 
    public EnquiryYourInstitution enquiryYourInstitution; 
    public EnquiryYourInstitution enquiryOutsideInstitution; 
    public EnquiryYourInstitution enquiryTotal; 
  }
  public class BorrwerIDDetails_Z {
    public String pan; 
    public String din; 
    public String voterID; 
    public String passportNumber; 
    public String drivingLicenseNo; 
    public String uid; 
    public String registrationNumber; 
    public String cin; 
    public String tin; 
    public String serviceTaxNumber; 
    public String rationCard; 
  }
  public class BorrwerInfo {
    public BorrwerDetails borrwerDetails; 
    public BorrwerAddressContactDetailsVec borrwerAddressContactDetailsVec; 
    public BorrwerIDDetailsVec borrwerIDDetailsVec; 
  }
  public class ResponseReport {
    public List<ReportIssuesVec> reportIssuesVec; 
    public ReportHeaderRec reportHeaderRec; 
    public EnquiryInformationRec enquiryInformationRec; 
    public ProductSec productSec; 
  }
  public class BorrwerIDDetails {
    public String cin; 
    public String pan; 
    public String tin; 
    public String registrationNumber; 
    public String serviceTaxNumber; 
  }
  public class STDVec {
    public DPD0 DPD0; 
    public DPD0 DPD1to30; 
    public DPD0 DPD31to60; 
    public DPD0 DPD61to90; 
  }
  public class ClassOfActivityVec {
    public List<String> classOfActivity; 
  }
  public class GuarantorIDDetails {
    public String pan; 
    public String registrationNumber; 
    public String cin; 
    public String tin; 
    public String serviceTaxNumber; 
    public String din; 
    public String voterID; 
    public String passportNumber; 
    public String uid; 
    public String drivingLicenseNumber; 
    public String rationCard; 
    public String otherID; 
  }
  public class Total {
    public String totalLenders; 
    public String totalCF; 
    public String openCF; 
    public String totalOutstanding; 
    public String latestCFOpenedDate; 
    public String delinquentCF; 
    public String delinquentOutstanding; 
  }
  public class DerogatoryInformationSec {
    public String message; 
    public String messageOfBorrower; 
    public String messageOfBorrowerYourInstitution; 
    public String messageOfBorrowerOutsideInstitution; 
    public String messageOfRelatedParties; 
    public String messageOfRelatedPartiesYourInstitution; 
    public String messageOfRelatedPartiesOutsideInstitution; 
    public String messageOfGuarantedParties; 
    public DerogatoryInformationBorrower derogatoryInformationBorrower; 
    public DerogatoryInformationBorrower derogatoryInformationOnRelatedPartiesOrGuarantorsOfBorrowerSec; 
    public DerogatoryInformationReportedOnGuarantedPartiesVec derogatoryInformationReportedOnGuarantedPartiesVec; 
  }
  
  public class CreditFacilityOverdueDetailsVec {
    public String message; 
    public CreditFacilityOverdueDetails creditFacilityOverdueDetails; 
  }
  public class GuarantorDetailsBorrwerIDDetailsVec {
    public String lastReportedDate; 
    public List<GuarantorIDDetails> guarantorIDDetails; 
  }
  public class CFHistoryforACOrDPDupto24Months {
    public String month; 
    public String ACorDPD; 
    public String OSAmount; 
  }
  public static CommercialPRResponse parse(String json) {
    return (CommercialPRResponse) System.JSON.deserialize(json, CommercialPRResponse.class);
  }
}