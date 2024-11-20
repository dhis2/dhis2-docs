# Route

## Route { #webapi_route }

The route API allows users to communicate with external HTTP gateways and proxies. It is designed as a simple solution to extend your apps to get and post from services that you use to extend your apps functionality.'

```
/api/routes
```

The endpoint can be found at `/api/routes` and the routes can be run with `GET` or `POST` to `/api/routes/{id}/run`.

To be able to externally react to the user which initiated the request from DHIS2 every request has the header:

```properties
X-Forwarded-User: <username>
```

For the examples here we will be using the the [Echo API](https://learning.postman.com/docs/developer/echo-api/) from Postman which just returns what you send to it (including body in the case of `POST`).

### GET Route without authentication

```json
{
  "name": "postman-get",
  "code": "postman-get",
  "disabled": false,
  "url": "https://postman-echo.com/get"
}
```

After you have sent this to `/api/routes` you now have your route available for you, and can run it either with its returned ID or you can also use code.

```
GET /api/routes/{id}/run
GET /api/routes/postman-get/run
```

### GET Route with authentication

Two types of authentication are supported: `http-basic` and `api-token`. In both cases they will simply add the required headers. In the case of `api-token` its meant to be used by our PAT (personal access token) so it might not be the right header for your purpose (the format is `ApiToken token`).

We will use the same example as before, but this time with `http-basic` authentication.

```json
{
  "name": "postman-get",
  "code": "postman-get",
  "disabled": false,
  "url": "https://postman-echo.com/get",
  "auth": {
    "type": "http-basic",
    "username": "admin",
    "password": "admin"
  }
}
```

Here you can see the request will be done with basic auth and username `admin` password `admin`.

For completeness here is an example with `api-token`, here we have also add in some custom headers that will also be sent along with the request.

```json
{
  "name": "postman-get",
  "code": "postman-get",
  "disabled": false,
  "url": "https://postman-echo.com/get",
  "headers": {
    "a": "1",
    "b": "2",
    "c": "3"
  },
  "auth": {
    "type": "api-token",
    "token": "74478F79-7B85-424A-9C93-8A6F924AA9F9"
  }
}
```

### POST Route with authentication and custom authority

In this example we are using the postman service to allow for POSTs, we have added `http-basic` and also support what are called custom authorities.
Custom authorities allows users that don't have the metadata access to manage the route to still be able to run it (so it can be used for your custom apps).

```json
{
  "name": "postman-post",
  "code": "postman-post",
  "disabled": false,
  "url": "https://postman-echo.com/post",
  "auth": {
    "type": "http-basic",
    "username": "admin",
    "password": "admin"
  },
  "authorities": ["MY_CUSTOM_APP"]
}
```

```
POST /api/routes/ID/run
```

```json      
{
  "answer": 42
}
```

### Wildcard Routes

It is possible to create "wildcard routes" which support sub-path requests which are then passed through to the upstream service. To do this, the route URL must end with `/*`.  Sub-paths can then be specified by appending them after `/run`.

```json
{
  "name": "postman-wildcard",
  "code": "postman-wildcard",
  "disabled": false,
  "url": "https://postman-echo.com/*"
}
```

After you have sent this to `/api/routes` you now have your route available for you, and can run it with its returned ID or you can also use code. Note that the sub-paths `/get` and `/post` are passed in the URL of the request below, which will trigger requests to `https://postman-echo.com/get` and `https://postman-echo.com/post` respectively.

```
GET /api/routes/ID/run/get
GET /api/routes/postman-wildcard/run/get
POST /api/routes/ID/run/post
POST /api/routes/postman-wildcard/run/post
```

