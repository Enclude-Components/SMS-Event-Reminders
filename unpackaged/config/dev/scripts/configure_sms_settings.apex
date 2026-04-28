encsms__SMS_Settings__c settings = encsms__SMS_Settings__c.getOrgDefaults();
settings.encsms__Default_Sender_Id__c = 'Enclude';
settings.encsms__External_Credential_API_Name__c = 'Gateway_SMS_Mock_Api_External_Credentials';
settings.encsms__Named_Credential_API_Name__c = 'Gateway_SMS_Mock_Api_Named_Credentials';
upsert settings;

System.debug('SMS Settings configured.');
