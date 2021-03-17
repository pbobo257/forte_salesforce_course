trigger JobCandidateTrigger on Job_Candidate__c (before insert, before update, after undelete) {

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            JobCandidateTriggerHandler.onBeforeInsert(Trigger.new);
        }
        if(Trigger.isUpdate){
            JobCandidateTriggerHandler.onBeforeUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isUndelete){
            JobCandidateTriggerHandler.onAfterUndelete(Trigger.newMap);
        }
    }

}