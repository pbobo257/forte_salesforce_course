@isTest
public class JobPositionTriggerTest {
    @TestSetup
    static void makeData(){
        Contact hr = new Contact(LastName='hr contact');
        insert hr;
        Date positionDate = Date.newInstance(2021, 03, 25);
        List<Job_Position__c> positions = DataFactory.generateJobPositions(100,hr,positionDate,Constants.PRACTICE_UNIT_SALESFORCE,Constants.JOB_POSITION_LOCATION_Ukraine);
        positions.addAll(DataFactory.generateJobPositions(100,hr,positionDate,Constants.PRACTICE_UNIT_JAVA,Constants.JOB_POSITION_LOCATION_Ukraine));
        insert positions;
    }

    @isTest
    static void formatSalesforcePositionTitlePositiveTest(){
        Contact hr = [select Id from Contact limit 1];
        Date positionDate = Date.newInstance(2021, 03, 25);
        Test.startTest();
        List<Job_Position__c> positions = DataFactory.generateJobPositions(200,hr,positionDate,Constants.PRACTICE_UNIT_SALESFORCE,Constants.JOB_POSITION_LOCATION_Ukraine);
        insert positions;
        Test.stopTest();
        List<Job_Position__c> insertedPositions = [select Id,Name from Job_Position__c where Practice_Unit__c=:Constants.PRACTICE_UNIT_SALESFORCE];
        for(Job_Position__c pos : insertedPositions){
            System.assert(pos.Name.startsWith(Constants.SALESFORCE_TITLE_PREFIX));
        }
    }

    @isTest
    static void formatSalesforcePositionTitleNegativeTest(){
        Contact hr = [select Id from Contact limit 1];
        Date positionDate = Date.newInstance(2021, 03, 25);
        Test.startTest();
        List<Job_Position__c> positions = DataFactory.generateJobPositions(200,hr,positionDate,Constants.PRACTICE_UNIT_JAVA,Constants.JOB_POSITION_LOCATION_Ukraine);
        insert positions;
        Test.stopTest();
        List<Job_Position__c> insertedPositions = [select Id,Name from Job_Position__c where Practice_Unit__c!=:Constants.PRACTICE_UNIT_SALESFORCE];
        for(Job_Position__c pos : insertedPositions){
            System.assert(!pos.Name.startsWith(Constants.SALESFORCE_TITLE_PREFIX));
        }
    }
    
    
    @IsTest
    static void reviewHighValueJobPosition(){
        List<Job_Position__c> positions = [select Id,Name,Position_Budget__c from Job_Position__c];
        User user = [Select Id from User where Profile.Name=:Constants.SYSTEM_ADMINISTRATOR_PROFILE_NAME];
        Test.startTest();
        System.runAs(user){
            for(Job_Position__c pos : positions){
                pos.Position_Budget__c = 10000;
            }
            update positions;
        }
        Test.stopTest();

        List<Task> createdTasks = [select Id,Subject,WhatId from Task where WhatId in :positions];
        for(Integer i = 0;i<positions.size();i++){
            System.assertEquals(Constants.REVIEW_TASK_SUBJECT+positions[i].Name, createdTasks[i].Subject);
            System.assertEquals(positions[i].Id, createdTasks[i].WhatId);
        }
        
    }
}
