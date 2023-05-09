# Route

## Route { #webapi_route }

The route API allows users to communicate with external http gateways/proxies. It's meant as a simple way
to extend your apps to get and post from services that you use to extend your apps functionality.

The endpoint can be found at `/api/routes` and the routes themselves can be run with `GET` or `POST` to `/api/routes/ID/run`
given that the user has the rights to run it. Additional query parameters, and body (in the case of `POST`) will be passed
along with the request.

To be able to externally react to the user which initiated the request from DHIS2
every request has the header:

    X-Forwarded-User: <username>

For the examples here we will be using the the [Echo API](https://learning.postman.com/docs/developer/echo-api/) from Postman
which just returns what you send to it (including body in the case of `POST`).

### GET Route without authentication

```json
{
  "name": "postman-get",
  "code": "postman-get",
  "disabled": false,
  "url": "https://postman-echo.com/get"
}
```

After you have sent this to `/api/routes` you now have your route available
for you, and can run it either with its returned ID or you can also use code.

    GET /api/routes/ID/run
    GET /api/routes/postman-get/run

### GET Route with authentication

We support 2 types of authentication out of the box, `http-basic` and `api-token` and in both cases they will simply add the required headers.
In the case of `api-token` its meant to be used by our PAT (personal access token) so it might not be the right header for your purpose (the format is `ApiToken token`).

We will use the same example as before, but this time with `http-basic` auth.

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
