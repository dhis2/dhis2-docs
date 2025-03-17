# File store configuration { #install_file_store_configuration } 

DHIS2 is capable of capturing and storing files. By default, files will
be stored on the local file system of the server which runs DHIS2 in a *files*
directory under the `DHIS2_HOME` external directory location. 

The directory files can be changed via the `filestore.container` property in
the `dhis.conf.` You can also configure DHIS2 to store files on cloud-based
storage providers. AWS S3 or S3 compatible object stores are currently
supported. 

To enable cloud-based storage you must define the following additional properties
in your `dhis.conf` file:

```properties
# File store provider. Currently 'filesystem' (default), 'aws-s3' and 's3' are supported.
filestore.provider = 'aws-s3'

# Directory in external directory on local file system or bucket in AWS S3 or S3 API
filestore.container = files

# The following configuration is applicable to cloud storage only (provider 'aws-s3' or 's3')

# Datacenter location. Optional but recommended for performance reasons.
filestore.location = eu-west-1

# Username / Access key for AWS S3 or S3 APIs
filestore.identity = xxxx

# Password / Secret key for AWS S3 or S3 APIs (sensitive)
filestore.secret = xxxx
```

To enable storage in an S3 compatible object store you must define the following additional properties in your dhis.conf file:

```properties
# File store provider. Currently 'filesystem' (default), 'aws-s3' and 's3' are supported.
filestore.provider = 's3'

# Directory in external directory on local file system or bucket in AWS S3
filestore.container = files

# The following configuration is applicable to cloud storage only (provider 'aws-s3' or 's3')

# URL where the S3 compatible API can be accessed (only for provider 's3')
filestore.endpoint = http://minio:9000 

# Datacenter location. Optional but recommended for performance reasons.
filestore.location = eu-west-1

# Username / Access key for AWS S3 or S3 APIs
filestore.identity = xxxx

# Password / Secret key for AWS S3 or S3 APIs (sensitive)
filestore.secret = xxxx
```

> **Note**
> 
> If you’ve configured cloud storage in `dhis.conf,` all files you upload
> or the files the system generates will use cloud storage.

These configurations are examples and should be changed to fit your needs. For
a production system the initial setup of the file store should be carefully
considered as moving files across storage providers while keeping the integrity
of the database references could be complex. Keep in mind that the contents of
the file store might contain both sensitive and integral information and
protecting access to the folder as well as making sure a backup plan is in
place is recommended on a production implementation.

> **Note**
>
> AWS S3 and S3 compatible object stores are the only supported cloud providers
> but more providers could be added. Let us know if you have a use case for
> additional providers.
> 

