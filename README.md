# SMS Event Reminders

Automatically sends SMS reminders to Event participants at a scheduled time. When an Event is created or updated with an **SMS Reminder Time**, a message is sent to the participant's mobile phone at that time containing the event subject, start time, and end time. This package depends on [Enclude Gateway SMS](https://github.com/EncludeLtd/Gateway-SMS-Package).

## How It Works

1. A user sets the **SMS Reminder Time** field on an Event record. See [Defaulting the SMS_Reminder_Time__c](#defaulting-the-sms_reminder_time__c) for more options.
2. At the scheduled time, a record-triggered flow checks that the reminder is still current (within a 15-minute processing window).
3. If valid, the flow looks up the Contact associated with the Event via the `WhoId` field and verifies they have a mobile phone number.
4. An SMS message is created via the [Enclude Gateway SMS](https://github.com/EncludeLtd/Gateway-SMS-Package) package, which handles delivery.

> [!WARNING]
> No SMS will be sent if the participant is not a Contact or has no mobile phone number. See [Supporting Additional Objects](#supporting-additional-objects) for more options.

## Post-install Customisations

This being an unlocked package, it's possible to modify the metadata.

### Defaulting the SMS_Reminder_Time__c

Normally, the field [SMS_Reminder_Time__c](./force-app/main/default/objects/Activity/fields/SMS_Reminder_Time__c.field-meta.xml) should be populated automatically. Add a default value or a flow to define it's default value, such as 1 hour before the Event Start Date/Time.

### Supporting Additional Objects
If SMS reminders need to be sent to objects other than Contact, such as Lead, modify the flow [SUBFLOW_Send_Event_SMS_Notification](./force-app/main/default/flows/SUBFLOW_Send_Event_SMS_Notification.flow-meta.xml)

### Additional Notifications
If SMS notifications should be sent at other parts of the Event's lifecycle, such as immediately on record creation, create additional record-triggered Event flows and invoke the subflow [SUBFLOW_Send_Event_SMS_Notification](./force-app/main/default/flows/SUBFLOW_Send_Event_SMS_Notification.flow-meta.xml)

## Prerequisites

- [CumulusCI](https://cumulusci.readthedocs.io/en/latest/tutorial.html) installed and configured
- The [Enclude Gateway SMS](https://github.com/EncludeLtd/Gateway-SMS-Package) package must be installed in the target org before deploying this project

## Objects & Fields

| Object | Field | Type | Description |
|--------|-------|------|-------------|
| Activity (Event/Task) | `SMS Reminder Time` | DateTime | The date and time at which the SMS reminder should be sent |

## Flows

| Flow | Type | Description |
|------|------|-------------|
| `Event_Schedule_SMS_Reminder` | Record-Triggered (AutoLaunched) | Triggers on Event create/update when `SMS Reminder Time` and `WhoId` are populated. Schedules a path to fire at the reminder time, then checks the reminder is still current before invoking the subflow. |
| `SUBFLOW_Send_Event_SMS_Notification` | AutoLaunched (Subflow) | Called by the parent flow. Looks up the Contact via `WhoId`, validates their mobile phone is populated, and creates an `SMS Message` record via the Enclude package to trigger delivery. |

## Permission Sets

| Permission Set | Description |
|----------------|-------------|
| SMS Event Reminders | Grants read/edit access to the SMS Reminder Time field on Events and Tasks |

Assign this permission set to any users who should be able to schedule SMS reminders.

## Development

1. [Set up CumulusCI](https://cumulusci.readthedocs.io/en/latest/tutorial.html)
2. Run `cci flow run dev_org --org dev` to deploy this project.
3. Run `cci org browser dev` to open the org in your browser.

## Release

1. Release a Beta Version
```bash
cci flow run release_unlocked_beta --org dev
```

2. Test Deploy the Beta Version
```bash
cci flow run ci_beta --org beta
```

3. Promote to a Production Version. ***This promotes the latest beta version by default***
```bash
cci flow run release_unlocked_production --org release
```
