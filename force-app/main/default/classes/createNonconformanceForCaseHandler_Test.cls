@isTest
public class createNonconformanceForCaseHandler_Test {
    @testSetup
    static void setup() {
        Case c = new Case();
        c.Status = 'New';
        c.Origin = 'Phone';
        c.Type = 'Problem';
        insert c;
    }
  
    static testMethod void checkConformanceRecordIsCreatedOrNot(){
        Case caseRec = [select Id,SQX_NC_Reference__c from Case where Type = 'Problem' Limit 1];
        SQX_Nonconformance__c nonConformanceRecord = [Select Id From SQX_Nonconformance__c Limit 1];
        system.Assert(caseRec.SQX_NC_Reference__c != null,'Record should be created');
        system.Assert(nonConformanceRecord != null,'Record should be created');
        system.Assert(caseRec.SQX_NC_Reference__c == nonConformanceRecord.Id,'Record should be created');
    }
}