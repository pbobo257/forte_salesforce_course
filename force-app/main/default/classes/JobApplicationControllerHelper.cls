public class JobApplicationControllerHelper {
    public static List<Job_Application__c> getApplicationsByPosition(String positionId) {
        if(positionId==null){
            throw new AuraHandledException('Position didn`t selected');
        }
        List<Job_Application__c> applications= [
            SELECT Id, Requested_Salary__c, Job_Candidate__r.Name, Job_Position__c
            FROM Job_Application__c
            WHERE Job_Position__c=:positionId
            WITH SECURITY_ENFORCED
            ORDER BY Requested_Salary__c
        ];
        return applications;
    }
}
