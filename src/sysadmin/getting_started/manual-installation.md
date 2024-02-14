# Manual Installation
DHIS2 is has three basic components, 
1. java based web Application running on to of tomcat.
2. PostgreSQL database storing 
3. Proxy, which is the gateway/entry from the outside world.

Manual installation involves setting up theses components manually and integrating there work together, not to mention you'll need some form of monitoring in your infrastructure. 
We strongly discourage manual install because -:
1. Its prone to human errors
2. The end architecture is not standard, everyoone has their own ways of doing things
3. Not adhering to the best security standards
4. Not repeatable
5. Often not documented. 

Please, unless there is a reason not to, use [dhis2-server-tools](https://github.com/dhis2/dhis2-server-tools) to automate you installation. 
