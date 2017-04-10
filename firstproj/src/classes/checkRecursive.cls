public Class checkRecursive{
    public static boolean run = true;
    
    public void CreationOfChild(list<Duplicate_Account__c> dalist,integer i)
    
    {
    
    for(Duplicate_Account__c da:dalist)
      {
      
       //Duplicate_Account__c duacc=[select date__c from Duplicate_Account__c where MD_Relation_with_Account__c= :da.MD_Relation_with_Account__c order by date__c DESC limit 1 ];     
         //system.debug('List Of Account Childs'+duacc);
         
          date dt=date.today();   
          
           Duplicate_Account__c  dupapp= new Duplicate_Account__c ();
            dupapp.Name = da.Name;
            dupapp.MD_Relation_with_Account__c= da.MD_Relation_with_Account__c;
            //dupapp.Date__c = duacc.Date__c.adddays(30);
           // system.debug('Dupluicate Account Date'+duacc.date__c);
            //system.debug('Dupluicate Account Date Added'+duacc.date__c.addDays(30));
            dupapp.Date__c = dt.adddays(i*30);
           //duplilist.add(dupapp);    
           insert dupapp;   

    
      }
    }
 
 }