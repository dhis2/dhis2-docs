# DHIS2 Glossary

<!--DHIS2-SECTION-ID:dhis2_glossary-->

  - Aggregation
    In the context of DHIS2, aggregation refers to how data elements are
    combined within a particular hierarchical relationship. As an
    example, all the health facilities in a particular district would
    contribute to the total value for the particular district in
    question. Different aggregation operators are supported within
    DHIS2, such as SUM, AVERAGE, and COUNT.

  - Analytics
    Analytics refers to the process which processes and prepares data
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

  - Aggregate data
    In the context of DHIS2, aggregate data refers to either data
    elements or indicators that have been derived from other
    hierarchical data sources. For instance, aggregate facility data
    would result from the aggregate totals of all patients that have
    attended that facility for a particular service. Aggregate district
    data would result from the aggregate totals of all facilities
    contained with a particular district.

  - Application programming interface
    An application programming interface is a specification of how
    different software components should interact with each other. The
    DHIS2 API (or WebAPI) can be used to interface DHIS2 with other
    software, to build reports or custom data entry forms.

  - Approvals
    Approvals can be used to control the visibility and editibility of
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

<!-- end list -->

  - Bi-monthly
    Refers to a two-month period, such as January 1st to February 28th.

<!-- end list -->

  - Category
    Categories are groups of category options. The are used in
    combinations to disaggregate data elements. Categories are typically
    a single type of concept, such as "Age" or "Gender".

  - Category combinations
    Category combinations are used to disaggregate data elements. As an
    example, the data element "Number of confirmed cases of malaria"
    could be disaggregated subdivided into to categories: "Age" and
    "Gender". In turn each of these categories, would consist of several
    category options, such as "Male" and "Female" for the gender
    category. Category combinations may consist of one or several
    categories.

  - Category combination options
    Category combination options are dynamically composed of all of the
    different combinations of category options which compose a category
    combination. As an example, two categories "Gender" and "Age", might
    have options such as "Male"/"Female" and "\<5 years"/"\>5 years".
    The category combination options would then consist of:

    (Male/\<5 years)

    (Male/\>5 years)

    (Female/\<5 years)

    (Female/\>5 years)

  - Category option
    Category options are atomic elements that are grouped into
    categories.

  - Comma separated values
    Comma separated values are series of tabular data stored in a
    plain-text format. They are commonly used with DHIS2 to export and
    import data values.

<!-- end list -->

  - Data dictionary
    A collection of data elements and indicators, which can be exchanged
    with other DHIS2 systems. Typically used to define a set of data
    elements and indicators when setting up the DHIS2 system.

  - Data exchange format
    In the context of DHIS2, the "data exchange format" refers to a XML
    schema that enables the transportation of data and meta-data between
    disconnected DHIS2 instances, as well as between different
    applications that support the DXF schema.

  - Datamart
    A set of database tables in DHIS2 that contains processed data
    elements and indicator values that is generated based on aggregation
    rules and calculated data element and indicator formulae. Datamart
    tables are used for analysis and report production. Typically, users
    should not work directly with unaggregated data values, but rather
    with values that have resulted from a datamart export for analysis.

  - Data element
    A data element is the fundamental building block of DHIS2. It is an
    atomic unit of data with well-defined meaning. Essentially it is a
    data value that has been actually observed or recorded which is
    further characterized by a number of dimensions. As an example the
    data element "Number of fully immunized children" would refer to the
    number of children that received this particular service. Data
    elements are always linked to a period as well as an organizational
    unit. They optionally may be linked to other dimensions.

  - Data element group
    Data element groups are used to categorize multiple data elements
    according to a common theme, such as "Immunization" or "ART".
    Typically, they are used during reporting and analysis to allow
    related data elements to be analysed together.

  - Data element group sets
    Data element groups are used to categorize multiple data element
    groups into a common theme.

  - Dimension
    A dimension is used to categorize data elements during analysis.
    Dimensions provide a mechanism to group and filter data based on
    common characteristics. Typically, related data elements may be
    aggregated or filtered during analysis with the use of dimensions.
    Dimensions may be a member of a hierarchy. For instance the "Period"
    dimension may be broken down into "Day-\>Month-\>Quarter-\>Year".

  - DXF

<!-- end list -->

  - Health management information system
    Typically, an electronic database system that is used to record
    aggregated data on service delivery, disease incidence, human
    resource data and other information used to evaluate the performance
    of delivery of health services. Typically, an HMIS does not contain
    the highly detailed data of electronic medical record systems or
    individual patient data.

<!-- end list -->

  - Indicator
    The divisor of an indicator. Can be composed of multiple data
    elements with the use of an indicator formula.

    This is obviously a very generalized example. The numerator and
    indicator themselves can be composed of various data elements,
    factors, and the four basic operands (addition, multiplication,
    division and subtraction).

<!-- end list -->

  - Numerator
    The dividend of a indicator. Can be composed of multiple data
    elements and factors with the use of indicator formulas.

<!-- end list -->

  - Organisational unit
    An organisational unit is usually a geographical unit, which exists
    within a hierarchy. As an example, in the United States, "Georgia"
    would be considered an organisational unit with in the orgunit level
    of "State". Organizational units can also be used to specify an
    administrative unit, such as a ward within a hospital. The
    organisational unit dimension specifies essentially "where" a
    particular data value occurs.

  - Organisational unit level
    Refers to a level within an organizational hierarchy. Typically,
    countries are administered at different levels, such as 1) Country
    2) States 3) Counties 4) Health facilities. In the context of DHIS2,
    health facilities typically are the lowest orgunit level. Data is
    aggregated upwards from the lowest orgunit level to the highest.

<!-- end list -->

  - Period
    A period is a specific time interval which consists of a start date
    and end date. For instance "January 2011" would refer to the time
    interval of January 1st 2011-January 31st 2011.

<!-- end list -->

  - Unique identifier
    A unique identifier (UID) is a semi-random series of letters and
    numbers used by DHIS2 to identify specific resources. UIDs begin
    with a letter, and are followed by exactly 10 letters or digits.

#

<!--DHIS2-SECTION-ID:AlSaid2010--> Said Salah Eldin Al Said The health
information system in Sudan The University of Oslo 2010
<http://urn.nb.no/URN:NBN:no-27062>

<!--DHIS2-SECTION-ID:Berg2007--> Eivind Anders Berg The challenges of
implementing a health information system in Vietnam The University of
Oslo 2007 <http://urn.nb.no/URN:NBN:no-15021>

<!--DHIS2-SECTION-ID:BraaHedeberg2002--> Jørn Braa Calle Hedberg The Struggle
for District-Based Health Information Systems in South Africa
Information Society 18 113-127 2002
<http://search.ebscohost.com/login.aspx?direct=true&db=aph&AN=6705438&site=ehost-live>

<!--DHIS2-SECTION-ID:BraaNetworksAction2004--> Eric;Braa Jørn; Monteiro
Sundeep Sahay Networks of Action: Sustainable Health Information Systems
Across Developing Countries MIS Quarterly 28 3 2004
<http://aisel.aisnet.org/misq/vol28/iss3/3/>

<!--DHIS2-SECTION-ID:Brucker2007--> Øyvind FBrucker Internationalization and
localization - A case study from HISP The University of Oslo 2007
<http://urn.nb.no/URN:NBN:no-15774>

<!--DHIS2-SECTION-ID:Damitew2005--> Hirut Gebrekidan Damitew Netsanet
Haile Gebreyesus Sustainability and optimal use of Health Information
Systems The University of Oslo 2005 <http://urn.nb.no/URN:NBN:no-11506>

<!--DHIS2-SECTION-ID:Jacucci06exploringtensions--> Ved Anfinsen Edoardo
Jacucci Cover Inger S EXPLORING TENSIONS IN INFORMATION SYSTEMS
STANDARDIZATION Two Case Studies from Healthcare in Norway and South
Africa 2006 <http://folk.uio.no/edoardo/MatNatAvh_Jacucci_rettet.pdf>

<!--DHIS2-SECTION-ID:Gjendem2008--> Anders Gjendem Recruitment, training,
communication and Open Source The University of Oslo 2008
<http://urn.nb.no/URN:NBN:no-19821>

<!--DHIS2-SECTION-ID:Gjerull2006--> Nils Fredrik Gjerull Open Source Software
Development in Developing Countries The University of Oslo 2006
<http://urn.nb.no/URN:NBN:no-13117>

<!--DHIS2-SECTION-ID:Heldre2006--> Thor Helge Heldre Study of a Health
Information System pilot project in Tanzania The University of Oslo 2006
<http://urn.nb.no/URN:NBN:no-12362>

<!--DHIS2-SECTION-ID:Jacobsen2006--> Petter Jacobsen Design and development
of a global reporting solution for DHIS The University of Oslo 2006
<http://urn.nb.no/URN:NBN:no-12659>

<!--DHIS2-SECTION-ID:BraaStandards2007--> Arthur Heywood Woishet Mohammed
Vincent ShawJørn Braa Ole Hanseth DEVELOPING HEALTH INFORMATION SYSTEMS
IN DEVELOPING COUNTRIES: THE FLEXIBLE STANDARDS STRATEGY MIS Q 31 1 2007
<http://heim.ifi.uio.no/~vshaw/Files/Published%20Papers%20included%20in%20Kappa/4_Braa_Flexible%20standards.pdf>

<!--DHIS2-SECTION-ID:BraaSahayPowerToUsers--> Sundeep Sahay Jørn Braa
Integrated Health Information Architecture - Power to the Users Matrix
Publishers 384 2012

<!--DHIS2-SECTION-ID:Lewis2005--> John Lewis Design and development of
spatial GIS application for primary healthcare sector The University of
Oslo 2005 <http://urn.nb.no/URN:NBN:no-11504>

<!--DHIS2-SECTION-ID:Mangset2005--> Lars Mangset DHIS-2 - A Globally
Distributed Development Process The University of Oslo 2005
<http://urn.nb.no/URN:NBN:no-10640>

<!--DHIS2-SECTION-ID:Ngoma2007--> Caroline Ngoma Cultivation Strategies in
the Implementation of Health Management Information System in Zanzibar
The University of Oslo 2007 <http://urn.nb.no/URN:NBN:no-16911>

<!--DHIS2-SECTION-ID:Nguyen2007--> Thanh Ngoc Nguyen OSS For Health Care in
Developing Countries The University of Oslo 2007
<http://urn.nb.no/URN:NBN:no-17859>

<!--DHIS2-SECTION-ID:Saeb2009--> E.K. Golly-Kobrissa R.T. Titlestad O. Braa
J.Saeb J. Kossi Integrating health information systems in Sierra Leone
379 - 391 2009

<!--DHIS2-SECTION-ID:ShawComplexityInspried2009--> Vincent Shaw A complexity
inspired approach to co-evolutionary hospital management information
systems development 2009
<http://folk.uio.no/vshaw/Files/VShaw%20Kappa%20Final%20Version/2_V_Shaw%20Intro%20Chapter_no%20annex.pdf>

<!--DHIS2-SECTION-ID:Staring_Titlestad_2008--> Knut Staring O H Titlestad
Development as a Free Software: Extending Commons Based Peer Production
to the South ICIS 2008 Proceedings 50 2008
<http://aisel.aisnet.org/icis2008/50>

> This paper examines the concept of commons-based peer production
> (CBPP) in the context of public health information systems in the
> South. Based on an analysis of the findings from a global network of
> software development and implementation, an approach to preserve the
> importance of local user participation in distributed development is
> presented. Through practical examples, we discuss the applicability of
> the CBPP model for software production aimed at improving the public
> health sector in the South, and propose the concept of a snowflake
> topology.

<!--DHIS2-SECTION-ID:Store2007--> Margrethe Store Explore the challenges of
providing documentation in open source projects The University of Oslo
2007 <http://urn.nb.no/URN:NBN:no-15782>

<!--DHIS2-SECTION-ID:Storset2010--> Leif Arne Storset Integration of Health
Management Information Systems The University of Oslo 2010
<http://urn.nb.no/URN:NBN:no-25666>

<!--DHIS2-SECTION-ID:ShawScaling2007--> Jorn Braa Vincent Shaw Shegaw Anagaw
Mengiste Scaling of Health Information Systems in Nigeria and Ethiopia-
Considering the Options 2007
<http://heim.ifi.uio.no/~vshaw/Files/Published%20Papers%20included%20in%20Kappa/6_Shaw_IFP9.4%20Scaling%20of%20HIS_Considering%20the%20Options.pdf>

<!--DHIS2-SECTION-ID:Vo2009--> Kim Anh ThiVo Challenges of Health
Information Systems Programs in Developing Countries: SUCCESS and
FAILURE The University of Oslo 2009 <http://urn.nb.no/URN:NBN:no-23652>

<!--DHIS2-SECTION-ID:Overland2010--> Jan HenrikØverland An Open Source
Approach to Improving GIS Implementations in Developing Countries The
University of Oslo 2010 <http://urn.nb.no/URN:NBN:no-24751>

<!--DHIS2-SECTION-ID:Overland2006--> Lars HelgeØverland Global Software
Development and Local Capacity Building University of Oslo 2006
<http://urn.nb.no/URN:NBN:no-13609>
