List <Opportunity> opportunities = [SELECT Id, Name, Account.Name, AccountId FROM Opportunity WHERE StageName = 'Closed Lost'];
List <Account> accounts = new List <Account>();

//loop through each account
for (Account acc : [SELECT Id FROM Account WHERE Type LIKE 'Customer%']){
    for (Opportunity opp : opportunities){
        if (opp.AccountId == acc.Id){
            acc.Has_Lost_Opportunity__c = true;
            accounts.add(acc);
            break;  //move on to other matches
        }
    }    
        System.debug('acc: ' + acc);

}
    System.debug('opportunities: '  + opportunities);
Update accounts;

//another approach

// List <Opportunity> opps = [SELECT Id, Name, Account.Name, AccountId FROM Opportunity WHERE StageName = 'Closed Lost'];
// List <Account> accts = [SELECT Id FROM Account WHERE Type LIKE 'Customer %'];
List <SObject> oppsWAccs = [SELECT Id, Name, (
                                SELECT Id 
                                FROM Opportunities
                                WHERE StageName = 'Closed Lost')
                            FROM Account
                            WHERE Type LIKE 'Customer %'];

//loop thru accounts
for (SObject oa : oppsWAccs){
    if (oa.AccountId == oppsWAccs.Id) {
        oa.Has_Lost_Opportunity__c = true;
        oa.add(oppsWAccs);            
    }
    System.debug('oa: ' + oa);
    
}