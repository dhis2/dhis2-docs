# Data Elements and Custom Dimensions

This chapter first discusses an important building block of the system:
the data element. Second it discusses the category model and how it can
be used to achieve highly customized meta-data structure for storage of
data.

## Data elements

The data element is together with the organisation unit the most
important building block of a DHIS2 database. It represents the *what*
dimension and explains what is being collected or analysed. In some
contexts this is referred to an indicator, however in DHIS2 this
meta-data element of data collection and analysis is referred to as a
data element. The data element often represents a count of some event
and its name describes what is being counted, e.g. "BCG doses given" or
"Malaria cases". When data is collected, validated, analysed or
presented it is the data elements or expressions built with data
elements that describe what phenomenon, event or case the data is
registered for. Hence the data elements become important for all aspects
of the system and decide not only how data is collected, but more
importantly how the data is represented in the database and how data can
be analysed and presented.

An important principle behind designing data elements is to think of
data elements as a self-contained description of a phenomenon or event
and not as a field in a data entry form. Each data element lives on its
own in the database, completely detached and independent from the
collection form. It is important to consider that data elements are used
directly in reports, charts and other tools for data analysis, in which
the context in any given data entry form is not accessible nor relevant.
In other words, it must be possible to clearly identify what event a
data element represents by only looking at its name. Based on this, 
it is considered best practice to create the name of the data element
such that it is able to stand on its own. Any user should be able to 
read the name and understand what event it represents, even outside
of the context of the data entry form.

As an example, a data element called “Malaria” might be concise when seen
in a data entry form capturing mortality data, in a form capturing
drug stocks as well as in a form for out-patient data. When
viewed in a report, however, outside the context of the data entry form,
it is impossible to decide what event this data element represents. If
the data element had been called “Malaria deaths”, “Malaria stock doses
received” or “Malaria prophalaxis given” it would have been clear from a user
perspective what the report is trying to express. In this case we are
dealing with three different data elements with completely different
semantics.

## Categories

Certain requirements for data capture necessitate a fine-grained
breakdown of the dimension describing the event being counted. For
instance one would want to collect the number of “Malaria cases” broken
down on gender and age groups, such as “female”, “male” and “\< 5 years”
and “\> 5 years”. What characterizes this is that the breakdown is
typically repeated for a number of “base” data elements: For instance
one would like to reuse this break-down for other data elements such as
“TB” and “HIV”. In order to make the meta-data more dynamic, reusable
and suitable for analysis, it makes sense to define the mentioned
diseases as data elements and create a separate model for the breakdown
attributes. This can be achieved by using the category model, which is
described in the following.

The category model has four main elements which are best described using
the above example:

1.  *Category options*, which correspond to “Female”, “Male” and “\< 5
    years” and “\> 5 years”. Category options are the fine grained
    attributes which are related in some common way.

2.  A *category*, which corresponds to “Gender” and “Age group”. Categories
are used to group related category options according to a common theme.

3.  A *category combination*, which is a combination of multiple categories
together. In the example above, we might assign both the "Gender" and "Age
Group" categories to a category combination called "Age/Gender". 

4. *Category option combinations* result from all possible combinations of
all category options within a category combination. In the example 
above, the following category option combinations would be 
created: "Female/\<5 years", "Female/\>5
years", "Male/\<5 years", "Male/\>5 years"

It is worth noting that the category model is completely indepent of the data element model. 
 Data elements are loosely coupled to categories, in that the association 
 between them can be changed at any time without losing any data. 
 As a practical example from above, perhaps data needs to be collected 
for malaria cases with more granular age bands. Instead of just "\<5" and
"/>5", a new category could be created for "\<1", "1-5","\>5" to describe
the finer age bands. This category could then in turn be associated 
with the data element in a new data entry form to collect the data
at a more granular level. The advantage with this approach would be that 
the same data element is used, which simplifies analysis of data over time. 


It is generally not recommended to change the association 
between data elements and their category combinations trivially or often because
of potential incompatibility between data which has been collected
using differing category combinations. Potential approaches to solve
this problem using "category option group sets" will be discussed in 
another section of this document.

Note that there is no intrisic limit on the number of category
options in a category or number of categories in a category combination,
however there is a natural limit to where the structure becomes messy
and unwieldy. Very large category combinations with many options
can quickly inflate to become many thousands of category option combinations
which in turn can have a negative impact on performance. 

A pair of data element and category combination can now be used to
represent any level of breakdown. It is important to understand that
what is actually happening is that a number of custom dimensions are
assigned to the data. Just like the data element represents a mandatory
dimension to the data values, the categories add custom dimensions to
it. In the above example we can now, through the DHIS2 output tools,
perform analysis based on both “Gender” and “Age group” for those data
elements, in the same way as one can perform analysis based on data
elements, organisation units and periods.

This category model can be utilized both in data entry form designs and
in analysis and tabular reports. For analysis purposes, DHIS2 will
automatically produce sub-totals and totals for each data element
associated with a category combination. The rule for this calculation is
that all category options should sum up to a meaningful total. The above
example shows such a meaningful total since when summarizing “Malaria
cases” captured for “Female \< 5 years”, “Male \< 5 years”, “Female \> 5
years” and “Male \> 5 years” one will get the total number of “Malaria
cases”.

For data capture purposes, DHIS2 can automatically generate tabular data
entry forms where the data elements are represented as rows and the
category option combinations are represented as columns. This will in
many situations lead to compelling forms with a minimal effort. It is
necessary to note that this however represents a dilemma as these two
concerns are sometimes not compatible. For instance one might want to
quickly create data entry forms by using categories which do not adhere
to the rule of a meaningful total. We do however consider this a better
alternative than maintaining two independent and separate models for
data entry and data analysis.

An important point about the category model is that data values are
persisted and associated with a category option combination. This
implies that adding or removing categories from a category combination
renders these combinations invalid and a low-level database operation
must be done to correct it. It is hence recommended to thoughtfully
consider which breakdowns are required and to not change them too often.

## Attribute combinations

All aggregate data in DHIS2 is always associated with four primary dimensions: 

* Data elements and category combinations represent the *what* dimension. 
* Organisation units represent the *where* dimension. 
* Periods represent the *when* dimension. 

Additional categories may be required in order to support data entry and analysis however. 
An additional free form dimension is also available to implementers, known as the "attribute combination". 
Attribute combinations are very similar to category combinations in terms of how they are implemented in the system. 
The difference however, is that they are not directly associated with individual data elements, but rather groups of data elements. 

Expanding on the example from above using the data element "Malaria cases", there may be a need to collect data at the same organisation unit and same time period for two different partners which work in that facility. In order to be able to attribute data to these partners, we could create a category called "Partner" which would contain the names of each partner as category options. This category could then be used as an attribute combination for the dataset which the "Malaria cases" is a part of. During data entry, an additional drop down option becomes available in the data entry screen, which would allow the user to choose which partner the data is associated with. 

Thus, while attribute option combinations are structurally equivalent to category option combinations, they are used to disaggregate data at the level of the data set. All data value which are part of a data set which is associated with an attribute combination, would be recorded and disaggregated with an additional fifth dimension, in addition to the four primary dimensions listed above. There are no restrictions on how an attribute combination can be constructed, which in turn allows for implementers to design arbitrary dimensions for specific data sets. 


## Group sets and analytical dimensions

Category and attribute combinations are used during data entry to disaggregate data in certain ways, 
for instance by age and sex breakdowns. When the data is later analyzed, there may be a need to 
aggregate or group the data in different ways. Consider a category with the following age bands: 

* \< 1
* 1-4
* 5-10
* 10-15
* 15-19
* 20-29
* 30-49
* 49+

Data may be entered with these age groups, but when analyzed in the analytics apps of DHIS2, 
there may be a need to group the data according to more coarse age bands.
Using a category option group set, we could create two category groups, such as \<15 and 15+. 
Each of the original category options could then be placed into the corresponding
category option group. Each of the groups can then be associated with a category option group 
set, which becomes available as an additional dimension in the analytics apps. 


Category option group sets are particularly useful for creating higher level groupings of common
category options. This approach is often useful for combining data elements which may have been 
collected according to related, but different category combinations. 


## Data element groups

Data elements which are related to one another can be grouped together
with a *data element group*. Data element groups are completely flexible in
terms of both their names and their memberships. 



Groups are useful both for browsing and presenting related data,
and can also be used to aggregate values captured for data elements in
the group. Groups are loosely coupled to data elements and not tied
directly to the data values which means they can be modified and added
at any point in time without interfering with the low-level data.

## Data element group sets

Similar to category option group sets, data element group sets can be used 
to aggregate related data elements together. We might be interested in 
determining the total number of communicable and non-communicable 
diseases from a morbidity data set. A data element group set could be 
created with two groups: "Communicable diseases" and "Non-communicable
diseases". Data elements could be placed into each of these groups. 

During a pivot table analysis, the data elemement group set could be 
used to aggregate data by each of the data element groups within 
the group set. 

This approach allows for highly flexible types of analyses where the 
exact defintion of the combination of data elements are not known
or which may be difficult to define in the form of an indicator. 

