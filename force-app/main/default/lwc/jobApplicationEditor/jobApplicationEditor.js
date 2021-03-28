import { api, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import JOB_APPLICATION_OBJECT from '@salesforce/schema/Job_Application__c';

export default class JobApplicationEditor extends LightningElement {
    @api applicationid;
    objectApiName = JOB_APPLICATION_OBJECT;

    handleSuccess(event){
        const toastEvent = new ShowToastEvent({
            title: "Application edited",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
        this.dispatchEvent(new CustomEvent('edited'));
    }
    handleCancel(){
        this.dispatchEvent(new CustomEvent('edited'));
    }
}