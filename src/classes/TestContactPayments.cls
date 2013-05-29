@isTest
public  class TestContactPayments {


 static testMethod void testContactPaymentsController() {
 	
 	  	 test.startTest(); 
 	  	 List<Contact> contacts = new List<Contact>();
 	  	 
 	 	Contact c1 = new Contact(Firstname = 'howard', 
                                lastname='johnson');
        Contact c2= new Contact(Firstname = 'sarah', 
                                lastname='smith');
       	contacts.add(c1);
       	contacts.add(c2);
       	
        insert contacts;
        
        Project__c p1 = new Project__c (name='Project1');
        insert p1;
        
        Payments__c pay1 = new Payments__c(amount__c=100,
        						date__c = System.Today().addDays(-7),
                                contact__c = c1.id,
                                project__c = p1.id);
        Payments__c pay2 = new Payments__c(amount__c=120,
        						date__c = System.Today().addDays(-5),
                                contact__c = c1.id,
                                project__c = p1.id);
         List<Payments__c> payments = new List<Payments__c>();
        payments.add(pay1);
        payments.add(pay2);
       	 insert payments;
       	
        ContactPaymentsController controller = new ContactPaymentsController ();
        controller.save();
         test.stoptest();
        
  } 
  static testMethod  void testTriggers()
  {
  	     test.startTest();
  	
  		List<Contact> contacts = new List<Contact>();
  	   Contact c1 = new Contact(Firstname = 'howard', 
                                lastname='johnson');
        Contact c2= new Contact(Firstname = 'sarah', 
                                lastname='smith');
       	contacts.add(c1);
       	contacts.add(c2);
       	         
        insert contacts;
      
        Project__c p1 = new Project__c (name='Project1');
        Project__c p2 = new Project__c (name='Project2');
         
         List<Project__c> projects = new List<Project__c>();
         projects.add(p1);
         projects.add(p2);
         insert projects;
        
        Payments__c pay1 = new Payments__c(amount__c=100,
        						date__c = System.Today().addDays(-7),
                                contact__c = c1.id,
                                project__c = p1.id);
        Payments__c pay2 = new Payments__c(amount__c=120,
        						date__c = System.Today().addDays(-5),
                                contact__c = c1.id,
                                project__c = p2.id);
         Payments__c pay3 = new Payments__c(amount__c=100,
        						date__c = System.Today().addDays(-3),
                                contact__c = c1.id,
                                project__c = p1.id);
        Payments__c pay4 = new Payments__c(amount__c=50,
                				date__c = System.Today().addDays(+1),
        
                                contact__c = c2.id,
                                project__c = p1.id);
           Payments__c pay5 = new Payments__c(amount__c=51,
           						date__c = System.Today().addDays(+2),
                                contact__c = c2.id,
                                project__c = p2.id);
      
        List<Payments__c> payments = new List<Payments__c>();
        payments.add(pay1);
        payments.add(pay2);
        payments.add(pay3);
        payments.add(pay4);
        payments.add(pay5);
        insert payments;
        delete pay5;
  	    test.stoptest();
	 Map  <Id,Contact> contactsById = new  Map<Id,Contact> ([select c.name, c.Total_Paid__c, c.Last_Payment_Date__c from contact c  ]);
  	 Contact result1 =  contactsById.get(c1.id);
  	 System.assert(result1.total_paid__c ==320);
  	 System.assert(result1.Last_Payment_Date__c ==System.Today().addDays(-3));
  	 
  	 Contact result2 =  contactsById.get(c2.id); 
  	 System.assert(result2.total_paid__c ==50);
  	 System.assert(result2.Last_Payment_Date__c ==System.Today().addDays(+1));
  	 
  	 
  	 Map  <Id,Project__c> projectsById = new  Map<Id,Project__c> ([select p.name, p.Total_Amount_For_Project__c from Project__c p  ]);
  	 Project__c projectResult =  projectsById.get(p1.id);
  	 System.assert(projectResult.Total_Amount_For_Project__c ==250);
  	 Project__c projectResult2 =  projectsById.get(p2.id);
  	  System.assert(projectResult2.Total_Amount_For_Project__c ==120);
        
  }
}