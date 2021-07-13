# DHIS2 Glossary { #dhis2_glossary }

## A

Aggregation
:   In the context of DHIS2, aggregation refers to how data elements are
    combined within a particular hierarchical relationship. As an
    example, all the health facilities in a particular district would
    contribute to the total value for the particular district in
    question. Different aggregation operators are supported within
    DHIS2, such as SUM, AVERAGE, and COUNT.

Analytics
:   Analytics refers to the process which processes and prepares data
    which has been entered into DHIS2 into a format which is more
    suitable for retrieving indicators and aggregated data. When data is
    entered into DHIS2, it is stored in a format which is optimized for
    writing the data. However, when data needs to be processed into
    indicators or aggregated (e.g from months to quarters), it is more
    efficient to transform and store this data in a different format
    which is optimized for read-only operations. The analytics system of
    DHIS2 is used extensively by the analytics apps (GIS, Pivot Table,
    Event reports, etc.).

    It is important to keep in mind that because the data which has been
    entered into DHIS2 must be processed into the analytics format, the
    data which appears in the analytics apps only represents the data
    which was present in the system the last time analytics was run. If
    data has been entered after that, analytics will need to be run
    again for this data to appear in the analytics apps.

Aggregate data
:   In the context of DHIS2, aggregate data refers to either data
    elements or indicators that have been derived from other
    hierarchical data sources. For instance, aggregate facility data
    would result from the aggregate totals of all patients that have
    attended that facility for a particular service. Aggregate district
    data would result from the aggregate totals of all facilities
    contained with a particular district.

Application programming interface
:   An application programming interface is a specification of how
    different software components should interact with each other. The
    DHIS2 API (or WebAPI) can be used to interface DHIS2 with other
    software, to build reports or custom data entry forms.

Approvals
:   Approvals can be used to control the visibility and editibility of
    data. When data is submitted from the lowest reporting level, it can
    be approved by the next higher level. This approval has two effects:

    1.  Data is no longer able to be edited in the data entry screens at
        the lower level.

    2.  Depending on the system settings which have been enabled, the
        data will become visible at the approval level.

    As an example, data is entered at the facility level, and the
    submitted for approval. Once the data has been approved at the
    district level, the data will become locked in the data entry
    screens for the facility level. It will also become visible in the
    analytics apps to district users.

## B

Bi-monthly
:   Refers to a two-month period, such as January 1st to February 28th.

## C

Category
:   Categories are groups of category options. The are used in
    combinations to disaggregate data elements. Categories are typically
    a single type of concept, such as "Age" or "Gender".

Category combinations
:   Category combinations are used to disaggregate data elements. As an
    example, the data element "Number of confirmed cases of malaria"
    could be disaggregated subdivided into to categories: "Age" and
    "Gender". In turn each of these categories, would consist of several
    category options, such as "Male" and "Female" for the gender
    category. Category combinations may consist of one or several
    categories.

Category combination options
:   Category combination options are dynamically composed of all of the
    different combinations of category options which compose a category
    combination. As an example, two categories "Gender" and "Age", might
    have options such as "Male" or "Female" and "<5 years" or ">5 years".
    The category combination options would then consist of:

    - Male <5 years
    - Male >5 years
    - Female <5 years
    - Female >5 years

Category option
:   Category options are atomic elements that are grouped into
    categories.

Comma separated values
:   Comma separated values are series of tabular data stored in a
    plain-text format. They are commonly used with DHIS2 to export and
    import data values.

## D

Data dictionary
:   A collection of data elements and indicators, which can be exchanged
    with other DHIS2 systems. Typically used to define a set of data
    elements and indicators when setting up the DHIS2 system.

Data exchange format
:   In the context of DHIS2, the "data exchange format" refers to a XML
    schema that enables the transportation of data and meta-data between
    disconnected DHIS2 instances, as well as between different
    applications that support the DXF schema.

Datamart
:   A set of database tables in DHIS2 that contains processed data
    elements and indicator values that is generated based on aggregation
    rules and calculated data element and indicator formulae. Datamart
    tables are used for analysis and report production. Typically, users
    should not work directly with unaggregated data values, but rather
    with values that have resulted from a datamart export for analysis.

Data element
:   A data element is the fundamental building block of DHIS2. It is an
    atomic unit of data with well-defined meaning. Essentially it is a
    data value that has been actually observed or recorded which is
    further characterized by a number of dimensions. As an example the
    data element "Number of fully immunized children" would refer to the
    number of children that received this particular service. Data
    elements are always linked to a period as well as an organizational
    unit. They optionally may be linked to other dimensions.

Data element group
:   Data element groups are used to categorize multiple data elements
    according to a common theme, such as "Immunization" or "ART".
    Typically, they are used during reporting and analysis to allow
    related data elements to be analysed together.

Data element group sets
:   Data element groups are used to categorize multiple data element
    groups into a common theme.

Dimension
:   A dimension is used to categorize data elements during analysis.
    Dimensions provide a mechanism to group and filter data based on
    common characteristics. Typically, related data elements may be
    aggregated or filtered during analysis with the use of dimensions.
    Dimensions may be a member of a hierarchy. For instance the "Period"
    dimension may be broken down into "Day-\>Month-\>Quarter-\>Year".

DXF

## H

Health management information system
:   Typically, an electronic database system that is used to record
    aggregated data on service delivery, disease incidence, human
    resource data and other information used to evaluate the performance
    of delivery of health services. Typically, an HMIS does not contain
    the highly detailed data of electronic medical record systems or
    individual patient data.

## I

Indicator
:   The divisor of an indicator. Can be composed of multiple data
    elements with the use of an indicator formula.

    \[
    Indicator = {\frac{Numerator}{Denominator}}
    \]

    This is obviously a very generalized example. The numerator and
    indicator themselves can be composed of various data elements,
    factors, and the four basic operands (addition, multiplication,
    division and subtraction).

## N

Numerator
:   The dividend of a indicator. Can be composed of multiple data
    elements and factors with the use of indicator formulas.

## O

Organisational unit
:   An organisational unit is usually a geographical unit, which exists
    within a hierarchy. As an example, in the United States, "Georgia"
    would be considered an organisational unit with in the orgunit level
    of "State". Organizational units can also be used to specify an
    administrative unit, such as a ward within a hospital. The
    organisational unit dimension specifies essentially *where* a
    particular data value occurs.

Organisational unit level
:   Refers to a level within an organizational hierarchy. Typically,
    countries are administered at different levels, such as 1) Country
    2) States 3) Counties 4) Health facilities. In the context of DHIS2,
    health facilities typically are the lowest orgunit level. Data is
    aggregated upwards from the lowest orgunit level to the highest.

## P

Period
:   A period is a specific time interval which consists of a start date
    and end date. For instance "January 2011" would refer to the time
    interval of January 1st 2011-January 31st 2011.

## U

Unique identifier
:   A unique identifier (UID) is a semi-random series of letters and
    numbers used by DHIS2 to identify specific resources. UIDs begin
    with a letter, and are followed by exactly 10 letters or digits.
