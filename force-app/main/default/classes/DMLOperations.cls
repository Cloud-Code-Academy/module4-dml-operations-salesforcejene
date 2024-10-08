/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Jené T. Fuller
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account myAcc = new Account(Name = 'Coded Acct' + Datetime.now());

        // Set some fields on the Account        
        myAcc.BillingCity       = 'Anchorage';
        myAcc.NumberOfEmployees = 10;
        myAcc.Description       = 'Entered by APEX!';
        

        // Insert the Account into the database
        insert myAcc;

        // Return the Id of the newly created Account
        return myAcc.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account acc = New Account(Name= name, industry = industry, description = 'Entered by APEX!');
        // Insert the Account
        insert acc;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact con = new Contact();

        // Set some fields on the Contact
        con.FirstName   = 'Jane';
        con.LastName    = 'Smoe';
        con.Description = 'Entered by APEX!';

        // Set the AccountId field to the given accountId
        con.AccountId = accountId;

        // Insert the Contact into the database
        insert con;
        // Return the Id of the newly created Contact
        return con.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        Contact findContact = [SELECT Id, LastName FROM Contact WHERE Id = :contactId];

        // Update the Contact's last name
         findContact.LastName = newLastName;

        // Update the Contact in the database
        try {
            update findContact;    
        } catch (DmlException e) {
            System.debug('An error occured during insert!');
        } 
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        Opportunity updateOpp = [SELECT Id, StageName FROM Opportunity WHERE Id = :oppId];

        // Update the Opportunity's stage
        updateOpp.stageName = newStage;        

        // Update the Opportunity in the database
        update updateOpp;
    }

    /**
     * Question 6
 0     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        Account updateAcc = [SELECT Id, Industry, Name FROM Account WHERE Id = :accountId];

        // Update the Account with the given Id with the new name and industry
        updateAcc.Id       = accountId;
        updateAcc.Name     = newName;
        updateAcc.Industry = newIndustry;

        update updateAcc;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list
        
       For (Opportunity o : opportunities){
        o.StageName = 'Qualification';
        o.CloseDate = Date.today().addMonths(3);
        o.Amount    = 50000;                
        }   
        
        // Upsert the opportunities List so that records are either updated or created
        upsert opportunities;
       }

    /**
     * Question 8
     * 
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        // Loop through each Opportunity name
        // Create an Opportunity with the given name
        // Add the Opportunity to the list  

        //adding Account variable
        Account acc;
        //Querying account to find a match, if no match, generate new account. Using a list to verify whether a record exists
        List <Account> accFind = [SELECT Id, Name FROM Account WHERE Name = :accountName LIMIT 1];
        
        if (accFind.isEmpty()){
            //Generate a new Account with the given name
            acc = new Account(Name = accountName);
            insert acc;
        } else {
            //use the matching record         
            acc = accFind[0]; 
        }

        //Store opps in list
        List <Opportunity> oppList = new List <Opportunity>();

        //loop through each Opp
        for (String opp : oppNames) {
            //instantiate opp object to add record
            Opportunity o   = new Opportunity();
            o.Name          = opp;
            o.StageName     = 'Prospecting';
            o.Amount        = 100000;
            o.CloseDate     = Date.today().addMonths(3);
            o.AccountId     = acc.Id;

            //Add opps to list
            System.debug('Total opps: ' + oppList.size() + ' inside loop');
            oppList.add(o);
        }
        System.debug('Total opps: ' + oppList.size() + ' before upsert');
        upsert oppList;
    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accountsList = [SELECT Id, Name, Description FROM Account WHERE Name = :accountName];        
        //instantiate account object to be used for either new or existing account
        Account myAcc;

		// if the Account does not exist, add the account and w new acct description
        if (accountsList.isEmpty()){
            myAcc = new Account (Name = accountName, Description = 'New Account');
            
        } else {
            // otherwise, update the account description
            myAcc = accountsList[0];
            myAcc.Description = 'Updated Account';
        }
		// Upsert the Account
        upsert myAcc;

		return myAcc;
	}

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
        //adding container to store unique last names
        Set <String> lastNames = New Set <String>();

        //verify whether there is data in the list
        if (contactsToUpsert == null){
            system.debug('The contactsToUpsert list is null.');
            return;
        } else if (contactsToUpsert.isEmpty()){
            system.debug('The contactsToUpsert list is empty.');
        } else {
            System.debug('Here are the contents of the contactsToUpsert list: ' + contactsToUpsert);
            System.debug('Here are the # of contactsToUpsert list: ' + contactsToUpsert.size());   
        }
    

		// Loop through each Contact; add to lastNames set
        for (Contact c : contactsToUpsert){
            if (String.isNotBlank(c.LastName)) {
                lastNames.add(c.LastName);
            }                
        }
        //adding containers to store existing Accounts
        Map <String,Account> existAccountsMap = new Map <String,Account>();
        
		// Extract the Account Name from Contact's LastName
        if (!lastNames.isEmpty()){
            List<Account> existingAccounts = [SELECT Id, Name FROM Account WHERE Name IN: lastNames];  //query accounts that match the contacts' last name
            for (Account a : existingAccounts){
                existAccountsMap.put(a.Name, a); //store each match in the existingAccountsMap
            }
        }

		// Get the account based on the name or create one if it doesn't exist
        List<Account> accountsToUpsert = new List<Account>();

		// Link the Contact to its Account using the Account Id
        for (Contact c: contactsToUpsert){
            if (String.isNotBlank(c.LastName)){
                Account matchingAccount = existAccountsMap.get(c.LastName);

                //if an account matching contact lastName doesn't exist, generate a new one
                if (matchingAccount == null){
                    matchingAccount = new Account (Name = c.LastName);
                    accountsToUpsert.add(matchingAccount);
                    existAccountsMap.put(c.LastName, matchingAccount);
                }
            }
        }
        // Upsert Accounts first
        if (!accountsToUpsert.isEmpty()){
            upsert accountsToUpsert;
        } 
        
        //Update Contact's AccountId after accounts are inserted/upserted
        for (Contact con : contactsToUpsert){
            if (String.isNotBlank(con.lastName)){
                Account matchingAccount = existAccountsMap.get(con.lastName);
                if (matchingAccount != null){                    
                    //Link the contact to the account
                    con.AccountId = matchingAccount.Id;
                }
            }
        }

        // Upsert the Contacts
        if (!contactsToUpsert.isEmpty()){
            upsert contactsToUpsert;
        }
    }

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        //Use container to store unique Leads
        List <Lead> uniqueLeads = new List <Lead>();

        // Loop through each Lead name
        if (leadNames == null || leadNames.isEmpty()){
            System.debug('There are no leads!');
            return;            
        }
        for (String l : leadNames){
            System.debug('Contents of list: ' + l);
            //add value of leadNames to uniqueLeads
            //AAHH I needed a new sObject!!
            Lead addLead = new Lead (LastName = l, Company = 'Sample Co');
            uniqueLeads.add(addLead);
        }            
        

        // Insert the Leads
        System.debug('Here are the Leads to be inserted ' + leadNames);
        System.debug('Total of ' + leadNames.size() + ' Leads');
        insert uniqueLeads;
        System.debug('Leads inserted ' + leadNames);

        // Delete the Leads
        try {
            System.debug('Leads to be deleted are: ' + leadNames);
            System.debug('Total # of leads to delete: ' + uniqueLeads);
            delete uniqueLeads;
        } catch (DmlException e){
            System.debug('Deleting the Leads Failed, review and try again.' + e.getMessage());
        }
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {                

        // Insert the cases
        List <Case> addCases = new List<Case>();

        //updating loop to an iterative loop.

        for (Integer i = 0; numOfCases > i; i++){

            Case newCase = new Case(Subject = 'Auto Generated from Code ' + i, Priority = 'High');
            addCases.add(newCase);
            newCase.AccountId = accountId;
            //validate
            System.debug('Inside Cases loop');
        }
        insert addCases;
        System.debug('Insert Outside Cases loop');

        // // Delete the cases
        if (addCases.size() >= 0){
            System.debug('Before deletion, there were ' + addCases.size() + 'Cases');
            delete addCases;
        }
    }
}