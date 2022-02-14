# Import/Export App { #import_export } 

In a primary health system, the HMIS typically involves a distributed
application, where the same application is running in different
geographical locations (PHCs,CHCs, hospitals, districts, and state).
Many of these physical locations do not have Internet connectivity, and
hence they work off-line. At some point (normally at the district
level), the data needs to be synchronised in order to have a
consolidated database for the a particular geographical region. For
this, it is important to be able to export data from one location (which
is working offline, say at the health facility level) and import into
another one (say at the district level).
This feature of exporting and importing is thus a crucial function of a HMIS.
This feature also helps us overcome the dependency on the Internet to some
degree, as data updates can be transferred via USB key where there is no
connectivity, or through email where there is limited Internet
connectivity. DHIS2 provides robust export-import functionality to
fulfil these needs.

To access the Import/Export app, search in the top header bar for
Import/Export. Import/Export app offers a number of services details for
which can be found below.

![](resources/images/import_export/overview.png)

## Importing data { #importing_data } 

### Import progress logger { #import_progress_logger } 

No matter what you import ("Data", "Events", "GML", "Metadata" or
"Tracked Entity Instances" data), you can always view the progress of
the import by looking at the "Job Summary" at the top of the page.

### Import Summaries { #metadata_import_summaries } 

On import request completion, we show import summaries above the
import form. Any conflicts or errors are shown in the table under the
main summary for the import.

![](resources/images/import_export/import_summary.png)

### Metadata Import { #metadata_import } 

Metadata Import can be accessed from the sidebar by clicking on
Metadata Import.

![](resources/images/import_export/metadata_import.png)

1.  Choose a file to upload

2.  Select a format: *JSON* , *CSV*, or *XML*

3.  Select the appropriate settings for:

    * Identifier
    * Import report mode
    * Preheat mode
    * Import strategy
    * Atomic mode
    * Merge mode

4.  Click **Advanced options** if you want to adjust one or more of
    the following settings before importing:

    * Flush mode
    * Skip sharing
    * Skip validation
    * Async
    * Inclusive strategy

5.  Click on the **Import** button which will upload the file and start the
    importing process.

> **Tip**
>
> **It is highly recommend to use the Dry run option** to test before
> importing data; to make sure you keep control over any changes to your
> Metadata, and to check for problems with out-of-sync data elements or
> organisation unit names


> **Note**
>
> If an organisation unit e.g. `Nduvuibu MCHP` had a unknown reference to an object with ID `aaaU6Kr7Gtpidn`, it means that the object with ID `aaaU6Kr7Gtpidn` was not present in your imported file, and it was not found in the existing database.
>
> You can control this using **Identifier** option, to indicate if you want to allow objects with such invalid references to be imported or not. If you choose to import invalid references you will have to correct the reference manually in DHIS2 later.

#### Matching Identifiers in DXF2 { #matching_identifiers_in_dxf2 } 

The DXF2 format currently support matching for two identifiers, the
internal DHIS2 identifier (known as a UID), and also using an external
identifier called called a "code". When the importer is trying to search
for references (like the one above), it will first go to the UID field,
and then to the code field. This allows you to import from legacy
systems without having a UID for every meta-data object. I.e. if you are
importing facility data from a legacy system, you can leave out the ID
field completely (DHIS2 will fill this in for you) and put the
legacy system's own identifiers in the code field, this identifier is
required to be unique. This not only works for organisation units, but
for all kinds of meta-data, allowing for easy import from other systems.

### Data Import { #import } 

Data Import can be accessed from the sidebar by clicking on Data
Import.

![](resources/images/import_export/data_import.png)

1.  Choose a file to upload

2.  Select a format: *JSON*, *CSV*, *XML*, *ADX*, or *PDF*

3.  Select the appropriate settings for:

    * Strategy
    * Preheat cache

4.  Click **Advanced options** if you want to adjust one or more of
    the following settings before importing:

    * Data element ID scheme
    * Org unit ID scheme
    * ID scheme
    * Skip existing check

5.  Click on the **Import** button which will upload the file and start the
    importing process.

> **Tip**
>
> **It is highly recommend to use the Dry run option** to test before
> importing data; to make sure you keep control over any changes to your
> Metadata, and to check for problems with out-of-sync data elements or
> organisation unit names

#### PDF Data { #importPDFdata } 

DHIS2 supports import of data in the PDF format. This can be used to
import data produced by off-line PDF data entry forms. Please refer to
the section **Data set management** for details on how to produce a PDF
form which can be used for off-line data entry.

To import a PDF data file, navigate to the *PDF Data Import* item in the
side menu. Upload the completed PDF file and click *Import*.

### Event Import { #event_import } 

Event can be access from the sidebar by clicking on Event
import.

![](resources/images/import_export/event_import.png)

1.  Select a format: *JSON* , *CSV*, or *XML*

2.  Click **Advanced options** if you want to adjust one or more of
    the following settings before importing:

    * Event ID scheme
    * Data element ID scheme
    * Org unit ID scheme
    * ID scheme

3.  Click on the **Import** button which will upload the file and start the
    importing process.

### GML Import { #gml_import } 

GML Import can be accessed from the sidebar by clicking on GML
Import.

![](resources/images/import_export/gml_import.png)

1.  Upload a file using the *GML* (Geographic Markup Language) format.

2.  Click on the **Import** button which will upload the file and start the
    importing process.

### Tracked Entity Instances Import { #tei_import } 

Tracked Entity Instances Import can be accessed from the sidebar by
clicking on TEI Import.

![](resources/images/import_export/tei_import.png)

1.  Choose a file to upload

2.  Select a format: *JSON* or *XML*

3.  Select the appropriate settings for:

    * Identifier
    * Import report mode
    * Preheat mode
    * Import strategy
    * Atomic mode
    * Merge mode

4.  Click **Advanced options** if you want to adjust one or more of
    the following settings before importing:

    * Flush mode
    * Skip sharing
    * Skip validation
    * Inclusive strategy

5.  Click on the **Import** button which will upload the file and start the
    importing process.

> **Tip**
>
> **It is highly recommend to use the Dry run option** to test before
> importing data; to make sure you keep control over any changes to
> your Tracked Entity Instances.

## Exporting data

### Metadata Export { #metadata_export } 

Metadata export can be accessed from the sidebar by clicking on
Metadata export.

![](resources/images/import_export/metadata_export.png)

1.  Choose the list of objects you would like to export.

2.  Select a format: *JSON*, *CSV* or *XML*

3.  Select a compression type: *zip*, *gzip* or *uncompressed*

4.  Decide whether to check *Skip sharing and access settings*

5.  Click **Export metadata** which will open a new web-browser window
    that will give you a file to download to your local computer.

### Metadata Export with Dependencies { #metadata_export_dependencies } 

Metadata export with dependencies lets you create canned exports for
metadata objects. This type of export will include the metadata objects
and the metadata object's related objects; that is, the metadata which
belong together with the main object.



Table: Object types and their dependencies

| Object type | Dependencies included in export |
|---|---|
| **Data sets** | Data elements<br> <br>Sections<br> <br>Indicators<br> <br>Indicator types<br> <br>Attributes<br> <br>Data entry forms<br> <br>Legend sets<br> <br>Legends<br> <br>Category combinations<br> <br>Categories<br> <br>Category options<br> <br>Category option combinations<br> <br>Option sets |
| Programs | Data entry form<br> <br>Tracked entity<br> <br>Program stages<br> <br>Program attributes<br> <br>Program indicators<br> <br>Program rules<br> <br>Program rule actions<br> <br>Program rule variables<br> <br>Program attributes<br> <br>Data elements<br> <br>Category combinations<br> <br>Categories<br> <br>Category options<br> <br>Category option combinations<br> <br>Option sets |
| Category combination | Category combinations<br> <br>Categories<br> <br>Category options<br> <br>Category option combinations<br> <br>Attributes |
| Dashboard | Dashboard items<br> <br>Charts<br> <br>Event charts<br> <br>Pivot tables<br> <br>Event reports<br> <br>Maps<br> <br>Reports<br> <br>Resources |
| Data element groups | Data elements<br> <br>Category combinations<br> <br>Categories<br> <br>Category options<br> <br>Category option combinations<br> <br>Option sets<br> <br>Attributes<br> <br>Legend sets<br> <br>Legends |
| OptionSets | Option |

![](resources/images/import_export/metadata_dependency_export.png)

![](resources/images/import_export/metadata_dependency_export_object_types.png)

1.  Select an object type: *Data sets*, *Programs*, *Category combination*, 
    *Dashboard*, *Data element groups* or *OptionSets*.

2.  Select an object.

3.  Select a format: *JSON* or *XML*

4.  Select a compression type: *Zip* , *GZip* or *Uncompressed*

5.  Click **Export metadata dependencies** which will open a new
    web-browser window that will give you a file to download to your
    local computer.

### Data export { #data_export } 

Data export can be accessed from the sidebar by clicking on Data
export.

![](resources/images/import_export/data_export.png)

1.  Select which organisation units to export from.

2.  Select if you want export to include descendants of organisation
    units selected in Step 1 or only the manually selected
    organisation units.

3.  Select which data sets to export.

4.  Set the start and end date.

5.  Select a format: *JSON*, *CSV*, *XML*, or *ADX*

6.  Select a compression mode: **Zip** , **GZip** or **Uncompressed**

7.  Click **Advanced options** if you want to adjust one or more of
    the following settings before exporting:

    * Include deleted
    * Data element ID scheme
    * Organisation unit ID scheme
    * ID scheme

8.  Click **Export data** which will open a new web-browser window
    that will give you a file to download to your local computer.

### Event export { #event_export } 

Event export can be accessed from the sidebar by clicking on Event
export.

![](resources/images/import_export/event_export.png)

You can export event or tracker data in JSON, CSV, or XML formats.

1.  Select an organisation unit.

2.  Select the inclusion:

      - *Selected*: Export event data only for the selected
        organisation unit

      - *Directly below*: Export event data including the first
        level of the organisation units inside the selections as well
        as the selected organisation unit itself.

      - *All below*: Export event data for all organisation units
        inside the selections as well as the selected organisation
        unit itself.

3.  Select a program and a program stage (if applicable).

4.  Set the start date and end date.

5.  Select a format: *JSON*, *CSV*, or *XML*.

6.  Select a compression mode: *Zip*, *GZip* or *Uncompressed*.

7.  Click **Advanced options** if you want to adjust one or more of
    the following settings before exporting:

    * Include deleted
    * Data element ID scheme
    * Organisation unit ID scheme
    * ID scheme

8.  Click **Export events** which will open a new web-browser window
    that will give you a file to download to your local computer.

### Tracked Entity Instances export { #tei_export } 

Tracked entity instances export can be accessed from the sidebar by
clicking on TEI export.

![](resources/images/import_export/tei_export.png)

You can export event or tracker data in JSON, CSV, or XML format.

1.  Select the organisation units that should be included.

2.  Decide whether you want to filter by program or tracked entity type.

6.  Select a format: *JSON*, *CSV*, or *XML*.

7.  Click **Advanced options** if you want to adjust one or more of
    the following settings before exporting:

    * Filter by last updated date
    * Assigned user mode
    * Include deleted
    * Include all attributes
    * Data element ID scheme
    * Event ID scheme
    * Organisation unit ID scheme
    * ID scheme

8.  Click **Export tracked entity instances** which will open a new
    web-browser window that will give you a file to download to your
    local computer.

## Job Overview { #job_overview } 

The job overview page can be accessed from the sidebar by clicking on
*Job Overview*.

![](resources/images/import_export/job_overview.png)

This page allows you to see the progress of all the imports you have
started this session. You can see the list of all jobs on the left
side and details about a specific selected job on the right.

### Filtering by import job type

![](resources/images/import_export/job_overview_filter.png)

By default jobs of all import types are shown in the job list, but you
can filter categories you are interested in by clicking on the job
type filters above the job list.

### Recreating a previous job

![](resources/images/import_export/job_overview_recreate.png)

You can recreate previously run import jobs by clicking on the
*Recreate job* button at the bottom of the page, assuming you have
selected a job from the list. This will take you to the correct import
page and fill in all the form details exactly as the job you chose to
recreate.

## Schemes
The various schemes used in many of the import and export pages are
also known as identifier schemes and are used to map metadata objects
to other metadata during import, and to render metadata as part of
exports.



Table: Available values

| Scheme | Description |
|---|---|
| ID, UID | Match on DHIS2 stable Identifier, this is the default id scheme. |
| CODE | Match on DHIS2 Code, mainly used to exchange data with an external system. |
| NAME | Match on DHIS2 Name, please note that this uses what is available as *object.name*, and not the translated name. Also note that names are not always unique, and in that case, they can not be used. |
| ATTRIBUTE:ID | Match on metadata attribute, this attribute needs to be assigned to the type you are matching on, and also that the unique property is set to *true*. The main usage of this is also to exchange data with external systems, it has some advantages over *CODE* since multiple attributes can be added, so it can be used to synchronize with more than one system. |

### ID scheme
The ID scheme applies to all types of objects, but can be overwritten
by more specific object types.
