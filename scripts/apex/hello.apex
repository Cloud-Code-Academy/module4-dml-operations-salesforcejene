// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

String tempvar = 'Jene T.';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);

    /* upsert account 
    if no acc, insert acct w description 'New Account'
    otherwise update desc w 'Update Account'*/


    String accountName = 'J Test Account';
    List <Account> accList = [SELECT Id, Name, Description FROM Account WHERE Name = :accountName];
    System.debug('Query has '+ accList.size() +  ' results: ');
    System.debug('Query has '+ accList.size() +  ' results: ');

    //build new object instance to take action
    Account myAcct;
    
    
    //does record exist, update description
    if (accList.isEmpty()){
        myAcct = new Account (Name = accountName);
        myAcct.Description = 'New Account';
        System.debug('New Acct Descr is: '  + myAcct.Description);
        System.debug('Acct Id is: '         + myAcct.Id);

    } else {
        myAcct = accList[0];
        myAcct.Description = 'Updated Account';
        System.debug('New Acct Descr is: ' + myAcct.Description);
        System.debug('Acct Id is: '        + myAcct.Id);
    }
    upsert myAcct;

    System.debug('The Description is '  + myAcct.Description);
    System.debug('The Account Name is ' + myAcct.Name);
    System.debug('Acct Id is: '         + myAcct.Id);

String conLastName = 'Fuller';
List <Contact> conList = [SELECT Id, FirstName, LastName, Account.Name, AccountId FROM Contact WHERE Account.Name = :conLastName];
System.debug('Contacts returned: ' + conList);
System.debug('Query has '+ conList.size() +  ' result(s): ');

//Add new Account based on Contact's Last Name
//find contacts where lastName does not equal Account name
List <Contact> cList = [SELECT Id, FirstName, LastName, Account.Name, AccountId FROM Contact] WWHERE Account.Name IN (conLastName);
System.debug('Contacts returned: ' + cList);
System.debug('Query has '+ cList.size() +  ' result(s): ');

