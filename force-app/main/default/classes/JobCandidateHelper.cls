public class JobCandidateHelper {

    public static void validateVisaTerms(List<Job_Candidate__c> candidates){
        for(Job_Candidate__c candidate: candidates){
            if(candidate.USA_visa_holder__c && (candidate.USA_visa_valid_From__c==null || candidate.USA_visa_valid_to__c==null)){
                candidate.addError(Constants.INVALID_VISA_TERMS_ERROR_MESSAGE);
            }
        }
    }

    public static void markRecoveredCandidates(Map<Id, Job_Candidate__c> recoveredCandidates){
        List<Job_Candidate__c> candidatesToUpdate = new List<Job_Candidate__c>();
        
        List<Job_Candidate__c> candidates = [SELECT Id, Recovered__c FROM Job_Candidate__c WHERE Id IN :recoveredCandidates.keyset()];

        for(Job_Candidate__c candidate : candidates){
            candidate.Recovered__c = true;
            candidatesToUpdate.add(candidate);
        }
        update candidatesToUpdate;
    }
}
