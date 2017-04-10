trigger SendAccount on Account(after insert)
{
    for(Account a : Trigger.new){
    SendAccountFromSource.createAccount(a.Name, a.Id);
    }
}