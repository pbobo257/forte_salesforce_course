import { LightningElement, wire } from 'lwc';
import { reduceErrors } from 'c/ldsUtils';
//import { publish, MessageContext } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Job_Position__c.Name';
import POSITION_BUDGET_FIELD from '@salesforce/schema/Job_Position__c.Position_Budget__c';
import OPEN_DUE_DATE_FIELD from '@salesforce/schema/Job_Position__c.Open_Due_Date__c';
import getPositions from '@salesforce/apex/JobPositionController.getPositions';

const COLUMNS = [
    { label: 'Title', fieldName: NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Budget', fieldName: POSITION_BUDGET_FIELD.fieldApiName, type: 'currency' },
    { label: 'Open due date', fieldName: OPEN_DUE_DATE_FIELD.fieldApiName, type: 'date' }
];
const PRACTICE_UNITS = [
    { label: 'None', value: '' },
    { label: '.Net', value: '.Net' },
    { label: 'Salesforce', value: 'Salesforce' },
    { label: 'Java', value: 'Java' },
];
export default class AccountList extends LightningElement {
    

    practiceUnit= '';


    //@wire(MessageContext)
    //messageContext;
    practiceUnits= PRACTICE_UNITS;

    columns = COLUMNS;
    @wire(getPositions,{practiceUnit: '$practiceUnit'})
    positions;

    handleSelect(event){

        if (!event.detail.selectedRows[0]){
            return;
        }

        let selectedRows=event.detail.selectedRows;
        if(selectedRows.length>1)
        {
            var el = this.template.querySelector('lightning-datatable');
            selectedRows=el.selectedRows=el.selectedRows.slice(1);
            this.setPositionId(selectedRows[0]);
            event.preventDefault();
            return;
        }

        this.setPositionId(selectedRows[0].Id);
    }

    handlePracticeUnitChange(event) {
        this.practiceUnit = event.detail.value;
    }

    setPositionId(id){
        this.dispatchEvent(new CustomEvent('selectid', {
            detail: id
          }));
    }

    get errors() {
        return (this.positions.error) ?
            reduceErrors(this.positions.error) : [];
    }
}