# Additional data dimensions

<!--DHIS2-SECTION-ID:additional_data_dimensions-->

## About additional data dimensions

DHIS2 has the ability to add dimensions to data in addition to what was
described in the previous chapter. We will call these dimensions
"attribute categories" (ACs). The categories described in the previous
chapter we will call "disaggregation categories" (DCs) to differentiate
them from ACs.

ACs and DCs are quite similar—they work in much the same way, are
accessed through the same part of the maintenance interface, and exist
in the same part of the database. The main difference between them is
what they are connected to: a DC is attached to a data element. An AC,
however, is attached to a data set. This means values for all DC options
can be entered on the same data entry screen, whereas you must choose
the AC option before you begin to enter data.

In setting up a system, you could just use DCs and ignore ACs
altogether. However, ACs are a way to simplify data entry screens or
reduce the size of the cross-product of category option combos.

When you’re deciding which categories should be DCs and which should be
ACs, here’s a good rubric:

  - Use DCs when you want to use different combinations of categories on
    different data elements within a data set

  - Use DCs when you want to enter all the category option combinations
    on one data entry screen

  - Use ACs when you want to use the same combination of categories for
    all the data in a data set

  - Use ACs when you want to enter only one category option combination
    on one data entry screen

While we referred to DCs as part of the *what* dimension for simplicity
in the former chapter, it’s actually more complex. Either DCs or ACs can
answer any question about a data element, including *what* (of course),
*who*, *why*, *how*, or even a *where* or a *when* beyond the
organisation unit and period dimensions.

## Create or edit an attribute category and its options

For the process of creating an attribute category as well as options and
combinations, see the section of this manual named Manage categories.
