trigger JobCandidateTrigger on Job_Candidate__c (before insert, before update) {

    if(Trigger.isBefore){
        if(Trigger.isInsert){

        }
        if(Trigger.isUpdate){
            
        }
    }

}