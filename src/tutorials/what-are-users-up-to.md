---
title: What are users up to?
---
# What are users up to?

**Sometimes you want to know which users are active on your system. Here are two simple scripts which might prove useful.**

Who has been logging in?

This a simple bash one liner to get a listing of who has logged in when, discounting multiple logins in one day. It gets this information from the log file. If you rotate the logfile monthly (the default with dhis2-tools for example) you can easily create monthly reports.

```
cat /var/lib/dhis2/dhis/logs/catalina.out |grep 'Login success' |cut -f 4,10 -d ' '|sort |uniq
```

or operating on a rotated gzipped file

```
zcat /var/lib/dhis2/dhis/logs/catalina.out-20141101.gz |grep 'Login success' |cut -f 4,10 -d ' '|sort |uniq
```

Who has been entering data? This one is a simple query to the database. You could make it fancier by grouping by district or the like:

```
psql -c "select startdate,storedby,count(*) dvs from datavalue join period on datavalue.periodid = period.periodid where lastupdated > '2014-08-31' group by startdate, storedby order by startdate" dhis
```
