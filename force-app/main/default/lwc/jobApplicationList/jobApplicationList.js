import { LightningElement, wire, api, track } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CANDIDATE_NAME_FIELD from '@salesforce/schema/Job_Application__c.Job_Candidate__r.Name';
import REQUESTED_SALARY_FIELD from '@salesforce/schema/Job_Application__c.Requested_Salary__c';
import getApplications from '@salesforce/apex/JobApplicationController.getApplications';
import {refreshApex} from '@salesforce/apex';

const ACTIONS = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

const COLUMNS = [
    { label: 'Candidate', fieldName: CANDIDATE_NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Requested Salary', fieldName: REQUESTED_SALARY_FIELD.fieldApiName, type: 'currency' },
    {
        type: 'action',
        typeAttributes: { rowActions: ACTIONS },
    },
];
export default class JobApplicationList extends LightningElement {
    isCreating=false;

    isEditing=false;
    objectToEdit;


    @api positionid;

    @track columns=COLUMNS;

    @track applications;
    
    //@wire(getContacts)
    @wire(getApplications,{positionId: '$positionid'})
    wiredApplications({ error, data }) {
        if(data) {
           //this is the final array into which the flattened response will be pushed. 
           let applicationsArray = [];
            
           for (let row of data) {
                // this const stroes a single flattened row. 
                const flattenedRow = {}
                
                // get keys of a single row — Name, Phone, LeadSource and etc
                let rowKeys = Object.keys(row); 
               
                //iterate 
                rowKeys.forEach((rowKey) => {
                    
                    //get the value of each key of a single row. John, 999-999-999, Web and etc
                    const singleNodeValue = row[rowKey];
                    
                    //check if the value is a node(object) or a string
                    if(singleNodeValue.constructor === Object){
                        
                        //if it's an object flatten it
                        this._flatten(singleNodeValue, flattenedRow, rowKey)        
                    }else{
                        
                        //if it’s a normal string push it to the flattenedRow array
                        flattenedRow[rowKey] = singleNodeValue;
                    }
                    
                });
               
                //push all the flattened rows to the final array 
                applicationsArray.push(flattenedRow);
            }
            
            //assign the array to an array that's used in the template file
            this.applications = applicationsArray;
        } else if (error) {
            this.error = error;
        }
    }

    _flatten = (nodeValue, flattenedRow, nodeName) => {        
        let rowKeys = Object.keys(nodeValue);
        rowKeys.forEach((key) => {
            let finalKey = nodeName + '.'+ key;
            flattenedRow[finalKey] = nodeValue[key];
        })
    }


    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.log(row);
        switch (actionName) {
            case 'delete':
                this.deleteRow(row.Id);
                break;
            case 'edit':
                this.editRow(row.Id);
                break;
            default:
        }
    }

    deleteRow(Id) {
        deleteRecord(Id)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });

    }


    editRow(Id) {
        this.objectToEdit=Id;
        this.isEditing=true;
    }
    handleEdit(){
        this.isEditing=false;
    }

    handleCreateClick(){
        this.isCreating=true;
    }
    handleCreation(){
        this.isCreating=false;
    }

}