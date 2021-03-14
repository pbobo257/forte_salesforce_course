/**
 * Created by bohdanpovoroznyk on 13/03/21.
 */

trigger JobPositionTrigger on Job_Position__c (after insert,after update,after delete,
                                            after undelete,before update,before delete,before insert) {

    
    if(Trigger.isBefore){
        if(Trigger.isInsert){                
            JobPositionTriggerHandler.onBeforeInsert(Trigger.new);                
        }
        if(Trigger.isUpdate){                
            //JobPositionTriggerHandler.onBeforeUpdate();                
        }
        if(Trigger.isDelete){                
            //JobPositionTriggerHandler.onBeforeDelete();                
        }
    }
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            //JobPositionTriggerHandler.onAfterInsert(Trigger.newMap);                
        }
        if(Trigger.isUpdate){
            JobPositionTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);                
        }
        if(Trigger.isDelete){
            //JobPositionTriggerHandler.onAfterDelete();                
        }
        if(Trigger.isUndelete){
            //JobPositionTriggerHandler.onAfterUnDelete();                
        }
    }
}