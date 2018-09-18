# Development Infrastructure

<!--DHIS2-SECTION-ID:dev_infrastructure-->

## Release process

<!--DHIS2-SECTION-ID:dev_inf_release_process-->

Checklist for release.

1.  In order to tag the source source code with new release. First
    temporarily add a dependency to dhis-web in the root pom.xml:
    
        <module>dhis-web</module>
    
    Use the mvn version plugin with:
    
        mvn versions:set
        mvn versions:commit
    
    This will prompt you to enter the version. Include pom-full.xml.
    Remove the dhis-web dependency. Update application cache manifests
    in the various apps to new version. Commit and push the changes to
    master.

2.  Create a stable release branch off master, e.g. with:
    
        git branch 2.25

3.  Push a release branch to Github, e.g. with:
    
        git checkout 2.25
        git push --set-upstream origin 2.25

4.  Tag source code with SNAPSHOT release. Include pom-full.xml.
    Remember to add the temporary dhis-web dependency in the root
    pom.xml. Commit and push the changes to master.

5.  Create Jenkins build for the release WAR file. Include automatic
    copy job to www.dhis2.org. Include automatic WAR update of
    play.dhis2.org/demo (add release directory on server).

6.  Create Jenkins build for the release Javadocs.

7.  Update the database and WAR file on play.dhis2.org/demo and
    play.dhis2.org/dev instances. To create a dump in directory format
    and turn it into a tar file:
    
        pg_dump dhis2 -Fd -U dhis -j 4 -f db.pgdump
        tar zcvf db.tar.gz db.pgdump
    
    To unpack the tar file:
    
        tar zxvf db.tar.gz
    
    Run the reinit-db-instance script to make the database take effect.

8.  Create a new DHIS2 Live package on www.dhis2.org and place it in
    download/live directory. Only the WAR file must be updated. An
    uncompressed Live package is located on the demo server at:
    
        /home/dhis/dhis-live-package
    
    Replace the uncompressed WAR file with the new release. Make a
    compressed Live archive and move to /download/live directory.

9.  Upload sample database to www.dhis2.org and place it in
    download/resources directory.

10. Update the version info on the play server home page at
    https://play.dhis2.org/. The index file is found on the play server
    at:
    
        /usr/share/nginx/html/index.html

11. Update download page at www.dhis2.org/downloads with links to new
    Live package, WAR file, source code branch page and sample data
    including version.

12. Create a documentation branch and update documentation page at
    www.dhis2.org/documentation with links to documentation and
    Javadocs.

13. Add stable WAR file download link in nginx.conf on dhis2.org.

14. Write and send release email.

