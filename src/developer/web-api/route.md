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

### Running a route

The following is an example of a JSON request creating a route:

```json
{
  "name": "postman",
  "code": "postman",
  "disabled": false,
  "url": "https://postman-echo.com/"
}
```

The route can be run from DHIS2 after the above request is sent to the `/api/routes` API endpoint. You can run the route either with its returned ID or the code assigned to it as demonstrated below:

```
GET /api/routes/{id}/run
GET /api/routes/postman/run
POST /api/routes/postman/run
```

### Running a route with authentication

A number of authentication modes are supported when running routes. These authentication modes add headers or query parameters to the request being routed from DHIS2. DHIS2 encrypts at rest sensitive headers or query parameters when creating a route with an authentication mode. This means that the clear text secrets cannot be read from the database or the Web API. What follows are the supported authentication modes:

* `http-basic`: adds an _Authorization_ header to the route request for HTTP basic access authentication. Here is an example creating a route configured with `http-basic` authentication:

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

* `api-token`: adds an _Authorization_ header for [Personal Access Token (PAT) authentication](https://docs.dhis2.org/en/use/user-guides/dhis-core-version-master/working-with-your-account/personal-access-tokens.html). It is worth noting that PAT authentication is specific to DHIS2 so you might want to consider the more general `api-headers` authentication mode (described next) should the route's target URL be a non-DHIS2 instance. Here is an example creating a route configured with `api-token` authentication:

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
  Note that this request configures the route with static headers so that these headers are included in the request sent from DHIS2. Keep in mind that DHIS2 does not store these static headers as encrypted. 

* `api-headers`: adds user-defined headers for API authentication. Here is an example creating a route configured with `api-headers` authentication:

  ```json
  {
    "name": "postman-get",
    "code": "postman-get",
    "disabled": false,
    "url": "https://postman-echo.com/get",
    "auth": {
      "type": "api-headers",
      "headers": {
        "X-API-KEY": "aXJgm4Kwv1xk9UfFRYIIR8b6mEV1cQz3lcxMQlaQz9lwI35j4ZIUK5T2O2aQDfIY"
      }
    }
  }
  ```

* `api-query-params`: adds user-defined headers for API authentication. Here is an example to creating a route configured with `api-query-params` authentication:

  ```json
  {
    "name": "postman-get",
    "code": "postman-get",
    "disabled": false,
    "url": "https://postman-echo.com/get",
    "auth": {
      "type": "api-query-params",
      "queryParams": {
        "token": "aXJgm4Kwv1xk9UfFRYIIR8b6mEV1cQz3lcxMQlaQz9lwI35j4ZIUK5T2O2aQDfIY"
      }
    }
  }
  ```

### Running a route with authentication and custom authority

In the example shown below, we are configuring a route with `http-basic` authentication and assigning a custom authority it:

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

Custom authorities allows a DHIS2 client that does not have the rights to manage the route to still be able to run it. This enables the route to be run from your app.

### Wildcard Routes

It is possible to create "wildcard routes" which support sub-path requests which are then passed through to the upstream service. To do this, the route URL must end with `/**`.  Sub-paths can then be specified by appending them after `/run`.

```json
{
  "name": "postman-wildcard",
  "code": "postman-wildcard",
  "disabled": false,
  "url": "https://postman-echo.com/**"
}
```

After you have sent this to `/api/routes` you now have your route available for you, and can run it with its returned ID or you can also use code. Note that the sub-paths `/get` and `/post` are passed in the URL of the request below, which will trigger requests to `https://postman-echo.com/get` and `https://postman-echo.com/post` respectively.

```
GET /api/routes/{id}/run/get
GET /api/routes/postman-wildcard/run/get
POST /api/routes/{id}/run/post
POST /api/routes/postman-wildcard/run/post
```
