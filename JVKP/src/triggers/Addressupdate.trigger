trigger Addressupdate on Account (After Update) 
{
 if(checkRecursive.runOnce())
    {
    
     List<Account> accountsWithDuplicateaccs = [select id, name, (select id,Address__c,

                                                                Account_Name__c from Duplicate_Accounts__r)

                                                                from Account];
                                                                
  
    List<Duplicate_Account__c> DupAcctobeupdated =new List<Duplicate_Account__c>();
    for(Account a :accountsWithDuplicateaccs)
       {
       
          for(Duplicate_Account__c d : a.Duplicate_Accounts__r )
          
            {
              a.Address_Line_1__c = d.Address__c;
              
              
              
            }
            

       }
       update accountsWithDuplicateaccs ;
          
   
}

}