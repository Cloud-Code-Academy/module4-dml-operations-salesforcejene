RecordType recType = [SELECT Id, Name FROM RecordType
                    WHERE SobjectType = 'Contact' AND DeveloperName ='PartnerContact'
                    LIMIT 1];
Schema.DescribeSObjectResult result = Schema.SObjectType.Contact;
map<Id, Schema.RecordTypeInfo> mapRectTypes = result.getRecordTypeInfosById();
Schema.RecordTypeInfo recordTypeInfo = mapRectTypes.get(recType.Id);

schema.DescribeSObjectResult dsr = Account.SobjectType.getDescribe;



System.debug('Value of mapRecTypes ' + mapRectTypes);
System.debug('get max cap of field' + Opportunity.getValues(sale))
System.debug('Describe all objects:::: ' + Schema.getGlobalDescribe());
