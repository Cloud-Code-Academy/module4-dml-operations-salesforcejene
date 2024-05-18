// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Jene T.';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);

//insert account using dml

// Account myAcc = New Account (Name = 'Jenes Account');
// System.debug('Intial Account info: ' + myAcc);
// insert myAcc;
// System.debug('Ending Account info: ' + myAcc);

// //update account
// myAcc.Name = 'myJene.com' + String.valueOf(Datetime.now().getTime());
// myAcc.BillingCity='North Arlington';
// myAcc.description = 'Updated by APEX!';
// update myAcc;
// System.debug('Name of Account updated:' + myAcc);

// Create a new Account and set the fields inline
Account acc = New Account(Name='Acct by Code', industry ='Technology');
System.debug('New acct added: ' + acc);
// Insert the Account
insert acc;
System.debug('AFter the acct was added: ' + acc);
