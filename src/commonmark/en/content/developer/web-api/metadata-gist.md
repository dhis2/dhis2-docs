# Metadata Gist API

The metadata gist API is a RESTful read-only JSON API to browse metadata.

It is specifically designed to avoid: 
* large response payloads because of deeply nested object graphs
* resource intensive in memory processing of requests (e.g. in memory filtering)

It should be the "go to" API for metadata as long as the use case is supported.

All shown items, size counts or boolean transformer result reflect
the situation considering the items visible to you based on object sharing.


## Comparison with Metadata API
TODO

## Endpoints
The `/gist` API has 3 endpoints:

* `/api/<object-type>/gist`: paged list of all known and visible objects of the type (implicit `auto=S`)
* `/api/<object-type>/<object-id>/gist`: view single object by ID (implicit `auto=L`)
* `/api/<object-type>/<object-id>/<field-name>/gist`: paged list of all known and visible items in the collection of owner object's field (implicit `auto=M`; in case this is a simple field just the field value)

These endpoints correspond to the endpoints of the standard metadata API without 
the `/gist` suffix and share the majority of parameters and their options with 
that API.

## Browsing Data
Since `/gist` API avoids deeply nested data structures in the response the
details of referenced complex objects or list of objects is instead provided
in form of a URI to the gist endpoint that only returns the complex object or
list. These URIs are provided by the `apiEndpoints` field which is 
automatically added to an item when such references exist.

## Parameters
All endpoints of the `/gist` API accept the same set of parameters.
Parameters and their options that do not make sense in the endpoint context are 
ignored.

### Overview
Parameters in alphabetical order:

* `absoluteUrls`: `true` (default) use relative paths in links, `false` use absolute URLs in links
* `auto`: `XS`,`S`,`M`,`L`,`XL` extent of fields selected by `*` field selector
* `fields`: comma separated list of fields to include (default is `*`)
* `filter`: comma separated list of query field filters (can be used more than once)
* `headless`: `true` skip wrapping result in a pager (ignores `total`), `false` (default) use a pager wrapper object around the result list
* `inverse`: `true` return items **not** in the list, `false` (default) return items in the list
* `order`: comma separated list of query order fields (can be used more than once)
* `page`: `{1..n}`
* `pageSize`: `{1..1000}`
* `rootJunction`: `AND` (default) or `OR` combination of `filter`s
* `total`: `true` add total number of matches to the pager, `false` (default) skip counting total number of matches
* `translate`: `true` (default) translate all translatable properties, `false` skip translation of translatable properties (no effect on synthetic display names)

### The `absoluteUrls` Parameter
By default, URIs in `apiEndpoints`, `href` and the `pager`'s`prev` and `next` 
members are relative, starting with `/<object-type>/` path.

The URIs can be changed to absolute URLs using the `absoluteUrls` parameter.

For example, `/api/users/rWLrZL8rP3K/gist?fields=id,href` returns:

    {"id":"rWLrZL8rP3K","href":"/users/rWLrZL8rP3K/gist"}

whereas <code>/api/users/rWLrZL8rP3K/gist?fields=id,href<b>&absoluteUrls=true</b></code> 
returns:

    {"id":"rWLrZL8rP3K","href":"http://localhost:8080/api/users/rWLrZL8rP3K/gist?absoluteUrls=true"}

As the example shows the `absoluteUrls` parameter is also forwarded or carried
over to the included URLs so allowing to browse the responses by following the 
provided URLs.

### The `auto` Parameter
Each endpoint implicitly sets a default for the extent of fields matched by the
`*`/`:all` fields selector:

* `/api/<object-type>/gist`: `auto=S`
* `/api/<object-type>/<object-id>/gist`: `auto=L`
* `/api/<object-type>/<object-id>/<field-name>/gist`: `auto=M`

The `auto` parameter is used to manually override the default to make list items
include more or less fields. This setting again acts as a default which can be
further overridden on a per field basis using an explicit transformation.

Possible options for `auto` are ("t-shirt sizes"):

* `XS`: includes only IDs and textual properties
* `S`: excludes complex (object) properties, collection are only linked (not counted)
* `M`: complex included as reference URL, collections as count and reference URL
* `L`: like `M` but collections included as list of IDs (OBS! unbound in size)
* `XL`: like `L` but collections included as ID objects: `{ "id": <id> }`

For example, `/api/users/gist` would list items with fields `id`, `surname`, 
`firstName`, `phoneNumber`, `email`, `lastUpdated` whereas 
`/api/users/gist?auto=XS` only lists `id`, `surname`,
`firstName`, `phoneNumber`, `email`. Using `/api/users/gist?auto=L` would also
include `organisationUnits`, `dataViewOrganisationUnits`, 
`teiSearchOrganisationUnits` and `userGroups` each with the list of IDs of the
members in the lists/sets.

### The `fields` Parameter
Specifies the list of fields to include for each list item.

Fields are included in the result JSON objects for an item in the provided order.
A preset in the list of fields is expanded to the fields it contains at the 
position in the `fields` list it appears.
Fields within the preset are ordered from simple to complex.

If no `fields` parameter is provided `fields=*` is assumed.
Note that the fields of the `*` preset also depend on the `auto` parameter

Further details in section [Fields](#gist-fields).

### The `filter` Parameter


### The `headless` Parameter
Endpoints returning a list by default wrap the items with an envelope containing 
the `pager` and the list, which is named according to the type of object listed.

For example `/api/organisationUnits/gist` returns:

    {
        "pager": {
            "page": 1,
            "pageSize": 50,
            "nextPage": "/organisationUnits/gist?page=2"
        }
        "organisationUnits": [...]
    }

With `headless=true` the response to `/api/organisationUnits/gist?headless=true` 
is just the `[...]` list part in above example.

### The `inverse` Parameter
The `inverse` can be used in context of a collection field gist of the form 
`/api/<object-type>/<object-id>/<field-name>/gist` to not list all items that
are contained in the member collection but all items that are **not** contained
in the member collection.

For example, while 
    
    /api/organisationUnits/rZxk3S0qN63/children/gist

would list all organisation units that are children of `rZxk3S0qN63` the inverse

    /api/organisationUnits/rZxk3S0qN63/children/gist?inverse=true

would list all organisation units that are not children of `rZxk3S0qN63`. 
This would e.g. be used to compose a list of all units that can be made a child 
of a particular unit.

### The `order` Parameter
To sort the list of items one or more order expressions can be given.

An order expression is either just a field name of a persisted field or a field
name followed by `:asc` (ascending order - the default) or `:desc` 
(descending order).

For example, to sort organisation units alphabetically by name use:

    /api/organisationUnits/gist?order=name

Reverse alphabetical order would use:

    /api/organisationUnits/gist?order=name:desc

To sort organisation units first by level, then by name use:

    /api/organisationUnits/gist?order=level,name

This would start with root(s) at level 1. To start with the leaf units use:

    /api/organisationUnits/gist?order=level:desc,name

If no order is specified the result list will have a stable order based on 
internal data organisation.


### The `page` Parameter
Refers to the viewed page in paged list starting with `1` for the first page.

If no `page` parameter is present this is equal to `page=1`.

The `page` is always in relation to the `pageSize`.
If a `page` is given beyond the number of existing matches an empty item list
is returned.

### The `pageSize` Parameter
Refers to the number of items on a `page`. Maximum is 1000 items.

If no `pageSize` parameter is present this is equal to `pageSize=50`.

### The `rootJunction` Parameter
The `rootJunction` parameter can be used to explicitly set the logic junction
used between filters. Possible are:

* `AND`: all filters have to match an entry for it to be included in the results
* `OR`: any of the filters matches an entry for it to be included in the results

Default is `AND`.

### The `total` Parameter
By default, a gist query will **not** count the total number of matches should 
those exceed the `pageSize` limit. Instead, we opt-in to the additional costs
the total count implicates.

When not counting the total matches (`total=false`) the response `pager` will
assume that there is a `next` page in case `pageSize` items were found. This
could however turn out to be false when browsing to the page. Also, the `total`
field stating the number of total matches is not included in the `pager`.

For example, `/api/organisationUnits/gist` returns a `pager`:

    {
        "pager": {
            "page": 1,
            "pageSize": 50,
            "nextPage": "/organisationUnits/gist?page=2"
        }
    }

When counting the total matches (`total=true`) the response `pager` will 
contain the `total` field with the actual number of total matches at the cost
of an additional database operation.

The response to `/api/organisationUnits/gist?total=true` now returns this `pager`:

    {
        "pager": {
            "page": 1,
            "pageSize": 50,
            "total": 1332,
            "nextPage": "/organisationUnits/gist?total=true&page=2",
            "pageCount": 27
        }
    }

### The `translate` Parameter
Fields like `name` or `shortName` can be translated (internationalised).

By default, any translatable field that has a translation is returned translated
given that the user requesting the gist has an interface language configured.

To return the plain non-translated field use `translate=false`.

For example, `/api/organisationUnits/gist` returns items like this:

    {
        "name": "A translated name",
        ...
    }

Whereas `/api/organisationUnits/gist?translate=false` would return items like:

    {
        "name" "Plain field name",
        ...
    }

Note that synthetic fields `displayName` and `displayShortName` are always
returning the translated value independent of the `translate` parameter.


## Fields
The fields included by default (without `fields` parameter) correspond to 
`fields=*`. 
This means the list of fields shown depends on object type, endpoint context as 
well as the `auto` parameter.

Note that the `/gist` API always excludes certain fields that usually are of no 
interest to clients, like for example the `translations` or `sharing` fields. 
These can be added explicitly.

When not explicitly provided by name in the `fields` parameters the list of 
fields is computed from a preset.
A preset can be used in the list of fields like a field name. 
It expands to zero, one or many fields depending on the object type, used 
endpoint and selector.

### Field Presets

* `*` / `:all`: default fields depend on the context and `auto` parameter
* `:identifiable`: all persisted fields of the `IdentifiableObject` interface
* `:owner`: all persisted fields where the listed type is the owner
* `:nameable`: all persisted fields of the `NameableObject` interface
* `:persisted`: literally all persisted fields

### Field Transformers



## Synthetic Fields
The `/gist` API is tightly coupled to properties that exist the database.
This means properties that aren't stored in the database usually aren't 
available.
The exception to this are the "synthetic" properties which are dynamically 
computed on the basis of one or more database stored properties.

Synthetic properties are available for all endpoints where the persisted 
properties needed to compute the synthetic property exist.

Except for the `apiEndpoints` property which is automatically added when needed 
all other synthetic properties are not included by default and have to be 
requested explicitly in the list of `fields`.

### Overview
Synthetic fields in alphabetical order:

* `apiEndpoints`: contains links to browse nested complex objects or collections
* `href`: link to the list item itself (single item view)
* `displayName`: translated `name` (always translated)
* `displayShortName`: translated `displayName` (always translated)

### The `href` Field
Each item in a `/gist` response can link to itself. This link is given in the 
`href` property.

To add the `href` field use (for example):

		/api/<object-type>/gist?fields=*,href

### The `displayName` and `displayShortName` Field
By definition the `displayName` is the translated `name` and the 
`displayShortName` is the translated `shortName`. 

To add `displayName` or `displayShortName` add it to the list use (for example):

		/api/<object-type>/gist?fields=*,displayName
		/api/<object-type>/gist?fields=*,displayShortName

Note that by default all translatable properties like `name` and `shortName` 
would also be translated. When `translate=false` is used to disable this 
`displayName` and `displayShortName` stay translated.

### The `apiEndpoints` Field
This property provides the links to further browse complex objects or list of 
items that are included in the `/gist` response in form of a transformed simple 
value like an item count.

The `apiEndpoints` object will have a member of the same name for every member 
in the item that was transformed to a simple value.

For example, `/api/users/gist?fields=id,userGroups::size,organisationUnits::size` 
returns items in the form:

	{
		"id": "rWLrZL8rP3K",
		"userGroups": 0,
		"organisationUnits": 1,
		"apiEndpoints": {
			"organisationUnits": "/users/rWLrZL8rP3K/organisationUnits/gist",
			"userGroups": "/users/rWLrZL8rP3K/userGroups/gist"
	}

The list of `userGroups` and `organisationUnits` are included as their `size`. 
Each has a corresponding member in `apiEndpoints` with the path to browse the 
list.

The paths can be changed to URLs by using the `absoluteUrls` parameter. 
`/api/users/gist?fields=id,userGroups::size,organisationUnits::size&absoluteUrls=true` 
returns items in the form:

	{
		"id": "rWLrZL8rP3K",
		"userGroups": 0,
		"organisationUnits": 1,
		"apiEndpoints": {
			"organisationUnits": "http://{host}/api/users/rWLrZL8rP3K/organisationUnits/gist?absoluteUrls=true",
			"userGroups": "http://{host}/api/users/rWLrZL8rP3K/userGroups/gist?absoluteUrls=true"
		}
	}


## Filters


## Response

### Pager
