public class JobCandidateTriggerHandler {
    public static void onBeforeInsert(List<Job_Candidate__c> insertedNewList) {
        
        JobCandidateHelper.validateVisaTerms(insertedNewList);
    }
    public static void onBeforeUpdate(Map<Id, Job_Candidate__c> newMap, Map<Id,Job_Candidate__c> oldMap) {

        JobCandidateHelper.validateVisaTerms(newMap.values());
    }

    public static void onAfterUndelete(Map<Id, Job_Candidate__c> undeletedCandidates) {
        
        JobCandidateHelper.markRecoveredRecords(undeletedCandidates);
    }
}
