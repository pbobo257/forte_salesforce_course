public class JobPositionHelper {
    public static final String PRACTICE_UNIT_SALESFORCE = 'Salesforce';
    public static final String SALESFORCE_TITLE_PREFIX = 'SF - ';
    public static final String REVIEW_TASK_SUBJECT = 'Review high budget application ';
    public static final String REVIEW_MAIL_CONTENT = 'Please review this high budget application ';

    //For each new Job Position where Practice Unit is Salesforce format Position Title field like this  “SF - ” + <value from field>
    public static void formatSalesforcePositionTitle(List<Job_Position__c> createdPositions){
        for(Job_Position__c jobPosition : createdPositions){
            if(jobPosition.Practice_Unit__c == PRACTICE_UNIT_SALESFORCE){
                jobPosition.Name = SALESFORCE_TITLE_PREFIX+jobPosition.Name;
            }
        }
    }

    //When position budged is changed and it is more than 5000, create a task for HR to review Job Position with Task Subject “Review high budget application ” + <Application Name>. 
    //Assign Task to HR Manager User. Send an email to HR Manager with the text “Please review this high budget application ” + application name. 
    public static void reviewHighValueJobPosition(Map<Id,Job_Position__c> updatedPositions, Map<Id,Job_Position__c> oldPositions){
        List<Task> reviewTasks = new List<Task>();
        integer valueToNotify = 5000;
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();

        for(Job_Position__c jobPosition :[select Id,Name,Position_Budget__c,Owner.Email from Job_Position__c where Id in :updatedPositions.values() and Position_Budget__c >:valueToNotify]){
            if(oldPositions.get(jobPosition.Id).Position_Budget__c == jobPosition.Position_Budget__c){
                continue;
            }
            reviewTasks.add(new Task(Subject=REVIEW_TASK_SUBJECT+jobPosition.Name, WhatId=jobPosition.Id, OwnerId=jobPosition.Ownerid));
            System.debug(jobPosition.Name);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setToAddresses(new String[]{jobPosition.Owner.Email});
            System.debug(jobPosition.Owner.Email);
            message.setSubject(REVIEW_TASK_SUBJECT);
            message.setPlainTextBody(REVIEW_MAIL_CONTENT+jobPosition.Name);

            messages.add(message);
        }

        insert reviewTasks;
        Messaging.sendEmail(messages);
    }
}
