

public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
    list <Contact> con
    Account testAccount = new Account (Name = 'Doe');
    insert testAccount;

    // Create test contacts with last names matching account names
    List<Contact> testContacts = new List<Contact>{
        new Contact(LastName = 'Doe', FirstName = 'John'),
        new Contact(LastName = 'Smith', FirstName = 'Jane')
    };

    System.debug('Here are the contents of the testContacts list: ' + testContacts);
    System.debug('# testContacts list: ' + testContacts.size());

    //adding container to store unique last names
    Set<String> lastNames = New Set<String>();

    //verify wheter there is data in the list
    if (contactsToUpsert == null){
        system.debug('The contactsToUpsert list is null.');
        return;
    } else if (contactsToUpsert.isEmpty()){
        system.debug('');
    } else {
        System.debug('Here are the contents of the contactsToUpsert list: ' + contactsToUpsert);
          System.debug('Here are the # of contactsToUpsert list: ' + contactsToUpsert.size());   
    }
}
    
    // Loop through each Contact
    for (Contact c : contactsToUpsert){
        if (String.isNotBlank(c.LastName)) {
            lastNames.add(c.LastName);
            
            //print names to log
            System.debug('     Contact Name -- Initial Loop:: ' + c.Name);
            System.debug('Contact Last Name -- Initial Loop:: ' + c.LastName);
        }                
    }
    //adding containers to store existing Accounts
    Map<String,Account> existAccountsMap = new Map<String,Account>();
    
    // Extract the Account Name from Contact's LastName
    if (!lastNames.isEmpty()){
        List<Account> existingAccounts = [SELECT Id, Name FROM Account WHERE Name IN: lastNames];  //query accounts that match the contacts' last name
        for (Account a : existingAccounts){
            existAccountsMap.put(a.Name, a); //store each match in the existingAccountsMap
            System.debug('Accounts that match Contact Last Names::: ' + a.Name);
        }
        System.debug('Accounts that match Contact Last Names - Outside of Loop::: ' + lastNames);
        System.debug('# of Account records that match Contact Last Names - Outside of Loop::: ' + lastNames.size());
    }

    // Get the account based on the name or create one if it doesn't exist
    List<Account> accountsToUpsert = new List<Account>();

    // Link the Contact to its Account using the Account Id
    for (Contact c: contactsToUpsert){
        if (String.isNotBlank(c.LastName)){
            //print names to log
            System.debug('     Contact Name -- 2nd Loop w Accts:: ' + c.Name);
            System.debug('Contact Last Name -- 2nd Loop w Accts:: ' + c.LastName);
            
            Account matchingAccount = existAccountsMap.get(c.LastName);
            //if an account matching contact lastName doesn't exist, generate a new one
            if (matchingAccount == null){
                matchingAccount = new Account (Name = c.LastName);
                
                //print Account to logs
                System.debug('Accounts that match Contact Last Names -- 2nd Loop::: ' + matchingAccount);

                accountsToUpsert.add(matchingAccount);
                existAccountsMap.put(c.LastName, matchingAccount);
            }
            //Link the contact to the account
            c.AccountId = matchingAccount.Id;
        }
        System.debug('     Contact Name -- 2nd Loop w Accts - Outside of Loop:: ' + c.Name);
        System.debug('Contact Last Name -- 2nd Loop w Accts - Outside of Loop:: ' + c.LastName);
    }
    // Upsert Accounts
    if (!accountsToUpsert.isEmpty()){
        //print accounts
        System.debug('Account to be upserted::: ' + existAccountsMap.values());
        System.debug('# of Account records to be upserted::: ' + accountsToUpsert.size());
        upsert accountsToUpsert;
    }
    // Upsert the Contacts
    if (!contactsToUpsert.isEmpty()){
        upsert contactsToUpsert;
    }
}