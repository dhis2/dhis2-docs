# Event Hooks

## Event Hooks { #webapi_event_hooks }

The event hook API enables users to subscribe to events that occur within DHIS2. Currently, there are two types of events that are published: metadata events for the creation, updating, and deletion of metadata objects, and scheduler events for when any type of internal scheduled job is run, such as analytics.

The endpoint can be found on `/api/eventHooks` and must be enabled in your `dhis.conf` with the
key `event_hooks.enabled = on` to work.

There are 2 main concept for event hooks, you need to configure the source (which includes the path,
and the field filters to apply) and one or multiple targets (webhooks, JMS etc).

To illustrate some of these points we will go through a simple webhook that listens on metadata changes for dataElements. And have a webhook target enabled.

Outside of `source` and `target` there are 2 properties that you should be aware of, the `name` which is used for a visual hint when looking in the UI, and `disabled` which by default
is enabled but does temporarily allow you to disable certain event hooks that might not be relevant right now.

```json
{
  "name": "webhook-api-token",
  "disabled": false,
  "source": {
    "path": "metadata.dataElement",
    "fields": "id,code,name"
  },
  "targets": [
    {
      "type": "webhook",
      "url": "http://localhost:3000/api/gateway",
      "auth": {
        "type": "api-token",
        "token": "EB3F6799-AA5A-47E8-B6B7-97EA54EB3873"
      }
    }
  ]
}
```

### Source

We will focus on the `source.path` part of the event hooks here. For the `path` property we support 2 main paths:

`metadata.type.id` where you can be as specific as you need, for example you can listen on all metadata by using `metadata` or you can list on
organisation unit operations only by using `metadata.organisationUnit`.

The same goes for scheduler events, where the path is `scheduler.type.id`
so an example would be `scheduler.ANALYTICS_TABLE`.

There is also support for field filtering, the default is `id,displayName` but you are free to use any field filtering that you
want. To keep things light it's not recommended to request too big of a payload (as there might be many events happening, depending on your path)

### Target

After you have `source` prepared (including path and filters) you must now
setup one or more targets. All targets require the `type` property, and then the
payloads themselves will look different based on that.

#### Console

The `console` target is the simplest target we have, it has no parameter and all it does is to print the events to the system log (can be nice when testing)

```json
{
  "type": "console"
}
```

#### Webhook

The `webhook` target send a outgoing http request the your target `url`.
Optionally it can include authentication (both `api-token` and `http-basic`) supported out of the box. But you can also add any headers you want if you have any custom needs. The payload will be sent as `application/json` and the content
will depend on your field filters you set in the source.

```json
{
  "type": "webhook",
  "url": "http://localhost:3000/api/gateway",
  "headers": {},
  "auth": {
    "type": "api-token",
    "token": "EB3F6799-AA5A-47E8-B6B7-97EA54EB3873"
  }
}
```

```json
{
  "type": "webhook",
  "url": "http://localhost:3000/api/gateway",
  "auth": {
    "type": "http-basic",
    "username": "admin",
    "password": "admin"
  }
}
```

#### Apache Artemis JMS

The `jms` target allows you to send JMS messages to your Apache Artemis instance (JMS 2/3 supported). This target is great for doing async handling of these events, and to not have the server block while processing. If you prefer using a `queue` instead you can set `useQueue` to `true`.

```json
{
  "type": "jms",
  "brokerUrl": "tcp://localhost:61616",
  "useQueue": false,
  "username": "guest",
  "password": "guest"
}
```

#### Apache Kafka

Simlar to the `jms` target, using the `kafka` target allows you to send these events into an Apache Kafka instance. Authentication is not yet supported.

```json
{
  "type": "kafka",
  "topic": "dhis2.hooks"
}
```
