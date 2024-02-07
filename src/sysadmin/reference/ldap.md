## LDAP configuration { #install_ldap_configuration } 

DHIS2 is capable of using an LDAP server for authentication of users.
For LDAP authentication it is required to have a matching user in the
DHIS2 database per LDAP entry. The DHIS2 user will be used to represent
authorities / user roles.

To set up LDAP authentication you need to configure the LDAP server URL,
a manager user and an LDAP search base and search filter. This
configuration should be done in the DHIS 2 configuration file `dhis.conf`. 
LDAP users, or entries, are identified by distinguished names 
(DN from now on). An example configuration looks like this:

```properties
# LDAP server URL
ldap.url = ldaps://domain.org:636

# LDAP manager entry distinguished name
ldap.manager.dn = cn=johndoe,dc=domain,dc=org

# LDAP manager entry password
ldap.manager.password = xxxx

# LDAP base search
ldap.search.base = dc=domain,dc=org

# LDAP search filter
ldap.search.filter = (cn={0})
```

The LDAP configuration properties are explained below:

- *ldap.url:* The URL of the LDAP server for which to authenticate
  against. Using SSL/encryption is strongly recommended in order to
  make authentication secure. As example URL is
  *ldaps://domain.org:636*, where ldaps refers to the protocol,
  *domain.org* refers to the domain name or IP address, and *636*
  refers to the port (636 is default for LDAPS).
- *ldap.manager.dn:* An LDAP manager user is required for binding to
  the LDAP server for the user authentication process. This property
  refers to the DN of that entry. I.e. this is not the user which will
  be authenticated when logging into DHIS2, rather the user which
  binds to the LDAP server in order to do the authentication.
- *ldap.manager.password:* The password for the LDAP manager user.
- *ldap.search.base:* The search base, or the distinguished name of
  the search base object, which defines the location in the directory
  from which the LDAP search begins.
- *ldap.search.filter:* The filter for matching DNs of entries in the
  LDAP directory. The {0} variable will be substituted by the DHIS2
  username, or alternatively, the LDAP identifier defined for the user
  with the supplied username.

DHIS2 will use the supplied username / password and try to authenticate
against an LDAP server entry, then look up user roles / authorities from
a corresponding DHIS2 user. This implies that a user must have a
matching entry in the LDAP directory as well as a DHIS2 user in order to
log in.

During authentication, DHIS2 will try to bind to the LDAP server using
the configured LDAP server URL and the manager DN and password. Once the
binding is done, it will search for an entry in the directory using the
configured LDAP search base and search filter.

The {0} variable in the configured filter will be substituted before
applying the filter. By default, it will be substituted by the supplied
username. You can also set a custom LDAP identifier on the relevant
DHIS2 user account. This can be done through the DHIS2 user module user
interface in the add or edit screen by setting the "LDAP identifier"
property. When set, the LDAP identifier will be substituted for the {0}
variable in the filter. This feature is useful when the LDAP common name
is not suitable or cannot for some reason be used as a DHIS2 username.
