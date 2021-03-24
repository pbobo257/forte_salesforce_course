public class DataFactory {
    public static List<Job_Position__c> generateJobPositions(integer numberOfPositions, Contact hr, Date positionDate, String practiceUnit, String Location) {
        List<Job_Position__c> positions = new List<Job_Position__c>();
        
        for(integer i = 0; i < numberOfPositions; i++){
            positions.add(new Job_Position__c(Name='pos'+i, Practice_Unit__c=practiceUnit, HR_Manager__c=hr.Id, Position_Budget__c=100,
            Open_Due_Date__c=positionDate, Location__c=Location));
        }

        return positions;
    }

    public static List<Job_Candidate__c> generateJobCandidates(integer numberOfCandidates, Boolean isVisaHolder, Date visaFrom,Date visaTo){
        List<Job_Candidate__c> candidates = new List<Job_Candidate__c>();

        for(integer i = 0;i<numberOfCandidates;i++){
            candidates.add (new Job_Candidate__c(Name='cand'+i, Email__c='test@mail.com', Phone_Number__c='123456789', Years_in_IT__c=10, 
            USA_visa_holder__c=isVisaHolder, USA_visa_valid_From__c=visaFrom, USA_visa_valid_to__c=visaTo));
        }
        return candidates;
    }

    public static List<Job_Application__c> generateJobApplications(integer numberOfApplications, Job_Position__c position, Job_Candidate__c candidate){
        List<Job_Application__c> applications = new List<Job_Application__c>();

        for(integer i=0;i<numberOfApplications;i++){
            applications.add(new Job_Application__c(Job_Candidate__c=candidate.Id, Job_Position__c=position.Id));
        }

        return applications;
    }
}
