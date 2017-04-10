/*
**********************************************************************************
Class Name: APS_Case_CopyWorkflowSteps_Helper 
Use for : This class for copying workflow steps
Created By: Sahil Prinja
Modified By : Saraswathi Gangali(01/Jun/2015)
*************************************************************************************
*/

public without sharing class APS_Case_CopyWorkflowSteps_Helper{

    //Not in Use Manoj
    /*
    private Set<Id> setProductIDs = new Set<Id>();
    private Map<Id, List<APS_Workflow_Steps__c>> mapProductIdToSetOfWFSteps = new Map<Id, List<APS_Workflow_Steps__c>>();
    private Map<Id, List<APS_Prerequisite_Step__c>> mapWFStepIdToWFStepPreqIds = new Map<Id, List<APS_Prerequisite_Step__c>>();
    private Set<Id> setRelatedWFStepIds = new Set<Id>();
    private Map<Id, Id> mapCaseWFStepIdToWFStepId = new Map<Id, Id>();
    private Map<Id, Id> mapWFStepIdToCaseWFStepId = new Map<Id, Id>();
    private Map<String, Id> mapTaskNameToTaskId = new Map<String, Id>();
    private Map<Id, APS_Workflow_Steps__c> mapWFSIdToDetail = new Map<Id, APS_Workflow_Steps__c>();
    private Map<Id, Id> mapPreReqIdToCasePreReqId = new Map<Id, Id>();
    private Map<Id, Case> mapCaseIdToDetail = new Map<Id, Case>();
    private Map<String, Id> mapCaseMemberRoleToUserId = new Map<String, Id>();
    
    //Added by Amar
    List<String> caseRecordTypeNames = new List<String>();
    
    //This method used to copy workflow steps to cases
    
    public void copyWorkflowStepsToCases(Map<Id, Case> mapCasesNew, Map<Id, Case> mapCasesOld){
        
        List<Case> lstCases = new List<Case>();
        mapCaseIdToDetail = mapCasesNew;
        mapCaseMemberRoleToUserId = initMapCaseMemberRoleToUserId_FromDB(mapCasesNew.keyset());
        lstCases = getListOfCasesToWorkUpon(mapCasesNew, mapCasesOld);

        //Added by Amar        
        for(Case caseObj : [Select Id, RecordType.Name from Case where Id in : lstCases limit 50000])
        {
            caseRecordTypeNames.add(caseObj.RecordType.Name);
        }
        
        initiateSetProductIds(lstCases);
        initiateMapProductToWFSteps();
        initializeMapWFStepIdToWFStepPreqIds();
        insertCaseWorkFlowSteps(lstCases);
        insertCasePrerequisiteSteps();
        copyCaseImmediateActions();
    }
    
    
    private List<Case> getListOfCasesToWorkUpon(Map<Id, Case> mapCasesNew, Map<Id, Case> mapCasesOld){
        
        List<Case> lstCasesResult = new List<Case>();
        if(mapCasesOld != null){
            //Update Case Scenario
            for(Id objId: mapCasesNew.keyset()){
                if(mapCasesOld.get(objId).APS_Product__c == null && mapCasesNew.get(objId).APS_Product__c != null ){
                    lstCasesResult.add(mapCasesNew.get(objId));
                }
            }
        }
        else{
            //Insert Case Scenario
            lstCasesResult = mapCasesNew.values();
        }
        return lstCasesResult;
    }
    
    //Traverse list of cases and get the related Product Ids
    private void initiateSetProductIds(List<Case> lstCases){
        
        for(Case objCase: lstCases){
            if(objCase.APS_Product__c != null){
                setProductIDs.add(objCase.APS_Product__c);
            }
        }

    }
    
    //Method that will initialize the Map from a Product Id to Set Of WF Steps that are with active WF Master and active WF step Master
    private void initiateMapProductToWFSteps(){

        for(APS_Workflow_Steps__c objWFStep: [select id, APS_Actor__c, APS_Category__c, APS_Category_Sequence__c,APS_Sequence__c,
                                             APS_IsRequired__c, APS_Description__c,
                                             APS_Workflow_Master__c,
                                             APS_Workflow_Master__r.APS_Product__c, APS_Workflow_Master__r.name, 
                                             APS_Workflow_Master__r.APS_IsActive__c,APS_Logic_Expression__c, APS_Polish_Notation__c,
                                             APS_Step_Name__c,APS_Image_Category__c,
                                             APS_Workflow_Master__r.Id, APS_Workflow_Master__r.APS_WF_Type__c,
                                             APS_Assignee__c,APS_Assignee_Type__c,
                                             APS_Queue_List__c, APS_Case_Team_Member_Role__c,
                                             APS_Create_with_Status__c,
                                             APS_Due_Date_Adjustment__c,APS_Due_Date_Adjustment_Base_Date__c,
                                             APS_Generate_Email_Notification__c,
                                             APS_Object_Type_To_Create__c,APS_Object_Record_Type_To_Create__c,
                                             APS_Shares_Object_With_Workflow_Step__c,
                                             PSP_CORE_Repeated_Start_Step_No__c                                                       
                                             from APS_Workflow_Steps__c
                                             where 
                                             APS_Workflow_Master__r.APS_IsActive__c = true
                                             and APS_Workflow_Master__r.APS_WF_Type__c in : caseRecordTypeNames  //Added by Amar
                                             order by APS_Workflow_Master__r.APS_Product__c, APS_Sequence__c limit 50000
                                             ]){
            if(mapProductIdToSetOfWFSteps.containsKey(objWFStep.APS_Workflow_Master__r.APS_Product__c)){
                mapProductIdToSetOfWFSteps.get(objWFStep.APS_Workflow_Master__r.APS_Product__c).add(objWFStep);
            }
            else{
                mapProductIdToSetOfWFSteps.put(objWFStep.APS_Workflow_Master__r.APS_Product__c, new List<APS_Workflow_Steps__c>());
                mapProductIdToSetOfWFSteps.get(objWFStep.APS_Workflow_Master__r.APS_Product__c).add(objWFStep);
            }
            mapWFSIdToDetail.put(objWFStep.id, objWFStep);
            setRelatedWFStepIds.add(objWFStep.Id);                               
        }

    }
    
    //Method that will initialize the Map from the Current WF Step to Set of Ids of its Prerequisite Steps
    private void initializeMapWFStepIdToWFStepPreqIds(){

        for(APS_Prerequisite_Step__c objPreqs : [SELECT Id, APS_Prerequisite_Step__c, APS_Current_Step__c, APS_Sequence__c,
                                                APS_Target_Record__c, APS_Field__c,
                                                APS_Operator__c, APS_Value__c
                                                FROM APS_Prerequisite_Step__c
                                                where APS_Current_Step__c in : setRelatedWFStepIds
                                                and APS_Prerequisite_Step__r.APS_Workflow_Master__r.APS_IsActive__c = true
                                                order by APS_Current_Step__c, APS_Sequence__c asc limit 50000
                                                ]){
            if(mapWFStepIdToWFStepPreqIds.containskey(objPreqs.APS_Current_Step__c)){
                mapWFStepIdToWFStepPreqIds.get(objPreqs.APS_Current_Step__c).add(objPreqs);
            }
            else{
                mapWFStepIdToWFStepPreqIds.put(objPreqs.APS_Current_Step__c, new List<APS_Prerequisite_Step__c>());
                mapWFStepIdToWFStepPreqIds.get(objPreqs.APS_Current_Step__c).add(objPreqs);
            }
        }
        system.debug('mapWFStepIdToWFStepPreqIds:'+mapWFStepIdToWFStepPreqIds);

    }
    
    //Method to Insert a Case WorkFlow Step for Every Case for every WorkFlow Stepm
    private void insertCaseWorkFlowSteps(List<Case> lstCases){

        
        Set<APS_Case_Workflow_Step__c> setCaseWFStepsToBeInserted = new Set<APS_Case_Workflow_Step__c>();
        List<APS_Case_Workflow_Step__c> lstCaseWFStepsToBeInserted = new List<APS_Case_Workflow_Step__c>();
        APS_Case_Workflow_Step__c objCaseWFStep;
        List<APS_Workflow_Steps__c> lstWFStepsResult = new List<APS_Workflow_Steps__c>();
        
        for(Case objCase: lstCases){
            if(objCase.APS_Product__c != null){
                if(mapProductIdToSetOfWFSteps.containskey(objCase.APS_Product__c) && !mapProductIdToSetOfWFSteps.get(objCase.APS_Product__c).isEmpty()){
                    //lstWFStepsResult = sortSetOfWorkFlowStepsBySequence(mapProductIdToSetOfWFSteps.get(objCase.APS_Product__c));
                    system.debug('mapProductIdToSetOfWFSteps.get(objCase.APS_Product__c)'+mapProductIdToSetOfWFSteps.get(objCase.APS_Product__c));
                    for(APS_Workflow_Steps__c objWFstep: mapProductIdToSetOfWFSteps.get(objCase.APS_Product__c)){
                        System.debug('@@!!!@@@!!!@@@!!!@@@!!! Inside For') ;
                        System.debug('@@!!!@@@!!!@@@!!!@@@!!!' + mapProductIdToSetOfWFSteps.get(objCase.APS_Product__c)) ;
                        objCaseWFStep = new APS_Case_Workflow_Step__c();                        
                        //Changed by Babita: Because size was 80 characters.
                        String strWFName = objWFstep.APS_Workflow_Master__r.name +APS_Util_Constants.SINGLEUNDERSCORE+objWFstep.APS_Step_Name__c;
                        objCaseWFStep.name = strWFName.left(80);
                        
                        objCaseWFStep.APS_Related_Case__c = objCase.Id;
                        objCaseWFStep.APS_Workflow__c = objWFstep.APS_Workflow_Master__r.name;
                        objCaseWFStep.APS_Workflow_Step_Name__c = objWFstep.APS_Step_Name__c;
                        objCaseWFStep.APS_Workflow_Step_SFDC_ID__c = objWFstep.Id;
                       
                        //Added by Babita
                        objCaseWFStep.APS_Sequence__c = objWFstep.APS_Sequence__c;
                        objCaseWFStep.APS_Actor__c = objWFstep.APS_Actor__c;
                        objCaseWFStep.APS_Category__c = objWFstep.APS_Category__c;

                        // Added by Babita
                        objCaseWFStep.APS_Category_Sequence__c= objWFstep.APS_Category_Sequence__c;
                        objCaseWFStep.APS_Workflow_Step_Image_Category__c= objWFstep.APS_Image_Category__c;
                        
                        //Assignee Details
                        objCaseWFStep.APS_Assignee__c= objWFstep.APS_Assignee__c;
                        objCaseWFStep.APS_Assignee_Type__c= objWFstep.APS_Assignee_Type__c;
                        objCaseWFStep.APS_Queue_List__c= objWFstep.APS_Queue_List__c;
                        objCaseWFStep.APS_Case_Team_Member_Role__c= objWFstep.APS_Case_Team_Member_Role__c;
                        
                        //Additional Details
                        objCaseWFStep.APS_Create_with_Status__c= objWFstep.APS_Create_with_Status__c;
                        objCaseWFStep.APS_Due_Date_Adjustment__c= objWFstep.APS_Due_Date_Adjustment__c;
                        objCaseWFStep.APS_Due_Date_Adjustment_Base_Date__c= objWFstep.APS_Due_Date_Adjustment_Base_Date__c;
                        objCaseWFStep.APS_Object_Type_To_Create__c= objWFstep.APS_Object_Type_To_Create__c;
                        objCaseWFStep.APS_Object_Record_Type_To_Create__c= objWFstep.APS_Object_Record_Type_To_Create__c;
                        objCaseWFStep.APS_Generate_Email_Notification__c= objWFstep.APS_Generate_Email_Notification__c;
                        
                        //Added by Babita
                        objCaseWFStep.APS_Workflow_Type__c = objWFstep.APS_Workflow_Master__r.APS_WF_Type__c;
                        objCaseWFStep.APS_Workflow_Id__c = objWFstep.APS_Workflow_Master__r.Id;
                        
                                                
                        objCaseWFStep.APS_Description__c = objWFStep.APS_Description__c;
                        objCaseWFStep.APS_Logic_Expression__c = objWFStep.APS_Logic_Expression__c;
                        objCaseWFStep.APS_Polish_Notation__c = objWFStep.APS_Polish_Notation__c;
                        objCaseWFStep.PSP_CORE_Repeated_Start_Step_No__c= objWFStep.PSP_CORE_Repeated_Start_Step_No__c;

                        if(mapWFStepIdToWFStepPreqIds.containsKey(objWFstep.Id)){
                        System.debug('Inside Success') ;
                            objCaseWFStep.APS_Completed_Pre_requisites__c = false;
                            objCaseWFStep.APS_Status__c =APS_Util_Constants.NOTASSIGNED;
                            if(objWFstep.APS_Due_Date_Adjustment__c!=null && objWFstep.APS_Due_Date_Adjustment_Base_Date__c==APS_Util_Constants.CREATEDDATE) {
                                objCaseWFStep.APS_Due_Date_Adjustment__c =  objWFstep.APS_Due_Date_Adjustment__c ;
                                objCaseWFStep.APS_Due_Date__c = Date.Today().addDays(Integer.valueof(objCaseWFStep.APS_Due_Date_Adjustment__c));
                            }
                            if(objWFstep.APS_Due_Date_Adjustment__c!=null && objWFstep.APS_Due_Date_Adjustment_Base_Date__c ==APS_Util_Constants.PLANNEDDATE) {
                                objCaseWFStep.APS_Due_Date_Adjustment__c =  objWFstep.APS_Due_Date_Adjustment__c ;
                                if(objCase.PSP_CORE_TSWelcome_Training_Planned_Date__c!= null)
                                objCaseWFStep.APS_Due_Date__c = Date.ValueOf(objCase.PSP_CORE_TSWelcome_Training_Planned_Date__c).addDays(Integer.valueof(objCaseWFStep.APS_Due_Date_Adjustment__c));
                            }
                            if(objWFstep.APS_Due_Date_Adjustment__c!=null && objWFstep.APS_Due_Date_Adjustment_Base_Date__c.equals('Welcome and Training Completed Date/Time')) {
                                 objCaseWFStep.APS_Due_Date_Adjustment__c =  objWFstep.APS_Due_Date_Adjustment__c ;
                                 if(case1.PSP_CORE_r17_Wel_Train_Completed_Date__c!= null){
                                 objCaseWFStep.APS_Due_Date__c = Date.ValueOf(case1.PSP_CORE_r17_Wel_Train_Completed_Date__c).addDays(Integer.valueof(objWFstep.APS_Due_Date_Adjustment__c));
                                       }
                                 }  
                         
                        }
                        else{
                            objCaseWFStep.APS_Completed_Pre_requisites__c = true;
                            objCaseWFStep.APS_Status__c =APS_Util_Constants.ASSIGNED;
                            if(objWFstep.APS_Due_Date_Adjustment__c!=null && objWFstep.APS_Due_Date_Adjustment_Base_Date__c ==APS_Util_Constants.PLANNEDDATE) {
                                objCaseWFStep.APS_Due_Date_Adjustment__c =  objWFstep.APS_Due_Date_Adjustment__c ;
                                if(objCase.PSP_CORE_TSWelcome_Training_Planned_Date__c!= null){
                                objCaseWFStep.APS_Due_Date__c = Date.ValueOf(objCase.PSP_CORE_TSWelcome_Training_Planned_Date__c).addDays(Integer.valueof(objCaseWFStep.APS_Due_Date_Adjustment__c));
                            }
                            }
                            if(objWFstep.APS_Due_Date_Adjustment_Base_Date__c ==APS_Util_Constants.CREATEDDATE)
                            {  
                                if(objWFstep.APS_Due_Date_Adjustment__c!=null ) {
                                     objCaseWFStep.APS_Due_Date__c = Date.Today().addDays(Integer.valueof(objWFstep.APS_Due_Date_Adjustment__c));
                                                                    }
                                    } // Else Addedd By Viraj 
                            
                            if(objWFstep.APS_Due_Date_Adjustment_Base_Date__c ==APS_Util_Constants.COMPLETEDDATE)
                            {
                              List<APS_Prerequisite_Step__c> PreReqList = mapWFStepIdToWFStepPreqIds.get(objCaseWFStep.Id) ;
                               if(PreReqList!=NULL)
                               {
                                 
                               
                               }
                            }                            
                             }        
                            //Added by Babita - to populate the Completed Prereq date.
                            objCaseWFStep.APS_Completed_Pre_requisites_Date__c=  Date.Today();
                            lstCaseWFStepsToBeInserted.add(objCaseWFStep);
                        }
                        
                    }
                }
            }
        
        
        //Call to insert Tasks
        //Insert Tasks + Update Task Id on the CWFS + Insert CWFS
        system.debug('lstCaseWFStepsToBeInserted:'+lstCaseWFStepsToBeInserted);
        insertRelatedTasksForCWFS(lstCaseWFStepsToBeInserted);
        System.debug('Updating Related Object SFDC Id on Case Workflow Step Before Insert!');
        
        String tempWorkflowStepId = '';
        String tempWorkflowStepName = '';
        String strCaseWFNameCombination = '';
        
        for(APS_Case_Workflow_Step__c objCWFS: lstCaseWFStepsToBeInserted){
            //Update the task id on CWFS before insert
            tempWorkflowStepId =APS_Util_Constants.NULLVAL;
            tempWorkflowStepName =APS_Util_Constants.NULLVAL;
            strCaseWFNameCombination = APS_Util_Constants.NULLVAL;
            
            if(mapWFSIdToDetail.containsKey(objCWFS.APS_Workflow_Step_SFDC_ID__c)){
                tempWorkflowStepId = mapWFSIdToDetail.get(objCWFS.APS_Workflow_Step_SFDC_ID__c).APS_Shares_Object_With_Workflow_Step__c;
                if(tempWorkflowStepId != null){
                    if(mapWFSIdToDetail.containsKey(tempWorkflowStepId)){
                        tempWorkflowStepName = mapWFSIdToDetail.get(tempWorkflowStepId).APS_Step_Name__c;
                        strCaseWFNameCombination = objCWFS.APS_Related_Case__c +APS_Util_Constants.DOUBLEUNDERSCORE+ tempWorkflowStepName;
                    }
                }
                else{
                    strCaseWFNameCombination = objCWFS.APS_Related_Case__c +APS_Util_Constants.DOUBLEUNDERSCORE+ objCWFS.APS_Workflow_Step_Name__c;
                }
            }
            
            if(strCaseWFNameCombination != null){
                if(mapTaskNameToTaskId.containsKey(strCaseWFNameCombination)){
                    objCWFS.APS_Related_Object_SFDC_ID__c = mapTaskNameToTaskId.get(strCaseWFNameCombination);
                }       
            }
        }
        
        System.debug('Inserting CWFS!');
        Database.SaveResult[] result =database.insert(lstCaseWFStepsToBeInserted, false);
        system.debug('result:'+result);
        System.debug('lstCaseWFStepsToBeInserted after insert --- ' + lstCaseWFStepsToBeInserted);
        
        //initialize mapCaseWFStepIdToWFStepId
        for(APS_Case_Workflow_Step__c objCWFS: lstCaseWFStepsToBeInserted){
            if(objCWFS.id != null){
                mapCaseWFStepIdToWFStepId.put(objCWFS.id, objCWFS.APS_Workflow_Step_SFDC_ID__c);
                mapWFStepIdToCaseWFStepId.put(objCWFS.APS_Workflow_Step_SFDC_ID__c, objCWFS.id);
            }
        }
        System.debug('mapCaseWFStepIdToWFStepId ----- ' + mapCaseWFStepIdToWFStepId);
        System.debug('mapWFStepIdToCaseWFStepId ----- ' + mapWFStepIdToCaseWFStepId);
        
        System.debug('Updating the APS_Shares_Object_With_Case_WorkflowStep__c on the inserted Case Workflow Steps!');
        //Disable the Trigger on Case Workflow Step and Update the APS_Shares_Object_With_Case_WorkflowStep__c field on CWFS
        APS_PreventRecursion_Helper.setBlnAllowTriggerOnCWFS(false);
        List<APS_Case_Workflow_Step__c> lstCWFSToBeUpdated = new List<APS_Case_Workflow_Step__c>();
        
        for(APS_Case_Workflow_Step__c objCWFS: lstCaseWFStepsToBeInserted){
            tempWorkflowStepId =APS_Util_Constants.NULLVAL;
            tempWorkflowStepName =APS_Util_Constants.NULLVAL;
            strCaseWFNameCombination =APS_Util_Constants.NULLVAL;
            if(mapWFSIdToDetail.containsKey(objCWFS.APS_Workflow_Step_SFDC_ID__c)){
                tempWorkflowStepId = mapWFSIdToDetail.get(objCWFS.APS_Workflow_Step_SFDC_ID__c).APS_Shares_Object_With_Workflow_Step__c;
                if(tempWorkflowStepId != null){
                    //Means that parent WFS shares object with the ID: tempWorkflowStepId
                    if(mapWFStepIdToCaseWFStepId.containsKey(tempWorkflowStepId)){
                        objCWFS.APS_Shares_Object_With_Case_WorkflowStep__c = mapWFStepIdToCaseWFStepId.get(tempWorkflowStepId);
                        lstCWFSToBeUpdated.add(objCWFS);
                    }
                }
            }
        }
        
        System.debug('lstCWFSToBeUpdated ----- ' + lstCWFSToBeUpdated);
        database.update(lstCWFSToBeUpdated,false);
        System.debug('CWFS updation complete!');
    }
    
    //Method that will sort the set of Workflow Steps by Sequence Number
    private List<APS_Workflow_Steps__c> sortSetOfWorkFlowStepsBySequence(Set<APS_Workflow_Steps__c> setWFSteps){
        System.debug('Inside Method sortSetOfWorkFlowStepsBySequence!!');
        System.debug('setWFSteps ----- ' + setWFSteps);
        
        Map<Integer,APS_Workflow_Steps__c> mapSequenceToWFStep = new Map<Integer,APS_Workflow_Steps__c>();
        List<APS_Workflow_Steps__c> lstWFStepsResult = new List<APS_Workflow_Steps__c>();
        List<Integer> lstSequences = new List<Integer>();
        
        //Map of Sequence to Object
        for(APS_Workflow_Steps__c objWFS: setWFSteps){
            mapSequenceToWFStep.put((Integer)objWFS.APS_Sequence__c, objWFS);
        }
        lstSequences.addall(mapSequenceToWFStep.keyset());
        lstSequences.sort();
        
        for(Integer i: lstSequences){
            lstWFStepsResult.add(mapSequenceToWFStep.get(i));
        }
        System.debug('lstWFStepsResult ----- ' + lstWFStepsResult);
        return lstWFStepsResult;
    }
    
    private void insertRelatedTasksForCWFS(List<APS_Case_Workflow_Step__c> lstCWFSToBeInserted){
        System.debug('Inside Method sortSetOfWorkFlowStepsBySequence!!');
        System.debug('lstCWFSToBeInserted ----- ' + lstCWFSToBeInserted);
        List<Task> lstTasksToBeCreated = new List<Task>();
        Map<String, Id> mapTaskRecordTypesNameToID = new Map<String, Id>();
        Task objTask;
        Date dt = Date.Today();
        
        //Initializing Task Record Types Names objTasko IDs
        for(RecordType objRecordType:  [Select Id, Name From RecordType where SobjectType =:APS_Util_Constants.TASK limit 50000])
        {
            mapTaskRecordTypesNameToID.put(objRecordType.Name, objRecordType.Id);
        }
       
        //For all objTaskhe Case Workflow Steps Inserted
        for(APS_Case_Workflow_Step__c objCWFS: lstCWFSToBeInserted)
        { 
            system.debug('objCWFS -------- '+objCWFS);

            if(mapWFSIdToDetail.containsKey(objCWFS.APS_Workflow_Step_SFDC_ID__c) && mapWFSIdToDetail.get(objCWFS.APS_Workflow_Step_SFDC_ID__c).APS_Shares_Object_With_Workflow_Step__c == null){
                //Implies No New Task is to be Created for this
                if (objCWFS.APS_Object_Type_To_Create__c != null && objCWFS.APS_Object_Type_To_Create__c.equals(APS_Util_Constants.TASK))
                {
                    objTask = new Task();
                    objTask.whatId = objCWFS.APS_Related_Case__c; 
                    
                    Case CaseOBj = [select id , PSP_CORE_Patient__c,PSP_CORE_TSWelcome_Training_Planned_Date__c from Case where Id =: objTask.WhatId limit 1] ;
                    Account AccountObj  = [select id ,PersonHomePhone , PersonMobilePhone from Account where Id =:CaseOBj.PSP_CORE_Patient__c limit 1] ;
                    //objTask.PSP_CORE_Cellular_Phone__c = AccountObj.PersonMobilePhone ;
                    //objTask.PSP_CORE_Home_Phone__c = AccountObj.PersonHomePhone ;
                    objTask.PSP_CORE_Service_Request__c = objCWFS.APS_Related_Case__c;
                    
                    
                   //Task Subject would have the same name as the master workflow step name
                    objTask.Subject = objCWFS.APS_Workflow_Step_Name__c;
                    if(mapCaseIdToDetail.containsKey(objCWFS.APS_Related_Case__c)){
                        //objTask.APS_Patient__c = mapCaseIdToDetail.get(objCWFS.APS_Related_Case__c).APS_Patient_Name__c;
                        
                    }
                    //Add by Manoj
                    if(objCWFS.APS_Due_Date__c!=null && objCWFS.APS_Due_Date_Adjustment_Base_Date__c ==APS_Util_Constants.CREATEDDATE){
                        
                    }
               */     
                    //Calculating Due Date of the Task
          /*          if(objCWFS.APS_Due_Date_Adjustment_Base_Date__c != null && objCWFS.APS_Due_Date_Adjustment_Base_Date__c.equals('Current Date'))
                    {
                        //Current Date Logic
                        if(objCWFS.APS_Due_Date_Adjustment__c != null){
                            dt=  dt.addDays(Integer.valueof(objCWFS.APS_Due_Date_Adjustment__c));   
                        }
                  //      objTask.ActivityDate = dt;
                  //      system.debug('activity date'+dt);
                      }
                    
                    else
                    { */
                   /*
                    // Added By Viraj   
                        if(objCWFS.APS_Due_Date__c!=null && objCWFS.APS_Due_Date_Adjustment_Base_Date__c ==APS_Util_Constants.CREATEDDATE)
                        { objTask.PSP_CORE_Modified_Schedule_Date__c = objCWFS.APS_Due_Date__c;
                          objTask.ActivityDate = objCWFS.APS_Due_Date__c;
                        }
                   // }
                    if(objCWFS.APS_Due_Date__c!=null  && objCWFS.APS_Due_Date_Adjustment_Base_Date__c ==APS_Util_Constants.PLANNEDDATE) {
                        objTask.PSP_CORE_Modified_Schedule_Date__c = objCWFS.APS_Due_Date__c;
                          objTask.ActivityDate = objCWFS.APS_Due_Date__c;           
                    }
                    
                    if (objCWFS.APS_Create_with_Status__c!=null){
                        objTask.Status = objCWFS.APS_Create_with_Status__c;
                    }    
                    if (objCWFS.APS_Workflow_Step_Image_Category__c!=null){
                        //objTask.Type= objCWFS.APS_Workflow_Step_Image_Category__c;  
                        objTask.PSP_CORE_InteractionType__c= objCWFS.APS_Workflow_Step_Image_Category__c;  
                     }     
                    if(objCWFS.APS_Assignee_Type__c != null){
                        if(objCWFS.APS_Assignee_Type__c.equals(APS_Util_Constants.USER)){
                            if (objCWFS.APS_Assignee__c!=null){
                                System.debug('Setting specific User as Owner : ' + objCWFS.APS_Assignee__c);
                                objTask.OwnerId = objCWFS.APS_Assignee__c;      
                            }
                        }
                        else if(objCWFS.APS_Assignee_Type__c.equals(APS_Util_Constants.ASSOCIATEDCASE)){
                            if(objCWFS.APS_Case_Team_Member_Role__c != null){
                                if(mapCaseMemberRoleToUserId.containsKey(objCWFS.APS_Related_Case__c + '__' + objCWFS.APS_Case_Team_Member_Role__c)){
                                    System.debug('Setting the Owner from the Related Case Team : ' + mapCaseMemberRoleToUserId.get(objCWFS.APS_Related_Case__c + '__' + objCWFS.APS_Case_Team_Member_Role__c));
                                    objTask.OwnerId = mapCaseMemberRoleToUserId.get(objCWFS.APS_Related_Case__c + '__' + objCWFS.APS_Case_Team_Member_Role__c);
                                }
                                else{
                                    System.debug('No User in Related Case Team found for the Role : ' + objCWFS.APS_Case_Team_Member_Role__c);
                                }
                            }
                        }
                    }
                        
                    if ( mapTaskRecordTypesNameToID.get(objCWFS.APS_Object_Record_Type_To_Create__c)!=null){
                        objTask.RecordTypeId = mapTaskRecordTypesNameToID.get(objCWFS.APS_Object_Record_Type_To_Create__c); 
                    }
                    lstTasksToBeCreated.add(objTask);
                }
            }
            
        }
        System.debug('lstTasksToBeCreated --------- ' + lstTasksToBeCreated);
        Database.SaveResult[] result=database.insert(lstTasksToBeCreated, false); 
        system.debug('result:'+result);
        System.debug('Task Insertion Completed!!!');
        System.debug('lstTasksToBeCreated after insert --- ' + lstTasksToBeCreated);
        
        for(Task objTask1: lstTasksToBeCreated){
            if(objTask1.id != null){
                //Implies it has been inserted
                if(objTask1.whatId != null){
                    mapTaskNameToTaskId.put(objTask1.whatId + '__' + objTask1.subject, objTask1.id);
                }
            }
        }
        System.debug('mapTaskNameToTaskId --------- ' + mapTaskNameToTaskId);
    }
    
    
    
    //Method that will insert the Case Prerequisite Steps
    private void insertCasePrerequisiteSteps(){
        System.debug('Inside Method insertCasePrerequisiteSteps!!');
        System.debug('mapCaseWFStepIdToWFStepId ----- ' + mapCaseWFStepIdToWFStepId);
        
        //Set<APS_Case_Prerequisite_Step__c> setCasePreStepsToBeInserted = new Set<APS_Case_Prerequisite_Step__c>();
        List<APS_Case_Prerequisite_Step__c> lstCasePreStepsToBeInserted = new List<APS_Case_Prerequisite_Step__c>();
        APS_Case_Prerequisite_Step__c objCasePreStep;
        Id objWFSId;
        
        
        System.debug('mapCaseWFStepIdToWFStepId.keyset() ----- ' + mapCaseWFStepIdToWFStepId.keyset());
        for(Id objCWFSId: mapCaseWFStepIdToWFStepId.keyset()){
            objWFSId = mapCaseWFStepIdToWFStepId.get(objCWFSId);
            System.debug('Processing Case Workflow Step Id: '+ objCWFSId + ' with Workflow Step Id as: ' + objWFSId);
            if(mapWFStepIdToWFStepPreqIds.containsKey(objWFSId) && !mapWFStepIdToWFStepPreqIds.get(objWFSId).isEmpty()){
                System.debug('Workflow Step Id: ' + objWFSId + ' has a set of Prerequisites Steps: ' + mapWFStepIdToWFStepPreqIds.get(objWFSId));
                for(APS_Prerequisite_Step__c preqWFStep: mapWFStepIdToWFStepPreqIds.get(objWFSId)){
                    System.debug('Checking if the Case Workflow Step has been inserted related to the Workflow Prerequisite Step: ' + preqWFStep.APS_Prerequisite_Step__c);
                    if(mapWFStepIdToCaseWFStepId.containsKey(preqWFStep.APS_Prerequisite_Step__c)){
                        System.debug('Found Case Workflow Step: ' + mapWFStepIdToCaseWFStepId.get(preqWFStep.APS_Prerequisite_Step__c) + ' for Workflow Prerequisite Step: ' + preqWFStep.APS_Prerequisite_Step__c);
                        objCasePreStep = new APS_Case_Prerequisite_Step__c();
                        objCasePreStep.APS_Master_Prerequisite_SFDC_Id__c = preqWFStep.Id;
                        objCasePreStep.APS_Current_Step__c = objCWFSId;
                        objCasePreStep.APS_Prerequisite_Step__c = mapWFStepIdToCaseWFStepId.get(preqWFStep.APS_Prerequisite_Step__c);
                        //Copying the Sequence
                        objCasePreStep.APS_Sequence__c = preqWFStep.APS_Sequence__c;
                        //Copying the additional details for new functionality
                        objCasePreStep.APS_Target_Record__c = preqWFStep.APS_Target_Record__c;
                        objCasePreStep.APS_Field__c = preqWFStep.APS_Field__c;
                        objCasePreStep.APS_Operator__c = preqWFStep.APS_Operator__c;
                        objCasePreStep.APS_Value__c = preqWFStep.APS_Value__c;
                        
                        lstCasePreStepsToBeInserted.add(objCasePreStep);
                    }
                }
            }
        }
        //lstCasePreStepsToBeInserted.addall(setCasePreStepsToBeInserted);
        System.debug('lstCasePreStepsToBeInserted --- ' + lstCasePreStepsToBeInserted);
        
        List<Database.SaveResult> lstSR = database.insert(lstCasePreStepsToBeInserted, false);
        for(Database.SaveResult objSR: lstSR){
            if(objSR.isSuccess()){
                System.debug('Successfully Inserted with Id: ' + objSR.getId());
            }
        }
        
        for(APS_Case_Prerequisite_Step__c objCPS: lstCasePreStepsToBeInserted){
            if(objCPS.id != null){
                mapPreReqIdToCasePreReqId.put(objCPS.APS_Master_Prerequisite_SFDC_Id__c, objCPS.id);
            }
        }
        System.debug('mapPreReqIdToCasePreReqId --- ' + mapPreReqIdToCasePreReqId);
    }

    private void copyCaseImmediateActions(){
        System.debug('Inside Method copyCaseImmediateActions!!');
        List<APS_Case_Immediate_Action__c> lstCIAToBeInserted = new List<APS_Case_Immediate_Action__c>();
        APS_Case_Immediate_Action__c objCIA;
        for(APS_Immediate_Action__c objIA: [select id, APS_Current_Step__c, APS_Target_Step__c, APS_Field__c, APS_Value__c
                                            from APS_Immediate_Action__c
                                            where APS_Current_Step__c in: mapPreReqIdToCasePreReqId.keyset()
                                            limit 50000
                                            ]){
            if(mapPreReqIdToCasePreReqId.containsKey(objIA.APS_Current_Step__c) && mapWFStepIdToCaseWFStepId.containsKey(objIA.APS_Target_Step__c)){
                objCIA = new APS_Case_Immediate_Action__c();
                objCIA.APS_Current_Step__c = mapPreReqIdToCasePreReqId.get(objIA.APS_Current_Step__c);
                objCIA.APS_Target_Step__c = mapWFStepIdToCaseWFStepId.get(objIA.APS_Target_Step__c);
                objCIA.APS_Field__c = objIA.APS_Field__c;
                objCIA.APS_Value__c = objIA.APS_Value__c;
                lstCIAToBeInserted.add(objCIA); 
            }
            
        }
        System.debug('lstCIAToBeInserted --- ' + lstCIAToBeInserted);
        database.insert(lstCIAToBeInserted, false);
    }
*/
    /*Phase2: Updated the below method to assign tasks in such a way that if there are zero tasks for an User with matching the RoldId, that User will be assigned the task
              If there are no such users with zero tasks, then the Users with lease assigned tasks will be picked    
    */
    /*
    private Map<String, Id> initMapCaseMemberRoleToUserId_FromDB(Set<Id> setDistinctCaseIds)
    {
        Map<String, Id> mapCaseMemberRoleToUserId = new Map<String, Id>();
        Map<Id, String> mapCaseTeamRoleIdToName = new Map<Id, String>();
        List<AggregateResult> ctm = [select teamroleid,count(id) cc from CaseTeamMember where ParentId in: setDistinctCaseIds group by teamroleid limit 50000] ;
        List<String> userIds = new List<String>();        
        for(CaseTeamRole objCTR: [select Id, name from CaseTeamRole limit 50000 ])
        {
            mapCaseTeamRoleIdToName.put(objCTR.Id, objCTR.name);
        }
        for(AggregateResult ag : ctm)
        {
            Integer i = 0;           
            if((Integer)ag.get(APS_Util_Constants.CC)>1)
            {   
                List<CaseTeamMember> cc = [select Id,MemberId,ParentId  From CaseTeamMember where teamRoleId=:(Id)ag.get(APS_Util_Constants.ROLEID) and ParentId in: setDistinctCaseIds limit 50000];       
                for(CaseTeamMember c : cc)
                {
                    List<task> taskcnt  = [Select Ownerid from Task where OwnerId = :c.MemberId and IsClosed = false and Status!=:APS_Util_Constants.COMPLETED Limit 2];
                    if(taskcnt.size()==0 && i==0 )
                    {
                        for(CaseTeamMember objCTM: [select id, TeamRoleId, MemberId, ParentId, TeamTemplateMemberId from CaseTeamMember where ParentId in: setDistinctCaseIds and teamroleid = :(Id)ag.get(APS_Util_Constants.ROLEID) and memberid = :c.MemberId  limit 50000  ])
                        {
                            if(mapCaseTeamRoleIdToName.containsKey(objCTM.TeamRoleId))
                            {
                                mapCaseMemberRoleToUserId.put(objCTM.ParentId + APS_Util_Constants.DOUBLEUNDERSCORE + mapCaseTeamRoleIdToName.get(objCTM.TeamRoleId), objCTM.MemberId);
                            }
                        i = 1;
                        }
                    }                  
                    userIds.add(c.MemberId);
                }
                if (i == 0)
                {                                
                    List<AggregateResult> t = [Select Ownerid,count(id) from Task where OwnerId in : userIds and  IsClosed = false and Status!=:APS_Util_Constants.COMPLETED group by ownerid order by count(id) asc LIMIT 1 ];       
                    Id theLeastTaskUserId = (Id)t[0].get(APS_Util_Constants.OWENERID);                    
                    for(CaseTeamMember objCTM: [select id, TeamRoleId, MemberId, ParentId, TeamTemplateMemberId  from CaseTeamMember  where ParentId in: setDistinctCaseIds and teamroleid = :(Id)ag.get(APS_Util_Constants.ROLEID) and memberid =: theLeastTaskUserId limit 50000 ])
                    {
                        if(mapCaseTeamRoleIdToName.containsKey(objCTM.TeamRoleId))
                        {
                            mapCaseMemberRoleToUserId.put(objCTM.ParentId +APS_Util_Constants.DOUBLEUNDERSCORE+ mapCaseTeamRoleIdToName.get(objCTM.TeamRoleId), objCTM.MemberId);
                        }           
                    }
                }                
            } //end of if
            
            else if( (Integer)ag.get(APS_Util_Constants.CC)== 1) 
            {
                for(CaseTeamMember objCTM: [select id, TeamRoleId, MemberId, ParentId, TeamTemplateMemberId from CaseTeamMember  where ParentId in: setDistinctCaseIds and teamroleid = :(Id)ag.get(APS_Util_Constants.ROLEID)  limit 50000 ])                                            
                 {
                    if(mapCaseTeamRoleIdToName.containsKey(objCTM.TeamRoleId))
                    {
                        mapCaseMemberRoleToUserId.put(objCTM.ParentId+APS_Util_Constants.DOUBLEUNDERSCORE+mapCaseTeamRoleIdToName.get(objCTM.TeamRoleId), objCTM.MemberId);
                    }
                         
                 }

            } //end of else if
        } 
        return mapCaseMemberRoleToUserId;
    }
    */
}