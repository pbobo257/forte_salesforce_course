public class JobApplicationTriggerHandler {
    public static void onBeforeInsert(List<Job_Application__c> newList) {
        JobApplicationHelper.validateUSACandidateWorkForYear(newList);
    }
}
