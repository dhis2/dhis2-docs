# General design principles for WHO metadata packages
This document describes in brief the overall design principles that have been followed when configuring the standard DHIS2 metadata packages for the WHO digital health data toolkit. In addition to this document outlining some general principles, an in-depth system design document is available for each health area/program package.

## Data analysis

The data analysis part of the configuration is centered around *indicators* and *dashboards*. Aggregate packages (both *dashboard/analytics* and *complete* versions) include one or more dashboards. 

Dashboards in the aggregate packages are based exclusively on **indicators**. This means that even in cases where an equivalent data element exists for a concept (i.e. ANC visits), an indicator will be created and used in the dashboard item (pivot table, chart or map). This is a requirements for the dashboard-only packages because the indicators are used to map to existing data elements in a country's own DHIS2 instance. One downside to this approach is that we are creating "duplicate" metadata which is not strictly needed. However, there are significant advantages that outweigh this duplication. The most important advantage is that is allows the same dashboards to be used in the *aggregate* and *dashboard only* configuration packages, without modifications. Since the standard configurations packages are aligned with a training curriculum, it is an advantage that any implementation of the dashboard is as similar as possible. Whether the aggregate or dashboard-only package has been installed, the same variables for analysis will be available. In addition, it is often easier for end users to access all of the data they want to analyze within an indicator group in the analytics apps, rather than toggling between data element groups and indicator groups. These analytics end users should not be expected to distinguish between what is a DHIS2 data element vs. a DHIS2 indicator. 

Similar to how only indicators are used in the dashboards, only *category option groups* and *category option group sets* are used to apply disaggregations to the analytical outputs. That rationale for this is similar to the decision to use only indicators: the *category option groups* can be mapped to existing *category options*.

Finally, all analytical outputs (favourites: pivot tables, charts, maps) use *relative* organisation units and periods. This is necessary to make them portable across instances and over time. In some cases, some modifications are needed to set this according to the context. In those cases, this is described in the documentation.

## Aggregate reporting

The aggregate reporting component of the metadata packages include:

* data sets
* data element
* data element categories, category option, category combinations
* validation rules

The data sets have all been based either on WHO recommendations and best-practice examples or 
published reporting frameworks (such as the ["WHO  Definitions and reporting framework for tuberculosis"](http://www.who.int/tb/publications/definitions/en/)). These data sets will in many instances have to be adjusted to fit with national reporting systems, to varying degree. On the one hand, there might be additional variables that are important in a national context which must be added. On the other hand, there might be information that is simply not available for reporting, for example if the data is not captured in the case-based registers at the clinical level. The implementation of these reference data sets will therefore often be a longer-term project. Even in contexts where they are not used directly, they can be used as models for what and how data for different health areas/programs can be collected using DHIS2.

While the standard configuration packages are health area/program specific, the underlying metadata has been harmonized and used across health programs as much as possible. For example, if a data element or disaggregation applies in more than one data set, the DHIS2 metadata has ben re-used. 

A common gap seen in many country DHIS2 instances is that validation rules are not implemented consistently: they are either not used, or sometimes used to flag data quality issues that are unlikely, but possible. In the standard configuration packages, an effort has been made to add validation rules everywhere it is possible, but only for checks that are certain data quality issues (e.g. tests done vs positive tests).

## Cross-cutting principles
Where possible, all metadata objects from data sets and data elements to charts favourites should have a meaningful description. In order to facilitate a harmonized HMIS, aggregate metadata such as data elements and category combinations are shared wherever possible. For example, if the malaria package includes a data element on 'Number of ANC visits' as a denominator for an indicator, this data element would be shared with the RMNCAH package in the complete aggregate packages. 

## Tracker

*Coming soon!*