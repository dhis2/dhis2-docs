# New Tracker

  * Describe /tracker as a group of new tracker endpoints, where there are some new changes
  * List changes we have made between 2.35->2.36
  * Make a note that the old endpoints are marked as deprecated, but still work. Not all the functionality is ready in the new endpoint yet.

## Tracker Import

<!--DHIS2-SECTION-ID:webapi_nti_import-->

  * List all existing import endpoints (Just /tracker today)
  * For each endpoint:
    * Example payload
    * Example response
    * Example request
    * Table of params
  * Make a note about JSON is the only supported format
  * Configuration that alters the import process (IE. turning off cache)
  * Describe the difference between sync\async
  * Flat\nested payload support
  * Note about Side effects - Link to side effects
  * Note about validation - Link to validation
  * Note about program rules - Link to program rules

### Import Summary

<!--DHIS2-SECTION-ID:webapi_nti_import_summary-->

  * List the endpoints for retrieving log and importSummary
  * For each endpoint:
    * Example request
    * Example response
    * Table of params
  * Make a note that these are temporal, meaning they will only exists for a limited time
  * Explain the “job” / “log” / “notification” response
  * Explain the structure of the importSummary
  * Explain how to read errors from the importSummary - Link to   errors

### Error Codes

<!--DHIS2-SECTION-ID:webapi_nti_error_codes-->

A table with a full reference of error codes, messages and description:

| Error Code | Error Message | Description |
|:--|:----|:----|
| E1000 | "User: `{0}`, has no write access to OrganisationUnit: `{1}`." | |
| E1001 | "User: `{0}`, has no data write access to TrackedEntityType: `{1}`." | |
| E1002 | "TrackedEntityInstance: `{0}`, already exists." | |
| E1005 | "Could not find TrackedEntityType: `{0}`." | |
| E1006 | "Attribute: `{0}`, does not exist." | |
| E1007 | "Error validating attribute value type: `{0}`; Error: `{1}`." | |
| E1008 | "Value: `{0}`, does not match the attribute pattern: `{1}`." | |
| E1009 | "File resource: `{0}`, has already been assigned to a different object." | |
| E1011 | "Could not find OrganisationUnit: `{0}`, linked to Event." | |
| E1012 | "Geometry does not conform to FeatureType: `{0}`." | |
| E1014 | "Provided Program: `{0}`, is a Program without registration. An Enrollment cannot be created into Program without registration." | |
| E1015 | "TrackedEntityInstance: `{0}`, already has an active Enrollment in Program `{1}`." | |
| E1016 | "TrackedEntityInstance: `{0}`, already has an active enrollment in Program: `{1}`, and this program only allows enrolling one time." | |
| E1018 | "Attribute: `{0}`, is mandatory in program `{1}` but not declared in enrollment `{2}`." | |
| E1019 | "Only Program attributes is allowed for enrollment; Non valid attribute: `{0}`." | |
| E1020 | "Enrollment date: `{0}`, can`t be future date." | |
| E1021 | "Incident date: `{0}`, can`t be future date." | |
| E1022 | "TrackedEntityInstance: `{0}`, must have same TrackedEntityType as Program `{1}`." | |
| E1023 | "DisplayIncidentDate is true but property occurredAt is null or has an invalid format: `{0}`." | |
| E1025 | "Property enrolledAt is null or has an invalid format: `{0}`." | |
| E1029 | "Event OrganisationUnit: `{0}`, and Program: `{1}`, don't match." | |
| E1030 | "Event: `{0}`, already exists." | |
| E1031 | "Event OccurredAt date is missing." | |
| E1032 | "Event: `{0}`, do not exist." | |
| E1033 | "Event: `{0}`, Enrollment value is NULL." | |
| E1035 | "Event: `{0}`, ProgramStage value is NULL." | |
| E1036 | "Event: `{0}`, TrackedEntityInstance does not point to a existing object." | |
| E1037 | "TrackedEntityInstance: `{0}`, is not enrolled in Program `{1}`." | |
| E1038 | "TrackedEntityInstance: `{0}`, has multiple active enrollments in Program `{1}`." | |
| E1039 | "ProgramStage: `{0}`, is not repeatable and an event already exists." | |
| E1041 | "Enrollment OrganisationUnit: `{0}`, and Program: `{1}`, don't match." | |
| E1042 | "Event: `{0}`, needs to have completed date." | |
| E1048 | "Object: `{0}`, uid: `{1}`, has an invalid uid format." | |
| E1049 | "Could not find OrganisationUnit: `{0}`, linked to Tracked Entity." | |
| E1050 | "Event ScheduledAt date is missing." | |
| E1055 | "Default AttributeOptionCombo is not allowed since program has non-default CategoryCombo." | |
| E1056 | "Event date: `{0}`, is before start date: `{1}`, for AttributeOption: `{2}`." | |
| E1057 | "Event date: `{0}`, is after end date: `{1}`, for AttributeOption; `{2}`." | |
| E1063 | "TrackedEntityInstance: `{0}`, does not exist." | |
| E1064 | "Non-unique attribute value `{0}` for attribute `{1}`" | |
| E1068 | "Could not find TrackedEntityInstance: `{0}`, linked to Enrollment." | |
| E1069 | "Could not find Program: `{0}`, linked to Enrollment." | |
| E1070 | "Could not find OrganisationUnit: `{0}`, linked to Enrollment." | |
| E1074 | "FeatureType is missing." | |
| E1075 | "Attribute: `{0}`, is missing uid." | |
| E1076 | "Attribute: `{0}`, value is null." | |
| E1077 | "Attribute: `{0}`, text value exceed the maximum allowed length: `{0}`." | |
| E1080 | "Enrollment: `{0}`, already exists." | |
| E1081 | "Enrollment: `{0}`, do not exist." | |
| E1082 | "Event: `{0}`, is already deleted and can't be modified." | |
| E1083 | "User: `{0}`, is not authorized to modify completed events." | |
| E1084 | "File resource: `{0}`, reference could not be found." | |
| E1085 | "Attribute: `{0}`, value does not match value type: `{1}`." | |
| E1086 | "Event: `{0}`, has a program: `{1}`, that is a registration but its ProgramStage is not valid or missing." | |
| E1087 | "Event: `{0}`, could not find DataElement: `{1}`, linked to a data value." | |
| E1088 | "Event: `{0}`, program: `{1}`, and ProgramStage: `{2}`, could not be found." | |
| E1089 | "Event: `{0}`, references a Program Stage `{1}` that does not belong to Program `{2}`." | |
| E1090 | "Attribute: `{0}`, is mandatory in tracked entity type `{1}` but not declared in tracked entity `{2}`." | |
| E1091 | "User: `{0}`, has no data write access to Program: `{1}`." | |
| E1095 | "User: `{0}`, has no data write access to ProgramStage: `{1}`." | |
| E1096 | "User: `{0}`, has no data read access to Program: `{1}`." | |
| E1099 | "User: `{0}`, has no write access to CategoryOption: `{1}`." | |
| E1100 | "User: `{0}`, is lacking 'F_TEI_CASCADE_DELETE' authority to delete TrackedEntityInstance: `{1}`." | |
| E1102 | "User: `{0}`, does not have access to the tracked entity: `{1}`, Program: `{2}`, combination." | |
| E1103 | "User: `{0}`, is lacking 'F_ENROLLMENT_CASCADE_DELETE' authority to delete Enrollment : `{1}`." | |
| E1104 | "User: `{0}`, has no data read access to program: `{1}`, TrackedEntityType: `{2}`." | |
| E1112 | "Attribute value: `{0}`, is set to confidential but system is not properly configured to encrypt data." | |
| E1113 | "Enrollment: `{0}`, is already deleted and can't be modified." | |
| E1114 | "TrackedEntity: `{0}`, is already deleted and can't be modified." | |
| E1115 | "Could not find CategoryOptionCombo: `{0}`." | |
| E1116 | "Could not find CategoryOption: `{0}`." | |
| E1117 | "CategoryOptionCombo does not exist for given category combo and category options: `{0}`." | |
| E1118 | "Assigned user `{0}` is not a valid uid." | |
| E1119 | "A Tracker Note with uid `{0}` already exists." | |
| E1120 | "ProgramStage `{0}` does not allow user assignment" | |
| E1121 | "Missing required tracked entity property: `{0}`." | |
| E1122 | "Missing required enrollment property: `{0}`." | |
| E1123 | "Missing required event property: `{0}`." | |
| E1124 | "Missing required relationship property: `{0}`." | |
| E1125 | "Value {0} is not a valid option for {1} {2} in option set {3}" | |
| E1017 | "Attribute: `{0}`, does not exist." | |
| E1093 | "User: `{0}`, has no search access to OrganisationUnit: `{1}`." | |
| E1094 | "Not allowed to update Enrollment: `{0}`, existing Program `{1}`." | |
| E1110 | "Not allowed to update Event: `{0}`, existing Program `{1}`." | |
| E1111 | "We have a generated attribute: `{0}`, but no pattern." | |
| E1040 | "Multiple active enrollments exists for Program: `{0}`." | |
| E1045 | "Program: `{0}`, expiry date has passed. It is not possible to make changes to this event." | |
| E1043 | "Event: `{0}`, completeness date has expired. Not possible to make changes to this event." | |
| E1044 | "Event: `{0}`, needs to have event date." | |
| E1046 | "Event: `{0}`, needs to have at least one (event or schedule) date." | |
| E1047 | "Event: `{0}`, date belongs to an expired period. It is not possible to create such event." | |
| E1300 | "Generated by program rule (`{0}`) - `{1}`" | |
| E1302 | "Generated by program rule (`{0}`) - DataElement `{1}` is not valid: `{2}`" | |
| E1303 | "Generated by program rule (`{0}`) - Mandatory DataElement `{1}` is not present" | |
| E1304 | "Generated by program rule (`{0}`) - DataElement `{1}` is not a valid data element" | |
| E1305 | "Generated by program rule (`{0}`) - DataElement `{1}` is not part of `{2}` program stage" | |
| E1306 | "Generated by program rule (`{0}`) - Mandatory Attribute `{1}` is not present" | |
| E1307 | "Generated by program rule (`{0}`) - Unable to assign value to data element `{1}`. The provided value must be empty or match the calculated value `{2}`" | |
| E1308 | "Generated by program rule (`{0}`) - DataElement `{1}` is being replaced in event `{2}`" | |
| E1309 | "Generated by program rule (`{0}`) - Unable to assign value to attribute `{1}`. The provided value must be empty or match the calculated value `{2}`" | |
| E1310 | "Generated by program rule (`{0}`) - Attribute `{1}` is being replaced in tei `{2}`" | |
| E4000 | "Relationship: `{0}` cannot link to itself" | |
| E4001 | "Relationship Item `{0}` for Relationship `{1}` is invalid: an Item can link only one Tracker entity." | |
| E4003 | "There are duplicated relationships." | |
| E4004 | "Missing required relationship property: 'relationshipType'." | |
| E4005 | "RelationShip: `{0}`, do not exist." | |
| E4006 | "Could not find relationship Type: `{0}`." | |
| E4007 | "Missing required relationship property: 'from'." | |
| E4008 | "Missing required relationship property: 'to'." | |
| E4009 | "Relationship Type `{0}` is not valid." | |
| E4010 | "Relationship Type `{0}` constraint requires a {1} but a {2} was found." | |
| E4011 | "Relationship: `{0}` cannot be persisted because {1} {2} referenced by this relationship is not valid." | |
| E4012 | "Could not find `{0}`: `{1}`, linked to Relationship." | |
| E4013 | "Relationship Type `{0}` constraint is missing {1}." | |
| E4014 | "Relationship Type `{0}` constraint requires a Tracked Entity having type `{1}` but `{2}` was found." | |

E9999( "N/A" );

### Validation

<!--DHIS2-SECTION-ID:webapi_nti_validation-->

  * A full overview of validation that takes place during import
  * What properties are required
  * What is the validation for certain types of values
  * Uniqueness
  * Program rules - Link to program rules
  * Access control - Link to Tracker access control
  * Date restrictions
  * Program and Program Stage configuration-based validation

  * I am not sure about the best format here, but maybe we split it up into each model:
  * Tracked Entity
      * Enrollment
        * Event
            * DataValue -> Link
            * TrackedEntityAttributeValue -> Link
      * TrackedEntityAttributesValue -> Link
      * TrackedEntityAttributeValue
        * Value Types


### Program Rules

<!--DHIS2-SECTION-ID:webapi_nti_program_rules-->

  * Describe when\how rules are now run on the backend as well
  * Describe what rules are being run, and which are not being run
  * Describe any condition for when something is or is not run
  * Describe the different results rules can have (warning, error, etc)
  * Side effects(?) - Link to side effects


### Side Effects

<!--DHIS2-SECTION-ID:webapi_nti_side_effects-->

  * Describe what side-effects are
  * Note that side-effects can fail even if import succeeds. But not the other way around
  * Describe what side-effects we have and what they do (Table?)
  * Any configuration that affects side effects.


## Tracker Export

<!--DHIS2-SECTION-ID:webapi_nti_export-->

This will be sort of a work-in-progress, but as far as we can, we will describe what we have today. Describe that this is endpoints that are incomplete and will be improved in the future


  * Which endpoints are here today?
  * For each endpoint:
    * Important: What is the intention of the endpoint (exporting a lot of data? Searching? Etc)
    * Example payload
    * Example response
    * Example request
    * Table of params
  * For endpoints with reduced functionality, make a note of it, and that the old, deprecated endpoint still supports this.
  * Make a note that the intention of these endpoints is to support the new format when exporting.


## Tracker Access Control

<!--DHIS2-SECTION-ID:webapi_nti_access_control-->

### Metadata Sharing

<!--DHIS2-SECTION-ID:webapi_nti_metadata_sharing-->


  * How sharing relates to how we import and export data
  * Explain how the sharing is cascading in our model (if tei can’t be seen, you can’t see enrolment, etc)

### Organisation Unit Scopes

<!--DHIS2-SECTION-ID:webapi_nti_ou_scope-->

  * Explain the different scopes
  * Explain how they relate to import and export
  * Explain how they relate to searching
  * Explain how they relate to ownership - Link to Program Ownership

### Program Ownership

<!--DHIS2-SECTION-ID:webapi_nti_ownership-->

  * Describe the idea about Program Ownership
  * Temporary ownership
  * Program Ownership and Access Level - Link to Access Level

### Access Level

<!--DHIS2-SECTION-ID:webapi_nti_access_level-->

  * What is “access level”?
  * How does access level affect import\export?
