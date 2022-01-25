# DHIS2 and R integration { #rsetup } 

## Introduction { #rsetup_intro } 

R is freely available, open source statistical computing environment. R
refers to both the computer programming language, as well as the
software which can be used to create and run R scripts. There are
[numerous sources on the web](http://cran.r-project.org/) which describe
the extensive set of features of R.

R is a natural extension to DHIS2, as it provides powerful statistical
routines, data manipulation functions, and visualization tools. This
chapter will describe how to setup R and DHIS2 on the same server, and
will provide a simple example of how to retrieve data from the DHIS2
database into an R data frame and perform some basic calculations.

## Installing R { #rsetup_install } 

If you are installing R on the same server as DHIS, you should consider
using the Comprehensive R Archive Network (CRAN) to get the latest
distribution of R. All you need to do is to add the following like to
you `/etc/apt/source.list` file.

**deb \<your R mirror\>/bin/linux/ubuntu \<your Ubuntu distribution\>**

You will need to replace **\<your R mirror\>** with one from the list
available [here.](http://cran.r-project.org/mirrors.html) You will also
need to replace **\<your Ubuntu distribution\>** with the name of the
distribution you are using.

Once you have done this, invoke the following commands

    sudo apt-get update
    gpg --keyserver pgp.mit.edu --recv-keys 51716619E084DAB9
    gpg --armor --export 51716619E084DAB9 | apt-key add -
    sudo apt-get install r-base

At this point, you should have a functional R installation on your
machine.

Next, lets see if everything is working by simply invoking `R` from
the command line.

```R
R version 3.4.4 (2018-03-15) -- "Someone to Lean On"
Copyright (C) 2018 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

>
```

## Using PL/R with DHIS2 { #rsetup_plr }

The procedural language for R is an extension to the core of PostgreSQL
which allows data to be passed from the database to R, where
calculations in R can be performed. The data can then be passed back to
the database for further processing.. In this example, we will create a
function to calculate some summary statistics which do not exist by
default in SQL by using R. We will then create an SQL View in DHIS2 to
display the results. The advantage of utilizing R in this context is
that we do not need to write any significant amount of code to return
these summary statistics, but simply utilize the built-in functions of R
to do the work for us.

First, you will need to install [PL/R](http://www.joeconway.com/plr/),
which is described in detail
[here.](http://www.joeconway.com/plr/doc/plr-install.html). Following
the example from the PL/R site, we will create some custom aggregate
functions as detailed
[here.](http://www.joeconway.com/plr/doc/plr-aggregate-funcs.html) We
will create two functions, to return the median and the skewness of a
range of values.

```sql
    CREATE OR REPLACE FUNCTION r_median(_float8) returns float as '
      median(arg1)
    ' language 'plr';

    CREATE AGGREGATE median (
      sfunc = plr_array_accum,
      basetype = float8,
      stype = _float8,
      finalfunc = r_median
    );

    CREATE OR REPLACE FUNCTION r_skewness(_float8) returns float as '
      require(e1071)
      skewness(arg1)
    ' language 'plr';

    CREATE AGGREGATE skewness (
      sfunc = plr_array_accum,
      basetype = float8,
      stype = _float8,
      finalfunc = r_skewness
    );
```

Next, we will define an SQL query which will be used to retrieve the two
new aggregate functions (median and skewness) which will be calculated
using R. In this case, we will just get a single indicator from the data
mart at the district level and calculate the summary values based on the
name of the district which the values belong to. This query is very
specific, but could be easily adapted to your own database.

```sql
    SELECT  ou.shortname,avg(dv.value),
    median(dv.value),skewness(dv.value) FROM aggregatedindicatorvalue dv
    INNER JOIN period p on p.periodid = dv.periodid
    INNER JOIN organisationunit ou on
    dv.organisationunitid = ou.organisationunitid
    WHERE dv.indicatorid = 112670
    AND dv.level = 3
    AND dv.periodtypeid = 3
    AND p.startdate >='2009-01-01'
    GROUP BY ou.shortname;
```

We can then save this query in the form of SQL View in DHIS2. A clipped
version of the results are shown below.

![plr_results](resources/images/r/r_plr.PNG)

In this simple example, we have shown how to use PL/R with the DHIS2
database and web interface to display some summary statistics using R to
perform the calculations.

## Using this DHIS2 Web API with R { #rsetup_web_api }

DHIS2 has a powerful web API which can be easily accessed using R.  In this section, we will illustrate a few examples of
the use of the DHIS2 metadata and analytics API with R. The web API uses basic HTTP authentication (as described in
the Web API section of this document). Using two R packages "RCurl" and
"XML", we will be able to work with the output of the API in R. In the
first example, we will get some metadata from the database.

```R
#We are going to need these two libraries
require(httr)
require(magrittr)
require(readr)
base.url<-"https://play.dhis2.org/dev/"
url<-paste0(base.url,"api/me")
username<-"admin"
password<-"district"
login<-GET(url)
#If we cannot login, stop with an error
if(r$status == 200L) { print("Logged in successfully!")} else {stop("Could not login")}
}



mydata<-paste0(base.url,"api/reportTables/KJFbpIymTAo/data.csv") %>% #Define the API endpoint
    GET(.,authenticate(username,password)) %>% #Make the HTTP call
    content(.,"text") %>% #Read the response
    readr::read_csv() #Parse the CSV
head(mydata)
```

In this example, we are simply retrieving a report table which has been created in DHIS2 through the API, and parsing the CSV response into an R data frame.

In the next code example, we will retrieve some metadata, namely a list
of data elements and their unique identifiers.

```R

#Get the list of data elements. Turn off paging and only get a few attributes.
require(httr)
username<-"admin"
password<-"district"
base.url<-"https://play.dhis2.org/dev/"

login<-function(username,password,base.url) {
url<-paste0(base.url,"api/me")
r<-GET(url,authenticate(username,password))
if(r$status == 200L) { print("Logged in successfully!")} else {stop("Could not login")}
}

getDataElements<-function(base.url) {

url<-paste0(base.url,"api/dataElements?fields=id,name,shortName")
r<-content(GET(url,authenticate(username,password)),as="parsed")
do.call(rbind.data.frame,r$dataElements)
}

login(username,password,base.url)
data_elements<-getDataElements(base.url)
head(data_elements)
```

The object `data_elements` should now contain a data frame of all data elements in the system. 

```
                                         name          id
2   Accute Flaccid Paralysis (Deaths < 5 yrs) FTRrcoaog83
210   Acute Flaccid Paralysis (AFP) follow-up P3jJH5Tu5VC
3           Acute Flaccid Paralysis (AFP) new FQ2o8UBlcrS
4     Acute Flaccid Paralysis (AFP) referrals M62VHgYT2n0
5        Additional notes related to facility uF1DLnZNlWe
6                              Admission Date eMyVanycQSC
```

## Using this DHIS2 Web API with datimutils { #r_datimutils }

The [`datimutils`](https://github.com/pepfar-datim/datimutils) package is an open-source library developed by [ PEPFAR ](https://pepfar.gov), which provides a range of useful utility functions for interacting with the DHIS2 API. Although the package was developed specifically to interact with DATIM (the PEPFAR DHIS2 instance. ) We will not attempt to replicate the documentation of the package itself, but rather present a few practical examples of how to work with the library.

 Authentication with DHIS2 is handled via a special object `d2_default_session`. The name and parent environment of this object can be changed if needed. Consult the package documentation for details.

 ```R
 loginToDATIM(username = "admin",password = "district",base_url = "https://play.dhis2.org/dev/")
 ```

 We should now have an object called `d2_default_session` in our R environment. Subsequent API calls can use this object to handle authentication, and thus there is no need to specify explicitly the username and password with each function call.

 `datimutils` provides a function for most metadata API endpoints, and have been designed to seamlessly work with  `tidyverse` packages. As an example, we can get a specific metadata object with the following command:

 ```R
datimutils::getDataElements("hCVSHjcml9g",fields = "name,shortName,id")
                                      name          shortName          id
1 Albendazole given at ANC (2nd trimester) Albendazole at ANC hCVSHjcml9g
 ```

 `datimutils` commands also work with lists to retrieve multiple metadata objects.

 ```R
> de_groups<-c("oDkJh5Ddh7d","zmWJAEjfv59")
> datimutils::getDataElementGroups(de_groups,fields = "name,shortName,id")
                            name                      shortName          id
1 Acute Flaccid Paralysis (AFP)  Acute Flaccid Paralysis (AFP)  oDkJh5Ddh7d
2                           Yaws                           Yaws zmWJAEjfv59
 ```

 `datimutils` commands are pipeable, and thus can be chained together with other `tidyverse` commands.

 ```R

 > datimutils::getMetadata("dataElementGroups", fields = "id,name,shortName")
 %>%  dplyr::filter(grepl("ART",`shortName`))
 %>%  dplyr::select(name)

                     name
1                     ART
2          ART enrollment
3        ART entry points
4  ART pediatric 1st line
5             ART staging
6           ART treatment
7              New on ART
8       Prev month on ART
9     Shift from ART reg.
10      Shift to ART reg.

```

For more information on the `datimutils` package, please consult the package documentation. 

## Using R for statistical data analysis of bigger datasets { #r_biggish_data }

In this example we will show how data can be extracted from the DHIS2 event and enrollment analytics tables
using R. Similar results could be obtained using alternatives such as Python/Pandas.

In this example, a synthetic dataset of COVID19 vaccinations
 consisting of around 8 million enrollments, and around 16
million events was used. Data was extracted from the DHIS2 database into a set of "flat" CSV files.
In order to protect the identity of individuals, sensitive information such as names
and dates of birth were not present in the dataset. DHIS2 system identifiers (UIDs) were
also hashed in order to obscure direct lookups in the system. While beyond the scope
of this tutorial, personally identifiable information contained in tracker databases
should in general never be shared outside of the actual DHIS2 database.

Let us assume we have been tasked with answering the following questions:

- What percentage of persons have received at least a second dose of a COVID-19 vaccination?
- How many persons are eligible for a second COVID-19 vaccination but have not yet received one?
- Is there a statistically significant relationship between a persons sex and their vaccination status?

In this scenario a set of CSV files was extracted from the DHIS2 database using the following commands.

The first file contains a listing of all COVID-19 vaccination events in the database.

```sql
\copy ( SELECT ou, MD5(tei) as tei, executiondate::date, "LUIsbsm3okG" FROM analytics_event_yduazyqyabs WHERE "LUIsbsm3okG" IS NOT NULL) TO '/tmp/vaccinations.csv' CSV HEADER;
```

Take note, that the UID of each tracked entity instance has been hashed in the output to the CSV file.

We need to join this data with registration information, namely the age and sex of the person receiving the vaccination.

```sql
\copy ( SELECT MD5(tei) as tei, extract('years' from age("NI0QRzJvQ0k")) as age, "oindugucx72" as sex from analytics_enrollment_yduazyqyabs ) TO '/tmp/enrollments.csv' CSV HEADER;
```

Note again, we have hashed the UID of the tracked entity instance, as well as providing only the age of the individual instead of their exact date of birth.

Once we have received the flat files, we can begin to work up the data. First, we will read it from the CSV files, and reshape it into a better format.
Each of the vaccination events is represented with a value of "DOSE1", "DOSE2", etc. The data has been received in "long" format, with each
event corresponding to a single vaccination event. A sample of the data is shown below.


|ou          |tei                              |executiondate |LUIsbsm3okG |
|:-----------|:--------------------------------|:-------------|:-----------|
|qnPtFByMbjW |0e12fe16f0d6636e7943360b6d387bae |2021-04-03    |DOSE1       |
|qnPtFByMbjW |0e12fe16f0d6636e7943360b6d387bae |2021-04-24    |DOSE2       |
|y6A2a9CuBiv |07e20dd2312ca01c0566afff78a3e03d |2021-09-15    |DOSE1       |
|y6A2a9CuBiv |07e20dd2312ca01c0566afff78a3e03d |2021-10-06    |DOSE2       |
|zmMOrhA3mGg |3eb0671bb787d964ef44b3272affe9f7 |2021-04-11    |DOSE1       |
|zmMOrhA3mGg |3eb0671bb787d964ef44b3272affe9f7 |2021-05-02    |DOSE2       |

We can reshape the data into "wide" format, by placing the doses along the columns.

```r
doses_wide <- doses %>%  dplyr::group_by(ou,tei) %>%
  tidyr::pivot_wider(names_from="LUIsbsm3okG",values_from = executiondate)
```

The data now looks like this, with the doses along the columns and each
tracked entity instance along the rows.

|ou          |tei                              |DOSE1      |DOSE2      |DOSE3 |
|:-----------|:--------------------------------|:----------|:----------|:-----|
|qnPtFByMbjW |0e12fe16f0d6636e7943360b6d387bae |2021-04-03 |2021-04-24 |NA    |
|y6A2a9CuBiv |07e20dd2312ca01c0566afff78a3e03d |2021-09-15 |2021-10-06 |NA    |
|zmMOrhA3mGg |3eb0671bb787d964ef44b3272affe9f7 |2021-04-11 |2021-05-02 |NA    |
|cpwNidcP1Cs |f60a9cf66ba1a23a71c3de2f09fec61c |2021-08-12 |2021-09-02 |NA    |
|G6ytwH1lyBF |614f2d50c1fa7a72d76fc92e735f6dc1 |2021-06-06 |2021-06-27 |NA    |
|hxCmCH2cXmB |bd4aa559032351ce2461cb0b317b7448 |2021-08-17 |2021-09-07 |NA    |

We can begin to calculate what are essentially program indicators in DHIS2. Program
indicators are not stored directly in the analytics tables from which the data
was extracted, but are rather calculated at run time when requesting the data from DHIS2.
We can calculate the total number of doses received by testing for the presence of
a date in the "DOSE" column. If the value is present, the individual received a dose, otherwise
if the value is blank (NA) they did not receive a dose.

```r
doses_wide <- doses_wide  %>%
  dplyr::mutate(total_doses = ifelse(is.na(DOSE1), 0, 1) + ifelse(is.na(DOSE2), 0, 1) + ifelse(is.na(DOSE3), 0, 1)) %>%
  #Join with the enrollments
  dplyr::inner_join(enrollments, by = "tei")
```
We also joined the data with the enrollments, which contains information on the age and sex of each individual.

We can calculate another derived indicator to indicate if the individual is eligible for a second dose. In this
example, we determine this to be if they have received a first dose at least 12 weeks ago.

```r
doses_wide$is_eligible <-
  doses_wide$total_doses == 1 &
  difftime(Sys.time(), doses_wide$DOSE1, units = "weeks") > 12
```

It's now pretty easy to determine how many individuals are eligible for a second COVID vaccination.

```r
> sum(doses_wide$is_eligible,na.rm=TRUE)
[1] 596279
```

We can perform a standard t-test on the data to see if there is a statistically significant
relationship between an individuals sex and their eligibility for a vaccine.

```
t.test(doses_wide$is_eligible ~ doses_wide$sex)

Two Sample t-test

data:  doses_wide$is_eligible by doses_wide$sex
t = 256.26, df = 8094913, p-value < 2.2e-16
alternative hypothesis: true difference in means between group FEMALE and group MALE is not equal to 0
95 percent confidence interval:
  0.04650774 0.04722462
sample estimates:
  mean in group FEMALE   mean in group MALE
0.09711178           0.05024560
```

Since the p-value is extremely low in this case, we can reject the null hypothesis, and say with a high
degree of certainty that a statistically significant relationship exists between vaccine eligibility
and an individuals sex.

As a final example, we can output a summary table, which shows the percentage of individuals who have received
at least two doses broken down by by age and sex. We can create age bands and use these 
to classify individuals.

```r

agebreaks <- c(0,1,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,500)
agelabels <- c("0-1","1-4","5-9","10-14","15-19","20-24","25-29","30-34",
               "35-39","40-44","45-49","50-54","55-59","60-64","65-69",
               "70-74","75-79","80-84","85+")
doses_wide$age_grouping <- cut(doses_wide$age, breaks = agebreaks,
                                      right = FALSE, labels=agelabels)



vaccination_status_table <- doses_wide %>%
  dplyr::ungroup() %>%
  dplyr::group_by(sex,age_grouping) %>%
  dplyr:::summarise(has_two = sum(total_doses > 1)/dplyr::n()*100) %>%
  tidyr::pivot_wider(names_from = sex,values_from = has_two) %>%
  tidyr::drop_na()
```

Which provides the following table.

|Age range    | FEMALE|  MALE|
|:------------|------:|-----:|
|0-1          |   53.0|  53.4|
|1-4          |   52.9|  53.0|
|5-9          |   54.2|  54.4|
|15-19        |  100.0| 100.0|
|20-24        |   86.0|  91.6|
|25-29        |   85.2|  91.2|
|30-34        |  100.0| 100.0|
|35-39        |   90.1|  96.5|
|40-44        |   85.7|  91.4|
|45-49        |  100.0| 100.0|
|50-54        |  100.0| 100.0|
|55-59        |   95.8|  98.7|
|60-64        |  100.0| 100.0|
|65-69        |  100.0| 100.0|
|70-74        |  100.0| 100.0|
|75-79        |   76.6|  94.4|
|80-84        |   91.8|  97.7|

In this example, we have demonstrated how to extract data from the DHIS2 event analytics tables
and process it in an R environment. This approach may be suited to situations where the data sets
are large or certain analyses (such as statistical summaries or tests) are not possible
in the native DHIS2 analysis apps. Creation of highly formatted statistical tables suitable
for publication could also be a requirement.

Special attention was provided during the data extraction
phase to ensure that only the required data was provided which was actually necessary
to perform the analysis. Data analysts and database administrators should carefully
consider how to extract data from the DHIS2 database, and protect any personally identifiable
information (PII).