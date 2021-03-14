/**
 * Created by bohdanpovoroznyk on 13/03/21.
 */

public class JobPositionTriggerHandler {
    public static void onBeforeInsert(List<Job_Position__c> insertdNewList) {

        JobPositionHelper.formatSalesforcePositionTitle(insertdNewList);
    }
    public static void onAfterUpdate(Map<Id, Job_Position__c> newMap, Map<Id,Job_Position__c> oldMap) {

        JobPositionHelper.reviewHighValueJobPosition(newMap);
    }

}
