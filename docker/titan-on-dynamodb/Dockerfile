FROM ubuntu:latest

MAINTAINER Brainframe Technologies <docker@brainframe.me>

RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

RUN apt-get install -y unzip curl oracle-java8-installer

RUN curl -o /opt/titan.zip https://s3.amazonaws.com/dynamodb-titan-us-east-1/dynamodb-titan054-storage-backend-1.0.0-hadoop2.zip

RUN unzip /opt/titan.zip -d /opt/ && \
    rm /opt/titan.zip

ADD rexster-dynamodb.xml.template /opt/dynamodb-titan054-storage-backend-1.0.0-hadoop2/
ADD run.sh /opt/dynamodb-titan054-storage-backend-1.0.0-hadoop2/

WORKDIR /opt/dynamodb-titan054-storage-backend-1.0.0-hadoop2

EXPOSE 8182
EXPOSE 8183
EXPOSE 8184

CMD ["/opt/dynamodb-titan054-storage-backend-1.0.0-hadoop2/run.sh"]