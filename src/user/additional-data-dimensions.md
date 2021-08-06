# Additional data dimensions { #additional_data_dimensions } 

## About additional data dimensions

DHIS2 has the ability to add dimensions to data in addition to what was
described in the previous chapter. We will call these dimensions
“attribute categories” (ACs). The categories described in the previous
chapter we will call “disaggregation categories” (DCs) to differentiate
them from ACs.

ACs and DCs are quite similar—they work in much the same way, are
accessed through the same part of the maintenance interface, and exist
in the same part of the database. The main difference between them is
what they are connected to. A DC is attached to a data element; however,
an AC is attached to a data set. This means values for all DC options
can be entered on the same data entry screen, whereas you must choose
the AC option before you begin to enter data.

In setting up a system, you could just use DCs and ignore ACs
altogether. However, ACs are a way to simplify data entry screens or
reduce the size of the cross-product of category option combos.

> **Tip**
>
> When you’re deciding which categories should be DCs and which should be
> ACs, here’s a good rubric:
>
>  - Use DCs when you want to use different combinations of categories on
>    different data elements within a data set
>
>  - Use DCs when you want to enter all the category option combinations
>    on one data entry screen
>
>  - Use ACs when you want to use the same combination of categories for
>    all the data in a data set
>
>  - Use ACs when you want to enter only one category option combination
>    on one data entry screen

While we referred to DCs as part of the *what* dimension for simplicity
in the former chapter, it’s actually more complex. Either DCs or ACs can
answer any question about a data element, including *what* (of course),
*who*, *why*, *how*, or even a *where* or a *when* beyond the
organisation unit and period dimensions.

## Create or edit an attribute category and its options

The process of creating an attribute category as well as its options and
combinations, is discussed in the section 
[Manage categories](manage_category.html). As noted 
there, disaggregation categories are configured by editing a data
element and attribute categories are configured by editing a data set.

## Data entry with disaggregation categories and attribute categories

When entering aggregate data, one must first choose the attribute
categories, and then one can enter the data across disaggregation
categories on a single page.

For instance, in the graphic below, the attribute categories are
Implementing Partner (AIDSRelief Consortium) and Project (Improve access
to medicines).  The disaggregation categories are gender
(male/female/etc.), age (<15, 15-24, 25-49, >49).

![](resources/images/maintainence/categories_dataset_attributes.png)

## Analysis with disaggregation categories and attribute categories

In order to do analysis with disaggregation and attribute categories,
check the “Data dimension” box in the category editing screen of the
Maintenance app, as discussed in 
[Create or edit a category](manage_category.html#create_category).

## Approvals with attribute categories

To include attribute categories in approvals, create a category
option group that contains the same category options as the attribute
category.  Then create a category option group set and add that the
category option group set as a data approval level.

This is covered in more detail in the section
[Approving by category option group set](data_approvals_approving_by_cogs.html) and 
[Approving by multiple category option group sets](approving_by_multiple_category_option_group_sets.html).

## Attribute categories and the datavalue table

For some, the way attribute categories work with disaggregation
categories is clearer when we look at how the data values are stored
in DHIS2’s database. If diving into the database internals doesn’t help
you understand how the different types of categories work together,
please feel free to ignore it.

Each data value is associated with a data element, a period, and an
organisation unit, which are represented in this way:

<table width="100%">
<colgroup>
<col style="width: 18%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 7%" />
<col style="width: 27%" />
<col style="width: 28%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p>dataelementid</p></td>
<td><p>periodid</p></td>
<td><p>sourceid</p></td>
<td><p>&nbsp;</p></td>
<td><p>&nbsp;</p></td>
<td><p>&nbsp;</p></td>
</tr>
</tbody>
</table>

(Note these are numeric database ids, not DHIS2 uids.)

And of course, each data value has a value, adding the **value** column
to the database:

<table width="100%">
<colgroup>
<col style="width: 18%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 7%" />
<col style="width: 27%" />
<col style="width: 28%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p>dataelementid</p></td>
<td><p>periodid</p></td>
<td><p>sourceid</p></td>
<td><p>value</p></td>
<td><p>&nbsp;</p></td>
<td><p>&nbsp;</p></td>
</tr>
</tbody>
</table>

Each data value also references the disaggregation category options
and the attribute category options assigned to it. For instance, in
the example above, the data value entered in the box “Male <15” will
have the option “Male” for the disaggregation category **gender**, and
the option “<15” for the disaggregation category **age**. The
combination of these two options is represented in the database by a
single **category option combination** meaning “Male, <15”. The data
value references this disaggregation category option combination in the
**categoryoptioncomboid**:

<table width="100%">
<colgroup>
<col style="width: 18%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 7%" />
<col style="width: 27%" />
<col style="width: 28%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p>dataelementid</p></td>
<td><p>periodid</p></td>
<td><p>sourceid</p></td>
<td><p>value</p></td>
<td><p>categoryoptioncomboid</p></td>
<td><p>&nbsp;</p></td>
</tr>
</tbody>
</table>

Likewise, the same data value will have the option “AIDSRelief
Consortium” for the category **Implementing Partner**, and the option
“Improve access to medicines” for the category **Project**. There will
also be a database **category option combination** meaning “Implementing
Partner, Improve access to medicines”. The data value references this
attribute category option combination in the **attributeoptioncomboid**:

<table width="100%">
<colgroup>
<col style="width: 18%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 7%" />
<col style="width: 27%" />
<col style="width: 28%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p>dataelementid</p></td>
<td><p>periodid</p></td>
<td><p>sourceid</p></td>
<td><p>value</p></td>
<td><p>categoryoptioncomboid</p></td>
<td><p>attributeoptioncomboid</p></td>
</tr>
</tbody>
</table>

> **Note**
>
> The above column list does not include all of the columns in the
datavalue table.

If you have not defined a disaggregation category combination for a data
element, the categoryoptioncomboid will reference a “default” category
option combination, which is defined internally in DHIS2 as the category
default with the option default (the only option in the default
category). Likewise, if you have not defined an attribute category
combination for the dataset in which you enter the data, the
attributeoptioncomboid references the same “default” category option
combination.

We hope this investigation of how data values are stored in DHIS2’s
database makes it clearer how data values can be associated with various
groups of category options, both from disaggregation categories and
attribute categories.
