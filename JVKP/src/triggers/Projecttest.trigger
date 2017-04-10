trigger Projecttest on Projects__c (before update,after insert) 
{

list<Projects__c > proj =new list<Projects__c >();

  for(Projects__c pr : trigger.new)
  {
    system.debug('trigger.old:' +proj.size());
  system.debug('trigger.new:'+trigger.new);
  }
}