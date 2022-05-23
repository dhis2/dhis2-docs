## GeoJSON import

The GeoJSON import is used to attach geometry data to organisation units.

For a bulk import a GeoJSON file with a feature collection is expected.
Each feature in the collection requires a reference to the organisation unit it
should be linked to.

By default, the geometry from the file is stored as the `geometry` property of
an organisation unit. To store additional geometries attributes of type
`GEOJSON` can be created. When attributes are use all geometries from a file
are stored for the same attribute which is provided with an additional 
parameter `attributeId`.

### GeoJSON Bulk Data Import { #webapi_geojson_bulk_import }

Table: Import Parameters

| Name              | Type                           | Default | Description                                                                                                                       |
|-------------------|--------------------------------|---|-----------------------------------------------------------------------------------------------------------------------------------|
| `geoJsonId`       | `boolean`                      | `true` | When `true` the `id` property of the GeoJSON features is expected to hold the organisation unit identifier                        |
| `geoJsonProperty` | `String`                       | _undefined_ | If `geoJsonId` is `false` this parameter names the property in the GeoJSON feature's `properties` that holds the organisation unit identifier |
| `orgUnitProperty` | `enum`: [`id`, `code`, `name`] | `id` | The property of the organisation unit that is referred to by the identifiers used in the GeoJSON file                             |
| `attributeId`     | `String` | _undefined_ | When set the geometry is stored as value of the attribute referenced  by ID                                                       |
| `dryRun`          | `boolean` | `false` | When `true` the import is processed without actually updating the organisation units |
| `async`           | `boolean` | `false` | When `true` the import is processed asnychronously |

Uasge:

    POST /api/organisationUnits/geometry

The post body is the GeoJSON file. Content type should be `application/json` or
`application/geo+json`. The file may be `.zip` or `.gzip` compressed.

For example, a default file where `id` is used to refer to an organisation unit 
id has this structure:

```json
{ 
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "id": "O6uvpzGd5pu",
      "geometry": { ... }
    },
    ...
  ]
}
```

A file where a feature property is used to refer to the organisation unit code
would have this structure:

```json
{ 
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": { "code": "OU1_CODE" },
      "geometry": { ... }
    },
    ...
  ]
}
```
A `geometry` may also be `null` to effectively clear or delete the geometry 
for specific organisation units. There is a special bulk deletion API that is
described in the next section.

When run synchronously an import report is returned directly.
The HTTP status code is either `OK` when at least 1 organisation unit was 
updated successful. Otherwise, the status code is `Conflict`.

The import counts statistics contained in the report give further information:

* `imported`: number of organisation units that were successfully updated with a geometry that did not have one before for the updated property
* `updated`: number of organisation units that were successfully updated with a geometry that did have value for the updated property already
* `ignored`: number of organisation units that failed to update
* `deleted`: number of organisation units that where successfully update with a _empty_ geometry

When the import is run asynchronous the request returns immediately with status 
`OK` and job configuration response that contains a relative reference to 
the task endpoint that allows to track the status of the asynchronous import.
For example:

    /api/system/tasks/GEOJSON_IMPORT/{job-id}

The summary that is returned directly for synchronous execution is available at

    /api/system/taskSummaries/GEOJSON_IMPORT/{job-id}

once the import is finished.

### GeoJSON Bulk Data Deletion { #webapi_geojson_bulk_deletion }
To clear or unset the `geometry` data for all organisation units use:

    DELETE /api/organisationUnits/geometry

To clear or unset the geometry data for a specific `GEOJSON` attribute for
all organisation units use:

    DELETE /api/organisationUnits/geometry?attributeId={attr-id}

Clearing is always synchronous and returns a similar report as the bulk import.
It does not support any other parameters. No `dry-run` can be performed.
Bulk clearing requires the `F_PERFORM_MAINTENANCE` authority.

### GeoJSON Single Data Import { #webapi_geojson_single_import }
The single import allows to update the geometry of a single organisation unit.

    POST /api/organisationUnits/{id}/geometry

The post body only contains the GeoJSON `geometry` value, for example:
```json
{
  "type": "Polygon",
  "coordinates": [...]
}
```
Single import only supports `attributeId` and `dryRun` parameters.

### GeoJSON Single Data Deletion { #webapi_geojson_single_deletion }
To clear the `geometry` GeoJSON data of an individual organisation unit use:

    DELETE /api/organisationUnits/{id}/geometry

Similarly to clear a `GEOJSON` attribute value for an individual organisation 
unit use:

    DELETE /api/organisationUnits/{id}/geometry?attributeId={attr-id}

Clearing is always synchronous returns a similar report as single import.
The `dry-run` parameter is supported as well. 
The performing user requires authority to modify the target organisation unit.
