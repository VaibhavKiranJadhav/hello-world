/*
*                                                                                                   *
*                            Version 1.00                                                           *
*                                                                                                   *
* Creation Date: 16.Apr.2015                    m.anandhan                                          *
* Last Modified: 16.Apr.2015                    m.anandhan                                          *
*                                                                                                   *
*                             © 2008 - Accenture - All Rights Reserved                              *


*/

global class VFC01_MetaDataExtractor {
    // =====================================================================================================================================================================================================================
    // === A.T.T.R.I.B.U.T.E.S
    // =====================================================================================================================================================================================================================

    public string callfunc{get;set;}    
    public static list<String> compNames {get;set;} 
    public String components {get;set;}
    public String Modifiedbyset {get;set;}    
    public Boolean startload{ get; set; }
    public date startdate{get;set;}
    public date enddate {get;set;}
    public String startdatestr{get;set;}
    public String enddatestr {get;set;}
    public List<selectoption> Modifiedbyvalues {get;set;}
    public List<String> Modifiedby {get;set;}
    public List<selectoption> selectedModifiedbyvalues {get;set;}
    public List<String> selectedModifiedby {get;set;}
    public List<selectoption> MetadataComponentvalues {get;set;}
    public List<String> MetadataComponents {get;set;}
    public List<selectoption> selectedMetadataComponentvalues {get;set;}
    public List<String> selectedMetadataComponents {get;set;}
    public Id folderId{get;set;}
    
    // =====================================================================================================================================================================================================================
    // === C.O.N.S.T.R.U.C.T.O.R
    // =====================================================================================================================================================================================================================
    public VFC01_MetaDataExtractor ()
    {
        folderId=UserInfo.getUserId(); 
        startdate=system.today();
        enddate=system.today();
        startload=false;
        selectedMetadataComponentvalues= new List<selectoption> ();
        Modifiedbyvalues = new List<selectoption> ();
        SelectedModifiedbyvalues = new List<selectoption> ();
        MetadataComponentvalues = new List<selectoption> ();
        initializeAllData();
    }
    
    // ======================================================================================================================================================================================================================
    // = M.E.T.H.O.D.S
    // ======================================================================================================================================================================================================================
    
    public void initializeAllData() {   // Initialize the components list and the Modified Users list for retrival
    
        // Components list that can be retrieved - Start
        
        //MetadataComponentvalues.add(new SelectOption('AccountCriteriaBasedSharingRule','AccountCriteriaBasedSharingRule'));
        //MetadataComponentvalues.add(new SelectOption('AccountOwnerSharingRule','AccountOwnerSharingRule'));
        MetadataComponentvalues.add(new SelectOption('ApexClass','ApexClass'));
        MetadataComponentvalues.add(new SelectOption('ApexComponent','ApexComponent'));
        MetadataComponentvalues.add(new SelectOption('ApexPage','ApexPage'));
        MetadataComponentvalues.add(new SelectOption('ApexTrigger','ApexTrigger'));
        MetadataComponentvalues.add(new SelectOption('ApprovalProcess','ApprovalProcess'));
        MetadataComponentvalues.add(new SelectOption('CustomApplication','CustomApplication'));
        MetadataComponentvalues.add(new SelectOption('CustomApplicationComponent','CustomApplicationComponent'));
        MetadataComponentvalues.add(new SelectOption('CustomField','CustomField'));
        MetadataComponentvalues.add(new SelectOption('CustomLabel','CustomLabel'));
        MetadataComponentvalues.add(new SelectOption('CustomObject','CustomObject'));
        //MetadataComponentvalues.add(new SelectOption('CustomObjectCriteriaBasedSharingRule','CustomObjectCriteriaBasedSharingRule'));
        //MetadataComponentvalues.add(new SelectOption('CustomObjectOwnerSharingRule','CustomObjectOwnerSharingRule'));
        MetadataComponentvalues.add(new SelectOption('CustomObjectTranslation','CustomObjectTranslation'));   
        MetadataComponentvalues.add(new SelectOption('CustomPageWebLink','CustomPageWebLink'));        
        MetadataComponentvalues.add(new SelectOption('CustomSite','CustomSite'));
        MetadataComponentvalues.add(new SelectOption('CustomTab','CustomTab'));
        MetadataComponentvalues.add(new SelectOption('Dashboard','Dashboard'));
        MetadataComponentvalues.add(new SelectOption('Document','Document')); 
        MetadataComponentvalues.add(new SelectOption('EmailTemplate','EmailTemplate'));
        MetadataComponentvalues.add(new SelectOption('FieldSet','FieldSet'));
        MetadataComponentvalues.add(new SelectOption('DocumentFolder','DocumentFolder'));
        MetadataComponentvalues.add(new SelectOption('DashboardFolder','DashboardFolder'));
        MetadataComponentvalues.add(new SelectOption('ReportFolder','ReportFolder'));
        MetadataComponentvalues.add(new SelectOption('EmailFolder','EmailFolder'));         
        MetadataComponentvalues.add(new SelectOption('Group','Group'));
        MetadataComponentvalues.add(new SelectOption('HomePageComponent','HomePageComponent')); 
        MetadataComponentvalues.add(new SelectOption('HomePageLayout','HomePageLayout'));
        MetadataComponentvalues.add(new SelectOption('Letterhead','Letterhead'));
        MetadataComponentvalues.add(new SelectOption('Layout','Layout'));
        MetadataComponentvalues.add(new SelectOption('ListView','ListView'));
        MetadataComponentvalues.add(new SelectOption('PermissionSet','PermissionSet'));
        MetadataComponentvalues.add(new SelectOption('Portal','Portal'));
        MetadataComponentvalues.add(new SelectOption('Profile','Profile'));
        MetadataComponentvalues.add(new SelectOption('Queue','Queue')); 
        MetadataComponentvalues.add(new SelectOption('RecordType','RecordType'));
        MetadataComponentvalues.add(new SelectOption('RemoteSiteSetting','RemoteSiteSetting'));
        MetadataComponentvalues.add(new SelectOption('Report','Report'));
        MetadataComponentvalues.add(new SelectOption('ReportType','ReportType'));
        MetadataComponentvalues.add(new SelectOption('SharingReason','SharingReason'));
        MetadataComponentvalues.add(new SelectOption('SharingSet','SharingSet'));
        MetadataComponentvalues.add(new SelectOption('StaticResource','StaticResource'));
        MetadataComponentvalues.add(new SelectOption('Translations','Translations'));
        MetadataComponentvalues.add(new SelectOption('ValidationRule','ValidationRule'));
        MetadataComponentvalues.add(new SelectOption('WebLink','WebLink'));
        MetadataComponentvalues.add(new SelectOption('Workflow','Workflow'));
        MetadataComponentvalues.add(new SelectOption('WorkflowAlert','WorkflowAlert'));
        MetadataComponentvalues.add(new SelectOption('WorkflowFieldUpdate','WorkflowFieldUpdate'));
        MetadataComponentvalues.add(new SelectOption('WorkflowRule','WorkflowRule'));
        MetadataComponentvalues.add(new SelectOption('InstalledPackage','InstalledPackage'));            
        MetadataComponentvalues.add(new SelectOption('SharingCriteriaRule','SharingCriteriaRule'));
        MetadataComponentvalues.add(new SelectOption('SharingOwnerRule','SharingOwnerRule'));
        MetadataComponentvalues.add(new SelectOption('SharingTerritoryRule','SharingTerritoryRule'));
                // Components list that can be retrieved - End    
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);
        List<User> AlladminUsers = [select id,name from user where profileId in:profileIds.Keyset()];
        for(User usr : AlladminUsers )
        {
            Modifiedbyvalues.add(new SelectOption(usr.name ,usr.name));   
        }
        Modifiedbyvalues.sort();
        AlladminUsers.clear();
        profileIds.clear();
    }
    public PageReference loadMetadata()  {      // enables the JavaScript Remoting for Components retrieval  
        if(startdate!=null)
            startdatestr =startdate.format();
        else
            startdatestr ='';
        if(enddate!=null)
            enddatestr =enddate.format();
        else
            enddatestr ='';
        startload=true;
        components= String.join(selectedMetadataComponentvalues.size()==0?getSelection(MetadataComponentvalues):getSelection(selectedMetadataComponentvalues),';'); 
        if(getSelection(selectedModifiedbyvalues)!=null)
        Modifiedbyset=String.join(getSelection(selectedModifiedbyvalues),';'); 
        else
            Modifiedbyset=null;     
        callfunc='<script> getRemoteData(); </script>';
        return null;
    }
    public list<selectoption> getSelectedOption(List<String> picklistvalue)    {    //Prepares the list of selectoptions for the list of strings passed - Achieve Multi picklist feature
        list<selectoption> returnset = new list<selectoption>();
        for(String value : picklistvalue)  
        {        
            returnset.add(new selectoption(value,value)) ;         
        }     
        return returnset; 
    }
    public void removeSelectedOption(List<String> picklistvalue,List<Selectoption> picklistval)    {    // remove the selected options from selectlist - Achieve Multi picklist feature
        Set<SelectOption> tempSet = new Set<SelectOption>();
        tempset.addall(picklistval);
        tempset.removeall(getSelectedoption(picklistvalue));       
        picklistval.clear();       
        picklistval.addall(tempset);     
    }     
    public void selectModifiedBy()    {     // select the list of Modified by users options from Modifiedby selectlist - Achieve Multi picklist feature
        if(!Modifiedby.isempty()) 
        {     
           selectedModifiedbyvalues.addall(getSelectedoption(Modifiedby));
           selectedModifiedbyvalues.sort();
           removeSelectedoption(Modifiedby,Modifiedbyvalues); 
           Modifiedbyvalues.sort(); 
        }           
    }  
    public void removeModifiedBy()    {     // remove the list of Modified by users options from Modifiedby selectlist - Achieve Multi picklist feature
        if(!selectedModifiedby.isempty()) 
        {        
           Modifiedbyvalues.addall(getSelectedoption(selectedModifiedby));
           Modifiedbyvalues.sort();
           removeSelectedoption(selectedModifiedby,selectedModifiedbyvalues);
           selectedModifiedbyvalues.sort();  
        }     
    }
    public void selectComponent()    {      // select the list of components options from components selectlist - Achieve Multi picklist feature
        if(!MetadataComponents.isempty()) 
        {     
           selectedMetadataComponentvalues.addall(getSelectedoption(MetadataComponents));
           selectedMetadataComponentvalues.sort();
           removeSelectedoption(MetadataComponents,MetadataComponentvalues); 
           MetadataComponentvalues.sort(); 
        }           
    }  
    public void removeComponent()    {      // remove the list of Modified by users options from Modifiedby selectlist - Achieve Multi picklist feature
        if(!selectedMetadataComponents.isempty()) 
        {        
           MetadataComponentvalues.addall(getSelectedoption(selectedMetadataComponents));
           MetadataComponentvalues.sort();
           removeSelectedoption(selectedMetadataComponents,selectedMetadataComponentvalues);
           selectedMetadataComponentvalues.sort();  
        }     
    }
    public list<String> getSelection(list<SelectOption> selectedoptions)    {   //Prepares the list of strings for the list of selectoptions passed - Achieve Multi picklist feature
        list<String> options = new list<String>();
        for(SelectOption option:selectedoptions)
        {
            options.add(option.getValue());
        }
        return options;
    }
    @RemoteAction
    global static list<String> retrieveMetadata(Boolean startload,string components,string Modifiedbyset,string startdate,string enddate)    {   
    
    // Returns the list of components matching the search criteria as list of strings
    
        list<String> Installedpackages= new list<String>();
        
        VFC01_MetaDataAPIWSDLClass.SessionHeader_element SessionHeader = new VFC01_MetaDataAPIWSDLClass.SessionHeader_element();
        SessionHeader.sessionID = UserInfo.getSessionId();
        
        List<VFC01_MetaDataAPIWSDLClass.ListMetadataQuery> queries = new List<VFC01_MetaDataAPIWSDLClass.ListMetadataQuery>();        
        VFC01_MetaDataAPIWSDLClass.ListMetadataQuery queryValidationRule = new VFC01_MetaDataAPIWSDLClass.ListMetadataQuery();
        queryValidationRule.type_x = 'InstalledPackage';
        queries.add(queryValidationRule);       
        VFC01_MetaDataAPIWSDLClass.MetadataPort service = new VFC01_MetaDataAPIWSDLClass.MetadataPort();
        service.SessionHeader = SessionHeader;                    
        VFC01_MetaDataAPIWSDLClass.FileProperties[] result= service.listMetadata(queries, 34); 
        
        if(result!=null)
        for(VFC01_MetaDataAPIWSDLClass.FileProperties fileProperty : result)
        {
            Installedpackages.add(fileProperty.fullName.trim()+'__');
        }
        
        list<string> componentslist = new list<string> ();
        set<string> NewModifiedbyset = new set<string> ();
        
        // Start- workaround as Email Template,Report,dashboards are  not retrieved using MetaData API. 
        
        list<String> tobequeried= new list<String>(); 
        
        // End- workaround as Email Template,Report,dashboards are  not retrieved using MetaData API. 
        Date startDa=null;
        Date endDa=null;
        compNames = new list<String>();
        if(components!=null)        
        {
            if(Modifiedbyset!='')
                NewModifiedbyset.addall(Modifiedbyset.split(';',-1));
            if(startdate!='')
                startDa=date.parse(startdate);
            if(enddate!='')   
                endDa=date.parse(enddate); 
            componentslist=components.split(';',-1);            
            VFC01_MetaDataAPIWSDLClass.FileProperties[] fileProperties = new VFC01_MetaDataAPIWSDLClass.FileProperties[]{};
            Integer j =0;
            Map<Id,Folder> FolderMap= new Map<Id,Folder>([select id, developername from folder where developername !=null]);
            while(startload==true)
            {
                j=j+1;
                Set<String> types = new Set<String>();
                Integer noofcomp = componentslist.size()<3?componentslist.size():3;
                for(Integer i=0;i<noofcomp;i++)
                {
                    if(componentslist.get(0)!='EmailTemplate' && componentslist.get(0)!='Dashboard' && componentslist.get(0)!='Report' &&  componentslist.get(0)!='Document' )
                        types.add(componentslist.get(0));
                    
                    // Start- workaround as Email Template,Report,dashboards are  not retrieved using MetaData API.
                    
                    else
                        tobequeried.add(componentslist.get(0));
                   
                   // End- workaround as Email Template,Report,dashboards are  not retrieved using MetaData API.                        
                    
                    componentslist.remove(0);
                }
                
                
                // Start- workaround as Email Template,Report,dashboards are  not retrieved using MetaData API - This loop while executed only 4 Times maximum. i.e. Governor limit wont be reached any point.
                
                while(!tobequeried.isEmpty()) 
                {
                    String type=tobequeried.get(0);
                    String query='';
                    String CompFullname='';
                    if(type=='Report')
                        query='SELECT developername,lastmodifiedby.name,lastmodifieddate,NamespacePrefix,ownerid FROM '+ type + ' where id!=null and ownerid not in (select id from user)';
                    else
                        query='SELECT developername,lastmodifiedby.name,lastmodifieddate,NamespacePrefix,Folderid FROM '+ type + ' where id!=null and folderid not in (select id from user)';                    
                    if(!NewModifiedbyset.isEmpty())
                       query= query+' and lastmodifiedby.name in :NewModifiedbyset';
                    if(startda !=null )
                        query=query+' and lastmodifieddate >= :startda';
                    if(endda !=null )
                        query=query+' and lastmodifieddate <=  :endda';
                    if(type=='EmailTemplate')
                        for(EmailTemplate obj : Database.query(query))
                        {
                            if(FolderMap.containsKey(obj.Folderid)) 
                                CompFullname=FolderMap.get(obj.Folderid).developername+'/'+obj.developername;
                            else
                                CompFullname='unfiled$public/'+obj.developername;
                            compNames.add(type+';;'+ CompFullname +';;'+ obj.lastmodifiedby.name +';;'+ obj.lastmodifieddate+';;'+ obj.NamespacePrefix);         
                        }
                    else if(type=='Report')
                        for(Report obj : Database.query(query))
                        {
                            if(FolderMap.containsKey(obj.Ownerid)) 
                                CompFullname=FolderMap.get(obj.Ownerid).developername+'/'+obj.developername;
                            else
                                CompFullname='unfiled$public/'+obj.developername;
                            compNames.add(type+';;'+ CompFullname +';;'+ obj.lastmodifiedby.name +';;'+ obj.lastmodifieddate+';;'+ obj.NamespacePrefix);         
                        }                     
                    else if(type=='Dashboard')
                        for(Dashboard obj : Database.query(query))
                        {
                            if(FolderMap.containsKey(obj.Folderid)) 
                                CompFullname=FolderMap.get(obj.Folderid).developername+'/'+obj.developername;
                            else
                                CompFullname='unfiled$public/'+obj.developername;
                            compNames.add(type+';;'+ CompFullname +';;'+ obj.lastmodifiedby.name +';;'+ obj.lastmodifieddate+';;'+ obj.NamespacePrefix);         
                        }
                    else
                     for(Document obj : Database.query(query))
                        {
                            if(FolderMap.containsKey(obj.Folderid)) 
                                CompFullname=FolderMap.get(obj.Folderid).developername+'/'+obj.developername;
                            else
                                CompFullname='unfiled$public/'+obj.developername;
                            compNames.add(type+';;'+ CompFullname +';;'+ obj.lastmodifiedby.name +';;'+ obj.lastmodifieddate+';;'+ obj.NamespacePrefix);         
                        }   
                    tobequeried.remove(0);
                }
                
                 // End - workaround as Email Template,Report,dashboards are  not retrieved using MetaData API.
                 
                 
                if(componentslist.isEmpty()) 
                    startload=false;
                if(!types.isEmpty())
                {
                    queries = new List<VFC01_MetaDataAPIWSDLClass.ListMetadataQuery>();        
                    for(String type : types)
                    {
                        queryValidationRule = new VFC01_MetaDataAPIWSDLClass.ListMetadataQuery();
                        queryValidationRule.type_x = type;
                        queries.add(queryValidationRule);
                    }
                    result= service.listMetadata(queries, 34);
                    if(result!=null)
                    for(VFC01_MetaDataAPIWSDLClass.FileProperties fileProperty : result)
                    {                        
                        if(NewModifiedbyset.isEmpty() || (!NewModifiedbyset.isEmpty() && NewModifiedbyset.contains(fileProperty.lastModifiedByName)))            
                        if( fileProperty.lastModifiedDate.date() >= startda || startda ==null ) {
                            if( fileProperty.lastModifiedDate.date() <= endda || endda ==null )  { 
                                
                                //ReportFolder,DashboardFolder,DocumentFolder,EmailFolder should be defined as Report,Dashboard,Document,EmailTemplate respectively in the package.xml for Package Retrieval
                                
                                if(fileProperty.type_x.trim().equalsIgnoreCase('ReportFolder')) {
                                    compNames.add('Report;;'+fileProperty.fullName.trim() +';;'+fileProperty.lastModifiedByName +';;'+fileProperty.lastModifiedDate+';;'+fileProperty.namespacePrefix);
                                }
                                else if(fileProperty.type_x.trim().equalsIgnoreCase('DashboardFolder')) {
                                    compNames.add('Dashboard;;'+fileProperty.fullName.trim() +';;'+fileProperty.lastModifiedByName +';;'+fileProperty.lastModifiedDate+';;'+fileProperty.namespacePrefix);
                                }
                                else if(fileProperty.type_x.trim().equalsIgnoreCase('EmailFolder')) {
                                    compNames.add('EmailTemplate;;'+fileProperty.fullName.trim() +';;'+fileProperty.lastModifiedByName +';;'+fileProperty.lastModifiedDate+';;'+fileProperty.namespacePrefix);
                                }
                                else if(fileProperty.type_x.trim().equalsIgnoreCase('DocumentFolder'))  {
                                    compNames.add('Document;;'+fileProperty.fullName.trim() +';;'+fileProperty.lastModifiedByName +';;'+fileProperty.lastModifiedDate+';;'+fileProperty.namespacePrefix);
                                }
                                else    {
                                    compNames.add(fileProperty.type_x.trim()+';;'+fileProperty.fullName.trim() +';;'+fileProperty.lastModifiedByName +';;'+fileProperty.lastModifiedDate+';;'+fileProperty.namespacePrefix);         
                                }   
                            }
                        }   
                    }                      
                }
             }   
         }
         
         if(!Installedpackages.isEmpty() && !compNames.isEmpty() ) 
         {
             compNames.add(';;;'+String.join(Installedpackages,';'));
         }
         return compNames;       
    }
    public pagereference toRender()    {    // To Re render the page after the result
        startload=false;    
        callfunc='';
        return null;
    }
}