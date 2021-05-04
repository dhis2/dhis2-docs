---
title: Setting up email on a server
---
# Setting up email on a server

It is easy enough to setup with either postfix or exim4 to send mail directly from the host. However, the most important thing is to have your networking properly setup, in other words you must have a fully qualified domain name and make sure that host name and /etc/hosts is correct. If you don't have this, you need to take a different approach by relaying to some other smart host. If your host name is properly set, the process of setting up outgoing mail is straightforward enough. I'll outline the procedure for exim4: install exim4 with

```
sudo apt-get install exim4
```
Then configure with:
```
sudo dpkg-reconfigure exim4-config
```
Then working through the screens:

1.  Select the option for "internet site; mail is sent directly through smtp"
2.  The system mail name should be your fqdn (eg. dhis2.somewhere.org)
3.  Make sure smtp listener only listens on localhost (127.0.0.1 ; ::1) . This is really important. On no account do you want to open up the listener to listen to the outside world unless you are prepared to find yourself in a battle fighting the world's spammers.
4.  Leave "other destinations for which mail is accepted" blank
5.  Leave "domains to relay for" blank
6.  Leave "machines to relay for" blank

Just accept defaults for everything else. Try sending yourself a mail by typing: `mail me@someplace.com` using your own email address of course. Finish the mail by just typing a dot on a line on its own. Beware the mail may well be sent but end up in your spam. Check `sudo tail /var/log/exim4/mainlog` to see what happened. What you will probably want to do next is to make sure that any system alerts are sent to the people who should be seeing them. The easiest way to set this up is through the /etc/aliases file. The following is an example of /etc/aliases to guide you through:


```
# /etc/aliases
mailer-daemon: postmaster
postmaster: root
nobody: root
hostmaster: root
usenet: root
news: root
webmaster: root
www: root
ftp: root
abuse: root
noc: root
security: root
root: admins
monit: admins
dhiis: admins
admins: bobj@somewhere.net,peterg@somewhere.com
```

Basically "admins" is an alias for the email addresses for the two admins. All mail destined for root as well as the dhis user is redirected to admins. If you edit the aliases file you need to put it into effect by running `sudo newaliases`. You can also configure DHIS 2 to use the local mailer by setting the mail host to "localhost" and the port to "25" in the email settings screen of DHIS 2.
