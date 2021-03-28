@isTest
public class JobApplicationControllerTest {
    @TestSetup
    static void makeData() {
        Contact hr = new Contact(LastName='hr contact', MailingCountry='USA');
        insert hr;
        Date positionDate = Date.today();
        Job_Position__c[] position = DataFactory.generateJobPositions(1, hr, positionDate, Constants.PRACTICE_UNIT_SALESFORCE, Constants.JOB_POSITION_LOCATION_Ukraine);
        Job_Candidate__c[] candidate = DataFactory.generateJobCandidates(1, true, positionDate, positionDate.addYears(1));
        insert position;
        insert candidate;
        List<Job_Application__c> applications = DataFactory.generateJobApplications(200, position[0], candidate[0]);
        insert applications;
    }

    @IsTest
    static void getApplicationByPositionIdTest(){
        Job_Position__c position = [SELECT Id FROM Job_Position__c LIMIT 1];
        List<Job_Application__c> applications;
        Test.startTest();
        applications = JobApplicationController.getApplications(position.Id);
        Test.stopTest();

        for(Integer i = 0; i < applications.size(); i++){
            System.assertEquals(position.Id, applications[i].Job_Position__c);
        }
    }
}
