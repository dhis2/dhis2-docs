# Query Alias

## Query Alias { #webapi_query_alias }

The Query Alias API is an **EXPERIMENTAL** feature which supports shortening of long DHIS2 REST API queries using a built-in URL shortening service.  This can be useful in situations where very long URL paths exceed the limit set by browsers or network relays (often resulting in an [HTTP 414 - URI Too Long](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/414) error).  It is recommended to only use this query aliasing feature as a fallback when a 414 error is encountered.

> Note that query aliasing only support GET targets

An Alias is ephemeral and can be deleted by the server at any time.  It typically will persist for several hours, but this is not guaranteed.  When accessing an expired Alias URL, a `404 Not Found` error will be returned by the server.  If needed again, a new alias with the same target can be created.

### Creating an Alias

To create a new query alias, a POST request should be sent to the `/api/query/alias` endpoint with the following POST body, where `<target>` is the target Rest API path (starting with `/api/`).

```
{
    "target": "/api/path/to/long/rest/endpoint?withQuery=true&id=123456789"
}
```

The return value will look something like this:

```
{
    "id": "689a368a3f23e0985558eb4cff63e7fb4e63d736",
    "path": "/api/query/alias/689a368a3f23e0985558eb4cff63e7fb4e63d736",
    "href": "https://my-dhis2-instance.com/api/query/alias/689a368a3f23e0985558eb4cff63e7fb4e63d736",
    "target": "/api/path/to/long/rest/endpoint?withQuery=true&id=123456789"
}
```

### Accessing a previously-created Alias

Once an alias has been created, it can be accessed via the relative `path` or absolute `href` URI found in the response body.  The relative path will be of the form `/api/query/alias/<md5hash>`, where `<md5hash>` is the md5 hash of the passed `target` path.  This ensures that query aliases are deterministic - the same target will always result in the same Alias.

To access the `target` resource via a created Alias, a GET request can be sent to the Alias URI returned in the `href` response attribute.  For example:

GET https://my-dhis2-instance.com/api/query/alias/689a368a3f23e0985558eb4cff63e7fb4e63d736

The server will then respond as if the client had made a request directly to https://my-dhis2-instance.com/api/path/to/long/rest/endpoint?withQuery=true&id=123456789 (the target of the alias)


### Creating and immediately accessing an Alias

It is also possible to create an alias and, instead of parsing a JSON response, follow a `303 See Other` redirect to access the alias directly.  A `303 See Other` response is used instead of `302 Found` because following the redirect requires changing HTTP verb from POST (which creates the alias) to GET (which accesses the created alias)

To create and immediately access an Alias, send a POST request the same JSON POST body payload including a `target` attribute to `/api/query/alias/redirect`.  The Alias will be created just as before, but a redirect HTTP response will be returned instead of an HTTP 200 success.

HTTP 303 See Other
Location: https://my-dhis2-instance.com/api/query/alias/689a368a3f23e0985558eb4cff63e7fb4e63d736

Most clients will automatically follow this redirect, sending a follow-up GET request directly to https://my-dhis2-instance.com/api/query/alias/689a368a3f23e0985558eb4cff63e7fb4e63d736 and returning the response as if the original target had been accessed directly.  Note that some clients may not properly handle switching from POST to GET when encountering a `303 See Other`, which will result in a `501 Not Implemented` error.

### An example of client code which automatically falls back to query aliasing

The following short code snippet (in typescript) takes the target path of an API endpoint and attempts to access it.  If the URI is too long (either over some arbitrary length limit or returning a `414 URI Too Long` error) then a query alias will be created, and used whenever that target is accessed by this client again.  If the query alias has expired it will be automatically recreated.

Note that this is a very contrived example and **should not be used in a production application**.  In the future, the App Runtime query engine will automatically perform this fallback logic so that the application developer doesn't need to worry about constructing too-long URIs.

```ts
type AliasRequest = {
    target: string
}

type AliasResponse = {
    id: string
    path: string
    href: string
    target: string
}

type FetchResponse = {
    status: number
    data: AliasResponse
}

const BASE_URL = "https://my-dhis2-instance.com"
const MAX_URI_LENGTH = 2000
const ALIAS_API_PATH = 'api/query/alias'

const cachedAliases: Record<string, AliasResponse> = {}

const joinPath = (...segments: string[]) => {
    const firstPart = segments.shift()?.replace(/^\//, '')

    return segments.reduce((parts, segment) => {
        segment = segment.replace(/^\//, '').replace(/\/$/, '')
        return parts.concat(segment.split('/'))
    }, [firstPart]).join('/')
}

const fetchDHIS2 = async (path: string, init?: RequestInit): Promise<FetchResponse> => {
    const response = await fetch(joinPath(BASE_URL, path), {
        ...init
    })
    return {
        status: response.status,
        data: (response.status == 200) ? await response.json() : undefined
    }
}

const createAlias = async (path: string) => {
    const body: AliasRequest = {
        target: path
    }
    return await fetchDHIS2(ALIAS_API_PATH, {
        method: 'POST',
        body: JSON.stringify(body)
    })
}

const fetchDHIS2WithAliasFallback = async (path: string, init?: RequestInit, recreateOnFailure = true): Promise<FetchResponse> => {
    const uri = joinPath(BASE_URL, path)
    const alias = cachedAliases[path]

    if (alias) {
        const response = await fetchDHIS2(alias.path)
        if (response.status === 404 && recreateOnFailure) {
            delete cachedAliases[path];
            return fetchDHIS2WithAliasFallback(path, init, false)
        }
        return response;
    }

    if (uri.length >= MAX_URI_LENGTH) {
        const response = await createAlias(path);
        if (response.status === 201) {
            cachedAliases[path] = response.data
        }
        return fetchDHIS2WithAliasFallback(path, init, false)
    }

    const response = await fetchDHIS2(path, init)
    if (response.status === 414) {
        const response = await createAlias(path);
        if (response.status === 201) {
            cachedAliases[path] = response.data
        }
        return fetchDHIS2WithAliasFallback(path, init, false)
    }

    return response
}
export default fetchDHIS2WithAliasFallback
```
