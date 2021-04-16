# Metadata Gist API

The metadata gist API is a RESTful read-only JSON API to browse metadata without 
running the risk of unintentionally cause resource intensive requests or receive 
huge response payloads.

## Endpoints
The `/gist` API has 3 kinds of endpoints:

* `/api/<object-type>/gist`: paged list of all known and visible objects of the type (implicit `auto=S`)
* `/api/<object-type>/<object-id>/gist`: view single object by ID (implicit `auto=L`)
* `/api/<object-type>/<object-id>/<field-name>/gist`: paged list of all known and visible items in the collection of owner object's field (implicit `auto=M`; in case this is a simple field just the field value)

These endpoints correspond to the endpoints of the standard metadata API without 
the `/gist` suffix and share the majority of parameter options with that API.

Remember that all shown items, size counts or boolean transformer result reflect 
the situation considering the items visible to you based on object sharing.

## Parameters
All endpoints of the `/gist` API accept the same set of parameters.
Parameters or options that do not make sense in the endpoint context are ignored.

### Overview
Parameters in alphabetical order:

* `absolute`: `true` (default) use relative paths in links, `false` use absolute URLs in links
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

### The `absolute` Parameter

### The `fields` Parameter
Specifies the list of fields to include for each list item.

Fields are included in the result JSON objects for an item in the provided order.
If the list contains a preset it is expanded to list of fields it contains at 
the position in the list.
Fields within the preset are ordered from simple to complex.

If no `fields` parameter is provided `fields=*` is assumed.
Note that the fields of the `*` preset also depend on the `auto` parameter

Further details in section [Fields](#gist-fields).

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

The paths can be changed to URLs by using the `absolute` parameter. 
`/api/users/gist?fields=id,userGroups::size,organisationUnits::size&absolute=true` 
returns items in the form:

	{
		"id": "rWLrZL8rP3K",
		"userGroups": 0,
		"organisationUnits": 1,
		"apiEndpoints": {
			"organisationUnits": "http://{host}/api/users/rWLrZL8rP3K/organisationUnits/gist?absolute=true",
			"userGroups": "http://{host}/api/users/rWLrZL8rP3K/userGroups/gist?absolute=true"
		}
	}


## Filters

## Orders

