# Metadata Gist API { #gist_api } 
<!--DHIS2-SECTION-ID:gist_api-->

The Metadata Gist API is a RESTful read-only JSON API to fetch and browse 
metadata. Items in this API contain the gist of the same item in the Metadata API.

The API is specifically designed to avoid:

* Large response payloads because of the inclusion of partial nested object 
  graphs.
* Resource intensive in memory processing of requests 
  (e.g. in memory filtering or object graph traversal).
* _n + 1_ database queries as a result of object graph traversal while rendering
  the response.

## Comparison with Metadata API { #gist_vs_metadata_api } 
<!--DHIS2-SECTION-ID:gist_vs_metadata_api-->

The standard Metadata API is a flexible and powerful API built to serve any and 
every use case.
The downside of this is that not all features and combinations can scale while 
keeping good performance in the presence of huge numbers of items.
In particular lists with items where each item itself has a property which is a 
large collection of complex objects have proven problematic as they quickly
reference a large part of the entire object graph.

The `/gist` API was added to provide a metadata API where scaling well is our 
first priority. The downside of this is that there are more distinct limits to
what features are technically reasonable, which means not all features of the 
standard Metadata API exist for the Gist API.

The Gist API uses a divide and conquer strategy to avoid responses with large
partial object graphs. Instead of including nested objects or lists it provides
a `/gist` endpoint URI where this object or list can be viewed in isolation.

**The `/gist` API refers to nested data using URIs rather than including it.**
This means if a client is interested in this nested information more requests
are required but each of them is kept reasonable small and will scale
well in context of huge number of potential items.

Known Differences:

* items only includes fields of referenced identifiable objects if these do not
  have an endpoint on their own
* it never includes identifiable collections of objects directly
* items by default do not include all available fields, but a subset that depends 
  on context and parameters
* lists cannot be used without pager (therefore there is no `pager` parameter)
* fields with collections are not paged using the `pager`-transformer but through
  a paged API endpoint for the particular collection property
* items in a list, a collection property size or boolean transformer result 
  always considers object sharing (the set of considered items is always the set
  visible to the user)
* Gist offers `member(<id>)` and `not-member(<id>)` collection field transformers
* Gist offers `canRead` and `canWrite` access check filter instead of filtering
  on the `access` property
* Gist offers using attribute UIDs as field and filter property names to allow
  listing or filtering based on custom attribute values
* Gist offers filter grouping
* Gist offers renaming the enrty list in a paged response using `pageListName`
* Gist offers to pluck multiple simple properties

Known Limitations:

* by default only persisted are included; a handful of special 
  non-persistent fields (synthetic fields) can be added explicitly; other 
  non-persistent fields might be possible to extract using `from` transformation
* filters can only be applied to persisted fields
* orders can only be applied to persisted fields
* token filters are not available
* order is always case-sensitive
* `pluck` transformer limited to text properties (or simple properties for multi-pluck)
* fields which hold collections of simple (non-identifiable) items cannot always
  be included depending on how they are stored

Where possible to use the `/gist` API should be considered the preferable way
of fetching metadata information.


## Endpoints { #gist_endpoints } 
<!--DHIS2-SECTION-ID:gist_endpoints-->

The `/gist` API has 3 kinds of endpoints:

* <code>/api/&lt;object-type><b>/gist</b></code>: paged list of all known and visible objects of the type (implicit `auto=S`)
* <code>/api/&lt;object-type&gt;/&lt;object-id&gt;<b>/gist</b></code>: view single object by ID (implicit `auto=L`)
* <code>/api/&lt;object-type&gt;/&lt;object-id&gt;/&lt;field-name&gt;<b>/gist</b></code>: paged list of all known and visible items in the collection of owner object's field (implicit `auto=M`; in case this is a simple field just the field value)

These endpoints correspond to the endpoints of the standard metadata API without 
the `/gist` suffix and share the majority of parameters and their options with 
that API.


## Browsing Data { #gist_browse } 
<!--DHIS2-SECTION-ID:gist_browse-->

Since `/gist` API avoids deeply nested data structures in the response the
details of referenced complex objects or list of objects is instead provided
in form of a URI to the gist endpoint that only returns the complex object or
list of objects. These URIs are provided by the `apiEndpoints` field of an item
which is automatically added to an item when such references exist.
The item property itself might contain a transformation result on the object
or collection such as its size, emptiness, non-emptiness, id(s) or plucked 
property such as its name.

To manually browse data it can be handy to use the `absoluteUrls=true` parameter.
Linkage between parts of the gist can now be followed directly in browsers that
render JSON responses.


## Parameters { #gist_parameters } 
<!--DHIS2-SECTION-ID:gist_parameters-->

All endpoints of the `/gist` API accept the same set of parameters.
Parameters and their options that do not make sense in the endpoint context are 
ignored.


### Overview
Parameters in alphabetical order:

| Parameter      | Options               | Default                            | Description          |
| -------------- | --------------------- |------------------------------------| ---------------------|
| `absoluteUrls` | `true` or `false`     | `false`                            | `true` use relative paths in links, `false` use absolute URLs in links |
| `auto`         | `XS`, `S`, `M`, `L`, `XL` | (context dependent)                | extent of fields selected by `*` field selector |
| `fields`       | (depends on endpoint) | `*`                                | comma separated list of fields or presets to include |
| `filter`       | `<field>:<operator>` or `<field>:<operator>:<value>` |                                    | comma separated list of query field filters (can be used more than once) |
| `headless`     | `true` or `false`     | `false`                            | `true` skip wrapping result in a pager (ignores `total`), `false` use a pager wrapper object around the result list |
| `inverse`      | `true` or `false`     | `false`                            | `true` return items **not** in the list, `false` return items in the list |
| `locale`       |                       | (user account configured language) | translation language override |
| `order`        | `<field>` or  `<field>:asc` or `<field>:desc` | `:asc`                             | comma separated list of query order fields (can be used more than once) |
| `page`         | 1-n                   | 1                                  | page number |
| `pageSize`     | 1-1000                | 50                                 | number of items on a page |
| `pageListName` | `<text>` | (object type plural) | overrides the property name of the result entry list | 
| `rootJunction` | `AND` or `OR`         | `AND`                              | logical combination of `filter`s, `AND`= all must match, `OR`= at least one must match |
| `total`/`totalPages`        | `true` or `false`     | `false`                            | `true` add total number of matches to the pager, `false` skip counting total number of matches |
| `translate`    | `true` or `false`     | `true`                             | `true` translate all translatable properties, `false` skip translation of translatable properties (no effect on synthetic display names) |



### The `absoluteUrls` Parameter { #gist_parameters_absoluteUrls } 
<!--DHIS2-SECTION-ID:gist_parameters_absoluteUrls-->

By default, URIs in `apiEndpoints`, `href` and the `pager` `prev` and `next` 
members are relative, starting with `/<object-type>/` path.

The URIs can be changed to absolute URLs using the `absoluteUrls` parameter.

For example, `/api/users/rWLrZL8rP3K/gist?fields=id,href` returns:

```json
{
  "id": "rWLrZL8rP3K",
  "href": "/users/rWLrZL8rP3K/gist"
}
```

whereas `/api/users/rWLrZL8rP3K/gist?fields=id,href&absoluteUrls=true` 
returns:

```json
{
  "id": "rWLrZL8rP3K",
  "href": "http://localhost:8080/api/users/rWLrZL8rP3K/gist?absoluteUrls=true"
}
```

As the example shows the `absoluteUrls` parameter is also forwarded or carried
over to the included URLs so allowing to browse the responses by following the 
provided URLs.


### The `auto` Parameter
Each endpoint implicitly sets a default for the extent of fields matched by the
`*` / `:all` fields selector:

* `/api/<object-type>/gist`: implies `auto=S`
* `/api/<object-type>/<object-id>/gist`: implies `auto=L`
* `/api/<object-type>/<object-id>/<field-name>/gist`: implies `auto=M`

The `auto` parameter is used to manually override the default to make list items
include more or less fields. This setting again acts as a default which can be
further overridden on a per field basis using an explicit transformation.

Possible options for `auto` are ("t-shirt sizes"):

* `XS`: includes only IDs and textual properties
* `S`: excludes complex (object) properties, collection are only linked (not counted)
* `M`: complex included as reference URL, references and collections as count and reference URL
* `L`: like `M` but references and collections included as IDs (OBS! unbound in size)
* `XL`: like `L` but references and collections included as ID objects: `{ "id": <id> }`

For example, `/api/users/gist` would list items with fields `id`, `surname`, 
`firstName`, `phoneNumber`, `email`, `lastUpdated` whereas 
`/api/users/gist?auto=XS` only lists `id`, `surname`,
`firstName`, `phoneNumber`, `email`. Using `/api/users/gist?auto=L` would also
include `organisationUnits`, `dataViewOrganisationUnits`, 
`teiSearchOrganisationUnits` and `userGroups` each with the list of IDs of the
members in the lists/sets.


### The `fields` Parameter { #gist_parameters_fields } 
<!--DHIS2-SECTION-ID:gist_parameters_fields-->

Specifies the list of fields to include for each list item.

Fields are included in the result JSON objects for an item in the provided order.
A preset in the list of fields is expanded to the fields it contains at the 
position in the `fields` list it appears.
Fields within the preset are ordered from simple to complex.

If no `fields` parameter is provided `fields=*` is assumed.
Note that the fields of the `*` preset also depend on the `auto` parameter

To remove a field use either `!<name>` or `-<name>` in the list of fields.
For example to remove the userGroups from a user, use:

    /api/users/gist?fields=*,!userGroups

The same principle can also be used to specify the transformer to use for a 
field. For example, to include the IDs of the user's user groups use:

    /api/users/gist?fields=*,userGroups::ids

The `fields` parameter does allow listing fields of nested objects. 
For example to add `userCredentials` with `id` and `name` of a user use:

    /api/users/gist?fields=*,userCredentials[id,username]

This creates items of the form:

```json
{
  ...
  "userCredentials": {
    "id": "Z9oOHPi3FHB",
    "username": "guest"
  }
}
```

When including nested fields of collections the nested field must be a text
property. 

For example to include all `name`s of a user's `userGroups` by:

    /api/users/gist?fields=*,userGroups[name]

This lists the `userGroups` as:

```json
{
  "userGroups": {
    "name": [
      "_PROGRAM_Inpatient program",
      "_PROGRAM_TB program",
      "_DATASET_Superuser",
      "_PROGRAM_Superuser",
      "_DATASET_Data entry clerk",
      "_DATASET_M and E Officer"
    ]
  }
}
```
The above is functional identical to:

    /api/users/gist?fields=*,userGroups::pluck(name)~rename(userGroups.name)

When requesting a single field, like `/api/users/gist?fields=surname` the
response is a (still paged) list of simple values:

```json
{
  "pager": {
    "page": 1,
    "pageSize": 50
  },
  "users": [
    "Kamara",
    "Wakiki",
    "Nana",
    "Malai",
    ...
  ]
}
```

When requesting a single field of a specific owner object which has a simple
(non collection) value, like for example 
`/api/users/rWLrZL8rP3K/gist?fields=surname` the response only include the plain
JSON value:

```json
"Wakiki"
```

Further details on field presets can be found in section [Fields](#gist_fields).

### The `filter` Parameter { #gist_parameters_filter } 
<!--DHIS2-SECTION-ID:gist_parameters_filter-->

To filter the list of returned items add one or more `filter` parameters.

Multiple filters can either be specified as comma-separated list of a single 
`filter` parameter or as multiple `filter` parameters each with a single filter.

There are two types of filters:

* unary: `<field>:<operator>`
* binary: `<field>:<operator>:<value>`

A field can be: 

* a persisted field of the listed item type 
* a persisted field of a directly referenced object (1:1 relation)
* a UID of an attribute

Available unary operators are:

| Unary Operator | Description                                                 |
| -------- | ----------------------------------------------------------------- |
| `null`   | field is _null_ (undefined)                                       |
| `!null`  | field is _not null_ (defined)                                     |
| `empty`  | field is a _empty_ collection or string                           |
| `!empty` | field is a _non-empty_ collection or string                       |

Available binary operators are:

| Binary Operator   | Description                                              |
| ----------------- | -------------------------------------------------------- |
| `eq`              | field _equals_ value                                     |
| `ieq`             | field _equals_ value (case insensitive)                  |
| `!eq`, `neq`, `ne`| field is _not equal_ value                               |
| `lt`              | field is _less than_ value                               |
| `le`, `lte`       | field is _less than or equal to_ value                   |
| `gt`              | field is _greater than_ value                            |
| `ge`, `gte`       | field is _greater than or equal to_ value                |
| `in`              | field is a collection and value is an item _contained in_ the collection |
| `!in`             | field is a collection and value is an item _not contained in_ the collection |

If the `<value>` of an `in` or `!in` filter is a list it is given in the form
`[value1,value2,...]`, for example: `userGroups:in:[fbfJHSPpUQD,cYeuwXTCPkU]`.

Any `>`, `>=`, `<` `<=`, `==` or `!=` comparison applied to a collection field 
with a numeric value will compare the size of the collection to the value, for
example: `userGroups:gt:0`.

Any `>`, `>=`, `<` `<=`, `==` or `!=` comparison applied to a text field 
with a integer number value will compare the text length to the value, for 
example: `name:eq:4` (name has length 4).


Available binary pattern matching operators are:

| Binary Operator                   | Description                              |
| --------------------------------- | ---------------------------------------- |
| `like`, `ilike`                   | field _contains_ `<value>` or field _matches_ pattern `<value>` (when wildcards `*` or `?` in value) |
| `!like`, `!ilike`                 | field does _not contain_ `<value>` or field does _not match_ pattern `<value>` (when wildcards `*` or `?` in value) |
| `$like`, `$ilike`, `startsWith`   | field _starts with_ `<value>`            |
| `!$like`, `!$ilike`, `!startsWith`| field does _not start with_ `<value>`    |
| `like$`, `ilike$`, `endsWith`     | field _ends with_ `<value>`              |
| `!like$`, `!ilike$`, `!endsWith`  | field does _not end with_ `<value>`      |

The `like` and `!like` operators can be used by either providing a search term
in which case a match is any value where the term occurs anywhere, or they can
be used by providing the search pattern using `*` as _any number of characters_
and `?` as _any single character_.

All pattern matching operators named `like` are case-sensitive. All others 
are case-insensitive. 

Note that filters on attribute values use text based comparison which means 
all text filters are supported.

For example, to only list organisations on second level use

    /api/organisationUnits/gist?filter=level:eq:2

Similarly, when listing the `children` of a particular organisation unit the
collection can be filtered. To only list those children that are connected to
a program one would use:

    /api/organisationUnits/rZxk3S0qN63/children/gist?filter=programs:gt:0

Binary operators for access (sharing) based filtering:

| Binary Operator   | Description                                              |
| ----------------- | -------------------------------------------------------- |
| `canRead`         | Has user `<value>` metadata read permission to the object |
| `canWrite`        | Has user `<value>` metadata write permission to the object |
| `canDataRead`     | Has user `<value>` data read permission to the object    |
| `canDataWrite`    | Has user `<value>` data write permission to the object   |
| `canAccess`       | Has user `<value0>` permission `<value1>` to the object  |

When the user ID `<value>` is omitted the check is performed for the currently
logged-in user. Similarly, if `<value0>` is ommitted for `canAccess` filter
the check is performed for the currently logged-in user.

When applied to a simple value property, here `code`, the filter restricts the response to
those data elements (owner object) the user can read/write:

    /api/dataElements/gist?filter=code:canWrite:OYLGMiazHtW

When applied to a reference property, here `categoryCombo`, the filter restricts the response 
to those data elements having a category combo that the user can read/write:

    /api/dataElements/gist?filter=categoryCombo:canWrite:OYLGMiazHtW

When applied to a reference collection property, here `dataElementGroups`, the
filter restricts the response to those data elements where a data element group exists in the
collection property and which the user can read/write:

    /api/dataElements/gist?filter=dataElementGroups:canWrite:OYLGMiazHtW

The `canAccess` expects two arguments, 1st is user ID, 2nd the access pattern,
for example to check metadata read and write access the pattern is `rw%`:

    /api/dataElements/gist?filter=code:canAccess:[OYLGMiazHtW,rw%]


In addition, filter can be grouped to allow combining selected filters with 
logical OR when the general filter combinator is logical AND, or vice-versa 
with logical AND when the general combinator is logical OR.

For groups the filter pattern is extended as following:

* unary: `<group>:<field>:<operator>`
* binary: `<group>:<field>:<operator>:<value>`

The group is an arbitrary number between `0` and `9` (when omitted `0` is 
assumed). 

The behaviour is best explained with a small example for an imaginary object
type with an `age` and `name` property.

    ?filter=1:age:eq:50&filter=2:name:eq:foo&filter=2:name:eq:bar

The above filter has two groups `1` and `2`, and the `2` group has 2 members.
This is equivalent to the SQL (note the `and` and `or` as well as the 
grouping braces):

    e.age = 50 and (e.name = 'foo' or e.name = 'bar')

Now, if the same `filter`s would be used in combination with `rootJunction=OR`

    ?filter=1:age:eq:50&filter=2:name:eq:foo&filter=2:name:eq:bar&rootJunction=OR

the effect would be equivalent to the following SQL instead:

    e.age = 50 or (e.name = 'foo' and e.name = 'bar')


### The `headless` Parameter { #gist_parameters_headless } 
<!--DHIS2-SECTION-ID:gist_parameters_headless-->

Endpoints returning a list by default wrap the items with an envelope containing 
the `pager` and the list, which is named according to the type of object listed.

For example `/api/organisationUnits/gist` returns:

```json
{
  "pager": {
    "page": 1,
    "pageSize": 50,
    "nextPage": "/organisationUnits/gist?page=2"
  },
  "organisationUnits": [
    ...
  ]
}
```

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

Filters and orders do apply normally, meaning they filter or order the items
not contained in the member collection.


### The `locale` Parameter { #gist_parameters_locale } 
<!--DHIS2-SECTION-ID:gist_parameters_locale-->
The `locale` parameter is usually used for testing purposes to ad-hoc switch 
translation language of display names. 

If not specified the translation language is the one configured in the users
account settings.

Examples:

    /api/organisationUnits/gist?locale=en
    /api/organisationUnits/gist?locale=en_GB

### The `order` Parameter { #gist_parameters_order } 
<!--DHIS2-SECTION-ID:gist_parameters_order-->

To sort the list of items one or more order expressions can be given.

An order expression is either just a field name of a persisted field, or a field
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


### The `page` Parameter { #gist_parameters_page } 
<!--DHIS2-SECTION-ID:gist_parameters_page-->

Refers to the viewed page in paged list starting with `1` for the first page.

If no `page` parameter is present this is equal to `page=1`.

The `page` is always in relation to the `pageSize`.
If a `page` is given beyond the number of existing matches an empty item list
is returned.


### The `pageSize` Parameter { #gist_parameters_pageSize } 
<!--DHIS2-SECTION-ID:gist_parameters_pageSize-->

Refers to the number of items on a `page`. Maximum is 1000 items.

If no `pageSize` parameter is present this is equal to `pageSize=50`.


### The `rootJunction` Parameter { #gist_parameters_rootJunction } 
<!--DHIS2-SECTION-ID:gist_parameters_rootJunction-->

The `rootJunction` parameter can be used to explicitly set the logic junction
used between filters. Possible are:

* `AND`: all filters have to match an entry for it to be included in the results
* `OR`: any of the filters matches an entry for it to be included in the results

Default is `AND`.


### The `pageListName` Parameter { #gist_parameters_pageListName }
<!--DHIS2-SECTION-ID:gist_parameters_pageListName-->
The array property in a paged response that contains the matching entry list is 
named  after the object type contained in the list. 
For `/api/organisationUnits/gist` it would be named `organisationUnits`.

This default naming can be customized using the `pageListName` parameter.
For example, `/api/organisationUnits/gist?pageListName=matches` returns a
response root object with the format:

```json
{
  "pager": {},
  "matches": []
}
```
(details of the pager and matches are omitted here)


### The `total` or `totalPages` Parameter { #gist_parameters_total } 

<!--DHIS2-SECTION-ID:gist_parameters_total-->

By default, a gist query will **not** count the total number of matches should 
those exceed the `pageSize` limit. Instead, we opt-in to the additional costs
the total count implicates.

When not counting the total matches (`total=false`) the response `pager` will
assume that there is a `next` page in case `pageSize` items were found. This
could however turn out to be false when browsing to the page. Also, the `total`
field stating the number of total matches is not included in the `pager`.

For example, `/api/organisationUnits/gist` returns a `pager`:

```json
{
  "pager": {
    "page": 1,
    "pageSize": 50,
    "nextPage": "/organisationUnits/gist?page=2"
  }
}
```

When counting the total matches (`total=true`) the response `pager` will 
contain the `total` field with the actual number of total matches at the cost
of an additional database operation.

The response to `/api/organisationUnits/gist?total=true` now returns this `pager`:

```json
{
  "pager": {
    "page": 1,
    "pageSize": 50,
    "total": 1332,
    "nextPage": "/organisationUnits/gist?total=true&page=2",
    "pageCount": 27
  }
}
```


### The `translate` Parameter { #gist_parameters_translate } 
<!--DHIS2-SECTION-ID:gist_parameters_translate-->

Fields like `name` or `shortName` can be translated (internationalised).

By default, any translatable field that has a translation is returned translated
given that the user requesting the gist has an interface language configured.

To return the plain non-translated field use `translate=false`.

For example, `/api/organisationUnits/gist` returns items like this:

```json
{
  "name": "A translated name",
  ...
}
```

Whereas `/api/organisationUnits/gist?translate=false` would return items like:

```json
{
  "name"
  "Plain field name",
  ...
}
```

Note that synthetic fields `displayName` and `displayShortName` are always
returning the translated value independent of the `translate` parameter.


## Fields { #gist_fields } 
<!--DHIS2-SECTION-ID:gist_fields-->

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
A transformer or transformation can be applied to a field by appending 
any of the indicators `::`, `~` or `@` followed by the transformer expression.

Available transformer expressions are:

| Transformer          | JSON Result Type       | Description                                                                                           |
|----------------------|------------------------|-------------------------------------------------------------------------------------------------------|
| `rename(<name>)`     | -                      | renames the field in the response to `<name>`                                                         |
| `size`               | `number`               | number of items in the collection field                                                               |
| `isEmpty`            | `boolean`              | emptiness of a collection field                                                                       |
| `isNotEmpty`         | `boolean`              | non-emptiness of a collection field                                                                   |
| `ids`                | `string` or `[string]` | ID of an object or IDs of collection items                                                            |
| `id-objects`         | `[{ "id": <id> }]`     | IDs of collection items as object                                                                     |
| `member(<id>)`       | `boolean`              | has member with `<id>` for collection field                                                           |
| `not-member(<id>)`   | `boolean`              | not has member with `<id>` for collection field                                                       |
| `pluck(<field>,...)` | `string` or `[string]` | extract single text property or multiple simple properties from the object or of each collection item |
| `from(<field>,...)`  | depends on bean type   | extracts a non-persistent field from one or more persistent ones                                      |

A field can receive both the `rename` transformer and one of the other 
transformers, for example:

    /api/organisationUnits/gist?fields=*,children::size~rename(child-count)

The returned items now no longer have a `children` member but a `child-count`
member instead. Note that `rename` also affects the member name of the URI
reference given in `apiEndpoints`.

The `from` transformation can be used with one or more persistent fields as
parameter. These will be loaded from the database, set in an instance of the 
listed element object before the non-persistent property transformed with 
`from` is extracted from that instance by calling the getter. This allows to 
extract derived fields while using the same logic that is used in usual metadata API.

For example, a user's (non-persistent property) `name` is composed of the 
persistent property `firstName` and `surname`. It can be fetched like this:

    /api/users/gist?fields=id,name~from(firstName,surname)

Since a user's name is such a common case an auto-detection was added so that in
this special case the `from` transformation is added automatically to `name`.
We are allowed to just use the following which internally adds the `from` 
transformation:

    /api/users/gist?fields=id,name

While this makes non-persistent properties accessible in general these always 
have to be included in the `fields` explicitly. For a user this could be 
done using the following:

    /api/users/gist?fields=*,name


## Synthetic Fields { #gist_syntheticFields } 
<!--DHIS2-SECTION-ID:gist_syntheticFields-->

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

| Field              | Description                                             |
| ------------------ | ------------------------------------------------------- |
| `apiEndpoints`     | contains links to browse nested complex objects or collections |
| `href`             | link to the list item itself (single item view)         |
| `displayName`      | translated `name` (always translated)                   |
| `displayShortName` | translated `shortName` (always translated)              |
| `access`           | summary on ability of current user to read/write/modify the entry |


### The `href` Field { #gist_syntheticFields_href } 
<!--DHIS2-SECTION-ID:gist_syntheticFields_href-->

Each item in a `/gist` response can link to itself. This link is given in the 
`href` property.

To add the `href` field use (for example):

    /api/<object-type>/gist?fields=*,href

### The `displayName` and `displayShortName` Field { #gist_syntheticFields_displayName } 
<!--DHIS2-SECTION-ID:gist_syntheticFields_displayName-->

By definition the `displayName` is the translated `name` and the 
`displayShortName` is the translated `shortName`. 

To add `displayName` or `displayShortName` add it to the list use (for example):

    /api/<object-type>/gist?fields=*,displayName
    /api/<object-type>/gist?fields=*,displayShortName

Note that by default all translatable properties like `name` and `shortName` 
would also be translated. When `translate=false` is used to disable this 
`displayName` and `displayShortName` stay translated.


### The `apiEndpoints` Field { #gist_syntheticFields_apiEndpoints } 
<!--DHIS2-SECTION-ID:gist_syntheticFields_apiEndpoints-->

This property provides the links to further browse complex objects or list of 
items that are included in the `/gist` response in form of a transformed simple 
value like an item count.

The `apiEndpoints` object will have a member of the same name for every member 
in the item that was transformed to a simple value.

For example, 

    /api/users/gist?fields=id,userGroups::size,organisationUnits::size 

returns items in the form:

```json
{
  "id": "rWLrZL8rP3K",
  "userGroups": 0,
  "organisationUnits": 1,
  "apiEndpoints": {
    "organisationUnits": "/users/rWLrZL8rP3K/organisationUnits/gist",
    "userGroups": "/users/rWLrZL8rP3K/userGroups/gist"
  }
}
```

The list of `userGroups` and `organisationUnits` are included as their `size`. 
Each has a corresponding member in `apiEndpoints` with the path to browse the 
list.

The paths can be changed to URLs by using the `absoluteUrls` parameter. 

    /api/users/gist?fields=id,userGroups::size,organisationUnits::size&absoluteUrls=true

returns items in the form:

```json
{
  "id": "rWLrZL8rP3K",
  "userGroups": 0,
  "organisationUnits": 1,
  "apiEndpoints": {
    "organisationUnits": "http://{host}/api/users/rWLrZL8rP3K/organisationUnits/gist?absoluteUrls=true",
    "userGroups": "http://{host}/api/users/rWLrZL8rP3K/userGroups/gist?absoluteUrls=true"
  }
}
```

### The `access` Field
The `access` summary is based on the `sharing` and the current user.
This means it is only applicable for objects that have a `sharing` property.

For example, when listing data elements with `access` field

    /api/dataElements/gist?fields=*,access

the returned data element items contain a `"access"` member like the one below:

```json
"access": {
  "manage": false,
  "externalize": false,
  "write": false,
  "read": true,
  "update": false,
  "delete": false
}
```

### Attributes as Fields { #gist_attributeFields }
DHIS2 allows creating and adding custom attributes to metadata objects.
Their values are contained in the `attributeValues` property of a metadata 
object in form of a map with the attribute UID as the map's key.

To directly list one or more specific attribute values from this map as if they
were usual fields of the metadata object the attribute UID can be used as if it
was a name of a usual field.

For example, to include the value of the attribute with UID `Y1LUDU8sWBR` as 
the property `unit-of-measure` in the list use:

    /api/dataElements/gist?fields=id,name,Y1LUDU8sWBR::rename(unit-of-measure)

This results in list items of the form:
```json
{
  "id": "qrur9Dvnyt5",
  "name": "Age in years",
  "unit-of-measure": "years"
}
```

By default, the values are fetched as JSON and extracted from the map of 
attribute values. This means the listing will contain the proper JSON type for
the type of attribute value. This comes at the overhead of fetching all 
attribute values. To single out the value within the database the `PLUCK` 
transformation can be used.

    /api/dataElements/gist?fields=id,name,Y1LUDU8sWBR::rename(unit-of-measure)~pluck

The result will look the same but now the value is extracted as text in the 
database turning any JSON value to a string in the property output. 

## Examples { #gist_examples } 
<!--DHIS2-SECTION-ID:gist_examples-->
A few examples starting from simple listings moving on to very specific use cases. 

It is preferable to always supply an explicit list of `fields` so this section 
will do so. 

List organisation units with id and name:

    /api/organisationUnits/gist?fields=id,name

List organisation units with id and name and total count:

    /api/organisationUnits/gist?fields=id,name&total=true

List users with id and username:

    /api/users/gist?fields=id,userCredentials.username

List users with id, username and last login date:

    /api/users/gist?fields=id,userCredentials[username,lastLogin]

List only organisation units on second level with id, name and level:

    /api/organisationUnits/gist?fields=id,name,level&filter=level:eq:2

List only organisation units that have more than 1 child with id, name and
number of children:

    /api/organisationUnits/gist?fields=id,name,children::size&filter=children:gt:1

List only organisation units that are not yet a children of another unit
`zFDYIgyGmXG`:

    /api/organisationUnits/zFDYIgyGmXG/children/gist?fields=id,name&inverse=true

List users and flag whether they are a member of a specific user group 
`NTC8GjJ7p8P` and name that field `is-member` in the response:

    /api/users/gist?fields=id,userCredentials.username,userGroups::member(NTC8GjJ7p8P)~rename(is-member)

List links to all users in pages of 10 items:

    /api/users/gist?fields=href&absoluteUrls&pageSize=10

