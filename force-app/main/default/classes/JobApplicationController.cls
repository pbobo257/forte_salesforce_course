public with sharing class JobApplicationController {

    @AuraEnabled(cacheable=true)
    public static List<Job_Application__c> getApplications(String positionId) {
        return JobApplicationControllerHelper.getApplicationsByPosition(positionId);
    }
}
