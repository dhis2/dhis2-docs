# DHIS2 Frequently Asked Questions

**Q:** I have entered data into a data entry form, but I cannot see the
data in any reports (pivot tables, charts, maps). Why does data which is
entered not show up immediately in my graphs in DHIS2?

**A:** Data which is entered into DHIS2 must first be processed with the
"analytics". This means that data is not immediately available in the
analytics resources (such as reports, pivot tables, data visualizer,
GIS, etc.) after it has been entered. If scheduling is active, the
analytics process will run automatically at midnight each day. After
that, new data which was entered since the last time the analytics
process ran, will become visible.

You can trigger the analytics process manually by selecting
Reports-\>Analytics from the main menu and pressing the "Start export"
button. Note, the process may take a significant amount of time
depending on the amount of data in your database.

Other factors which can affect the visibility of data are:

  - Data approval: If data has not been approved to a level which
    corresponds to your users level, the data may not be visible to you.

  - Sharing of meta-data objects: If certain meta-data objects have not
    been shared with a user group which you are a member of, the data
    may not be visible to you.

  - Caching of analytics: In many cases, server administrators cache
    analytical objects (such as pivot tables, maps, graphs) on the
    server. If you have entered data, re-run analytics, and you are
    still not seeing any (updated) data, be sure that your data is not
    being cached by the server.

**Q:** I have downloaded DHIS2 from <https://www.dhis2.org/downloads>
but when i try to enter the system it needs a username and password.
Which should I use?

**A:** By default, the username will be "admin" and the password
"district". Usernames and passwords are case sensitive.

**Q:** I added a new dimension to the system, but I get errors when using it in analytics through the Data Visualizer or Line Listing app. The API returns HTTP 409 Conflict.

**A:** When new dimensions are added to the system, a FULL analytics export is required (for all years preferable). Otherwise, the new dimensions won't be available to the analytics APIs.
