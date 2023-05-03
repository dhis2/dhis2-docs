# Adding a custom DB language { #custom-db-language }

The UI and DB localisations are handled independently in DHIS2.

For the UI we have a hardcoded set of languages. The community can contribute improvements to specific languages in the Transifex platform.

For the DB the situation is a bit different. There are a few default locales, but you can easily add your own. There are some limitations to what you can add, but you can also get around that.
You can add your own DB locale by going to **Maintenance**-> **Locales** (you'll need to be a superuser). The limitation is that you must give a language and a country, and the name will be 
auto-generated, but there is a workaround you can use to change it to whatever you like, which I will explain below. 

## Workaround to customise the name and code of a locale { #customise-locale-code }

> **Note**
>
> This requires running SQL directly on the database.

Let's say you want to create a language `ku` and want it to be displayed as `Kurdish Sorani`. It is not possible to create this directly through the Maintenance App, so:

1. Create a DB locale. It doesn't matter what it is called, or even what language, as only the id of the locale will be used by the system. In fact, you can even use an existing language that is not currently in use. 

2. Modify the locale from step 1. I'm going to give the example that I didn't create a new one, and instead want to replace the "Norwegian" locale.

    a.  First I want to get the id of my chosen locale:
        
    ```
    select * from i18nLocale where locale = 'no';
     i18nlocaleid |     uid     | code |         created         |       lastupdated       | locale |   name    | lastupdatedby 
    --------------+-------------+------+-------------------------+-------------------------+--------+-----------+---------------
            52296 | oBMTTQceViV |      | 2013-11-18 13:00:43.837 | 2013-11-18 13:00:43.837 | no     | Norwegian |              
    (1 row)
    
    ``` 
    now I have the id = `oBMTTQceViV`
    
    b.  Now I can change that locale to the one I want:

    ```
    UPDATE i18nLocale SET locale = 'ku' WHERE i18nLocale.uid = 'oBMTTQceViV';
    UPDATE i18nLocale SET name = 'Kurdish Sorani' WHERE i18nLocale.uid = 'oBMTTQceViV';
    
    ```
    note that I used the id I got previously in 2a.

Now I have a locale called `ku` which will be visible as `Kurdish Sorani` in the DB locale selection in DHIS2.
