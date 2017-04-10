/*
*                                                                                                   *
*                            Version 1.00                                                           *
*                                                                                                   *
* Creation Date: 16.Apr.2015                    m.anandhan                                          *
* Last Modified: 16.Apr.2015                    m.anandhan                                          *
*                                                                                                   *
*                             © 2008 - Accenture - All Rights Reserved                              *


*/

@IsTest
private with sharing class VFC01_MetaDataExtractor_TEST {
//==============================================================================================================================================
// ====== T.E.S.T M.E.T.H.O.D 
//==============================================================================================================================================
    private static testMethod void metaDataAPITestMethod() //Test Method for VFC01_MetaDataExtractor 
    {   
        //Setting VFC01_WebServiceMockImpl_TEST Webservice as Mock class to receive fake response for callout 
        
        System.Test.setMock(WebServiceMock.class, new VFC01_WebServiceMockImpl_TEST());
        
        // Initialize controller variables and invoke methods
        
        VFC01_MetaDataExtractor  ControllerObj = new VFC01_MetaDataExtractor();
        ControllerObj.startdate = system.today()-10;
        ControllerObj.enddate = system.today()+1;
        ControllerObj.loadMetadata();
        
        ControllerObj.Modifiedby = new List<String>();
        ControllerObj.selectedModifiedby = new List<String>();
        ControllerObj.Modifiedby.add('User A');
        ControllerObj.selectedModifiedby.add('User A');
        ControllerObj.selectModifiedBy();
        ControllerObj.removeModifiedBy();
         
        ControllerObj.selectedMetadataComponents = new List<String>();
        ControllerObj.MetadataComponents = new List<String>();
        ControllerObj.selectedMetadataComponents.add('ApexClass');
        ControllerObj.MetadataComponents.add('ApexClass');
        ControllerObj.selectComponent();
        ControllerObj.removeComponent(); 
                    
        ControllerObj.toRender();
        string startdate = ControllerObj.startdate.format();
        string enddate = ControllerObj.enddate.format();
        string components = 'ApexClass;ApexPage;Report;Document;Dashboard;EmailTemplate;DashboardFolder;ReportFolder;DocumentFolder;EmailFolder';
        string Modifiedbyset = '';
        
        // Fake Callout response received from the Mock class
        
        List<String> response = VFC01_MetaDataExtractor.retrieveMetadata(true,components,Modifiedbyset,startdate,enddate);
        
        // Test that the response correctly received from the method

        System.assert( response.size() >= 1,'Test Result' );
    }
}