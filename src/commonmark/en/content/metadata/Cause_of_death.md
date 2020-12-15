---
title:WHO Cause of Death Tracker System Design
---
  
# Overall Design

The WHO cause of death tracker system is configured in order to effectively collect and manage data related to causes of death. It is based on the International Medical Certificate of Cause of Death and ICD-10.

There are two programs that comprise its design and can be used depending on the needs of country/organization that is collecting this data.

1.  Cause of death (anonymous -- event capture program without registration)
    
2.  Cause of death (tracker program with registration)

The anonymous  program is an event program while the registration program is a tracker program. Both of these programs share the same data elements, custom form design, program indicators, program rules, etc.

A comparison of these two programs, taken from the implementation guide, can be seen below

## Cause of death (anonymous) - event program

|Pros|Cons|
|---|---|
|Simple structure/data model|Not possible to record identifiers in a way where uniqueness can be enforced, and person attributes can be encrypted.|
|Uses the Event Capture app, which supports offline data entry in the Web browser.|Due to lack of identifiers, finding and editing existing data is difficult.|
|User friendly data entry screen, e.g. pertaining to display of data validation warnings.|


## Cause of death (registration) - tracker program

|Pros|Cons|
|---|---|
|Supports use of unique identifiers, as well as person attributes. This is necessary for example if considering interoperability with other CRVS systems, and for finding and editing data.|No support for offline data entry in the web browser.|
|Data and system becomes more sensitive when including person identifiers.|Less user friendly data entry screen, e.g. pertaining to display of validation warnings.|

What version to choose depends on the specific situation, however, the offline capability of the event program is likely to be of importance in many settings. Note that the variables (data elements) used by both programmes are the same, and data from the two are thus comparable should one switch from using one version to the other.

# Cause of Death Workflow

The cause of death module uses a framework based off of the ICD (International Classification of Diseases) method of recording cause of death data. The [international medical certificate of cause of death](http://apps.who.int/iris/handle/10665/40557) serves as the main source of information in this process. In order for the information to be entered in DHIS2, the medical certificate of cause of death must first be filled in (this will likely be a manual process and not filled in directly in DHIS2). This information will then be entered into DHIS2 using one of the program types that has been selected. The data entry form itself is a replica of the paper based medical certificate of cause of death. For more information/background on this certificate please refer to the ICD SMoL Training Manual.|

![](https://lh5.googleusercontent.com/i-BpEnYyZF98nuDvfPjm6tp6L2BEG-LlFwFfo3jLzAkqQ3JlyoK1cJXYO133GB-f3O5sCOJTSar6FHCEtCIUZAnu3hNKxyZwDGOKs3_0rLL839MRAbNP6VomazjyLFROy_PNys_r)

# Tracker Program Overview

Both the event and tracker version of the WHO cause of death module only consist of one program stage, as they are very similar in their design; with the key design change being the ability to register attributes in the tracker based program. The cause of death module uses a custom form in order to meet design requirements to closely reflect the paper form in a web browser, however sections have also been made in the event a mobile device is used. This structure can be seen in the diagram below.

![](https://lh6.googleusercontent.com/EpbbtlvbJcQGn9BIh3IG81FTsHwR_uMucpmsR7drOBsJZ0qBJdI0ZyLQDqzuV1SpZ1aB43WUonppJjpZWe2fHr6vjZE0Dkawu4p9FG4P20wauSrdPiy_AfqNbKSHGZgib9aLoa7y)

Descriptions of these programs are described in further detail in the sections below.

## Event Program - Cause of death (anonymous)

|Stage|Description|
|---|---|
|Cause of death (anonymous)|Contains all information necessary to record the information associated with the medical certificate of causes of death. Uses a custom form layout to reflect the paper-based certificate, with sections available to use on mobile devices.|  

## Tracker Program - Cause of death (registration)

|Stage|Description|
|---|---|
|Registration / Attributes|Registration consists of a single attribute, a system generated ID. This can be used in order to uniquely identify the death and find it in the system if required, but would in most cases be replaced with existing ID schemes, e.g. a national ID. It can also be used as a link to other systems (eg. civil registration).|
|Cause of death (registration)|Contains all the information necessary to record the information associated with the medical certificate cause of death. Uses a custom form layout to reflect the paper-based certificate, with sections available to use on mobile devices.<br>This is a non-repeatable stage; once the details of the death are registered no additional events will be added.|

For a full list and description of the program, program stages and data elements used in this design, please refer to the full meta-data reference here

# Program Rules

You can read more about program rules here:

[https://docs.dhis2.org/master/en/user/html/configure_program_rule.html](https://docs.dhis2.org/master/en/user/html/configure_program_rule.html)

Program rules are a critical component of the cause of death module in both tracker and event programs. Program rules are not only being used to reduce data entry errors through the use of the hide field and show error/warning actions, but also assign and code the underlying cause of death using ICD-10 SMoL and ICD-10 full codes; considered a key feature to this module in order to obtain higher quality mortality data. For a full list and description of the program rules for this program, see the detailed meta-data list here

## Hide Field

The hide field action is being used to grey/disable  fields (this is the hide rule action being applied to a custom form; while it can not hide the field due to the custom design it can grey out the field so it cannot be interacted with). You can see this in the below example

![](https://lh4.googleusercontent.com/rqpYwoFaSE-U-mqnjgOhV9x1BADKuv3dqcp1QwDTlgfcXUEKhvfZWc5yWsSOtRHV_YlHef-K6q38z3AJLH2q-B4VJ0nkbaw6aPpsMqPoA5ZyaO9JzWt4T1c8ZVjPckc55xXJ5Qzx)

Date of birth can not be interacted with as the birth date is unknown; however it is not hidden from view.

Note that on a mobile device the field will be hidden, as the form will default to the section design discussed previously.

## Show Warning/Show Error

A number of error/warning messages are built into the form in order to point out likely data entry issues. These messages will be displayed immediately within the event program when it detects a problem
  

![](https://lh3.googleusercontent.com/e-XLYkze5OvJA7CjzdSGY_5V_OYVxx3U0Nhmp68to3g9hw-9UhmuDR0I7HVMTbEaSz5t2EJB8dFUrUqf5OedMpLBxjua3jthJDPEveI3yoDGAQN0LMRdbJo-3UP-4t3EDfrASH6O)

![](https://lh4.googleusercontent.com/rtFfGdZEyO5kzeFc9lPDiOoxy4o-HRoZz7VR92BGDwU-a-vKxEtSfB6u8qk2uLo3ZaIz6yWMfWo73X6JyjMAnqUzjPKtR8tDGkGNwMkFCtovy_2O5vrZUHe0KRNp-bY2Ob6cSiDc)

For the tracker program, they will display upon event completion only.

![](https://lh3.googleusercontent.com/Zu3IfQTzeSS_NUoJ4g2fxTZXXcx-SbfS6vErS4w7ZjIwRgXJ6-hfDGTKAIHu_8SZA8M3iEqnFE8B4XV-K6EEjq9BVXoHVJ52HcfpzBiunEeHzxY6aya3EvEiUS0_3Q8sJPbjB2Fv)

The differences in displaying these error/messages was discussed as a potential pro/con to each of these designs and should be considered prior to implementation.

## Assign

The assign rule action is used in order to determine the values for the following 4 data elements:

-   Age in years
    
-   Underlying cause of death
    
-   ICD-10 SMoL code
    
-   ICD-10 full code

The assignment of the value for the age in years is based upon the information on dates of birth and death or the estimated age, whilst the last 3 data elements are based upon the selection of the underlying cause of death. More information on selecting this cause is available through the WHO’s SMoL training resources: [https://www.who.int/healthinfo/civil_registration/smol/en/.](https://www.who.int/healthinfo/civil_registration/smol/en/.)

In order to assign different values to 3 data elements an interaction of 2 option sets is used along with a code containing multiple parts. In this particular case, the data element that identifies the cause of death (for example, cause of death C on the form is identified as the underlying cause) is linked to the option set “ICD SMoL - local dictionary.” This option set contains plain English language terms for the different factors that could potentially be identified for cause of death A,B,C or D within the medical certificate of cause of death. This option set also contains option codes for each option that is separated into 3 parts; this is what is used to assign values to the separate data elements indicated previously.

![](https://lh3.googleusercontent.com/12fKQiZv7ly4LV5YtZA2PhLwOhet2ye0ymkZoIgmwStXZOk5wVLzid__OQFwdZ-ZNQR0StkPaLZo96yY74mQy840rA5unP8NQOi3UmE_okUPayYO-xn_7eg2XhBpY0n3qyRGQQeY)

Note that the code is separated by a delimiter “|” to indicate the separate parts of the code. The parts are separated as follows:

1.  Code 1: ICD-10 SMoL code
    
2.  Code 2: ICD-10 full code
    
3.  Code 3: The code used to uniquely identify the option

The SMoL code used within the “ICD SMoL - local dictionary” identifies what will be used as the eventual underlying cause of death according to the shortened list in the ICD-10 SMoL. See in the above example that there can be multiple options using the same SMoL code in the “ICD-SMoL - local dictionary” option set, as these terms all correspond with the same cause of death that will be used for statistical purposes in the SMoL list.

In this example, let us say that we have identified acute liver necrosis as our underlying cause of death (note this is to explain the design and not necessarily reflective of a real example), which corresponds to an ICD-10 SMoL code of 5-74 and an ICD-10 full code of K720.

![](https://lh3.googleusercontent.com/vLczo6RD8oUyTexloqdulyyBBRPDECSrdfbmjEXdiVq6gRRKQod17G7GrE4yLPCkoyQaQFfDgpc7asAyHC_sISSgeIeoD1sHgMYwPBH_310yS4EhUQVtOvMQgHfj9fweU1eURE7U)

One this has been entered:

1.  It will take the first part of the code in the option set “ICD SMoL - local dictionary” (5-74) and assign it to the “underlying cause of death” data element. This data element is also linked to an option set “ICD-SMoL.” This option set is the shortened list of causes of death that can be used for obtaining better quality cause of death data.
    
2.  The code 5-74 in the “ICD-SMoL” option set corresponds to a value of “Other diseases of the digestive system.”

    ![](https://lh3.googleusercontent.com/UZyt4-s5oVrmrnGgWPHHh4s477hbPRWvWbxJRBi7KkwFC1vFY0jnnB303xbuPHcfQjN5_m0Q2OVdd0q6x_O9lUkYOzf6VioY6C5MLHz1ql8Cs5Q9pokxhHoOkyFZ3nVOrpzUDIy0)

    We can see that this is what will appear in the data entry form assigned to this data element at the bottom of the screen

    ![](https://lh6.googleusercontent.com/tDEz9Wz4llW0qRXH8sJlGePokGFP1FJux-f6I0Enq32e_04l0vMEJaGklEEyDLnPxiktlRXgXFFDZ_Ri0F2vkv6YE7G7o4jVsf_6oNkg4FnfhWujSqmNNv-hgHSGIu9-MzgnlqrC)

3.  It will take the first part of the code in the option set “ICD SMoL - local dictionary” (5-74) and assign it to the “ICD-10 SMoL” data element. This is just a plain text data element, so the code appears exactly as it is written in the option set.
    
4.  It will take the second part of the code in the option set “ICD SMoL - local dictionary” (K720) and assign it to the “ICD-10” data element. This is just a plain text data element, so the code appears exactly as it is written in the option set.

    ![](https://lh6.googleusercontent.com/jHiL97A5JksOeO44oLhINfaDFzLo41Xbxkmp5jJd8olx2jFdNoAwyKMUcI4JTVpQWtCJDTDvPHnMt67bMdjeRnz3Cpy8WHSSGn41wQq_4CwglNKeMnHV0jGXPm4LHbDrVZSaqHHd)

This is the general process that is used in order to automatically code the identified underlying causes of death in this form and facilitate one of the key requirements of this module. By using this methodology, the cause of death is coded correctly and can subsequently be aggregated as required.

# Program Indicators

You can read more about program indicators here:

[https://docs.dhis2.org/master/en/user/html/configure_program_indicator.html](https://docs.dhis2.org/master/en/user/html/configure_program_indicator.html)

There are a number of program indicators associated with the program. A full list can be viewed in the detailed meta-data description here:

Program Indicators are used for this program to typically:

1.  Group similar diseases together by their assigned ICD-10 SMoL code
    
2.  Group deaths together by age group

# External Data Analysis (ANACOD)

Data captured by the Cause of Death program can also be exported for external analysis using the WHO’s [Analysis Levels and Cause of Death (ANACOD)](https://www.who.int/healthinfo/anacod/en/) tool. The ANACOD electronic tool provides a step-by-step approach to enables users to quickly conduct a comprehensive analysis of data on mortality levels and causes of death. The tool automatically reviews the data for errors, tabulates the information, presents the results in the form of easy to use tables and charts, and provides the opportunity to compare the findings with those from other groups of countries.

To export country data to the ANACOD tool, you will use the SQL views in DHIS2. The SQL views are included in the metadata package, by year (‘CoD: ANACOD Export [YYYY]’). New SQL views for each year are required in order to produce detailed outputs within ANACOD by year. You will need to take special care to keep the scripts up to date as new versions of DHIS2 may alter the underlying SQL tables that are being accessed to generate the view compatible with ANACOD. The SQL view will remain up-to-date on the DHIS2 WHO demo and can be used as a reference if your view is no longer working when you upgrade to a newer version of DHIS2.

# References

-   WHO Start-up Mortality List (SMoL-ICD-10): [https://www.who.int/healthinfo/civil_registration/smol/en/](https://www.who.int/healthinfo/civil_registration/smol/en/.)
    
-   WHO Analysis Levels and Cause of Death (ANACOD): [https://www.who.int/healthinfo/anacod/en/](https://www.who.int/healthinfo/anacod/en/)
