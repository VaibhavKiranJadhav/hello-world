@isTest
Private class checkRecursiveTest
{
  static testmethod void myunittest()
  {
  
  Account acc =new Account();
  acc.name = 'vaibhavkiran';
  insert acc;
  
   Duplicate_Account__c dacc = new Duplicate_Account__c ();
   dacc.name ='Kiran1';
   dacc.Date__c = Date.today();
   dacc.MD_Relation_with_Account__c = acc.id;
   insert dacc;
   
   Duplicate_Account__c dacc1 = new Duplicate_Account__c ();
   dacc1.name ='Kiran2';
   dacc1.Date__c = dacc.Date__c.adddays(30);
   dacc1.MD_Relation_with_Account__c = dacc.MD_Relation_with_Account__c;
   insert dacc1;
   
    Duplicate_Account__c dacc2 = new Duplicate_Account__c ();
   dacc2.name ='Kiran3';
   dacc2.Date__c = dacc.Date__c.adddays(60);
   dacc2.MD_Relation_with_Account__c = dacc.MD_Relation_with_Account__c;
   insert dacc2;
  
   Duplicate_Account__c dacc3 = new Duplicate_Account__c ();
   dacc3.name ='Kiran4';
   dacc3.Date__c = dacc.Date__c.adddays(90);
   dacc3.MD_Relation_with_Account__c = dacc.MD_Relation_with_Account__c;
   insert dacc3;
  
  }

}