public class JobApplicationHelper {

    public static void validateUSACandidateWorkForYear(List<Job_Application__c> createdJobApplications) {
        List<Id> candidatesIds = new List<Id>();
        List<Id> positionsIds = new List<Id>();
        for(Job_Application__c application: createdJobApplications){
            candidatesIds.add(application.Job_Candidate__c);
            positionsIds.add(application.Job_Position__c);
        }
        
        Map<Id, Job_Candidate__c> candidates = new Map<Id,Job_Candidate__c>([SELECT Id, USA_visa_holder__c, USA_visa_valid_to__c, USA_visa_valid_From__c FROM Job_Candidate__c WHERE Id IN :candidatesIds]);
        Map<Id, Job_Position__c> positions = new Map<Id,Job_Position__c>([SELECT Id,Location__c FROM Job_Position__c WHERE Id IN :positionsIds]);

        for(Job_Application__c application: createdJobApplications){
            Job_Candidate__c candidate = candidates.get(application.Job_Candidate__c);
            if(positions.get(application.Job_Position__c).Location__c==Constants.JOB_POSITION_LOCATION_USA && candidate.USA_visa_holder__c &&
            (System.Today().daysBetween(candidate.USA_visa_valid_to__c)<=365 || candidate.USA_visa_valid_From__c > System.Today())){
                application.addError(Constants.CANDIDATE_VISA_LESS_THAN_YEAR_ERROR_MESSAGE);
            }
        }
    }
}

