public  class ContactPaymentsController {

	
	public List<Contact> contacts {get;set;} 
	
	
 	public ContactPaymentsController()
 	{
	
		this.contacts = [Select c.Total_Paid__c, c.Name, c.Last_Payment_Date__c, (Select name, amount__c, Date__c, Project__c From Payments__r limit 5) From Contact c where Total_Paid__c > 0  limit 10];  		
 	}
 	
 	public PageReference save()
    {

   		List<Payments__c> payments = new List<Payments__c>();
   		for (Contact c : this.contacts){
   			if(c.Payments__r.size()==0) { // should never happen.
   				continue;
   			}
   			for (Payments__c payment: c.Payments__r){
   				
   				payments.add(payment);
   			}
   		}
   		update (payments);
      
     PageReference result=ApexPages.currentPage();
     result.setRedirect(true);
      
     return result;
    }
 	
}