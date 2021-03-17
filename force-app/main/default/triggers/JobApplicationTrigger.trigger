trigger JobApplicationTrigger on Job_Application__c (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            JobApplicationTriggerHandler.onBeforeInsert(Trigger.new);
        }
    }

}