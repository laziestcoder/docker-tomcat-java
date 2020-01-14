#FROM tomcat:8.5-centos
#
#ADD ./target/dockerized.war /usr/local/tomcat/webapps/
#
#EXPOSE 8080
#
#CMD ["catalina.sh", "run"]
#
#FROM centos:centos7
#
#RUN yum install -y tomcat tomcat-webapps tomcat-admin-webapps tomcat-javadocs tomcat-docs-webapps
#
##EXPOSE 8080
#
#ENTRYPOINT ["ping"]
#CMD ["google.com"]
#FROM davidcaste/alpine-tomcat:tomcat8
#
#COPY ./target/dockerized.war /opt/tomcat/webapps/
# Centos based container with Java and Tomcat
FROM centos:centos7

# Install prepare infrastructure
RUN yum -y update && \
 yum -y install wget && \
 yum -y install tar

# Prepare environment
ENV JAVA_HOME /usr/java/latest
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts

# Install Oracle Java8
ENV JAVA_VERSION 11.0.5
ENV JAVA_BUILD 11.0.5+10
ENV JAVA_DL_HASH e51269e04165492b90fa15af5b4eb1a5

RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
 https://download.oracle.com/otn-pub/java/jdk/${JAVA_BUILD}/${JAVA_DL_HASH}/jdk-${JAVA_VERSION}_linux-x64_bin.rpm && \
 yum -y localinstall jdk*


# Install Tomcat
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.50

RUN wget http://mirror.linux-ia64.org/apache/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
 tar -xvf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
 rm apache-tomcat*.tar.gz && \
 mv apache-tomcat* ${CATALINA_HOME}

RUN chmod +x ${CATALINA_HOME}/bin/*sh

WORKDIR /opt/tomcat

COPY tomcat-users.xml /opt/tomcat/conf/
COPY context.xml /opt/tomcat/webapps/manager/META-INF/

CMD ["catalina.sh", "start"]

ENTRYPOINT ["ping"]
CMD ["google.com"]