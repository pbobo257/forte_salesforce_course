import { LightningElement } from 'lwc';

export default class CandidateApplications extends LightningElement {
    positionId;

    handleSelectId(event){
        this.positionId = event.detail;
    }
}