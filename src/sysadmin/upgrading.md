# Upgrading { #upgrading-dhis2 }

## Upgrading vs. Updating { #upgrading-vs-updating }

When we talk about upgrading DHIS2, we generally simply mean "moving to a newer version". However, there is an important distinction between *upgrading* and *updating*.

**Upgrading**
:   Moving to a newer base version of DHIS2 (for example, from 2.34 to 2.36). Upgrading typically requires planning, testing, training (for new features or interfaces), which may take significant time and effort.

**Updating**
:   Moving to a newer patch of the current DHIS2 version (for example, from 2.35.1 to 2.35.4). Updating mainly provides bug fixes without changing the functionality of the software. It is lower risk, and we advise everyone to keep their version up to date.

## Before you begin { #upgrading-before-you-begin }

> **Caution**
>
> It is important to note that once you upgrade you will not be able to use the upgraded database with an older version of DHIS2. That is to say **it is not possible to downgrade**.
>
> If you wish to revert to an older version, you must do so with a copy of the database that was created from that older version, or a previous version. Therefore, it is almost always a good idea to make a copy of your database before you uprgrade.

## Performing the upgrade { #upgrading-process }

Regardless of whether you are upgrading or updating, the technical process is more-or-less identical. We will just refer to it as upgrading.

### 1 Safeguard your data { #upgrading-safeguard-your-data }

Depending on what sort of DHIS2 instance you have, and what you use it for, the first step is to make sure that you can recover any important data if anything goes wrong with the upgrade.

This means performing standard system admin tasks, such as:

1. Backing up your database
2. Testing in a development environment
3. Scheduling down time (to avoid data being entered during the upgrade)
4. etc.

### 2 Upgrade the software { #upgrading-upgrade-the-software }

#### From v2.29 or below { #upgrading-pre-230 }

If you are starting from v2.29 or below, you must first upgrade to v2.30 version-by-version, manually, following the upgrade notes you find under the specific version numbers on [our releases site](https://github.com/dhis2/dhis2-releases). When you are at v2.30 you can go to the next section.

#### From v2.30 or above { #upgrading-post-230 }

If you are starting from at least v2.30:

1. **Read all of the upgrade notes from your current version up to the target version on [our releases site](https://github.com/dhis2/dhis2-releases).** Make sure your environment meets all of the requirements
2. Stop the server
3. Make a final copy of your database (and ensure it is not corrupted)
4. Drop any materialized SQL views from your database
5. Replace the war file with the target version (There is no need to upgrade to intermediate versions; in fact, it is not recommended)
6. Start the server

You should now be ready to enjoy the new fixes and features.
