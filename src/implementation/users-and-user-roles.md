# Users and user roles

## About user management { #about_user_userrole } 

Multiple users can access DHIS2 simultaneously and each user can have
different authorities. You can fine-tune these authorities so that
certain users can only enter data, while others can only generate
reports.

  - You can create as many users, user roles and user groups as you
    need.

  - You can assign specific authorities to user groups or individual
    users via user roles.

  - You can create multiple user roles each with their own authorities.

  - You can assign user roles to users to grant the users the
    corresponding authorities.

  - You can assign each user to organisation units. Then the user can
    enter data for the assigned organisation units.



Table: User management terms and definitions

| Term | Definition | Example |
|---|---|---|
| Authority | A permission to perform one or several specific tasks | Create a new data element<br> <br>Update an organisation unit<br> <br>View a report |
| User | A person's DHIS2 user account | admin<br> <br>traore<br> <br>guest |
| User role | A group of authorities | Data entry clerk<br> <br>System administrator<br> <br>Antenatal care program access |
| User group | A group of users | Kenya staff<br> <br>Feedback message recipients<br> <br>HIV program coordinators |

You manager users, user roles and user groups in the **Users** app.



Table: Objects in the Users app

| Object type | Available functions |
|---|---|
| User | Create, edit, invite, clone, disable, display by organisation unit, delete and show details |
| User role | Create, edit, share, delete and show details |
| User group | Create, edit, join, leave, share, delete and show details |

### About users

Each user in DHIS2 must have a user account which is identified by a
user name. You should register a first and last name for each user as
well as contact information, for example an email address and a phone
number.

It is important that you register the correct contact information. DHIS2
uses this information to contact users directly, for example sending
emails to notify users about important events. You can also use the
contact information to share for example dashboards and pivot tables.

A user in DHIS2 is associated with an organisation unit. You should
assign the organisation unit where the user works.

When you create a user account for a district record officer, you should
assign the district where he/she works as the organisation unit.

The assigned organisation unit affects how the user can use DHIS2:

  - In the **Data Entry** app, a user can only enter data for the
    organisation unit she is associated with and the organisation units
    below that in the hierarchy. For instance, a district records
    officer will be able to register data for her district and the
    facilities below that district only.

  - In the **Users** app, a user can only create new users for the
    organisation unit she is associated with in addition to the
    organisation units below that in the hierarchy.

  - In the **Reports** app, a user can only view reports for her
    organisation unit and those below. (This is something we consider to
    open up to allow for comparison reports.)

An important part of user management is to control which users are
allowed to create new users with which authorities. In DHIS2, you can
control which users are allowed to perform this task. The key principle
is that a user can only grant authorities and access to data sets that
the user itself has access to. The number of users at national, province
and district level are often relatively few and can be created and
managed by the system administrators. If a large proportion of the
facilities are entering data directly into the system, the number of
users might become unwieldy. It is recommended to delegate and
decentralize this task to the district officers, it will make the
process more efficient and support the facility users better.

### About user roles

A user role in DHIS2 is a group of authorities. An authority means the
permission to perform one or more specific tasks.

A user role can contain authorities to create a new data element, update
an organisation unit or view a report.

A user can have multiple user roles. If so, the user's authorities will
be the sum of all authorities and data sets in the user roles. This
means that you can mix and match user roles for special purposes instead
of only creating new ones.

A user role is associated with a collection of data sets. This affects
the **Data Entry** app: a user can only enter data for the data sets
registered for his/her user role. This can be useful when, for example,
you want to allow officers from health programs to enter data only for
their relevant data entry forms.

Recommendations:

  - Create one user role for each position within the organisation.

  - Create the user roles in parallel with defining which user is doing
    which tasks in the system.

  - Only give the user roles the exact authorities they need to perform
    their job, not more. Only those who are supposed to perform a task
    should have the authorities to perform it.

### About user groups

A user group is a group of users. You use user groups when you set up
sharing of objects or notifications, for example push reports or program
notifications.

See also:

[Sharing](https://ci.dhis2.org/docs/master/en/user/html/sharing.html)

[Manage program
notifications](https://docs.dhis2.org/master/en/user/html/manage_program_notification.html)

[Mange push
reports](https://docs.dhis2.org/master/en/user/html/manage_push_report.html)

## Workflow { #user_mgt_workflow } 

1.  Define the positions you need for your project and identify which
    tasks the different positions will perform.

2.  Create roughly one user role for each position.

3.  Create users.

4.  Assign user roles to the users.

5.  Assign the users to organisation units.

6.  (Optional) Group users in user groups.

7.  Share datasets with users or user-groups via the Sharing Dialog in
    Data set management section of the Maintenance app

> **Tip**
>
> For users to be able to enter data, you must add them to an
> organisational unit level and share a dataset with them.

## Example: user management in a health system { #user_mgt_example } 

In a health system, users are logically grouped with respect to the task
they perform and the position they occupy.

1.  Define which users should have the role as system administrators.
    They are often part of the national HIS division and should have
    full authority in the system.

2.  Create roughly one user role for each position.

Examples of common positions are:


| Position | Typical tasks | Recommended authorities | Comment |
|---|---|---|---|
| System administrators | Set up the basic structure (metadata) of the system. | Add, update and delete the core elements of the system, for example data elements, indicators and data sets. | Only system administrators should modify metadata. <br>If you allow users outside the system administrators team to modify the metadata, it might lead to problems with coordination.<br> <br>Updates to the system should only be performed by the administrators of the system. |
| National health managers<br> <br>Province health managers | Monitor and analyse data | Access to the reports module, the **Maps**, **Data Quality** apps and the dashboard. | Don't need access to enter data, modify data elements or data sets. |
| National health information system division officers (HISO)<br> <br>District health records and information officers (DHRIO)<br> <br>Facility health records and information officers (HRIO) | Enter data that comes from facilities which are not able to do so directly<br> <br>Monitor, evaluate and analyse data | Access to all the analysis and validation apps<br> <br>Access to the **Data Entry** app. | - |
| Data entry clerks | - | - | - |
