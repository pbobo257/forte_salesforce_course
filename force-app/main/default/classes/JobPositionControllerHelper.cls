public class JobPositionControllerHelper {

    public static List<Job_Position__c> getPositionsByPracticeUnit(String practiceUnit){
        List<Job_Position__c> positions;
        if(String.isBlank(practiceUnit)){
            positions = [
                SELECT Id, Name, Position_Budget__c, Open_Due_Date__c, Practice_Unit__c
                FROM Job_Position__c
                WHERE Open_Due_Date__c>=:Date.today()
                WITH SECURITY_ENFORCED
                ORDER BY Priority__c
            ];
        }
        else{
            positions = [
                SELECT Id, Name, Position_Budget__c, Open_Due_Date__c, Practice_Unit__c
                FROM Job_Position__c
                WHERE Open_Due_Date__c >= :Date.today() AND Practice_Unit__c = :practiceUnit
                WITH SECURITY_ENFORCED
                ORDER BY Priority__c
            ];
        }
        return positions;
    }
}
