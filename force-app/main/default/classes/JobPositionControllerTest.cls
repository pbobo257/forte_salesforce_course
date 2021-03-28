@isTest
public class JobPositionControllerTest {
    @TestSetup
    static void makeData(){
        Contact hr = new Contact(LastName='hr contact', MailingCountry='USA');
        insert hr;
        Date positionDate = Date.today();
        Job_Position__c[] position = DataFactory.generateJobPositions(200, hr, positionDate, Constants.PRACTICE_UNIT_SALESFORCE, Constants.JOB_POSITION_LOCATION_USA);
        insert position;
    }

    @IsTest
    static void getPositionsByPracticeUnitTest(){
        List<Job_Position__c> positions = new List<Job_Position__c>();
        Test.startTest();
        positions = JobPositionController.getPositions(Constants.PRACTICE_UNIT_SALESFORCE);
        Test.stopTest();

        for(Integer i = 0; i < positions.size(); i++){
            System.assertEquals(Constants.PRACTICE_UNIT_SALESFORCE, positions[i].Practice_Unit__c);
        }
    }

    @IsTest
    static void getPositionsWithBlankPracticeUnitTest(){
        List<Job_Position__c> positions = new List<Job_Position__c>();
        Test.startTest();
        positions = JobPositionController.getPositions('');
        Test.stopTest();

        for(Integer i = 0; i < positions.size(); i++){
            System.assertEquals(Constants.PRACTICE_UNIT_SALESFORCE, positions[i].Practice_Unit__c);
        }
    }
}
