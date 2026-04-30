# SMS Event Reminders

Automatically sends SMS reminders to Event participants. Supports two modes: a **scheduled reminder** sent a configurable number of hours or days before the event, and an **immediate notification** sent at the point of record creation. This package depends on [Enclude Gateway SMS](https://github.com/EncludeLtd/Gateway-SMS-Package).

<a href="https://github.com/Enclude-Components/SMS-Event-Reminders/releases/latest">
  <img
    alt="Install Latest Release"
    src="https://img.shields.io/badge/Install%20Latest%20Release-238636?style=for-the-badge&logoColor=white&logo=DocuSign"
  >
</a>

## How It Works

### Scheduled Reminder

1. A user sets the **SMS Reminder Time Offset** (e.g. `2`) and **SMS Reminder Time Unit** (e.g. `Days Before`) fields on an Event record.
2. The **SMS Reminder Date/Time** formula field automatically computes the reminder time as the Event start date/time minus the offset.
3. At the computed time, a record-triggered flow checks that the reminder is still current (within a 15-minute processing window).
4. If valid, the flow looks up the Contact associated with the Event via the `WhoId` field and verifies they have a mobile phone number.
5. An SMS message is created via the [Enclude Gateway SMS](https://github.com/EncludeLtd/Gateway-SMS-Package) package, which handles delivery.

### Send on Creation

1. A user ticks **Send SMS on Creation** when creating an Event record.
2. On save, a record-triggered flow immediately invokes the subflow to send the notification.
3. The checkbox has no effect if set after the record has been created. To resend, use the **Send Event SMS Notification** action instead.

> [!WARNING]
> No SMS will be sent if the participant is not a Contact or has no mobile phone number. See [Supporting Additional Objects](#supporting-additional-objects) for more options.

## Post-install Customisations

This being an unlocked package, it's possible to modify the metadata.

### Defaulting the Reminder Offset

To avoid requiring users to manually set the offset fields on every Event, add a default value to [SMS_Reminder_Time_Offset__c](./force-app/main/default/objects/Activity/fields/SMS_Reminder_Time_Offset__c.field-meta.xml) and [SMS_Reminder_Time_Unit__c](./force-app/main/default/objects/Activity/fields/SMS_Reminder_Time_Unit__c.field-meta.xml), or populate them via a flow triggered on Event creation.

### Supporting Additional Objects
If SMS reminders need to be sent to objects other than Contact, such as Lead, modify the flow [SUBFLOW_Send_Event_SMS_Notification](./force-app/main/default/flows/SUBFLOW_Send_Event_SMS_Notification.flow-meta.xml)

### Additional Notifications
If SMS notifications should be sent at other points in the Event's lifecycle or automatically given certain criteria, create custom record-triggered Event flows and invoke the subflow [SUBFLOW_Send_Event_SMS_Notification](./force-app/main/default/flows/SUBFLOW_Send_Event_SMS_Notification.flow-meta.xml)

## Prerequisites

- The [Enclude Gateway SMS](https://github.com/EncludeLtd/Gateway-SMS-Package) package must be installed in the target org before deploying this project

## Objects & Fields

| Object | Field | Type | Description |
|--------|-------|------|-------------|
| Activity (Event/Task) | `SMS Reminder Time Offset` | Number | The number of hours or days before the Event start time to send the reminder |
| Activity (Event/Task) | `SMS Reminder Time Unit` | Picklist | Whether the offset is in hours or days (`Hours Before` / `Days Before`) |
| Activity (Event/Task) | `SMS Reminder Date/Time` | Formula (DateTime) | The computed reminder time (read-only). Calculated as Event start minus the offset. |
| Event | `Send SMS on Creation` | Checkbox | If ticked at record creation, immediately sends an SMS notification to the Event participant. Has no effect when edited after creation. |

## Flows

| Flow | Type | Description |
|------|------|-------------|
| `Event_Schedule_SMS_Reminder` | Record-Triggered (AutoLaunched) | Triggers on Event create/update when `SMS Reminder Date/Time` and `WhoId` are populated. Schedules a path to fire at the computed reminder time, then checks the reminder is still current before invoking the subflow. |
| `Event_After_Create_Send_SMS_Notification` | Record-Triggered (AutoLaunched) | Triggers on Event creation only when `Send SMS on Creation` is ticked. Immediately invokes the subflow to send the notification. |
| `SUBFLOW_Send_Event_SMS_Notification` | AutoLaunched (Subflow) | Called by the parent flows or the screen flow. Looks up the Contact via `WhoId`, validates their mobile phone is populated, and creates an `SMS Message` record via the Enclude package to trigger delivery. |
| `SCREEN_Send_Event_SMS_Notification` | Screen Flow | Allows a user to manually send (or resend) an SMS notification for an Event. Can be added to the Event record page as a quick action. |

## Permission Sets

| Permission Set | Description |
|----------------|-------------|
| SMS Event Reminders | Grants read/edit access to the SMS Reminder Time Offset, SMS Reminder Time Unit, and Send SMS on Creation fields, and read access to the SMS Reminder Date/Time formula field, on Events and Tasks |

Assign this permission set to any users who should be able to schedule SMS reminders.

## Development

> [!WARNING]
> This section is for developers only.

1. [Set up CumulusCI](https://cumulusci.readthedocs.io/en/latest/tutorial.html)
2. Run `cci flow run dev_org --org dev` to deploy this project.
3. Run `cci org browser dev` to open the org in your browser.

### Release

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
