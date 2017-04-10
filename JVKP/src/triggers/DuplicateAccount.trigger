trigger DuplicateAccount on Account (After Insert,After update)
 {
 List<Duplicate_Account__c> dup = new list<Duplicate_Account__c>();
 for(Account a:trigger.new)
 {
 Duplicate_Account__c   d =new Duplicate_Account__c();
 d.name = a.Name;
 
 dup.add(d);
 
 
 }
 
 insert dup;

}