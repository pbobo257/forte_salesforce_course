public class JobPositionHelper {

    public static final String REVIEW_MAIL_CONTENT = 'Please review this high budget application ';

    //For each new Job Position where Practice Unit is Salesforce format Position Title field like this  “SF - ” + <value from field>
    public static void formatSalesforcePositionTitle(List<Job_Position__c> createdPositions){

        for(Job_Position__c jobPosition : createdPositions){
            if(jobPosition.Practice_Unit__c == Constants.PRACTICE_UNIT_SALESFORCE){
                jobPosition.Name = Constants.SALESFORCE_TITLE_PREFIX + jobPosition.Name;
            }
        }
    }

    //When position budget is changed and it is more than 5000, create a task for HR to review Job Position with Task Subject “Review high budget application ” + <Application Name>. 
    //Assign Task to HR Manager User. Send an email to HR Manager with the text “Please review this high budget application ” + application name. 
    public static void reviewHighValueJobPosition(Map<Id, Job_Position__c> updatedPositions, Map<Id, Job_Position__c> oldPositions){

        List<Task> reviewTasks = new List<Task>();
        integer valueToNotify = 5000;
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();

        List<Job_Position__c> positions = [SELECT Id,Name,Position_Budget__c,Owner.Email FROM Job_Position__c WHERE Id IN :updatedPositions.values() AND Position_Budget__c >:valueToNotify];

        for(Job_Position__c jobPosition : positions){

            if(oldPositions.get(jobPosition.Id).Position_Budget__c == jobPosition.Position_Budget__c){
                continue;
            }

            reviewTasks.add(new Task(Subject=Constants.REVIEW_TASK_SUBJECT + jobPosition.Name, WhatId=jobPosition.Id, OwnerId=jobPosition.Ownerid));
            System.debug(jobPosition.Name);

            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setToAddresses(new String[]{jobPosition.Owner.Email});
            System.debug(jobPosition.Owner.Email);

            message.setSubject(Constants.REVIEW_TASK_SUBJECT);
            message.setPlainTextBody(REVIEW_MAIL_CONTENT+jobPosition.Name);

            messages.add(message);
        }

        insert reviewTasks;

        if(!Test.isRunningTest())
        Messaging.sendEmail(messages);
    }
}
