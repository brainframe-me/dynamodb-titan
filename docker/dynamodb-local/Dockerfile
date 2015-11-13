FROM ubuntu:latest

MAINTAINER Brainframe Technologies <docker@brainframe.me>

RUN apt-get update && \
    apt-get -y upgrade

RUN apt-get install -y zip wget default-jdk

WORKDIR /opt/

RUN wget -O /opt/dynamodb-local.zip http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.zip

RUN unzip /opt/dynamodb-local.zip -d /opt/dynamodb-local/ && \
    rm /opt/dynamodb-local.zip

WORKDIR /opt/dynamodb-local/

COPY ./run.sh /opt/dynamodb-local/

EXPOSE 8000

ENTRYPOINT ["/opt/dynamodb-local/run.sh"]