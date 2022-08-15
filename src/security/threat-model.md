# DHIS2 Threat Model

## Introduction

## Threat Agents

A threat agent is an individual or group that is capable of carrying out a particular threat.

- Unauthorized User
- Application User
- Application Administrator
- System Administrator
- DHIS2 App Hub Developer
- DHIS2 Developer
- DHIS2 Build Manager

## User Stories

### DHIS2 Application Login Flow

**Principals**

Users who want to...

- Authenticate
- Change password
- Restore password

**Goals**

- Seamlessly authenticate in the DHIS2 system

**Adversities**

- Brute-force user passwords

**Invariants**

- Password policy is enforced
- Brute-force protection / rate limiting
- MFA is enabled

### DHIS2 Multi-Factor Authentication

**Principals**

Users who want to...

- Enroll MFA
- Disable MFA
- Change MFA

**Goals**

- Seamlessly authenticate in the DHIS2 system

**Adversities**

- Loss of device with a MFA code
- Leak of the MFA secret

**Invariants**

- MFA code is changed with every new enrollment

### Remote Administrator Access

**Principals**

System administrators who want to

- Login via SSH

**Goals**

- Manage remote servers securely

**Adversities**

- Brute-force admin passwords
- MITM

**Invariants**

- Use passwordless authentication
- ?
