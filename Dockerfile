FROM ubuntu:22.04

ARG CRAC_JDK_URL

ENV JAVA_HOME /opt/jdk
ENV PATH $JAVA_HOME/bin:$PATH
ENV CRAC_FILES_DIR /opt/crac-files

ADD $CRAC_JDK_URL $JAVA_HOME/openjdk.tar.gz
RUN tar --extract --file $JAVA_HOME/openjdk.tar.gz --directory "$JAVA_HOME" --strip-components 1; rm $JAVA_HOME/openjdk.tar.gz;
RUN mkdir -p /opt/app
RUN chown root:root $JAVA_HOME/lib/criu
RUN chmod u+s $JAVA_HOME/lib/criu
COPY target/spring-petclinic-3.2.0-SNAPSHOT.jar /opt/app/spring-petclinic-3.2.0-SNAPSHOT.jar
COPY src/scripts/entrypoint.sh /opt/app/entrypoint.sh

ENTRYPOINT /opt/app/entrypoint.sh
