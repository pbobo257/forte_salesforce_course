@isTest
public class JobPositionTriggerTest {
    @TestSetup
    static void makeData(){
        Contact hr = new Contact(LastName='hr contact');
        insert hr;
        Date positionDate = Date.today();
        List<Job_Position__c> positions = DataFactory.generateJobPositions(100, hr, positionDate, Constants.PRACTICE_UNIT_SALESFORCE, Constants.JOB_POSITION_LOCATION_Ukraine);
        positions.addAll(DataFactory.generateJobPositions(100, hr, positionDate, Constants.PRACTICE_UNIT_JAVA, Constants.JOB_POSITION_LOCATION_Ukraine));
        insert positions;
    }

    @isTest
    static void formatSalesforcePositionTitlePositiveTest(){

        Contact hr = [SELECT Id FROM Contact LIMIT 1];
        Date positionDate =  Date.today();
        Test.startTest();
        List<Job_Position__c> positions = DataFactory.generateJobPositions(200, hr, positionDate, Constants.PRACTICE_UNIT_SALESFORCE, Constants.JOB_POSITION_LOCATION_Ukraine);
        insert positions;
        Test.stopTest();
        List<Job_Position__c> insertedPositions = [SELECT Id,Name FROM Job_Position__c WHERE Practice_Unit__c = :Constants.PRACTICE_UNIT_SALESFORCE];
        for(Job_Position__c pos : insertedPositions){
            System.assert(pos.Name.startsWith(Constants.SALESFORCE_TITLE_PREFIX));
        }
    }

    @isTest
    static void formatSalesforcePositionTitleNegativeTest(){
        Contact hr = [SELECT Id FROM Contact LIMIT 1];
        Date positionDate =  Date.today();
        Test.startTest();
        List<Job_Position__c> positions = DataFactory.generateJobPositions(200, hr, positionDate, Constants.PRACTICE_UNIT_JAVA, Constants.JOB_POSITION_LOCATION_Ukraine);
        insert positions;
        Test.stopTest();
        List<Job_Position__c> insertedPositions = [SELECT Id,Name FROM Job_Position__c WHERE Practice_Unit__c != :Constants.PRACTICE_UNIT_SALESFORCE];
        for(Job_Position__c pos : insertedPositions){
            System.assert(!pos.Name.startsWith(Constants.SALESFORCE_TITLE_PREFIX));
        }
    }
    
    
    @IsTest
    static void reviewHighValueJobPosition(){
        List<Job_Position__c> positions = [SELECT Id,Name,Position_Budget__c FROM Job_Position__c];
        User user = [SELECT Id FROM User WHERE Profile.Name = :Constants.SYSTEM_ADMINISTRATOR_PROFILE_NAME];
        Test.startTest();
        System.runAs(user){
            for(Job_Position__c pos : positions){
                pos.Position_Budget__c = 10000;
            }
            update positions;
        }
        Test.stopTest();

        List<Task> createdTasks = [SELECT Id,Subject,WhatId FROM Task WHERE WhatId IN :positions];
        for(Integer i = 0; i < positions.size(); i++){
            System.assertEquals(Constants.REVIEW_TASK_SUBJECT + positions[i].Name, createdTasks[i].Subject);
            System.assertEquals(positions[i].Id, createdTasks[i].WhatId);
        }
        
    }
}
