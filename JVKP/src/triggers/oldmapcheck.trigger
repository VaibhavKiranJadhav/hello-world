trigger oldmapcheck on Opportunity (before update)
{
  for(Opportunity opp:trigger.new)
  
  {
   opportunity oldopp = trigger.oldmap.get(opp.id);
   
   boolean newoppIsWon = opp.stagename.equals('Closed Won');
   boolean oldoppIsWon = oldopp.stagename.equals('Closed Won');
   
   if(!oldoppIsWon&&newoppIsWon )
   {
   Opp.oldmap_check__c = true;
   
   }
  
  
  }



}