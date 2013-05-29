trigger UpdateContactPayments on Payments__c (after insert, after update, after delete) {
	
	
	SET<ID> contactKeys = new SET<ID>();
	SET<ID> projectKeys = new SET<ID>();
	
	  Map<id,List<Payments__c>> contactsToPayments = new Map<id,List<Payments__c>>();
	  if (Trigger.isInsert || Trigger.isUpdate) {
	  	 for (Payments__c payment: System.Trigger.new) {
	  	 	contactKeys.add(payment.Contact__c);
	  	 	projectKeys.add(payment.Project__C);
	  	 }
	  }
	  else { // is delete
	  	for (Payments__c payment: System.Trigger.old) {
	  		contactKeys.add(payment.Contact__c);
	  		projectKeys.add(payment.Project__C);
	  		
	  	}
	  }
	 Map  <Id,Contact> contactsToUpdate = new  Map<Id,Contact> ([select c.name, c.Total_Paid__c, c.Last_Payment_Date__c from contact c where c.id in :contactKeys  ]);
	 for (Contact contact: contactsToUpdate.values()) {
	 	contact.Total_Paid__c = 0;
	 	contact.Last_Payment_Date__c = null;
	 }
	 
	 AggregateResult[] sumPaymentAmounts = [SELECT  p.Contact__c, SUM(p.amount__c)total FROM Payments__c p where p.Contact__c in :contactKeys GROUP BY p.Contact__c];

	for (AggregateResult result: sumPaymentAmounts) {
		Id id = (Id)result.get('Contact__c');
		Decimal total = (Decimal)result.get('total');
 		Contact c = contactsToUpdate.get(id);
 		c.Total_Paid__c=total;
	  	
	}
    AggregateResult[] maxDates = [SELECT  p.Contact__c, MAX(p.Date__c)recent FROM Payments__c p where p.Contact__c in :contactKeys GROUP BY p.Contact__c];
	for (AggregateResult result: maxDates) {
		Id id = (Id)result.get('Contact__c');
		Date recent = (Date)result.get('recent');
 		Contact c = contactsToUpdate.get(id);
 		c.Last_Payment_Date__c=recent;
	  	
	}
	// something aggregate classe cannot be summed properly taposdifj
	// lnk ehere
	update contactsToUpdate.values();
	
	Map  <Id,Project__c> projectsToUpdate = new  Map<Id,Project__c> ([select p.id, p.Total_Amount_For_Project__c From Project__c p where p.id in :projectKeys  ]);
	for (Project__c project: projectsToUpdate.values()) {
	 	project.Total_Amount_For_Project__c = 0;
	 }
	AggregateResult[] sumPaymentAmountsByProject = [SELECT  p.project__c, SUM(p.amount__c)total FROM Payments__c p where p.Project__c in :projectKeys GROUP BY p.Project__c];

	for (AggregateResult result: sumPaymentAmountsByProject) {
		Id id = (Id)result.get('project__c');
		Decimal total = (Decimal)result.get('total');
 		Project__c p = projectsToUpdate.get(id);
 		p.Total_Amount_For_Project__c=total;
	  	
	}
	update projectsToUpdate.values();
}