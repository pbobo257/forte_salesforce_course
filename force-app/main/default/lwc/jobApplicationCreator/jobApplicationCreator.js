import { api, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import JOB_APPLICATION_OBJECT from '@salesforce/schema/Job_Application__c';


export default class JobApplicationCreator extends LightningElement {
    @api positionid;
    objectApiName = JOB_APPLICATION_OBJECT;
    
    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Application created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
        this.dispatchEvent(new CustomEvent('created'));
    }

    handleCancel(){
        this.dispatchEvent(new CustomEvent('created'));
    }
}