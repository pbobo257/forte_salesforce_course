@isTest
public class JobCandidateTriggerTest {
    @TestSetup
    static void makeData(){
        List<Job_Candidate__c> candidates = DataFactory.generateJobCandidates(200,false,null,null);
        insert candidates;
    }
    
    @IsTest
    static void validateVisaTermsBeforeInsert(){
        List<Job_Candidate__c> candidates = DataFactory.generateJobCandidates(200,true,null,null);
        Test.startTest();
        Database.SaveResult[] results =  Database.insert(candidates,false);
        Test.stopTest();

        for(Database.SaveResult result:results){
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size()>0);
            System.assertEquals(Constants.INVALID_VISA_TERMS_ERROR_MESSAGE, result.getErrors()[0].getMessage());
        }
    }

    @IsTest
    static void validateVisaTermsBeforeUpdate(){
        List<Job_Candidate__c> candidates = [SELECT Id,USA_visa_holder__c FROM Job_Candidate__c];
        Test.startTest();
        for(Job_Candidate__c candidate : candidates){
            candidate.USA_visa_holder__c=true;
        }
        Database.SaveResult[] results =  Database.update(candidates,false);
        Test.stopTest();

        for(Database.SaveResult result:results){
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size()>0);
            System.assertEquals(Constants.INVALID_VISA_TERMS_ERROR_MESSAGE, result.getErrors()[0].getMessage());
        }
    }

    @IsTest
    static void markRecoveredCandidatesTest(){
        List<Job_Candidate__c> candidates = [SELECT Id FROM Job_Candidate__c];
        delete candidates;
        Test.startTest();
        undelete candidates;
        Test.stopTest();

        List<Job_Candidate__c> recoveredCandidates = [SELECT Id,Recovered__c FROM Job_Candidate__c];
        for(Job_Candidate__c candidate : recoveredCandidates){
            System.assert(candidate.Recovered__c);
        }
    }
}
