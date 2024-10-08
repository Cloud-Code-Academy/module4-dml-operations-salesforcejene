public static void upsertOrigAccountsWithContacts(List<Contact> contactsToUpsert) {
    /* */
     List<Contact> contactList = [SELECT Id, LastName, Account.Name, AccountId FROM Contact WHERE AccountId = null];
    
     // Extract the Contact's LastName by looping through each Contact, store to upsertContactList
     for (Contact con : contactList){
         if (con.LastName != null) {
             contactsToUpsert.add(con.LastName);
         }
         System.debug('contactList::: ' + contactList);
     }
     // Link the Contact to its Account using the Account Id
     List<Account> accountsToInsert = new List<Account>();
     
     For (Contact c : contactsToUpsert){
         if (c.LastName != null){
             //generate new acct
             Account newAcct = new Account (Name = c.LastName);   
             accountsToInsert.add(newAcct).c.id;
             System.debug('accountsToInsert::: ' + accountsToInsert);

             //Link the contact to the Account 
             c.AccountId = contactList.add(c.Id);
             System.debug('c.LastName is::: ') + c.LastName;
         }            
     //Insert the new Accounts 
     if (!accountsToInsert.isEmpty()) {
         insert accountsToInsert;

     }
    }
}

public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
    // Ensure the input list is not null
    if (contactsToUpsert == null || contactsToUpsert.isEmpty()) {
        return;  // No contacts to upsert
    }

    // List to hold new accounts to insert
    List<Account> accountsToInsert = new List<Account>();
    Map<String, Account> lastNameToAccountMap = new Map<String, Account>();

    // Loop through each contact and create a corresponding account
    for (Contact c : contactsToUpsert) {
        if (c.LastName != null && c.AccountId == null) {
            // Check if we already created an Account for this LastName
            if (!lastNameToAccountMap.containsKey(c.LastName)) {
                // Create a new account
                Account newAcct = new Account(Name = c.LastName);
                accountsToInsert.add(newAcct);
                lastNameToAccountMap.put(c.LastName, newAcct);
            }
        }
    }

    // Insert the new Accounts
    if (!accountsToInsert.isEmpty()) {
        insert accountsToInsert;
    }

    // Map to store account names and their IDs after insertion
    Map<String, Id> accountNameToIdMap = new Map<String, Id>();
    for (Account a : accountsToInsert) {
        accountNameToIdMap.put(a.Name, a.Id);
    }

    // Link the contacts to their corresponding accounts
    for (Contact c : contactsToUpsert) {
        if (c.LastName != null && c.AccountId == null && accountNameToIdMap.containsKey(c.LastName)) {
            c.AccountId = accountNameToIdMap.get(c.LastName);
        }
    }

    // Update the contacts with their new Account IDs
    if (!contactsToUpsert.isEmpty()) {
        upsert contactsToUpsert;
    }
}
