# Malaria Aggregate System Design

## Introduction

This document describes the system design for the malaria configuration package for aggregate reporting, focusing on how the data collection part of the configuration has been designed in DHIS2 (i.e. data sets and data elements). This is largely based on the guidelines _[Disease surveillance for malaria control](https://apps.who.int/iris/bitstream/handle/10665/44851/9789241503341_eng.pdf;jsessionid=7D2258370F31444A72815B5CFB2E1FE8?ua=1?sequence=1)_.

## Malaria data set and data element design

The malaria program consists of 3 different data sets that can be used at any given time based on the needs of the program:

1. Malaria annual data
2. Malaria burden reduction
3. Malaria elimination

These data sets contain the recommended data elements to collect for each of these separate activities. In addition, there is a data element group `Malaria unassigned` which consists of additional data elements that could potentially be assigned to the _Malaria burden reduction_ and _Malaria elimination_ datasets respectively. 

The _malaria annual data set_ is recommended in all settings. The _malaria elimination_ and _malaria burden reduction_ data sets can be used either separately or in conjunction with one-another depending on the type of public health responses being implemented within a particular geographical area (ie. in one district the burden reduction data set may be used, while in another the malaria elimination data set may be used).

### Malaria annual data

The malaria annual data data set contains information on the following three broad items:

1. Funding (both current funding and funding need)
2. Bednet distribution and indoor residual spraying protection
3. Population at risk

As the name indicates, this information is to only be collected once a year.This data set contains a mostly flat structure; with only one data element (population total) disaggregated by age. This disaggregation is fairly self-explanatory, as it is more efficient to disaggregate this population data element by the three age category options rather than create 3 data elements separately. 

### Malaria burden reduction

The malaria burden reduction data set is separated into seven sections:

1. Outpatient details
2. Laboratory
3. Interventions
4. Treatment
5. Intermittent preventive treatment in pregnancy (IPTp)
6. Pregnant Women
7. Stock-Out

This is a monthly data set that is meant for areas in which malaria burden reduction is the priority. The table below discusses the structure of the data elements as they appear within the various sections as well as the rationale behind the applied structure.

|Section|Applied Structure|Disaggregation|Rationale|
|:--|:--|:--|:--|
|Outpatient details|Disaggregated|Age (0-4, 5-14, 15+ years)|The age category combination drastically reduces the number of data elements. The totals for all of these data elements can also be used for analysis purposes. |
|Laboratory|Disaggregated|Age (0-4, 5-14, 15+ years)/Sex (Male, Female)|The age/sex category combination drastically reduces the number of data elements. The totals for all of these data elements can also be used for analysis purposes; allowing you to pivot both the age and sex dimensions and place them where required.|
|Interventions|Flat|N/A|No disaggregations required|
|Treatment|Flat|N/A|Several of the data elements in this section are sub-sets of one another. Making totals from these would not be meaningful. Well this increases the data element count, it also makes interpreting the output easier.|
|Intermittent preventive treatment in pregnancy (IPTp)|Flat|N/A|While it could potentially be argued that a category combination is used here in order to output the total number of doses administered, understanding the breakdown of the number of doses by their schedule takes precedence therefore no category combination is used.|
|Pregnant women|Flat|N/A|All of the data elements in this section have different definitions. No disaggregations required.|
|Stock-out|Flat|N/A|These data elements are all of yes/no type. No disaggregations required.|

#### Additional data elements 

There are a number of additional data elements that could potentially be used within the malaria burden reduction data set however are not currently assigned to it. These data elements can be found within the `Malaria unassigned` data element group. 

*   Migrant and mobile population (MMP) positive
*   Malaria cases tested at community level
*   Malaria confirmed cases (Mic + RDT)
*   Plasmodium falciparum (Mic + RDT)
*   Malaria cases positive at community level
*   Migrant and mobile population (MMP) tested
*   Migrant and mobile population (MMP) followed up for 14 days
*   Mixed malaria species (Mic + RDT)
*   Plasmodium vivax (Mic + RDT)
*   Malaria tested cases (Mic + RDT)
*   Malaria cases treated at community level
*   Mixed/Other malaria species (Mic + RDT)

### Malaria elimination

The malaria elimination data set is separated into seven sections; three of which are identical with the malaria burden reduction data set (identified with * in the list) 

1. Malaria inpatients and deaths
2. Laboratory*
3. Case Investigation
4. Treatment*
5. Foci Investigation
6. Foci classification and response
7. Stock-out*

This is a monthly data set intended for areas where malaria elimination is the priority. 

|Section|Applied Structure|Disaggregation|Rationale|
|:--|:--|:--|:--|
|Malaria inpatients and deaths|Disaggregated|Age (0-4, 5-14, 15+ years)|The age category combination reduces the number of data elements. The totals for the two data elements can also be used for analysis purpose.|
|Laboratory|Disaggregated|Age (0-4, 5-14, 15+ years)/Sex (Male, Female)|The age/sex category combination drastically reduces the number of data elements. The totals for all of these data elements can also be used for analysis purposes.|
|Case Investigation|Disaggregated|Age (0-4, 5-14, 15+ years)/Sex (Male, Female)|The age/sex category combination drastically reduces the number of data elements. The totals for all of these data elements can also be used for analysis purposes.|
|Treatment|Flat|N/A|Several of the data elements in this section are sub-sets of one another. Making totals from these would not be meaningful. Well this increases the data element count, it also makes interpreting the output easier.|
|Foci Investigation|Flat|N/A|Several of the data elements in this section are sub-sets of one another. Making totals from these would not be meaningful. Well this increases the data element count, it also makes interpreting the output easier|
|Foci classification and response||Foci classification (Active, Residual, Cleared-up)|The foci classification category combination allows for simplified classification of the data elements based on the 3 foci category options. The total of this category combination when applied to the data elements is useful for analysis as well.|
|Stock-out|Flat|N/A|These data elements are all of yes/no type. No disaggregations required.|

#### Additional data elements

There are a number of additional data elements that could potentially be used within the malaria elimination data set however are not currently assigned to it. These data elements can be found within the  `Malaria unassigned`  data element group. 

*   Malaria tested from cross-borders
*   Malaria cases notified within (N1) timeframe of the guideline (24hrs)
*   Malaria cases investigated within (N2)* timeframe of the guideline
*   Malaria positive from cross-borders followed for 14 days
*   Malaria positive from cross-borders
*   Other malaria species (microscopy)

## Malaria Validation Rules

The validation rules for malaria are divided across three groups:

1. Malaria: burden reduction
2. Malaria: elimination
3. Malaria: other

The malaria program consists of many validation rules within these three groups. A detailed description of these rules can be found here:

*   [Malaria burden reduction](https://who.dhis2.net/webdocs/malaria/malaria_elimination_reference.html)
*   [Malaria elimination](https://who.dhis2.net/webdocs/malaria/malaria_elimination_reference.html)

## Malaria Outputs

The malaria outputs included in the aggregate package include:

*   Malaria indicators
*   Malaria analytical outputs
    *   Charts
    *   Pivot Tables 
    *   Maps
*   Malaria dashboards
    *   Malaria burden reduction
    *   Malaria elimination
    *   Malaria quality control

A detailed overview of these items, including their names and descriptions, can be found in the _Malaria metadata reference guide._ They are available here:

*   [Malaria burden reduction](https://who.dhis2.net/webdocs/malaria/malaria_elimination_reference.html)
*   [Malaria elimination](https://who.dhis2.net/webdocs/malaria/malaria_elimination_reference.html)
