# DHIS2 Acronyms and Abbreviations { #dhis2_acronyms }

Expansions of acronyms and abbreviations you are likely to meet in DHIS2 documentation, the Community of Practice, DHIS2 Academy material, and conversation with the HISP network.

This page covers **acronyms**. For definitions of DHIS2 *concepts* — aggregation, analytics, the organisation unit hierarchy — see the [DHIS2 Glossary](#dhis2_glossary).

Where an acronym has a well-known meaning outside DHIS2 that differs from ours, the DHIS2 meaning is given first and the other is noted under *Not to be confused with*. Where an acronym is really a name rather than an abbreviation, that is stated instead of inventing an expansion.

**Common misspellings and near-misses are listed too**, as short cross-references pointing at the right entry — because a great many acronym lookups fail by one or two transposed letters rather than because the term is genuinely unknown. If you looked something up and landed on a cross-reference, that is working as intended.

**The lower-case `e` prefix** on many DHIS2 and global health acronyms simply means *electronic*: the digitised form of a system that also exists on paper. [eIDSR](#dhis2_acronyms_e), [eCHIS](#dhis2_acronyms_e), [eLMIS](#dhis2_acronyms_e) and the Immunization eRegistry all follow this convention, so an unfamiliar `e`-prefixed acronym can usually be decoded by looking up the rest of it. The same applies to a leading `i` for *integrated*, as in [iCHIS](#dhis2_acronyms_i).

To add a missing acronym or correct one, see [Contributing an acronym](#dhis2_acronyms_contributing).

## A { #dhis2_acronyms_a }

ADEA
:   **Association for the Development of Education in Africa.**
    Pan-African forum for education policy dialogue, established in 1988
    and hosted by the African Development Bank. Relevant to DHIS2
    education-sector work.
    [adeanet.org](https://www.adeanet.org/en/association-development-education-africa-adea)

ADX
:   **Aggregate Data Exchange.** An [IHE](#dhis2_acronyms_i) profile for
    exchanging aggregate public health data, using SDMX data structure
    definitions over HTTP. DHIS2 can import and export ADX-formatted
    aggregate data.
    [wiki.ihe.net](https://wiki.ihe.net/index.php/Aggregate_Data_Exchange)

    *Related:* mADX is the FHIR-based mobile variant of the same
    profile. *Note:* IHE spells it "Exchange"; the camel-case "eXchange"
    sometimes seen in DHIS2 material is not IHE's own styling.

AEC
:   **Annual Education Census.** The yearly national school data
    collection exercise in several education-sector DHIS2
    implementations, and typically the main input to an
    [EMIS](#dhis2_acronyms_e).

AEFI
:   **Adverse Events Following Immunization.** Any untoward medical
    occurrence following immunisation, whether or not it is causally
    related to the vaccine. DHIS2 provides an AEFI tracker package built
    on WHO's core variables.
    [AEFI package design](https://docs.dhis2.org/en/implement/health/immunization/adverse-events-following-immunization-aefi/design.html)

    *Not to be confused with:* [ESAVI](#dhis2_acronyms_e), the same
    concept under its PAHO / Latin American name, and MAPI, a third
    regional variant.

AeHIN
:   **Asia eHealth Information Network.** Peer network of digital health
    professionals across South and South-East Asia, working on
    interoperability and health information system strengthening.
    [aehin.org](https://www.aehin.org/)

Africa CDC
:   **Africa Centres for Disease Control and Prevention.** Continental
    public health agency of the African Union, established in 2016.
    [africacdc.org](https://africacdc.org/about-us/)

    *Not to be confused with:* the United States
    [CDC](#dhis2_acronyms_c), a separate and unaffiliated agency. Note
    the British spelling "Centres" here and the American "Centers" for
    the US agency.

ANC
:   **Antenatal Care.** Health care during pregnancy, before birth. WHO
    recommends a minimum of eight ANC contacts. A very common DHIS2 data
    set and tracker program area.
    [Antenatal care registry design](https://docs.dhis2.org/en/implement/health/rmncah/antenatal-care-registry/design.html)

AOC
:   **Attribute option combination** (also written *attribute option
    combo*). The fifth data dimension in DHIS2 aggregate data: a
    combination of category options attached to a **data set** rather
    than to a data element, used to disaggregate every value in that
    data set — by implementing partner or project, for example. In the
    API this is the `attributeOptionCombo` field.
    [Additional data dimensions](https://docs.dhis2.org/en/use/user-guides/dhis-core-version-master/understanding-the-data-model/additional-data-dimensions.html)

    *Not to be confused with:* [COC](#dhis2_acronyms_c), the category
    option combination, which attaches to a data element. AOC and COC
    are structurally identical and easily mixed up. AO is sometimes used
    as shorthand for the attribute option itself.

API
:   **Application Programming Interface.** In DHIS2 this almost always
    means the DHIS2 Web API, the HTTP interface at `/api` used to read
    and write metadata and data.
    [Web API documentation](https://docs.dhis2.org/en/develop/using-the-api/dhis-core-version-master/introduction.html)

## C { #dhis2_acronyms_c }

CDC
:   **Centers for Disease Control and Prevention.** The United States
    national public health agency, and a long-standing DHIS2 funder and
    partner.
    [cdc.gov](https://www.cdc.gov/about/organization/index.html)

    *Not to be confused with:* [Africa CDC](#dhis2_acronyms_a), which is
    unaffiliated. Note the full official name includes "and Prevention";
    "Centers for Disease Control" alone is incomplete.

CDN
:   **Content Delivery Network.** A geographically distributed set of
    servers that deliver static assets — JavaScript libraries,
    stylesheets, images — from a location near the user.

CDSR
:   **Complete Data Set Registration.** DHIS2 developer shorthand for
    the record marking a given data set, period, organisation unit and
    attribute option combination as completely captured. Exposed through
    `/api/completeDataSetRegistrations`.
    [Complete data set registrations](https://docs.dhis2.org/en/develop/using-the-api/dhis-core-version-master/data-validation.html#webapi_complete_data_set_registrations)

    *Not to be confused with:* the Cochrane Database of Systematic
    Reviews, which is what CDSR means in most health literature. This is
    a DHIS2 API term only, and is best written out in full outside
    developer contexts.

CESA
:   **Continental Education Strategy for Africa.** African Union
    education strategy. CESA 16-25 covered 2016–2025 and has been
    succeeded by CESA 2026–2035.
    [au.int](https://au.int/en/documents/20171217/continental-education-strategy-africa-2016-2025-cesa-16-25-vol-02-dec-2017)

CHAP
:   **Climate Health Analytics Platform.** Open-source platform
    developed by the HISP Centre for climate-informed forecasting of
    climate-sensitive disease, used with the DHIS2 Modeling App.
    [chap.dhis2.org](https://chap.dhis2.org/)

CHIS
:   **Community Health Information System.** A combination of paper,
    software, hardware, people and processes supporting informed
    decision making and action by community health workers at community
    level — distinct from a facility-based [HMIS](#dhis2_acronyms_h).
    [CHIS foundational terms](https://docs.dhis2.org/en/implement/health/chis-community-health-information-system/implementation/foundational-terms.html)

    *Not to be confused with:* [eCHIS](#dhis2_acronyms_e) and
    [iCHIS](#dhis2_acronyms_i), which name specific national
    implementations.

CHW
:   **Community Health Worker.** A health worker who is a member of, and
    selected by, the community they serve, supported by but not
    necessarily part of the formal health system, and with shorter
    training than a professional health worker.
    [CHIS foundational terms](https://docs.dhis2.org/en/implement/health/chis-community-health-information-system/implementation/foundational-terms.html)

CI
:   **Continuous Integration.** Automatically building and testing every
    change pushed to a repository, so integration problems surface
    early. DHIS2 repositories run CI on every pull request.

CMAM
:   **Community-based Management of Acute Malnutrition.** Approach to
    identifying and treating acute malnutrition in the community using
    ready-to-use therapeutic food, rather than requiring inpatient
    therapeutic feeding. Used with [MUAC](#dhis2_acronyms_m) screening.

    *Also written:* "Community Management of Acute Malnutrition". Both
    forms are in circulation.

COC
:   **Category option combination** (also written *category option
    combo*). The disaggregation attached to a **data element** — the
    combination of category options such as "Female, under 15" that a
    data value is broken down by. In the API this is the
    `categoryOptionCombo` field.
    [Additional data dimensions](https://docs.dhis2.org/en/use/user-guides/dhis-core-version-master/understanding-the-data-model/additional-data-dimensions.html)

    *Not to be confused with:* [AOC](#dhis2_acronyms_a), the attribute
    option combination, which attaches to a data set.

CoP
:   **Community of Practice.** The DHIS2 community forum, where users,
    implementers and the core team ask questions and share solutions.
    [community.dhis2.org](https://community.dhis2.org/)

CORS
:   **Cross-Origin Resource Sharing.** The HTTP header mechanism by
    which a server tells the browser which other origins may load its
    resources. DHIS2 has a CORS allowlist setting, which custom apps
    hosted outside the instance need to be added to.

CR
:   **Client Registry.** In [OpenHIE](#dhis2_acronyms_o) architecture,
    the component holding a single authoritative index of client
    identities across systems.

CRS
:   **Coordinate Reference System.** In DHIS2 Maps and GIS work, the
    spatial reference used for coordinates. DHIS2 supports only
    EPSG:4326 (geographic longitude/latitude).
    [Maps user guide](https://docs.dhis2.org/en/use/user-guides/dhis-core-version-241/configuring-the-system/maps.html)

    *Not to be confused with:* Congenital Rubella Syndrome, which is
    what CRS means in DHIS2's vaccine-preventable disease surveillance
    material. Check which sense a document intends.

CRVS
:   **Civil Registration and Vital Statistics.** The national system for
    registering births, deaths and other vital events and producing
    vital statistics from them. A DHIS2 [EIR](#dhis2_acronyms_e) can
    generate birth notifications into a CRVS.
    [EIR design](https://docs.dhis2.org/en/implement/health/immunization/eir-immunization-eregistry/design.html)

    *Note:* the final S is Statistics, not "Events".

CSP
:   **Content Security Policy.** An HTTP response header controlling
    which resources — particularly scripts — a page is allowed to load,
    chiefly as a defence against cross-site scripting.

CSTL
:   **Care and Support for Teaching and Learning.**
    [SADC](#dhis2_acronyms_s) regional education framework addressing
    barriers to learning. Individual countries brand their national
    implementation differently; Eswatini's, for instance, is called
    Inqaba, which is a programme name rather than an acronym.

## D { #dhis2_acronyms_d }

DAK
:   **Digital Adaptation Kit.** A WHO SMART Guidelines product:
    software-neutral operational requirements for a health area,
    comprising a data dictionary, decision-support logic, indicator
    dictionary and functional requirements. Several DHIS2 metadata
    packages are built from DAKs.
    [Antenatal care registry design](https://docs.dhis2.org/en/implement/health/rmncah/antenatal-care-registry/design.html)

DATIM
:   **Data for Accountability, Transparency and Impact Monitoring.**
    [PEPFAR](#dhis2_acronyms_p)'s central reporting system, built on a
    PEPFAR-specific version of DHIS2 and used in more than 50 countries.
    [datim.org](https://www.datim.org/)

    *Note:* often truncated to "Data for Accountability, Transparency
    and Impact", which drops the M.

DE
:   **Data element.** DHIS2 shorthand for the metadata object
    representing what is being recorded — "Malaria cases treated",
    "Patient weight". Widely used in conversation and in configuration
    spreadsheets.

DHIS
:   **District Health Information Software.** The name of the original
    software, first developed from 1994 within the Health Information
    Systems Programme. Now historical: the current platform is called
    DHIS2.
    [HISP and DHIS2 names](https://dhis2.org/hisp-dhis2-official-names/)

DHIS2
:   **Not an abbreviation — a name.** Since 2023 the official name of
    the software platform is simply DHIS2, and of the organisation
    simply [HISP](#dhis2_acronyms_h), "not as abbreviations, but as
    names in and of themselves". The names derive from District Health
    Information Software and Health Information Systems Programme, but
    the change was made deliberately: education ministries were
    reluctant to adopt something whose "H" stood for Health, even where
    DHIS2 had every feature their [EMIS](#dhis2_acronyms_e) needed.
    DHIS2 is a generic data platform used across health, education,
    logistics, climate, agriculture and other sectors.
    [HISP and DHIS2 names](https://dhis2.org/hisp-dhis2-official-names/)

    *Not to be confused with:* "DHIS 2" with a space, the historical
    styling. Current documentation uses the compact form DHIS2.

DICE
:   **Digital Health Centre of Excellence.** Multi-agency initiative
    launched by UNICEF and WHO in 2021 (originally the COVID-19 Digital
    Health Centre of Excellence) coordinating donor support and country
    technical assistance in digital health.
    [UNICEF digital health](https://www.unicef.org/health/digital-health)

    *Note:* a stylised abbreviation rather than a strict initialism —
    the letters do not map word-for-word.

DPG
:   **Digital Public Good.** Open-source software, open data, open AI
    models, open standards and open content that adhere to privacy and
    other best practices, do no harm by design, and are of high
    relevance to the Sustainable Development Goals. DHIS2 is a
    recognised DPG.
    [digitalpublicgoods.net](https://www.digitalpublicgoods.net/digital-public-goods)

    *Related:* DPGA is the Digital Public Goods Alliance, which
    maintains the DPG Standard. DHIS2 is also sometimes described as a
    Global Public Good or as Digital Public Infrastructure.

## E { #dhis2_acronyms_e }

ECCDE
:   **Early Childhood Care and Development Education.** Pre-primary
    education level, reported in several education-sector DHIS2
    implementations.

eCHIS
:   **Electronic Community Health Information System.** Specifically,
    Ethiopia's national mobile CHIS, used by Health Extension Workers
    across thousands of health posts and covering many health
    programmes.
    [Ethiopia MoH eCHIS](https://www.moh.gov.et/index.php/projects-3-col/echis)

    *Not to be confused with:* [iCHIS](#dhis2_acronyms_i), a separate
    integrated CHIS used in Malawi and elsewhere, or generic
    [CHIS](#dhis2_acronyms_c). Also written ECHIS.

eIDSR
:   **Electronic Integrated Disease Surveillance and Response.** The
    digital implementation of [IDSR](#dhis2_acronyms_i), usually
    DHIS2-based, enabling real-time reporting from facilities and
    automated outbreak alerts.
    [Tanzania architecture](https://docs.dhis2.org/en/topics/user-stories/tanzania-integrated-health-information-architecture/architecture.html)

    *Note:* the leading "e" is *electronic*; glossing eIDSR as just
    "Integrated Disease Surveillance and Response" loses the distinction
    from IDSR itself. Also written e-IDSR and EIDSR.

EIR
:   **Electronic Immunization Registry.** An individual-level register,
    built on DHIS2 Tracker, following each child through the national
    vaccination schedule, with clinical decision support and optional
    birth notification to [CRVS](#dhis2_acronyms_c).
    [EIR design](https://docs.dhis2.org/en/implement/health/immunization/eir-immunization-eregistry/design.html)

    *Also called:* the DHIS2 package is titled "Immunization eRegistry";
    EIR and eRegistry are used interchangeably.

eLMIS
:   **Electronic Logistics Management Information System.** The digital
    form of an [LMIS](#dhis2_acronyms_l). DHIS2 is used as a last-mile
    eLMIS and can integrate with upstream national eLMIS or ERP systems.
    [DHIS2 for Logistics](https://dhis2.org/logistics/)

EMIS
:   **Education Management Information System.** The education-sector
    counterpart of an [HMIS](#dhis2_acronyms_h): the national system for
    collecting, analysing and using data from schools and other
    institutions of learning. DHIS2 is used as an EMIS in a growing
    number of countries.
    [DHIS2 for Education](https://education.dhis2.org/)

    *Related:* [SEMIS](#dhis2_acronyms_s) is DHIS2's individual-level
    education solution.

EMPDSR
:   *See [MPDSR](#dhis2_acronyms_m).* Most likely a rendering of
    **eMPDSR**, the electronic form of Maternal and Perinatal Death
    Surveillance and Response, following the `e-` prefix convention
    described at the top of this page. No DHIS2 source states this
    expansion directly, so it is offered as the near-miss rather than as
    a definition — if you know the intended sense, please
    [correct this entry](#dhis2_acronyms_contributing).

EMR
:   **Electronic Medical Record.** A patient's clinical record held in a
    facility-level system. DHIS2 is not itself an EMR, though DHIS2
    Tracker overlaps with EMR use cases and DHIS2 is frequently
    integrated with EMRs.
    [DHIS2 and electronic medical records](https://dhis2.org/health/electronic-medical-records/)

EMTCT
:   **Elimination of Mother-to-Child Transmission.** A validation goal
    for eliminating vertical transmission of HIV, syphilis and hepatitis
    B.

    *Not to be confused with:* [PMTCT](#dhis2_acronyms_p), *prevention*
    of mother-to-child transmission, which is the intervention rather
    than the elimination target.

ESAVI
:   **Events Supposedly Attributable to Vaccination or Immunization**
    (Spanish: *Eventos Supuestamente Atribuibles a la Vacunación o
    Inmunización*). The PAHO and Latin American term for the concept
    English-language material calls [AEFI](#dhis2_acronyms_a). DHIS2 has
    a PAHO-developed ESAVI tracker.
    [ESAVI in the CoP](https://community.dhis2.org/t/from-dhis2-to-smart-guidelines-for-esavi/64668)

ESSP
:   **Education Sector Strategic Plan.** A country's multi-year
    education strategy, and usually the source of the indicators an
    education-sector DHIS2 implementation must report.

## F { #dhis2_acronyms_f }

FHIR
:   **Fast Healthcare Interoperability Resources.** HL7's standard for
    exchanging health information electronically, built around modular
    "Resources". DHIS2 supports FHIR-based integration.
    [hl7.org/fhir](https://www.hl7.org/fhir/overview.html) ·
    [DHIS2 and FHIR](https://dhis2.org/integration/fhir/)

    *Note:* it is "Health**care**", not "Health", and "Resource**s**"
    plural. Both shortened forms are common but neither is HL7's.

FPE
:   **Free Primary Education.** Policy of removing school fees at
    primary level, and a reporting category in several education-sector
    implementations.

FSH
:   **FHIR Shorthand.** HL7's domain-specific language for authoring
    [FHIR](#dhis2_acronyms_f) profiles and implementation guides.
    [hl7.org](http://hl7.org/fhir/uv/shorthand/)

## G { #dhis2_acronyms_g }

GPE
:   **Global Partnership for Education.** Multi-stakeholder partnership
    and the largest global fund dedicated to education in lower-income
    countries.
    [globalpartnership.org](https://www.globalpartnership.org/who-we-are/about-gpe)

GRADEL
:   *Almost certainly a misspelling of **Gradle**.* Gradle is not an
    acronym — it is the build automation tool used by the DHIS2 Android
    SDK and the Android Capture app. Dependencies are declared in
    `build.gradle` and APKs are built with commands such as
    `gradlew assembleRelease`.
    [Android SDK getting started](https://docs.dhis2.org/en/develop/developing-with-the-android-sdk/getting-started.html)
    ·
    [Compiling and distributing the Capture app](https://developers.dhis2.org/docs/mobile/android-capture-app/compilation-distribution/)

GS1
:   **Not an abbreviation — an organisation name.** GS1 is the global
    non-profit standards organisation responsible for barcodes and
    related identification standards used in supply chains, including
    health commodity traceability. Relevant to DHIS2 logistics work.
    [gs1.org](https://www.gs1.org/about)

## H { #dhis2_acronyms_h }

HIE
:   **Health Information Exchange.** Both the secure electronic sharing
    of health information between authorised organisations, and the
    infrastructure that provides it. See also
    [OpenHIE](#dhis2_acronyms_o).

HIS
:   **Health Information System.** The general term for a system that
    collects, manages and uses health data. [HMIS](#dhis2_acronyms_h) is
    the management-oriented subset most DHIS2 implementations occupy.

HISP
:   **Not an abbreviation — a name.** Since 2023 the official name of
    the organisation is simply HISP. It began in 1994 as the Health
    Information Systems Programme, a collaborative action research
    project between the University of Oslo and the University of the
    Western Cape. Today HISP refers both to the HISP Centre at the
    University of Oslo, which coordinates the DHIS2 project, and to the
    global network of HISP groups.
    [HISP and DHIS2 names](https://dhis2.org/hisp-dhis2-official-names/)
    · [HISP network](https://dhis2.org/hisp-network/)

HMIS
:   **Health Management Information System.** The national system for
    routine health service data used to manage the health system. DHIS2
    is the most widely used HMIS platform globally.
    [DHIS2 for HMIS](https://dhis2.org/health/hmis/)

    *Not to be confused with:* [CHIS](#dhis2_acronyms_c), which covers
    community-level rather than facility-level data.

## I { #dhis2_acronyms_i }

i18n
:   **Internationalization.** Designing software so it can be adapted to
    other languages and regions without engineering changes. The
    numeronym uses 18, the number of letters between the i and the n.
    [w3.org](https://www.w3.org/International/questions/qa-i18n)

    *Related:* l10n is *localization*, the adaptation itself. DHIS2
    translations are contributed via Transifex.

ICD-10
:   **International Statistical Classification of Diseases and Related
    Health Problems, 10th Revision.** WHO's classification of diseases
    and causes of death, in effect since 1993 and widely used in DHIS2
    metadata and option sets.
    [WHO classifications](https://www.who.int/standards/classifications/classification-of-diseases)

    *Note:* ICD-11 has been in effect since 2022 and is the version WHO
    now promotes; both are in active use in country systems.
    "International Classification of Diseases" is the accepted short
    form of the title.

iCHIS
:   **Integrated Community Health Information System.** A DHIS2-based
    integrated CHIS used in Malawi and other countries.

    *Not to be confused with:* [eCHIS](#dhis2_acronyms_e), Ethiopia's
    separate system, or generic [CHIS](#dhis2_acronyms_c). The three are
    routinely conflated.

IDRS
:   *See [IDSR](#dhis2_acronyms_i).* A common transposition of
    Integrated Disease Surveillance and Response. There is no separate
    term IDRS in DHIS2 use.

IDSR
:   **Integrated Disease Surveillance and Response.** WHO strategy,
    particularly in the African region, that integrates surveillance
    functions for multiple diseases onto a single platform.
    [Tanzania architecture](https://docs.dhis2.org/en/topics/user-stories/tanzania-integrated-health-information-architecture/architecture.html)

    *Not to be confused with:* [eIDSR](#dhis2_acronyms_e), its
    electronic implementation. Also frequently mistyped **IDRS**.

IHE
:   **Integrating the Healthcare Enterprise.** Standards-profiling
    initiative that specifies and tests interoperable healthcare
    workflows; formally IHE International. Publisher of the
    [ADX](#dhis2_acronyms_a) profile.
    [ihe.net](https://www.ihe.net/about_ihe/)

IMCI
:   **Integrated Management of Childhood Illness.** WHO and UNICEF
    strategy with clinical algorithms and training for managing the
    leading causes of illness and death in children under five at
    first-level facilities.
    [WHO](https://www.who.int/teams/maternal-newborn-child-adolescent-health-and-ageing/child-health/integrated-management-of-childhood-illness)

    *Note:* WHO's programme title is singular "Illness"; the plural
    "Illnesses" is common in country usage.

IPD
:   **Inpatient Department.** The hospital department for admitted
    patients, and the source of admission, length-of-stay and
    bed-occupancy indicators.

    *Not to be confused with:* [OPD](#dhis2_acronyms_o), the outpatient
    department.

## J { #dhis2_acronyms_j }

JAR
:   **Java Archive.** A ZIP-based file bundling Java class files and
    resources into one archive.
    [Oracle](https://docs.oracle.com/javase/tutorial/deployment/jar/)

JPA
:   **Jakarta Persistence API**, formerly the Java Persistence API. The
    Java standard for object-relational mapping, used by DHIS2 via
    Hibernate.
    [jakarta.ee](https://jakarta.ee/specifications/persistence/)

## L { #dhis2_acronyms_l }

LEG
:   **Local Education Group.** The in-country coordination group of
    government and partners in [GPE](#dhis2_acronyms_g)-supported
    education planning.

LIMS
:   **Laboratory Information Management System.** System for managing
    laboratory samples, workflows and results. Frequently integrated
    with DHIS2 so that lab results reach patient records and disease
    surveillance.
    [On lab integration](https://developers.dhis2.org/blog/2023/08/on-lab-integration/)

    *Not to be confused with:* [LIS](#dhis2_acronyms_l), which is
    closely related but not identical, or [LMIS](#dhis2_acronyms_l),
    which is about logistics rather than laboratories.

LIS
:   **Laboratory Information System.** A system supporting laboratory
    operations. Used almost interchangeably with
    [LIMS](#dhis2_acronyms_l), though the two carry subtly different
    emphases — LIS leans clinical, LIMS leans sample and workflow
    management.
    [On lab integration](https://developers.dhis2.org/blog/2023/08/on-lab-integration/)

LMIC
:   **Low- and Middle-Income Country.** World Bank income
    classification, and the setting in which most DHIS2 implementations
    run.
    [World Bank country groups](https://datahelpdesk.worldbank.org/knowledgebase/articles/906519-world-bank-country-and-lending-groups)

    *Note:* in World Bank data usage LMIC also denotes specifically a
    *lower*-middle-income country, alongside LIC and UMIC. Check which
    reading a document intends.

LMIS
:   **Logistics Management Information System.** A system for tracking
    health commodity stock, consumption and distribution. In DHIS2
    contexts this is nearly always the logistics sense: DHIS2 is used as
    a last-mile LMIS for facility and community stock management, and
    integrates with upstream [eLMIS](#dhis2_acronyms_e) or ERP systems.
    [DHIS2 for Logistics](https://dhis2.org/logistics/)

    *Not to be confused with:* Learning Management Information System,
    which appears in training and e-learning contexts and is a different
    thing entirely; or [LIMS](#dhis2_acronyms_l), the laboratory system.

LTA
:   **Long-Term Agreement**, also *long-term arrangement*. A standard UN
    procurement framework agreement with a supplier, against which
    individual contracts are placed without committing to a minimum
    quantity.
    [UNICEF Supply Division](https://www.unicef.org/supply/documents/long-term-agreement-lta-contractual-provisions)

LTS
:   **Long-Term Support.** A software release designated for extended
    maintenance. Relevant to DHIS2 server administration for operating
    system and PostgreSQL upgrade planning.

LVI
:   *No DHIS2 source defines this.* It appears in DHIS2 lab-integration
    questions but is not used in DHIS2 documentation, the Community of
    Practice, or the developer portal, and is most likely a mistyping of
    [LIS](#dhis2_acronyms_l), [LIMS](#dhis2_acronyms_l) or
    [LMIS](#dhis2_acronyms_l) — try those three first. Rather than guess
    an expansion, this entry records that the term is undefined. If LVI
    means something specific where you work, please
    [add it](#dhis2_acronyms_contributing).

## M { #dhis2_acronyms_m }

MFL
:   **Master Facility List.** The authoritative national register of
    health facilities, usually the source of the DHIS2 organisation unit
    hierarchy at facility level.

MICS
:   **Multiple Indicator Cluster Surveys.** UNICEF-supported
    international household survey programme producing key indicators on
    the situation of children and women.
    [mics.unicef.org](https://mics.unicef.org/)

    *Note:* MICS6 denotes the *sixth round* of the programme, not an
    expansion of the acronym.

MICS-EAGLE
:   **MICS — Education Analysis for Global Learning and Equity.** UNICEF
    initiative re-analysing [MICS](#dhis2_acronyms_m) education data
    through an equity lens to support education sector planning.
    [mics.unicef.org](https://mics.unicef.org/methodological-work/mics-eagle)

MoET
:   **Ministry of Education and Training.** The government department
    responsible for the education system in countries using that title;
    the counterpart to [MoH](#dhis2_acronyms_m) for education-sector
    DHIS2 work. Exact ministry names vary by country.

MoH
:   **Ministry of Health.** The government department responsible for
    administering and monitoring the national health system, and the
    institutional owner of most national DHIS2 instances.

MPDSR
:   **Maternal and Perinatal Death Surveillance and Response.** The
    continuous cycle of identifying, notifying, reviewing, analysing and
    responding to every maternal and perinatal death. DHIS2 has an MPDSR
    toolkit developed with UNFPA.
    [MPDSR design](https://docs.dhis2.org/en/implement/health/rmncah/maternal-and-perinatal-death-surveillance-and-response/design.html)

    *Note:* the P is *perinatal*, not "prenatal".

MPL
:   **Master Product List.** The authoritative national list of health
    commodities, the logistics counterpart of an
    [MFL](#dhis2_acronyms_m).

MSC
:   **Most Significant Change.** A participatory qualitative monitoring
    and evaluation technique based on collecting and systematically
    selecting stories of change.

MUAC
:   **Mid-Upper Arm Circumference.** An anthropometric measurement,
    taken with a colour-coded tape, used to screen children aged 6–59
    months for wasting. Appears throughout DHIS2 nutrition and community
    health metadata, often unexpanded, in data elements such as "New
    admission MUAC".
    [UNICEF MUAC guidance](https://www.unicef.org/indonesia/media/19771/file/MUAC%20guidelines.pdf)

## N { #dhis2_acronyms_n }

NCD
:   **Noncommunicable Disease.** Chronic conditions such as
    hypertension, diabetes and cancers.
    [CHIS foundational terms](https://docs.dhis2.org/en/implement/health/chis-community-health-information-system/implementation/foundational-terms.html)

    *Note:* WHO house style is the unhyphenated "noncommunicable"; DHIS2
    material uses both forms.

## O { #dhis2_acronyms_o }

OPD
:   **Outpatient Department.** The facility department seeing patients
    without admitting them, and the source of OPD morbidity returns in
    many national HMIS.

    *Not to be confused with:* [IPD](#dhis2_acronyms_i), the inpatient
    department.

OpenHIE
:   **Open Health Information Exchange.** Community and reference
    architecture specification for country-scale health information
    exchanges. DHIS2 commonly occupies the aggregate data warehouse role
    in an OpenHIE architecture. [ohie.org](https://ohie.org/about/)

OVC
:   **Orphans and Vulnerable Children.** A programme and reporting
    category in both health and education contexts, notably in
    [PEPFAR](#dhis2_acronyms_p)-funded work.

## P { #dhis2_acronyms_p }

PAHO
:   **Pan American Health Organization.** Founded in 1902 and the
    world's oldest international public health agency; simultaneously
    the specialised health agency of the Inter-American System and the
    WHO Regional Office for the Americas.
    [paho.org](https://www.paho.org/en/who-we-are)

PAT
:   **Personal Access Token.** A credential used instead of a password
    to authenticate to an API or to a Git host. DHIS2 supports personal
    access tokens for API authentication.
    [Personal access tokens in DHIS2](https://docs.dhis2.org/en/use/user-guides/dhis-core-version-master/managing-user-accounts/personal-access-tokens.html)

PEPFAR
:   **President's Emergency Plan for AIDS Relief.** United States
    government global HIV/AIDS programme launched in 2003, one of the
    earliest and largest DHIS2 funders, and the operator of
    [DATIM](#dhis2_acronyms_d).
    [state.gov/pepfar](https://www.state.gov/pepfar/)

PHC
:   **Primary Health Care.** The first level of care, closest to the
    community, covering preventive, promotive, curative and
    rehabilitative services. Also used in DHIS2 as an organisation unit
    group for primary-care facilities.
    [CHIS foundational terms](https://docs.dhis2.org/en/implement/health/chis-community-health-information-system/implementation/foundational-terms.html)

PHEM
:   **Public Health Emergency Management.** The function and
    institutional arrangements for anticipating, preparing for,
    detecting, responding to and recovering from public health threats.
    Institutionalised as the PHEM Centre at the Ethiopian Public Health
    Institute.
    [EPHI](https://ephi.gov.et/public-health-emergency/public-health-emergency-management/)

    *Not to be confused with:* PHEOC, the Public Health Emergency
    Operations Centre, which is the facility rather than the function.

PI
:   **Program Indicator.** A DHIS2 Tracker metadata object that
    calculates a value from tracker data — event counts, averages of
    data element values, durations between dates — for use in analytics.
    [Program indicators](https://docs.dhis2.org/en/use/user-guides/dhis-core-version-master/configuring-the-system/programs.html#about_program_indicator)

PMTCT
:   **Prevention of Mother-to-Child Transmission**, of HIV. Programme
    area preventing vertical HIV transmission; DHIS2 Tracker programs
    follow mother-and-infant pairs longitudinally.

    *Not to be confused with:* [EMTCT](#dhis2_acronyms_e), the
    elimination target.

PNC
:   **Postnatal Care.** Care for mother and newborn after delivery,
    commonly measured as PNC visits within a defined window.

PR
:   **Pull Request.** A proposal to merge a branch of changes into
    another branch, with review and automated checks before merging. The
    mechanism for contributing to DHIS2 code and documentation.
    [GitHub docs](https://docs.github.com/en/pull-requests)

PSI
:   **Population Services International.** Non-profit global health
    organisation working on sexual and reproductive health, malaria, HIV
    and NCDs. [psi.org](https://www.psi.org/about/)

## R { #dhis2_acronyms_r }

REO
:   **Regional Education Office.** A sub-national administrative level
    in education-sector implementations, typically an organisation unit
    level in DHIS2.

RHIS
:   **Routine Health Information System.** The system handling routinely
    collected service delivery data, as distinct from surveys or
    censuses. Closely related to [HMIS](#dhis2_acronyms_h).

RMNCAH
:   **Reproductive, Maternal, Newborn, Child and Adolescent Health.**
    Health services spanning pre-pregnancy through adolescence; both a
    WHO analysis framework and a DHIS2 metadata package.
    [RMNCAH aggregate design](https://docs.dhis2.org/en/implement/health/rmncah/rmncah-aggregate/design.html)

    *Note:* sometimes written with "Neonatal" in place of "Newborn".

RTL
:   **Right-to-Left.** Text direction for scripts written right to left,
    such as Arabic and Hebrew; relevant to DHIS2 localisation and app
    development. Paired with LTR (left-to-right).
    [MDN](https://developer.mozilla.org/en-US/docs/Glossary/RTL)

    *Not to be confused with:* Register Transfer Level, a hardware
    design term, which is not what RTL means in a DHIS2 or
    internationalisation context.

RTSL
:   **Resolve to Save Lives.** Non-profit working with countries on
    epidemic preparedness and cardiovascular disease control, and a
    DHIS2 partner.
    [resolvetosavelives.org](https://resolvetosavelives.org/who-we-are/about/)

## S { #dhis2_acronyms_s }

SABER
:   **Systems Approach for Better Education Results.** World Bank
    programme benchmarking national education policies and institutions
    against global good practice.
    [World Bank](https://www.worldbank.org/en/topic/education/brief/systems-approach-for-better-education-results-saber)

SADC
:   **Southern African Development Community.** Regional Economic
    Community of 16 member states, headquartered in Gaborone.
    [sadc.int](https://www.sadc.int/member-states)

    *Note:* "Southern", not "South". The 1980 predecessor body was
    SADCC, the Southern African Development Coordination Conference.

SAMS
:   **Student Administration Management System.** Student administration
    software encountered alongside DHIS2 in education-sector
    implementations.

SARA
:   **Service Availability and Readiness Assessment.** WHO and USAID
    health facility survey generating tracer indicators on service
    availability and facility readiness.
    [WHO](https://www.who.int/data/data-collection-tools/service-availability-and-readiness-assessment-(sara))

SDG
:   **Sustainable Development Goal.** The seventeen United Nations goals
    for 2030. DHIS2 is used for multi-sector SDG performance monitoring;
    SDG 4 is the education goal, reported through
    [UIS](#dhis2_acronyms_u). [sdgs.un.org](https://sdgs.un.org/goals)

SEMIS
:   **School Education Management Information System.** DHIS2
    Tracker-based solution for individual-level education data — student
    enrolment, attendance, performance, results and transfers, plus a
    staff registry.
    [SEMIS user guide](https://docs.dhis2.org/en/implement/education/semis/user-guide.html)

    *Also expanded as:* "Student-Staff-School-EMIS" in some DHIS2
    conference material. Both are in use.

SOP
:   **Standard Operating Procedure.** A documented process ensuring a
    task is performed consistently — for data quality checks, server
    maintenance or incident response, for example.

## T { #dhis2_acronyms_t }

T2A
:   **Tracker to Aggregate.** The practice, and supporting tooling, of
    pre-aggregating DHIS2 Tracker data into aggregate data values so
    that analytics and dashboards perform acceptably at scale, rather
    than computing program indicators on the fly.
    [Speeding up program indicators](https://developers.dhis2.org/blog/2022/05/speeding-up-your-program-indicators-with-tracker-to-aggregate)

TEA
:   **Tracked Entity Attribute.** In DHIS2 Tracker, an attribute that
    identifies a tracked entity — name, date of birth, national
    identifier — as opposed to a data element, which records what
    happened during an event. Captured once at enrolment and rarely
    changing.
    [Defining the tracked entity](https://docs.dhis2.org/en/implement/database-design/tracker-system-design/defining-the-tracked-entity.html)

TEI
:   **Tracked Entity Instance.** A single registered tracked entity —
    one specific person, case or sample.
    [Tracker data model](https://docs.dhis2.org/en/topics/training-docs/tracker-use-academy/tracker-data-model/tracker-data-model-session-summary.html)

    *Note on currency:* the API terminology changed in DHIS2 version 41.
    The `tei` and `trackedEntityInstance` parameters, paths and response
    keys are **deprecated** in favour of `trackedEntity`. TEI remains in
    wide conversational and training use, but new API work should use
    "tracked entity".
    [Version 41 upgrade notes](https://docs.dhis2.org/en/implement/software-release-information/dhis2-core-releases/dhis-core-version-241/upgrade-notes.html#naming)

TET
:   **Tracked Entity Type.** The kind of thing being tracked — Person,
    Case, Lab Sample, Village, or a commodity. A DHIS2 instance can have
    several tracked entity types configured.
    [Defining the tracked entity](https://docs.dhis2.org/en/implement/database-design/tracker-system-design/defining-the-tracked-entity.html)

    *Not to be confused with:* [TEI](#dhis2_acronyms_t), an individual
    instance of a type, or [TEA](#dhis2_acronyms_t), an attribute of
    one.

## U { #dhis2_acronyms_u }

UID
:   **Unique Identifier.** In DHIS2, the 11-character alphanumeric
    identifier automatically assigned to every metadata and data object
    — `ImspTQPwCqd`, for example. Stable across systems and used
    throughout the API.
    [Metadata object identifiers](https://docs.dhis2.org/en/develop/using-the-api/dhis-core-version-master/metadata.html#webapi_identifier_schemes)

UIS
:   **UNESCO Institute for Statistics.** UNESCO's statistical office and
    the custodian UN agency for global SDG 4 education indicators.
    [uis.unesco.org](https://www.uis.unesco.org/en/about-uis)

UNESCO
:   **United Nations Educational, Scientific and Cultural
    Organization.** UN specialised agency for education, science and
    culture, and custodian of the SDG 4 agenda.

UNICEF
:   **United Nations Children's Fund.** UN agency for children's rights,
    health, education and protection, and a DHIS2 partner and funder.
    [unicef.org](https://www.unicef.org/history)

    *Note:* originally the United Nations International Children's
    Emergency Fund. The organisation was renamed in 1953 but kept the
    acronym, so the letters no longer map to the current name.

## V { #dhis2_acronyms_v }

VPD
:   **Vaccine-Preventable Disease.** The class of diseases under
    immunisation-linked case surveillance. DHIS2's VPD case surveillance
    package covers nine of them.
    [VPD case surveillance design](https://docs.dhis2.org/en/implement/health/disease-surveillance/vpd-case-surveillance/design.html)

## W { #dhis2_acronyms_w }

WAR
:   **Web Archive**, or web application archive. A JAR-format file with
    a `.war` extension packaging a Java web application. A DHIS2 core
    release ships as a WAR file deployed into Tomcat.
    [Oracle](https://docs.oracle.com/javaee/7/tutorial/packaging003.htm)

WHO
:   **World Health Organization.** The United Nations specialised agency
    for public health, founded in 1948. [who.int](https://www.who.int/)

    *In other languages:* French *Organisation mondiale de la Santé*
    (**OMS**); Spanish *Organización Mundial de la Salud* (**OMS**). WHO
    regional offices are also referred to by acronym, for example WHO
    AFRO for the Regional Office for Africa and
    [PAHO](#dhis2_acronyms_p) for the Americas.

## Contributing an acronym { #dhis2_acronyms_contributing }

This page is maintained collaboratively. If an acronym is missing, wrong, or means something different where you work, please add or correct it.

**The easiest route** is the **Edit** (pencil) icon at the top of this page. It will fork the documentation repository for you, let you edit in the browser, and open a pull request. No local setup and no Git knowledge is required.

**If you would rather not use GitHub**, post in the acronyms thread on the [Community of Practice](https://community.dhis2.org/) and someone will add it for you.

**What makes a good entry:**

- **The expansion first, in bold**, then a sentence or two on what the thing *is* — not just what the letters stand for.
- **A link** where a useful one exists. Prefer a page in this documentation; a Community of Practice thread or the owning organisation's own site is fine too. Leave it out rather than linking something tangential.
- **A source.** Please only add an acronym you have actually seen used in DHIS2 documentation, the Community of Practice, Academy material, or a DHIS2 issue tracker. A plausible-looking expansion that turns out to be wrong is worse than a missing entry, because people and AI assistants will cite it.
- **A disambiguation line** where the acronym has a competing meaning, using the phrase *Not to be confused with:*. This is what allows a reader — or a search assistant — to tell which sense DHIS2 intends.
- **Say so when it isn't an acronym.** Some names, DHIS2 and HISP among them, are simply names. Recording that is more useful than inventing an expansion.
- **Cross-references are welcome entries in their own right.** If you searched for a term and it turned out to be a misspelling, a near-miss, or simply undefined anywhere, add it as a short *see also* pointing at the right entry. The next person to make the same mistake will land somewhere useful, and recording that a term is genuinely undefined is more honest than leaving a gap that invites a guess.

Acronyms specific to a single country programme are welcome where they appear in DHIS2 material, but please note the country so readers know the scope.
