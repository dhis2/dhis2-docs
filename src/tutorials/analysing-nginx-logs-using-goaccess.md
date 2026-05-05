---
title: Analysing nginx logs using GoAccess
---
# Analysing nginx logs using GoAccess

**For a busy DHIS 2 instance it is useful to know which URLs are the most frequently requested, what time of the day is most busy and where your users are coming from. GoAccess is a tool that lets you analyse the nginx (or Apache) access logs to gather this type of statistics.**

To install the latest GoAccess version on Ubuntu you can add the official repository and install with apt-get like this:

```
wget -O - https://deb.goaccess.io/gnugpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/goaccess.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/goaccess.gpg] https://deb.goaccess.io/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/goaccess.list
sudo apt-get update
sudo apt-get install goaccess
```
For more information about installing on all operating systems, see https://goaccess.io/download.

To configure GoAccess for nginx (or Apache) you simply need to uncomment a few settings in the GoAccess configuration file:

```
sudo vi /etc/goaccess/goaccess.conf
```

The settings you need to uncomment are these:

```
time-format %T
date-format %d/%b/%Y
log-format %h %^[%d:%t %^] "%r" %s %b "%R" "%u"
```

The nginx access log file typically contains log output for the last 2-4 days, so copying the access.log file from your live Web server and analyzing it on your local machine will give you a good indication of what's going on.

To generate a HTML report based on your nginx access log file, simply invoke GoAccess and redirect the output to a file:

```
goaccess /var/log/nginx/access.log -o report.html --log-format=COMBINED
```

Open report.html in your favorite Web browser. You can now view several types of useful statistics including the most frequently requested URLs, where your users are coming from, most used Web browser and operating system and more.

![](resources/images/goaccess.png)

> **Tip**
>
> Recent versions of GoAccess allow you to append to the results and maintain the history of the access statistics.
>
> For example:
>
> ```
> goaccess /var/log/nginx/access.log -o report.html --log-format=COMBINED --restore --persist --db-path /path/to/goaccess/db/
> ```
