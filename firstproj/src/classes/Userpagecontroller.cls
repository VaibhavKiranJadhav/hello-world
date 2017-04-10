public with sharing class Userpagecontroller 
{


public string user{get;set;}
Public string lastname{get;set;}
Public string username{get;set;}
Public string password{get;set;}
Public string Alias{get;set;}
Public string CommunityNickname {get;set;}
 public String Roleval{get;set;}
public String selectedEncodingVal{get;set;}   
public String LocaleVal{get;set;} 
public String LanguageVal{get;set;} 
public String Profileval{get;set;} 
 Public string Email{get;set;}
Public string message{get;set;}
Public string TimeZoneVal{get;set;}
Public string UserLicenseVal{get;set;}

public List<SelectOption> getEncodingOtptions()
    {
        List<SelectOption> optns = new List<Selectoption>();
        String[] encodingArr = new String[]{'UTF-8','Japanese(Shift-JIS)' };
        for(String obj : encodingArr)
        {
          optns.add(new selectOption(obj, obj));
        }            
      return optns;
    } 
    
    public List<SelectOption> getLocaleOtptions()
    {
        List<SelectOption> optns = new List<Selectoption>();
        String[] LocaleArr = new String[]{'en_US' };
        for(String obj : LocaleArr)
        {
          optns.add(new selectOption(obj, obj));
        }            
      return optns;
      }
      
      public List<SelectOption> getProfileOtptions()
    {
        List<SelectOption> optns = new List<Selectoption>();
        if(UserLicenseVal==Null)
        { 
        List<Profile> ProfileList =[select name from Profile];
        for(Profile profobj :ProfileList)
         {
           optns.add(new selectoption(profobj.id, profobj.name));
         }
        }
        else
          {
          string LicenseIdentifier = [select id from UserLicense where name =:UserLicenseVal].get(0).id;
          List<Profile> proflist =[select id,name from Profile where UserLicenseid =:LicenseIdentifier];
          for(Profile usrprof: proflist)
            {
            optns.add(new selectoption(usrprof.id,usrprof.name));
            
            }
           } 
          return optns;
          
        
        }
     
     
      public List<SelectOption> getLanguageOtptions()
    {
        List<SelectOption> optns = new List<Selectoption>();
        String[] LAnguageArr = new String[]{'en_US','en_GB' };
        for(String obj : LanguageArr)
        {
          optns.add(new selectOption(obj, obj));
        }            
      return optns;
      
      }
       public List<SelectOption> getUserLicenseOtptions()
    {
        List<SelectOption> optns = new List<Selectoption>();
        List<Userlicense> usrlic = [select id ,name from Userlicense];
        for(Userlicense usr : usrlic)
        {
          optns.add(new selectOption(usr.name, usr.name));
        }            
      return optns;
      
      }
       public List<SelectOption> getTimeZoneOtptions()
    {
        List<SelectOption> optns = new List<Selectoption>();
        String[] TimeZoneArr = new String[]{'GMT' };
        for(String obj : TimeZoneArr)
        {
          optns.add(new selectOption(obj, obj));
        }            
      return optns;
      
      }
      
       public List<SelectOption> getRoleOtptions()
   {
        List<SelectOption> optns = new List<Selectoption>();
       
        
        List<Userrole> UserroleList =[select name,id from Userrole];
        for(Userrole Roleobj :UserroleList)
         {
           optns.add(new selectoption(Roleobj.id, Roleobj.name));
         }
        
           
           
          return optns;
          
        }
        
     
     
     
      


    public void  save()
{
user u=new user();
system.debug('entered into loop');
u.username=username;
system.debug('username---'+username);
u.lastname=lastname;
u.Alias=Alias;
u.email=email;
u.EmailEncodingKey = selectedEncodingVal;
u.ProfileId = ProfileVal;
u.LanguageLocaleKey= LanguageVal;
u.LocaleSidKey =LocaleVal;
u.userroleid = RoleVal;

u.TimeZoneSidKey =TimeZoneVal;



  insert(u);

}

  
}