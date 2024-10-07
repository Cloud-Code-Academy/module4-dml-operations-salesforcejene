List <Opportunity> opportunities = [SELECT Id, Name, Has_Lost_Opportunity__c, Account.Name, AccountId FROM Opportunity WHERE StageName = 'Closed Lost'];
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
                                SELECT Id, Name, Account.Name, Account.Id 
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
    System.debug('oa::: ' + oa);
    
}

//Read fields from the Activity object, print out apiName, labelName, Desc based on data stored a in map
Map<String, Schema.SObjectField> taskFields = Schema.SObjectType.Task.fields.getMap();

System.debug('Task fields::');
System.debug('Field API Name -- Field Label');

for (String fieldName : taskFields.keySet()){
    schema.DescribeFieldResult fieldDesc = taskFields.get(fieldName).getDescribe();
    String fieldLabel = fieldDesc.getLabel();
    //String fieldDescriptionInfo = fieldDesc.name();

    System.debug('Field API Name:: ' + fieldName + ' ++ ' + 'Field Label:: ' + fieldLabel);
}


//This code works yet there are no records to retrieve.
RecordType recType = [SELECT Id, Name FROM RecordType
                    WHERE SobjectType = 'Contact' AND DeveloperName ='PartnerContact'
                    LIMIT 1];
Schema.DescribeSObjectResult result = Schema.SObjectType.Contact;
map<Id, Schema.RecordTypeInfo> mapRectTypes = result.getRecordTypeInfosById();
Schema.RecordTypeInfo recordTypeInfo = mapRectTypes.get(recType.Id);

schema.DescribeSObjectResult dsr = Account.SobjectType.getDescribe();



System.debug('Value of mapRecTypes ' + mapRectTypes);
System.debug('get max cap of field' + Opportunity.getValues(sale));
System.debug('Describe all objects:::: ' + Schema.getGlobalDescribe());
