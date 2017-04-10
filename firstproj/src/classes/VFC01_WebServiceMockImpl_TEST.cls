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
global class VFC01_WebServiceMockImpl_TEST implements WebServiceMock {
//==============================================================================================================================================
// ====== M.E.T.H.O.D 
//==============================================================================================================================================
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType)    // Create response element from the WSDL class and Populate response element. 
    {   
        // WSDL class code Coverage
        
        VFC01_MetaDataAPIWSDLClass.DebuggingInfo_element debug = new VFC01_MetaDataAPIWSDLClass.DebuggingInfo_element();
        VFC01_MetaDataAPIWSDLClass.CallOptions_element options = new VFC01_MetaDataAPIWSDLClass.CallOptions_element();
        VFC01_MetaDataAPIWSDLClass.DebuggingHeader_element debugHeader = new VFC01_MetaDataAPIWSDLClass.DebuggingHeader_element();
        VFC01_MetaDataAPIWSDLClass.LogInfo log = new VFC01_MetaDataAPIWSDLClass.LogInfo();
        
        // Fake Callout Response Generation
        
        VFC01_MetaDataAPIWSDLClass.listMetadataResponse_element respElement = new VFC01_MetaDataAPIWSDLClass.listMetadataResponse_element();
        VFC01_MetaDataAPIWSDLClass.FileProperties result = new VFC01_MetaDataAPIWSDLClass.FileProperties();
        result.fullName = 'Mock Callout';
        result.lastModifiedById = 'Mock Callout';
        result.lastModifiedByName = 'Mock Callout';
        result.lastModifiedDate = system.now();
        result.type_x = 'Mock Callout';
        result.namespacePrefix = 'Mock Callout';
        result.createdById = 'Mock Callout';
        result.createdByName = 'Mock Callout';
        result.createdDate = system.now();
        result.fileName = 'Mock Callout';        
        result.id = 'Mock Callout';
        result.manageableState = 'Mock Callout';
        respElement.result = new list<VFC01_MetaDataAPIWSDLClass.FileProperties>();
        respElement.result.add(result);
        response.put('response_x', respElement); 
    }   
}