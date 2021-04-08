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
||||


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

DHIS2 treats Tracker data with extra level of protection. In addition to the standard feature of metadata and data protection through sharing settings, Tracker data are shielded with various access level protection mechanisms. Currently there are 4 access levels: Open, Audited, Protected and Closed.

These access levels are triggered only when users try to interact with data outside their capture scope. If request to data is within the capture scope, DHIS2 applies standard metadata and data sharing protection. To access data outside capture scope, but within search scope, users need to pass through extra level of protection or what we call in DHIS2 concept of “breaking the glass”. The concept is, accessing outside data needs to be justified, has consequence and will be audited for others to see it.  The way to configure the level of consequence of breaking the glass is by setting Program’s access level to either Open, Audited, Protected or Closed.

1. Open: as the name implies, accessing data outside capture scope is possible without any justification or consequence. It is as if the data is within the capture scope. However, it is not possible to modify data captured by another org unit irrespective of the access level.
2.	Audited: this is the same as Open access level. The difference here is that the system will automatically put audit log entry on the data being accessed by the specific user.
3.	Protected: this takes audited access protection one level up. This time users need to provide a justification why they are accessing the data at hand. The system will then put a log of both the justification and access audit.
4. 	Closed: as the name implies, data recorded under programs configured with access level closed will not be accessed outside the capturing orgunit. Everything is closed for those outside the capture scope.