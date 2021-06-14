# Indicators

This chapter covers the following topics:

  - What is an indicator

  - Purposes of indicators

  - Indicator-driven data collection

  - Managing indicators in DHIS2

The following describes these topics in greater detail.

## What is an indicator?

In DHIS2, the indicator is a core element of data analysis. An indicator
is a calculated formula based on a combination of data elements,
category options, possibly constants and a factor. There are two foms of
indicators, those with a denominator and those which do not have a
denominator. Calculated totals, which may be composed of multiple data
elements do not have denominators. Coverage indicators (ratios,
percentages, etc) are composed of two formulas of data elements, one
representing the numerator and another representing the denominator.

Indicators are thus made up of formulas of data elements and other
components and are always multiplied by a factor (e.g. 1, 100, 100, 100
000). The factor is essentially a number which is multiplied by the
result of the numerator divided by denominator. As a concrete example,
the indicator "BCG coverage <1 year" is defined by a formula with a
factor 100 (in order to obtain a percentage), a numerator ("BCG doses
given to children under 1 year") and a denominator ("Target population
under 1 year"). The indicator "DPT1 to DPT3 drop out rate" is a formula
of 100 % x ("DPT1 doses given"- "DPT3 doses given") / ("DPT1 doses
given").



Table: Indicator examples

| Indicator | Formula | Numerator | Denominator | Factor |
|---|---|---|---|---|
| Fully immunized <1 year coverage | Fully immunized/Population < 1 year x 100 | Fully immunized | Population < 1 | 100 (Percentage) |
| Maternal Mortality Rate | Maternal deaths/Live births x 100 000 | Maternal deaths | Live births | 100 000 (MMR is measured per 100 000) |
| Cumulative number of people Enrolled in Care | Cumulative number of people Enrolled in Care x 1 | Cumulative number Enrolled in Care (Male, Age<18) +Cumulative number Enrolled in Care (Male, Age18+) +Cumulative number Enrolled in Care (Female, Age<18) +Cumulative number Enrolled in Care (Female, Age18+) | None | 1 |

## Purpose of indicators

Indicators which are defined with both numerators and denominators are
typically more useful for analysis. Because they are proportions, they
are comparable across time and space, which is very important since
units of analysis and comparison, such as districts, vary in size and
change over time. A district with population of 1000 people may have
fewer cases of a given disease than a district with a population of
10,000. However, the incidence values of a given disease will be
comparable between the two districts because of the use of the
respective populations for each district.

Indicators thus allow comparison, and are the prime tool for data
analysis. DHIS2 should provide relevant indicators for analysis for all
health programs, not just the raw data. Most report modules in DHIS2
support both data elements and indicators and you can also combine these
in custom reports.

## Indicator-driven data collection

Since indicators are more suited for analysis compared to data elements,
the calculation of indicators should be the main driving force for
collection of data. A usual situation is that much data is collected but
never used in any indicator, which significantly reduces the usability
of the data. Either the captured data elements should be included in
indicators used for management or they should probably not be collected
at all.

For implementation purposes, a list of indicators used for management
should be defined and implemented in DHIS2. For analysis, training
should focus on the use of indicators and why these are better suited
than data elements for this purpose.

## Managing indicators

Indicators can be added, deleted, or modified at any time in DHIS2
without affecting the data. Indicators are not stored as values in
DHIS2, but as formulas, which are calculated whenever the user needs
them. Thus a change in the formulas will only lead to different data
elements being called for when using the indicator for analysis, without
any changes to the underlying data values taking place. For information
how to manage indicators, please refer to the chapter on indicators in
the DHIS2 user documentation.
