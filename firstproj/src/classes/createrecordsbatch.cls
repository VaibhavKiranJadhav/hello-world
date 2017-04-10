global class createrecordsbatch implements database.batchable<sobject>{


 

 global Database.Querylocator start (Database.BatchableContext BC) {

     return Database.getQuerylocator('select id,name,date__c,MD_Relation_with_Account__c from Duplicate_Account__c where date__c=today');

  }

  

  global void execute (Database.BatchableContext BC, List<Duplicate_Account__c> scope) {

    system.debug('list************'+scope);

      List<Duplicate_Account__c > DList = new List<Duplicate_Account__c >();

    List<Duplicate_Account__c > updatedDList = new List<Duplicate_Account__c >();

    for (Duplicate_Account__c objScope: scope) { 

        //if(objScope.status__c=='Open')

        //{

        Duplicate_Account__c newObjScope = objScope ;//type casting from generic sOject to Duplicate_Account__c 

        newObjScope.status__c = 'Closed';

        updatedDList.add(newObjScope);

        Database.update(updatedDList);

        Duplicate_Account__c dup=new Duplicate_Account__c() ;

                        dup.name=newObjScope.name+'Batch';

                        dup.MD_Relation_with_Account__c=newObjScope.MD_Relation_with_Account__c;

                        dup.Date__c=newObjScope.Date__c.addDays(120);

                    system.debug('Duplicate Account Date'+newObjScope.Date__c);

                    system.debug('Duplicate Account Date Added'+newObjScope.Date__c.addDays(30));

                    DList.add(dup);

        //}

        

        

    } 

    if (updatedDList != null && updatedDList.size()>0){

            Database.update(updatedDList); 

            System.debug('List Size '+updatedDList.size());

      }

      if(DList!= null)

      {

          System.debug('DLIST IS'+Dlist);

          Database.insert(DList,true);

      }

    }

      global void finish(Database.BatchableContext BC){

    }

 

  

  }