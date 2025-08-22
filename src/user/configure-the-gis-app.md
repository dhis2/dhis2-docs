# Configure DHIS2 Maps { #gis_creating }

## Context { #gis_creating_context }

Setting up DHIS2 Maps simply means storing coordinates for the organisation
units you want to show on the map in the database. Coordinates are often
distributed in proprietary formats and will need to be converted to a
format which DHIS2 understands. ESRI shapefile is a common
geospatial vector data format for desktop applications. You might find
shapefiles for your country [here](http://www.diva-gis.org/gdata) or in
many other geospatial data repositories on the web. Some amount of work
needs to be done in order to use these coordinates in DHIS2 Maps, namely
transforming the data into a suitable format and ensuring the name which
are contained in the geospatial data match exactly with the names of the
organization units which they should be matched to.

Only organisation units with POINT geometry types can be edited through the
Maintenance app at this time. To modify POLYGON geometries, please us the
**Org unit geometry import** in the Import/Export app.

To edit the POINT coordinates of an organisation unit, open the Maintenance
App and navigate to the Organisation Unit section. Click on the Organisation
Unit you would like to view or edit, you can search or filter the list from
on the left-hand side of the screen. Once an organisation unit is selected,
you can edit the **Latitude** and **Longitude** values to update the POINT
coordinates. If the Organisation Unit has a POLYGON geometry, the coordinates
cannot be edited.

If you are going to add or update coordinates for a large number of units, or
if you need to update polygon geometries, you should use the automatic
**Org unit geometry import** explained in the following section.

> **Important**
>
> The only coordinate reference system (CRS) supported by DHIS2 is EPSG:4326,
> also known as geographic longitude/latitude. Coordinates must be
> stored with the longitude (east/west position) preceding the latitude
> (north/south position). If your vector data is in a different CRS than
> EPSG 4326, you will need to reproject the data first before importing
> into DHIS2.

## Importing coordinates in GeoJSON format { #geojson_creating_setup }

Step 1 - Convert geospatial data to GeoJSON format

Skip this step if your data is already in GeoJSON format using geographic
longitude/latitude.

The recommended tool for geographical format conversions is called
"ogr2ogr". This should be available for most Linux distributions
`sudo apt-get install gdal-bin`. For Windows, go to
<http://fwtools.maptools.org/>and download "FWTools", install it and open
up the FWTools command shell. During the format conversion we also want
to ensure that the output has the correct coordinate projection
(called EPSG:4326 with geographic longitude and latitude). For a more
detailed reference of geographic coordinates, please refer to this
[site](http://www.epsg-registry.org/). If you have already reprojected
the geographic data to the geographic latitude/longitude (EPSG:4326) system,
there is no need to explicitly define the output coordinate system, assuming
that `ogr2ogr` can determine the input spatial reference system. Note that
most GeoJSON files use the EPSG:4326 system. You can determine the
spatial reference system by executing the following command.

    ogrinfo -al -so filename.shp

This command assumes your geospatial data is in ESRI Shapefile (.shp) format,
but [several other formats are supported](https://gdal.org/drivers/vector/).

Assuming that the projection is reported to be EPSG:27700 by `ogrinfo`,
we can transform it to EPSG:4326 by executing the following
command.

    ogr2ogr -s_srs EPSG:27700 -t_srs EPSG:4326 -f GeoJSON filename.geojson filename.shp

If the geographic data is already in EPSG:4326, you can simply transform
the shapefile to GeoJSON by executing the following command.

    ogr2ogr -f GeoJSON filename.geojson filename.shp

You will find the created GeoJSON file in the same folder as the shapefile.

Step 2 - Simplify/generalize your geographical data

The boundaries in geographical data files are usually very accurate, too
much so for the needs of a web-based GIS. This usually does not affect
the performance when using GIS files on a local system, but it is
usually necessary to optimize the geographical data for the web-based
GIS system of DHIS2. All geographical data needs to be downloaded from
the server and rendered in a browser, so if the data is overly complex,
the performance of the DHIS2 Maps will be negatively impacted. This
optimization process can be described as follows:

For polygons, we can make the boundary lines less detailed by
removing some of the line points. This generalization will
lead to degradation of the polygon. However, after
a bit of experimentation, an optimal level of generalization can be
found, where the accuracy of the polygon is visually acceptable, and the
performance is optimal. Make a backup of your files
before you start. One possible method is the use of
[MapShaper](http://www.mapshaper.org/) which is an online tool which can
be used to generalize geographical data. To use MapShaper, simply upload
your files to the site. Then, click on _Simplify_ in the top menu and
select a simplification method. A slider will show at the top of the screen
that starts at 100%. It is usually acceptable to drag it up to about 30%.
When you are happy with the result, click "Export" in the top right
corner. Select the "GeoJSON" file format and click the Export button to
download the file. Move on to the next step with your new simplified
GeoJSON file.

Step 3 - Prepare the GeoJSON file

Unfortunately, the GeoJSON file is not ready for importation yet. Open it in
a robust text editor like Geany (Linux) or Notepad++ (Windows). GeoJSON is
a JSON based format. In the GeoJSON file an organisation unit is represented as a
Feature. Every feature should have a geometry, properties (attributes) and
they can have an id.

In order to import geospatial data from a GeoJSON file, DHIS2 must match
each of them with an organisation unit in its database. Each GeoJSON
feature must, in other words, contain a reference to its corresponding
organisation unit. The reference itself must be one of three possible
DHIS2 identifiers: **uid**, **code** or **name**.

By default we will try to match the organisation unit uid with the GeoJSON
feature id. You can add or change the id field so it matches the uid for
the organisasjon unit. You can also match by a property from the GeoJSON
feature properties. The property can be matched with organisation **uid**,
**code** or **name**.

Please note that the identifier used must **uniquely** identify an
organisation unit (e.g. if there are two organisation units in the
database of the same name or code, these cannot be matched properly on
either). As _uid_ is the only guaranteed-to-be-unique identifier it is
the most robust choice. However, as matching on name is usually easier
(given that the name is already part of your data).

Have a brief look at the identifiers and compare them to the
corresponding values in the database. If they seem to match fairly good,
it is about time to do a preview in the import-export module.

Go to the **Import/Export app** and click **Org Unit geometry import**.
Select the GeoJSON file and how you want to match the GeoJSON features to
the organisation units. Click **Start dry run** and look at the summary.
Look for new/updated organisation units. Our intention is to add coordinates
to already existing organisation units in the database, so we want as many
updates as possible and 0 new. Those listed as new will be created as
root units and mess up the organisation unit trees in DHIS2. If any listed
as new, click the number and the organisation units in question will appear
in the list below. If there are any slight misspellings compared to the
organisation unit names in the database - fix them and start dry run again.
Otherwise, click the "discard all" button below the list and then the
**Start import** button.

If the import process completes successfully, you should now be able to
utilize the geographical data in the DHIS2 Maps. If not, check the log
for hints and look for common errors such as:

\- Name duplicates in the GeoJSON file. The name column in the database is
unique and does not accept two organisation units with the same name.

\- The "shortname" column in the organisationunit table in your database
has a too small varchar definition. Increase it to 100.

\- Special name characters in the GeoJSON file.

\- Wrongly formatted input GeoJSON, use [GeoJSONLint](https://geojsonlint.com/)
to test the content.

## Importing coordinates in GML format { #gis_creating_setup }

> **Note**
>
> Only GML 2.0 is supported. GeoJSON is the recommended format.

Step 1 - Simplify/generalize your geographical data

The boundaries in geographical data files are usually very accurate, too
much so for the needs of a web-based GIS. This usually does not affect
the performance when using GIS files on a local system, but it is
usually necessary to optimize the geographical data for the web-based
GIS system of DHIS2. All geographical data needs to be downloaded from
the server and rendered in a browser, so if the data is overly complex,
the performance of the DHIS2 Maps will be negatively impacted. This
optimization process can be described as follows:

For polygons, we can make the boundary lines less detailed by
removing some of the line points. This generalization will
lead to degradation of the polygon. However, after
a bit of experimentation, an optimal level of generalization can be
found, where the accuracy of the polygon is visually acceptable, and the
performance is optimal. Make a backup of your shapefiles
before you start. One possible method is the use of
[MapShaper](http://www.mapshaper.org/) which is an online tool which can
be used to generalize geographical data. To use MapShaper, simply upload your files to the site. Then, click on Simplify in the top menu and select a simplification method. A slider will show at the top of the screen that starts at 100%. It is usually acceptable to drag it up to about 30%. When you are happy with the result, click "Export" in the top right corner. Select GeoJSON file format and click the Export button to download the file to your computer.

Step 2 - Convert to GML

The recommended tool for geographical format conversions is called
"ogr2ogr". This should be available for most Linux distributions `sudo apt-get install gdal-bin`. For Windows, go to <http://fwtools.maptools.org/> and download
"FWTools", install it and open up the FWTools command shell. During the
format conversion we also want to ensure that the output has the correct
coordinate projection (called EPSG:4326 with geographic longitude and
latitude). For a more detailed reference of geographic coordinates,
please refer to this [site](http://www.epsg-registry.org/). If you have
already reprojected the geographic data to the geographic
latitude/longitude (EPSG:4326) system, there is no need to explicitly
define the output coordinate system, assuming that `ogr2ogr` can
determine the input spatial reference system. Note that most shapefiles
are using the EPSG:4326 system. You can determine the spatial reference
system by executing the following command.

    ogrinfo -al -so filename.json

Assuming that the projection is reported to be EPSG:27700 by `ogrinfo`,
we can transform it to EPSG:4326 by executing the following
command.

    ogr2ogr -s_srs EPSG:27700 -t_srs EPSG:4326 -f GML filename.gml filename.json

If the geographic data is already in EPSG:4326, you can simply transform
the shapefile to GML by executing the following command.

    ogr2ogr -f GML filename.gml filename.json

You will find the created GML file in the same folder as the shapefile.

Step 3 - Prepare the GML file

Unfortunately, the GML file is not ready for importation yet. Open it in
a robust text editor like Geany (Linux) or Notepad++ (Windows). GML is
an XML based format which means that you will recognize the regular XML
tag hierarchy. In the GML file an organisation unit is represented as a
\<gml:featureMember\>. Inside the feature members we usually find a lot
of attributes, but we are just going to import their coordinates.

In order to import geospatial data from the feature members of the GML
input, DHIS2 must match each of them with an organisation unit in its
database. The feature member element must, in other words, contain a
reference to its corresponding organisation unit. The reference itself
must be one of three possible DHIS2 identifiers: **uid**, **code** or
**name**. The identifier of choice must be provided as a property for
each feature member element. The importer will look for a property with
the local name of either _Uid_, _Code_ or _Name_, e.g. "ogr:Name" or
"anyPrefix:Code".

If your feature members already contain a property of the identifier you
wish to use (such as the name of an area) you can use search and replace
in a text editor to rename these elements to a name DHIS2 will recognize
(see the below table). This is typically a workflow which is applicable
when using the name as the identifier (the source shapefile or even GML
will usually contain the name for each area it defines).

Table: Organisation unit identifiers supported for GML import

| Matching priority | Identifier | Valid spellings  | Guaranteed unique |
| ----------------- | ---------- | ---------------- | ----------------- |
| 1                 | Uid        | uid, Uid, UID    | Yes               |
| 2                 | Code       | code, Code, CODE | No                |
| 3                 | Name       | name, Name, NAME | No                |

In the case of renaming properties one would usually find a tag named
something like "ogr:DISTRICT*NAME", "ogr:NAME_1" and rename it to
"ogr:Name". If using the \_code* or _uid_ identifiers on the other hand,
looking up the correct values in the DHIS2 database and going through
the GML file, adding the properties for each corresponding feature
member might be necessary. In any of the cases it is important to
realize that the identifier used must **uniquely** identify an
organisation unit (e.g. if there are two organisation units in the
database of the same name or code, these cannot be matched properly on
either). As _uid_ is the only guaranteed-to-be-unique identifier it is
the most robust choice. However, as matching on name is usually easier
(given that the name is already part of your data), a viable approach to
solving uniqueness conflicts can be to match any non-uniquely named
organisation units on a different identifier (uid, preferably) and the
rest on their names.

As can be seen in the above table there is a matching priority, meaning
is any two or more identifiers are provided for the same feature member,
matching will be performed on the highest priority identifier. Note also
the valid properties which can be used in you GML. The namespace prefix
is not important as only the local name is used.

A common pitfall of performing preparation of the GML files is syntax-
or element naming errors. Therefore please make sure that all properties
of the GML file are started and terminated with correctly corresponding
tags. Also make sure the properties follow either of the given valid
spellings of the property name. The identifying properties are supposed
to look like e.g. \<ogr:Name\>Moyamba District\</ogr:Name\>,
\<somePrefix:uid\>x7uuia898nJ\</somePrefix:uid\> or
\<CODE\>OU*12345\</CODE\>. Another common error is not making sure the
identifier matches exactly, especially when using the \_name* property.
All matches are performed on exact values, meaning that "Moyamba" in a
source GML file would not be matched against "Moyamba District" in the
database.

Have a brief look at the identifiers and compare them to the
corresponding values in the database. If they seem to match fairly good,
it is about time to do a preview in the import-export module.

Go to the **Import/Export app**, click **Org Unit geometry import** and select the **GML** format. Select the GML file and click **Start dry run** and look at the summary. Look for new/updated organisation units. Our
intention is to add coordinates to already existing organisation units
in the database, so we want as many updates as possible and 0 new. Those
listed as new will be created as root units and mess up the organisation
unit trees in DHIS2. If any listed as new, click the number and the
organisation units in question will appear in the list below. If there
are any slight misspellings compared to the organisation unit names in
the database - fix them and do the preview again. Otherwise, click the
"discard all" button below the list and then the "Import all" button
above the list.

If the import process completes successfully, you should now be able to
utilize the geographical data in the DHIS2 GIS. If not, check the log
for hints and look for common errors such as:

\- Name duplicates in the GML file. The name column in the database is
unique and does not accept two organisation units with the same name.

\- The "shortname" column in the organisationunit table in your database
has a too small varchar definition. Increase it to 100.

\- Special name characters in the GML file. Be sure to convert these to
appropriate XML equivalents or escape sequences.

\- Wrongly formatted input GML, non-matching tags
