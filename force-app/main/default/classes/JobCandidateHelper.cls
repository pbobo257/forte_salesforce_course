public class JobCandidateHelper {
    public static final String INVALID_VISA_TERMS_ERROR_MESSAGE='Please specify your visa date information'; 

    public static void validateVisaTerms(List<Job_Candidate__c> candidates){
        for(Job_Candidate__c candidate: candidates){
            if(candidate.USA_visa_valid_From__c==null || candidate.USA_visa_valid_to__c==null){
                candidate.addError(INVALID_VISA_TERMS_ERROR_MESSAGE);
            }
        }
    }

    public static void markRecoveredRecords(Map<Id, Job_Candidate__c> recoveredCandidates){
        List<Job_Candidate__c> candidatesToUpdate = new List<Job_Candidate__c>();
        for(Job_Candidate__c candidate : [select Id, Recovered__c from Job_Candidate__c where Id=:recoveredCandidates.keyset()]){
            candidate.Recovered__c=true;
            candidatesToUpdate.add(candidate);
        }
        update candidatesToUpdate;
    }
}
