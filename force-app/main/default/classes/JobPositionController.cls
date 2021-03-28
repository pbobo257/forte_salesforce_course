public with sharing class JobPositionController {

    @AuraEnabled(cacheable=true)
    public static List<Job_Position__c> getPositions(String practiceUnit){
        return JobPositionControllerHelper.getPositionsByPracticeUnit(practiceUnit);
    }
}
