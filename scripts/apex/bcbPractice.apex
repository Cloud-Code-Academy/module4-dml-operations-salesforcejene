

List<Contact> testContacts = new List<Contact>{
    new Contact(LastName = 'Blue', FirstName = 'Girl'),
    new Contact(LastName = 'Blue', FirstName = 'Boy')
};

DMLOperations.upsertAccountsWithContacts(testContacts);


List<String> sampleLeads = new List<String>{
    'Lead 5 Test',
    'Lead 6 Tester'
};

DMLOperations.insertAndDeleteLeads(sampleLeads);

DMLOperations.createAndDeleteCases('001ak00000YX7AQAA1', 3);

String accountId = '001ak00000YX7AQAA1';
Integer numOfCases = 2;


List <Case> addCases = New List <Case>();

for (Integer i = 0; numOfCases > i; i++){
    Case newCase = new Case(Subject = 'Auto Generated from Code ', Priority = 'High');
    addCases.add(newCase);    
    accountId = newCase/accountId';
    //validate
    System.debug('Inside Cases loop');
}
insert addCases;
newAccts.Id = acctNum;
System.debug('Insert Outside Cases loop');

// Delete the cases
if (addCases.size() >= 0){
    //count prior to deletion
    System.debug ('Prior to deletek there were ' + addCaes.size() + ' cases remaining');
    delete addCases;
    //count after deletion
    System.debug('After delete, there are ' + addCaes.size()  +' Cases remaining');
}