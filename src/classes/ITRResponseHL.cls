public class ITRResponseHL{
    public cls_itrvDetails[] itrvDetails;
    public cls_itrDetails itrDetails;
    public class cls_itrvDetails {
        public String acknowledgementNumber;    //318761760291117
        public String assessmentYear;   //2017-18
        public String dateOfSubmission; //2017-11-29
        public String designationOfAO;  //WARD 7(2)(3)
        public String financialYear;    //2016-17
        public String formNumber;   //ITR-2
        public cls_incomeDetail incomeDetail;
        public String originalOrRevised;    //ORIGINAL
        //public cls_personalInfo personalInfo;
    }
    public class cls_incomeDetail {
        public String currentYearLoss;  //0
        public String deductionsUnderChapter6A; //175000
        public cls_exemptIncome exemptIncome;
        public String grossTotalIncome; //577102
        public String interestPayable;  //2706
        public String netTaxPayable;    //26183
        public String refund;   //0
        public String taxPayable;   //0
        public cls_taxesPaid taxesPaid;
        public String totalIncome;  //402100
        public String totalTaxAndInterestPayable;   //28889
    }
    public class cls_exemptIncome {
        public String agriculture;  //425000
        public String others;   //0
    }
    public class cls_taxesPaid {
        public String advanceTax;   //0
        public String selfAssessmentTax;    //18670
        public String tcs;  //0
        public String tds;  //10220
        public String totalTaxPaid; //28890
    }
    public class cls_personalInfo {
        public cls_address address;
        public cls_assesseeName assesseeName;
        public String dob;  //1988-12-25
        public String employerCategory; //OTH
        public String gender;   //F
        public String pan;  //ABCDE5699Q
        public String status;   //I
    }
    public class cls_itrDetails {
        public cls_itr2[] itr2;
        public cls_itr1[] itr1;
        //added 2018-05-07
        public cls_itr3[] itr3;
        public cls_itr4[] itr4;
    }
    public class cls_itr3 {
        public String ay;   //2017-18
        public String fy;   //2016-17
        public cls_partBTI partBTI;
        //public cls_personalInfo personalInfo;
        public cls_scheduleOS scheduleOS;
        public cls_itr3ScheduleBP itr3ScheduleBP;
        public String type; //ITR3
    }
    public class cls_itr3ScheduleBP{
        public cls_BusinessIncOthThanSpec businessIncOthThanSpec;
        public cls_SpecBusinessInc specBusinessInc;
        public cls_SpecifiedBusinessInc specifiedBusinessInc;
        public Integer incChrgUnHdProftGain;
        public cls_BusSetoffCurrYr busSetoffCurrYr;
    }

    public class cls_BusinessIncOthThanSpec {
        public Integer profBfrTaxPL;
        public Integer netPLFromSpecBus;
        public Integer netPLFromSpecifiedBus;
        public cls_IncRecCredPLOthHeadDtls incRecCredPLOthHeadDtls;
        public Integer plUs44SChapXIIG;
        public cls_IncCredPL incCredPL;
        public Integer balancePLOthThanSpecBus;
        public cls_IncRecCredPLOthHeadDtls expDebToPLOthHeadDtls;
        public Integer expDebToPLExemptInc;
        public Integer totExpDebPL;
        public Integer adjustedPLOthThanSpecBus;
        public Integer depreciationDebPLCosAct;
        public cls_DepreciationAllowITAct32 depreciationAllowITAct32;
        public Integer adjustPLAfterDeprOthSpecInc;
        public Integer amtDebPLDisallowUs36;
        public Integer amtDebPLDisallowUs37;
        public Integer amtDebPLDisallowUs40;
        public Integer amtDebPLDisallowUs40A;
        public Integer amtDebPLDisallowUs43B;
        public Integer interestDisAllowUs23SMEAct;
        public Integer deemIncUs41;
        public Integer deemIncUs3380HHD80IA;
        public Integer deemIncUs32AD;
        public Integer deemIncUs33AB;
        public Integer deemIncUs33ABA;
        public Integer deemIncUs35ABB;
        public Integer deemIncUs40A3A;
        public Integer deemIncUs72A;
        public Integer deemIncUs80HHD;
        public Integer deemIncUs80IA;
        public Integer deemIncUs43CA;
        public Integer othItemDisallowUs28To44DA;
        public Integer anyOthIncNotInclInExpDisallowPL;
        public Integer totAfterAddToPLDeprOthSpecInc;
        public Integer deductUs321Iii;
        public Integer deductUs32AD;
        public Integer debPLUs35ExcessAmt;
        public Integer amtDisallUs40NowAllow;
        public Integer amtDisallUs43BNowAllow;
        public cls_DeductUs35AC deductUs35AC;
        public Integer anyOthAmtAllDeduct;
        public Integer totDeductionAmts;
        public Integer plAftAdjDedBusOthThanSpec;
        public cls_DeemedProfitBusUs deemedProfitBusUs;
        public Integer netPLAftAdjBusOthThanSpec;
        public Integer netPLBusOthThanSpec7A7B7C;
    }
    public class cls_IncRecCredPLOthHeadDtls {
        public Integer salary;
        public Integer houseProperty;
        public Integer capitalGains;
        public Integer otherSources;
        public Integer us115BBF;
    }
    public class cls_IncCredPL {
        public Integer firmShareInc;
        public Integer aopboiSharInc;
        public Integer othExempInc;
        public Integer totExempIncPL;
    }
    public class cls_DepreciationAllowITAct32 {
        public Integer depreciationAllowUs321Ii;
        public Integer depreciationAllowUs321I;
        public Integer totDeprAllowITAct;
    }
    public class cls_DeductUs35AC {
        public Integer debPL35ACAmt;
        public Integer amtAllowUs35ACt;
        public Integer excessAmtDeduct35AC;
    }
    public class cls_DeemedProfitBusUs {
        public Integer section44AD;
        public Integer section44ADA;
        public Integer section44AE;
        public Integer section44B;
        public Integer section44BB;
        public Integer section44BBA;
        public Integer section44BBB;
        public Integer section44D;
        public Integer section44DA;
        public Integer firstSchTAct;
        public Integer totDeemedProfitBusUs;
    }
    public class cls_SpecBusinessInc {
        public Integer netPLFrmSpecBus;
        public Integer additionUs28To44DA;
        public Integer deductUs28To44DA;
        public Integer adjustedPLFrmSpecuBus;
    }
    public class cls_SpecifiedBusinessInc {
        public Integer netPLFrmSpecifiedBus;
        public Integer addSec28To44DA;
        public Double dedSec28To44DAOTDedSec35AD;
        public Integer profitLossSpecifiedBusiness;
        public Integer deductionUs35AD;
        public Integer dedSec35AD1;
        public Integer dedSec35AD1A;
        public Integer plFrmSpecifiedBus;
    }
    public class cls_BusSetoffCurrYr {
        public Integer lossSetOffOnBusLoss;
        public cls_SpeculativeInc speculativeInc;
        public cls_SpeculativeInc specifiedInc;
        public Integer totLossSetOffOnBus;
        public Integer lossRemainSetOffOnBus;
    }
    public class cls_SpeculativeInc {
        public Integer incOfCurYrUnderThatHead;
        public Integer busLossSetoff;
        public Integer incOfCurYrAfterSetOff;
    }
    public class cls_itr4 {
        public String ay;   //2017-18
        public String fy;   //2016-17
        public cls_partBTI partBTI;
        //public cls_personalInfo personalInfo;
        public cls_scheduleOS scheduleOS;
        public cls_itr4ScheduleBP itr4ScheduleBP;
        public String type; //ITR4
    }
    public class cls_itr4ScheduleBP{
        public cls_BusinessIncOthThanSpec businessIncOthThanSpec;
        public cls_SpecBusinessInc specBusinessInc;
        public cls_SpecifiedBusinessInc specifiedBusinessInc;
        public Integer incChrgUnHdProftGain;
        public cls_BusSetoffCurrYr busSetoffCurrYr;

    }
    public class cls_itr2 {
        public String ay;   //2017-18
        public String fy;   //2016-17
        public cls_partBTI partBTI;
        //public cls_personalInfo personalInfo;
        public cls_scheduleOS scheduleOS;
        public String type; //ITR2
    }
    public class cls_partBTI {
        public Integer aggregateIncome; //827100
        public Integer balanceAfterSetoffLosses;    //577102
        public Integer broughtFwdLossesSetoff;  //0
        public cls_capGain capGain;
        public Integer currentYearLoss; //0
        public Integer deductionsUnderScheduleVIA;  //175000
        public Integer grossTotalIncome;    //577102
        public Integer incChargeTaxSplRate111A112;  //0
        public Integer incChargeableTaxSplRates;    //0
        public cls_incFromOS incFromOS;
        public Integer incomeFromHP;    //0
        public Integer lossesOfCurrentYearCarriedFwd;   //0
        public Integer netAgricultureIncomeOrOtherIncomeForRate;    //425000
        public cls_profBusGain profBusGain;
        public Integer salaries;    //562600
        public Integer totalIncome; //402100
        public Integer totalTI; //577102
    }
    public class cls_capGain {
        public cls_longTerm longTerm;
        public cls_shortTerm shortTerm;
        public Integer totalCapGains;   //0
    }
    public class cls_longTerm {
        public Integer longTerm10Per;   //0
        public Integer longTerm20Per;   //0
        public Integer totalLongTerm;   //0
    }
    public class cls_shortTerm {
        public Integer shortTerm15Per;  //0
        public Integer shortTerm30Per;  //0
        public Integer shortTermAppRate;    //0
        public Integer totalShortTerm;  //0
    }
    public class cls_incFromOS {
        public Integer fromOwnRaceHorse;    //0
        public Integer incChargblSplRate;   //0
        public Integer otherSrcThanOwnRaceHorse;    //14502
        public Integer totIncFromOS;    //14502
    }
    public class cls_profBusGain {
        public Integer totProfBusGain;  //0
    }
    public class cls_address {
        public String cityOrTownOrDistrict; //Bengaluru
        public Integer countryCode; //91
        public String emailAddress; //finance@sst-india.com
        public cls_emailAddressSec emailAddressSec;
        public String localityOrArea;   //Tavarekere Village
        public String mobileNo; //9036090278
        public cls_mobileNoSec mobileNoSec;
        public cls_phone phone;
        public String pinCode;  //560081
        public cls_residenceName residenceName;
        public String residenceNo;  //# 35
        public String roadOrStreet; //1st A Cross
        public Integer stateCode;   //15
    }
    public class cls_residenceName {
    }
    public class cls_assesseeName {
        public String firstName;    //DEF
        public String surNameOrOrgName; //ABC
    }
    public class cls_scheduleOS {
        public Integer incChargeable;   //14502
        public cls_incFromOwnHorse incFromOwnHorse;
        public cls_incOthThanOwnRaceHorse incOthThanOwnRaceHorse;
        public Integer totOthSrcNoRaceHorse;    //14502
    }
    public class cls_incFromOwnHorse {
        public Integer balanceOwnRaceHorse; //0
        public Integer deductSec57; //0
        public Integer receipts;    //0
    }
    public class cls_incOthThanOwnRaceHorse {
        public Integer balanceNoRaceHorse;  //14502
        public cls_deductions deductions;
        public Integer dividendGross;   //0
        public Integer grossAmtChargblNormalRate;   //14502
        public cls_incChargblSplRateOS incChargblSplRateOS;
        public Integer interestGross;   //14502
        public Integer othersGross; //0
        public cls_othersGrossDtls[] othersGrossDtls;
        public Integer rentFromMachPlantBldgs;  //0
        public Integer totalOSGross;    //14502
    }
    public class cls_deductions {
        public Integer depreciation;    //0
        public Integer expenses;    //0
        public Integer totDeductions;   //0
    }
    public class cls_incChargblSplRateOS {
        public Integer dividendIncome115BBDA;   //0
        public Integer dividendIncome115BBE;    //0
        public Integer dividendIncome115BBF;    //0
        public Integer secXIIOth;   //0
        public Integer totalAmtTaxUsDTAASchOs;  //0
        public Integer totalOSGrossChargblSplRate;  //0
        public Integer winningFrmLotteries; //0
    }
    public class cls_othersGrossDtls {
        public cls_otherSourceDesc otherSourceDesc;
        public Integer sourceAmount;    //0
        public String sourceDescription;    //5BB
    }
    public class cls_otherSourceDesc {
    }
    public class cls_itr1 {
        public String ay;   //2016-17
        public cls_filingStatus filingStatus;
        public String fy;   //2015-16
        public cls_itr1IncomeDeductions itr1IncomeDeductions;
        public cls_itr1TaxComputation itr1TaxComputation;
        //public cls_personalInfo personalInfo;
        public cls_refund refund;
        public cls_taxPaid taxPaid;
        public cls_tdSonOthThanSals tdSonOthThanSals;
        public cls_tdSonSalaries tdSonSalaries;
        public String type; //ITR1
    }
    public class cls_filingStatus {
    }
    public class cls_itr1IncomeDeductions {
        public cls_deductUndChapVIA deductUndChapVIA;
        public Integer grossTotIncome;  //564551
        public Integer incomeFromSal;   //562600
        public Integer incomeOthSrc;    //1951
        public Integer totalIncome; //411750
        public Integer totalIncomeOfHP; //0
        public cls_usrDeductUndChapVIA usrDeductUndChapVIA;
    }
    public class cls_deductUndChapVIA {
        public Integer section80C;  //145850
        public Integer section80CCC;    //0
        public Integer section80CCDEmployeeOrSE;    //0
        public Integer section80CCDEmployer;    //0
        public Integer section80CCG;    //0
        public Integer section80D;  //5000
        public Integer section80DD; //0
        public Integer section80DDB;    //0
        public Integer section80E;  //0
        public Integer section80G;  //0
        public Integer section80GG; //0
        public Integer section80GGA;    //0
        public Integer section80GGC;    //0
        public Integer section80IA; //0
        public Integer section80IAB;    //0
        public Integer section80IB; //0
        public Integer section80IC; //0
        public Integer section80ID; //0
        public Integer section80JJA;    //0
        public Integer section80QQB;    //0
        public Integer section80RRB;    //0
        public Integer section80TTA;    //1951
        public Integer section80U;  //0
        public Integer totalChapVIADeductions;  //152801
    }
    public class cls_usrDeductUndChapVIA {
        public Integer section80C;  //145850
        public Integer section80CCC;    //0
        public Integer section80CCDEmployeeOrSE;    //0
        public Integer section80CCDEmployer;    //0
        public Integer section80CCG;    //0
        public Integer section80D;  //5000
        public Integer section80DD; //0
        public Integer section80DDB;    //0
        public Integer section80E;  //0
        public Integer section80G;  //0
        public Integer section80GG; //0
        public Integer section80GGA;    //0
        public Integer section80GGC;    //0
        public Integer section80IA; //0
        public Integer section80IAB;    //0
        public Integer section80IB; //0
        public Integer section80IC; //0
        public Integer section80ID; //0
        public Integer section80JJA;    //0
        public Integer section80QQB;    //0
        public Integer section80RRB;    //0
        public Integer section80TTA;    //1951
        public Integer section80U;  //0
        public Integer totalChapVIADeductions;  //152801
    }
    public class cls_itr1TaxComputation {
    }
    public class cls_emailAddressSec {
    }
    public class cls_mobileNoSec {
    }
    public class cls_phone {
    }
    public class cls_refund {
    }
    public class cls_taxPaid {
    }
    public class cls_tdSonOthThanSals {
    }
    public class cls_tdSonSalaries {
    }
    public static ITRResponseHL parse(String json){
        return (ITRResponseHL) System.JSON.deserialize(json, ITRResponseHL.class);
    }
}