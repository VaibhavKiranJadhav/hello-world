@isTest
Private class createrecordsbatchTest
{

 static testmethod void myunittest1()
  {
  
  Account acc =new Account();
  acc.name = 'vaibhavkiran2';
  insert acc;
  
  list<duplicate_account__c> dacc=new list<duplicate_account__c>();
  duplicate_account__c dup=new duplicate_account__c ();
  dup.MD_Relation_with_Account__c=acc.id;
  dup.date__c=system.today();
  dacc.add(dup);
  insert dacc;
  
  createrecordsbatch cb=new createrecordsbatch ();
  database.executebatch(cb);
  
 }
}