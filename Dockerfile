# JDK 7
# GlassFish
FROM        java:7-jdk

ENV         JAVA_HOME         /usr/lib/jvm/java-7-openjdk-amd64
ENV         GLASSFISH_HOME    /usr/local/glassfish3
ENV         PATH              $PATH:$JAVA_HOME/bin:$GLASSFISH_HOME/bin

RUN         apt-get update && \
            apt-get install -y curl unzip zip inotify-tools && \
            rm -rf /var/lib/apt/lists/*

RUN         curl -L -o /tmp/glassfish-3.1.2.2.zip http://download.java.net/glassfish/3.1.2.2/release/glassfish-3.1.2.2.zip && \
            unzip /tmp/glassfish-3.1.2.2.zip -d /usr/local && \
            rm -f /tmp/glassfish-3.1.2.2.zip

RUN         echo "AS_JAVA=\"$JAVA_HOME\"" >> \
            /usr/local/glassfish3/glassfish/config/asenv.conf

# Copy the war,ear files to autodeploy directory
COPY        build-artifect/* /usr/local/glassfish3/glassfish/domains/domain1/autodeploy/

# Copy the realm files to autodeploy directory
COPY        realm/* /usr/local/glassfish3/glassfish/lib/

# Copy the resource files to autodeploy directory
COPY        resources/resource.xml /usr/local/glassfish3/glassfish/domains/domain1/config/resource.xml


# Copy the script file to workdir
COPY        asadminCommands.sh /usr/local/glassfish3/

RUN         chmod 777 /usr/local/glassfish3/asadminCommands.sh

EXPOSE      4848 8080 8181

WORKDIR     /usr/local/glassfish3

# Replacing the password for user 'admin' as 'admin'
RUN         echo "admin;{SSHA256}cY8Kee5Epjurpz5t33ndtes9jdSuRnCfbYrRXsXCu92Myl8+OVfgxQ==;asadmin" > \
            /usr/local/glassfish3/glassfish/domains/domain1/config/admin-keyfile

# verbose causes the process to remain in the foreground so that docker can track it
CMD         asadmin start-domain -v

RUN         ./asadminCommands.sh
