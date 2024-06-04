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
// Account acc = New Account(Name='Acct by Code', industry ='Technology');
// System.debug('New acct added: ' + acc);
// // Insert the Account
// insert acc;
// System.debug('AFter the acct was added: ' + acc);

public static void upsertOpportunities(String accountName, List<String> oppNames) {
        // Loop through each Opportunity name
        // Create an Opportunity with the given name
        // Add the Opportunity to the list  


        //need list to store opps
        List <String> oppList = new List <String> {'XYZ Opp', 'XYZ Opp 2', 'XYZ Opp 3', 'XYZ Opp 4'};

        //instantiate Account
        String accName ='XYZ Account';
        Account acc = new Account(Name= accName);
        insert acc;

        //loop thru opps
        for (String opp: oppList){
             Opportunity o = New Opportunity();
            //add opp fields
            o.Name      = opp;
            o.StageName = 'Prospecting';
            o.Amount    = 127000;
            o.CloseDate = Date.today().addMonths(4);
            o.AccountId = acc.Id;

            //add opps to list
            // oppList.add(o);
            upsert opp;

            System.debug('Contents of o ' + o);
            System.debug('Contents of opp ' + opp);
            System.debug('Contents of oppList ' + oppList);           
        }
        System.debug('Contents of o ' + o);
        System.debug('Contents of opp ' + opp);
        System.debug('Contents of oppList ' + oppList);
        
    }

    //Generate an Account with the given name
        Account acc = new Account(Name = 'XYZ Account');
        insert acc;

        //Store opps in list
        List <Opportunity> oppList = new List <Opportunity>();

        //loop through each Opp
        For (Opportunity opp : oppList){
            Opportunity o   = new Opportunity ();
                o.Name      = 'XYZ Opp';
                o.StageName = 'Prospecting';
                o.Amount    = 100000;
                o.CloseDate = Date.today().addMonths(4);
                o.AccountId = acc.Id;

            upsert o;
            System.debug('Contents of o ' + o);
            System.debug('Contents of opp ' + opp);
            System.debug('Contents of oppList ' + oppList);

            //Add opps to list
            // oppList.add(o);
            // System.debug('Contents of o ' + o);
            // System.debug('Contents of opp ' + opp);
            // System.debug('Contents of oppList ' + oppList);
        }
        // upsert oppList;        
        // System.debug('Contents of oppList ' + oppList);

//add test account
Account acc = new Account (Name ='Test Account');
insert acc;
System.debug(acc);


	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id, Description FROM Account WHERE Name = :accountName];

		// if the Account exists, update the description
        if (accounts.size()>0){
            accounts.Description = 'Updated Account';
        } else {
            // otherwise, create a new Account and set the description
            Account newAcc = New Account (Name = accountName);
            newAcc.Description = 'New Account';
            insert newAcc;
        }
        accounts.add(newAcc);
		// Upsert the Account
        upsert accounts;

		return accounts;
	}
    /* upsert account 
    if no acc, insert acct w description 'New Account'
    otherwise update desc w 'Update Account'*/

    Account queryAcc = [SELECT Id, Name, Description FROM Account WHERE Name = 'Test Account' AND Id ='0015f00002L0Y3sAAF'];

    //build new object instance to take action
    Account myAcct = new Account(Name = 'Test Account');

    //does record exist, update description
    if (queryAcc == null){
        myAcct.Description = 'New Account';
    } else {
        myAcct.Description = 'Updated Account';
    }
    upsert myAcct;

    System.debug('The Description is ' + queryAcc.Description);
    System.debug('The Account Name is ' + queryAcc.Name);

    


