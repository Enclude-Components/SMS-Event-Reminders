// Idempotent: skip if user already exists
String targetUsername = 'sms_gateway@enclude.ie';

List<User> existing = [SELECT Id FROM User WHERE Username = :targetUsername LIMIT 1];
if (!existing.isEmpty()) {
    System.debug('SMS Gateway user already exists, skipping creation.');
    return;
}

Profile p = [SELECT Id FROM Profile WHERE Name = 'Minimum Access - API Only Integrations' LIMIT 1];

User u = new User(
    LastName = 'SMS Gateway',
    Email = UserInfo.getUserEmail(),
    Username = targetUsername,
    Alias = 'smsgw',
    TimeZoneSidKey = UserInfo.getTimeZone().getID(),
    LocaleSidKey = UserInfo.getLocale(),
    EmailEncodingKey = 'UTF-8',
    LanguageLocaleKey = UserInfo.getLanguage(),
    ProfileId = p.Id
);
insert u;

PermissionSetLicense psl = [SELECT Id FROM PermissionSetLicense WHERE DeveloperName = 'SalesforceAPIIntegrationPsl' LIMIT 1];
insert new PermissionSetLicenseAssign(AssigneeId = u.Id, PermissionSetLicenseId = psl.Id);

List<PermissionSet> permSets = [
    SELECT Id, Name FROM PermissionSet
    WHERE Name IN ('Gateway_SMS_Mock_API_Credentials', 'SMS_Gateway', 'SMS_Gateway_External_Client_App')
];
List<PermissionSetAssignment> psAssignments = new List<PermissionSetAssignment>();
for (PermissionSet ps : permSets) {
    psAssignments.add(new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id));
}
insert psAssignments;

System.debug('SMS Gateway user created: ' + targetUsername);
