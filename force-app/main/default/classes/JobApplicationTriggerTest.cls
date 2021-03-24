@isTest
public class JobApplicationTriggerTest {
    @TestSetup
    static void makeData(){
        Contact hr = new Contact(LastName='hr contact', MailingCountry='USA');
        insert hr;
        Date positionDate = Date.today();
        Job_Position__c[] application = DataFactory.generateJobPositions(1, hr, positionDate, Constants.PRACTICE_UNIT_SALESFORCE, Constants.JOB_POSITION_LOCATION_USA);
        Job_Candidate__c[] candidate = DataFactory.generateJobCandidates(1, true, positionDate, positionDate.addYears(1));
        insert application;
        insert candidate;
    }

    @IsTest
    static void validateUSACandidateWorkForYearTest(){
        Job_Position__c position = [SELECT Id FROM Job_Position__c WHERE Location__c=:Constants.JOB_POSITION_LOCATION_USA LIMIT 1];
        Job_Candidate__c candidate = [SELECT Id FROM Job_Candidate__c WHERE USA_visa_holder__c=true LIMIT 1];
        List<Job_Application__c> applications = DataFactory.generateJobApplications(200, position, candidate);
        Test.startTest();
        Database.SaveResult[] results = Database.insert(applications, false);
        Test.stopTest();

        for(Database.SaveResult result : results){
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size()>0);
            System.assertEquals(Constants.CANDIDATE_VISA_LESS_THAN_YEAR_ERROR_MESSAGE, result.getErrors()[0].getMessage());
        }
        
    }
}
