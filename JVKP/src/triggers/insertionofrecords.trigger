trigger insertionofrecords on Duplicate_Account__c (after insert)
{
  checkRecursive hepler = new checkRecursive();


    if(checkRecursive.run)
    {
      checkRecursive.run=false;
      if(Trigger.isInsert && Trigger.isAfter)
      
      {
      integer i=1;
      while(i<=3)
      
      {
        hepler.CreationOfChild(Trigger.new,i);
        i=i+1;
      
      }
     
      }
       
     }
   
  
}