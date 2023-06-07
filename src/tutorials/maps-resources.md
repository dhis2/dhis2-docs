---
title: DHIS2 Maps & GIS resources
---

# DHIS2 Maps & GIS resources

**This page countains useful tutorials and resources about DHIS2 Maps and geograhical information systems (GIS).**

### Getting help

Please use the [DHIS2 Community of Practice](https://community.dhis2.org) if you have questions about DHIS2 Maps or related geographical information systems (GIS). There is a separate [category for Maps](https://community.dhis2.org/c/implementation/maps/73) under DHIS2 Implementation.

### Learning DHIS2 Maps

There are several resources allowing you to learn more about DHIS2 Maps:

- [DHIS2 Maps user guide](https://docs.dhis2.org/en/use/user-guides/dhis-core-version-master/analysing-data/maps.html)
- [Introduction to DHIS2 Maps](https://train.moodle.hisp.org/) on the Moodle platform of HISP South Africa. See the [enrollment instructions](https://drive.google.com/drive/folders/1C-m9maSEyCqQpOmS0RA7VZ4TlARqM4mh) about how to sign up.
- [Learner's Guide to Maps](https://docs.dhis2.org/en/topics/training-docs/analytics-tools-academy/maps/learneraposs-guide-to-maps.html): Contains all exercises and detailed steps to perform them related to the use of maps for the Analytics Tools Level 1 academy.
- [Trainer's Guide to Maps](https://docs.dhis2.org/en/topics/training-docs/analytics-tools-academy/maps/traineraposs-guide-to-maps.html): Will help the trainer prepare for the live demo session of DHIS2 Maps.

Videos:

- Creating a map using DHIS2 Maps:
  1. [Basemaps and boundary layers](https://youtu.be/nOpNDMZBELo)
  2. [Thematic layer](https://youtu.be/ONgmyeOGWg0)
  3. [Interpreting legends and data tables](https://youtu.be/RQngcSHtEx0)
- [High-level overview of DHIS2 Maps](https://youtu.be/LdhV_kAt-IE): Presents all the layer types and map tools.
- [Extending DHIS2 Maps](https://youtu.be/6XjThKinFcE): Earth Engine layers, downloading data for QGIS/ArcGIS, adding external layers.
- [A Guide to Using DHIS2 Maps for Sierra Leone](https://youtu.be/TmrN7xKJPyM): Demonstrates facility, org unit and thematic layers, and different basemaps.

### Configuring DHIS2 Maps

This is how you can configure DHIS2 Maps:

1. **Import geographic data for your organisation units [REQUIRED]** \
   Use polygon gometries for your districts and point geometries for the facilities. This one-time task should be performed by a system adinistrator using the Import/Export app. We recommend you to use the
   GeoJSON format if you use DHIS 2.39 or above. \
   [See documentation](https://docs.dhis2.org/en/use/user-guides/dhis-core-version-master/exchanging-data/importexport.html#geometry_import)

2. **Signing up for Google Earth Engine [RECOMMENDED]** \
   DHIS2 has a powerful integration with [Google Earth Engine]() allowing you to access detailed datasets for population (WorldPop), building footprints, elevation, land use and climate. These datasets can be freely used by governments and non-profit organisations, and the the sign up process is now very easy. \
   [See documentation](https://docs.dhis2.org/en/topics/tutorials/google-earth-engine-sign-up.html)

### Population analysis with DHIS2 Maps & QGIS using WorldPop data

A series of short videos showing you how to calculate the population within your organisation units or around health facilities:

1.  [Downloading WorldPop population data](https://youtu.be/pMYbPXSrsYs)
2.  [DHIS2 data download](https://youtu.be/OZi5PTu0_w4)
3.  [QGIS data import and styling](https://youtu.be/DJDWTa9EvM0)
4.  [Finding Population living within org unit boundaries](https://youtu.be/0y_KuAtXu2A)
5.  [Calculating population living within buffers](https://youtu.be/R82aleC5k2E)
6.  [Population living within walking and driving distances](https://youtu.be/X6Du8qB8xEA)

### DHIS2 Maps vs QGIS/ArcGIS

Use DHIS2 Maps to visualise and monitor the data stored in your DHIS2 instance. If you would like to combine your DHIS2 data with external datasets, or do advanced analysis we recommend you to use a GIS application like [QGIS](https://qgis.org) or [ArcGIS](https://esri.com). QGIS is open source, free to use and has a big community similar to DHIS2.
