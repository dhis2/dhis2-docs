# How to Backup and Restore DHIS2 (LXD-based Setup)

This guide explains in simple terms how to back up and restore a DHIS2 database
when using LXD containers. Backups are automated using scripts provided by the
[dhis2-server-tools](https://github.com/dhis2/dhis2-server-tools) project.

---

## What You Need to Know

* **Backups protect your data** in case of server crashes or corruption.
* **Restoring** a database inside an LXD container is a bit complex, but the restore script simplifies the process.

---

## Backup Instructions

### 1. Automated Backup Script

The system already includes a script:
**`/usr/local/bin/dhis2-backup`**

It does the following:

* Runs daily backups.
* Stores dumps in `/var/pgbackups`.
* Excludes analytics-related tables.
* Dumps and truncates the `audit` table.
* Supports encrypted backups.

### 2. What It Backs Up

* Regular database tables (excluding analytics)
* Audit table (and truncates it after backup)

### 3. Where the Backups Go

* All backups are saved in:
  `/var/pgbackups/db-backup/`
  `/var/pgbackups/audit-backup/`

* Encrypted backups (optional) are stored similarly.

### 4. How It Works (Simplified)

* Settings are loaded from:
  `/usr/local/etc/dhis/dhis2-env`
* For each database, it:

  1. Dumps audit table.
  2. Truncates audit table.
  3. Dumps main database (excluding analytics).
  4. Optionally encrypts the dump.

---

## Restore Instructions

### 1. Restore Script

Use this script:
**`/usr/local/bin/dhis2-restoredb`**

You need:

* A `.sql.gz` file (your backup)
* The name of the database

### 2. What the Script Does

* Drops the old database (inside LXD container)
* Recreates the database with correct owner
* Restores the dump, ignoring ownership issues
* Reassigns any remaining `root`-owned objects

### 3. How to Run It

```bash
sudo /usr/local/bin/dhis2-restoredb /var/pgbackups/db-backup/mybackup.sql.gz dhis2
```

Make sure:

* PostgreSQL is running inside an LXD container named `postgres`
* The DB user matches the DB name (usually true in DHIS2)

### Sample Restore Logic

```bash
sudo lxc exec postgres dropdb dhis2
sudo lxc exec postgres -- createdb -O dhis2 dhis2
zcat mybackup.sql.gz | grep -v 'ALTER .* OWNER' | sudo lxc exec postgres -- psql dhis2
echo "REASSIGN OWNED BY root TO dhis2" | sudo lxc exec postgres -- psql dhis2
```

---

## Best Practices

* Use dedicated PostgreSQL users for backups.
* Encrypt sensitive backups.
* Protect backup folders: `chmod 750` on dirs, `chmod 600` on files.

---

## Summary

DHIS2 deployments using `dhis2-server-tools` come pre-configured with backup and restore scripts:

* Backups happen **daily**, automatically.
* Backups are saved to `/var/pgbackups`.
* Restore is done using a script that handles permissions and ownership inside LXD.

These tools make PostgreSQL backup and restore reliable and simple, even in complex LXD environments.

