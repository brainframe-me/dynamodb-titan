# Dockers for TITAN Graph database with AWS DynamoDB or DynamoDB-local as storage backend
This repository contains two docker images allowing you to get up and running with TITAN 0.54 - Distributed Graph Database - 
with DynamoDB as a storage backend in no time with three different deployment methods:

# DEPLOYMENT OPTIONS

1. [Run dockers for Titan and DynamoDB only locally](#DEPLOYMENT1)
2. [Run docker for Titan locally and use AWS DynamoDB in the cloud](#DEPLOYMENT2)
3. [Run docker for Titan on AWS EC2 Container Services (ECS) and use AWS DynamoDB in the cloud](#DEPLOYMENT3)

# GETTING STARTED

<a name="ALLINONE"/>

## 1. ALL IN ONE

Read this part only if you want to try local deployments 1 or 2. 
I recommend getting started with the included vagrant configuration which automatically installs the docker environment as a virtual machine.
This will automatically start both dynamodb-local and titan-on-dynamodb dockers inside a local virtual machine resulting in a working 
version of Deployment 1 which you can immediately start use without diving into any of the details explained below.

A simple "vagrant up" in the root of this project does all the work for you resulting in an up and running deployment 1. 
You only need to make sure you do following parts in advance in order for vagrant part to work:

- Install vagrant - https://www.vagrantup.com/downloads.html

- Install virtualbox - https://www.virtualbox.org/wiki/Downloads

- Reboot your machine

After having issued "vagrant up", the two dockers need to be downloaded and initialized (+-2GB), and this will take a while depending on your
internet connection. Count on 2 - 5 minutes, after which you should be able to access your new local empty Titan graph server:

- (via browser) http://localhost:8182/graphs

- (linux) "curl http://localhost:8182/graphs"

## 2. TEST WITH PYTHON

There are two files included in this project to test the deployments. To use these, ensure you have python 3 installed, 
and the required pip packages ("pip install boto bulbsflow"). 
Use virtual-environments by preference not to mess up your running configuration.

- dynamo-local-test.py - simple test which will check if the dynamodb-local is actually up and running

- titan-test.py - which will check if you can connect with the Titan DB, this script also includes some example code using bulbsflow allowing you to do some first tests

# CONNECTING TO VAGRANT VIA SSH

After doing a "vagrant up" you should have a fully working ubuntu instance up and running, which has the docker environment installed.
In case you want to modify and or build your own docker for internal usage based on this code, you will need to log into this vagrant host via for example putty.
To do this you need to do the following:

- Download putty.exe (http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)

- 1 minute after "vagrant up" you should be able to connect to your virtual machine

- Start putty.exe with the following configuration:

> - hostname: 127.0.0.1, port: 2222

> - now click "open" which should log you into your local vagrant (username & password = 'vagrant')
 
<a name="DEPLOYMENT1"/>

# DETAILS DEPLOYMENT 1 
Runs dockers for Titan and DynamoDB only locally.

Before you try this, make sure you tried out the [all in one](#ALLINONE) which does all for you via vagrant as explained above.

## 1. BUILD your own docker

- (in root directory via cmd) "vagrant provision" syncs your local project changes to vagrant /local/ folder (for faster builds)

### 1.1 dynamodb-local

- (in vagrant vm via ssh) "cd /local/docker/dynamodb-local" where the Dockerfile is located

- (in vagrant vm via ssh) "docker build -t yourusername/dynamodb-local ."  which will rebuild the complete docker locally

### 1.2 titan-on-dynamodb

- (in vagrant vm via ssh) "cd /local/docker/titan-on-dynamodb" where the Dockerfile is located

- (in vagrant vm via ssh) "docker build -t yourusername/titan-on-dynamodb ."  which will rebuild the complete docker locally


## 2. RUN DOCKER MANUALLY

### 2.1 dynamodb-local

- (in vagrant vm via ssh) "docker run -t --name dynamodb-local -p 8000:8000 brainframe/dynamodb-local"

### 2.2 titan-on-dynamodb

- (in vagrant vm via ssh) "docker run -t --name titan-on-dynamodb --link dynamodb-local:dynamodb-local -p 8182:8182  -p 8183:8183 -p 8184:8184 
       -e DYNAMODB_HOSTPORT=http://dynamodb-local:8000 
       -e AWS_ACCESS_KEY_ID=notcheckedlocallybutmustbeprovided 
       -e AWS_SECRET_ACCESS_KEY=notcheckedlocallybutmustbeprovided 
       -e GRAPH_NAME=yourdatabasename 
       brainframe/titan-on-dynamodb"
       
## 3. RUN DOCKER (with bash for debugging)

### 3.1 dynamodb-local

- (in vagrant vm via ssh) "docker run -ti --entrypoint /bin/bash --name dynamodb-local -p 8000:8000 brainframe/dynamodb-local"

### 3.2 titan-on-dynamodb

- (in vagrant vm via ssh) "docker run -ti --entrypoint /bin/bash --name titan-on-dynamodb --link dynamodb-local:dynamodb-local -p 8182:8182  -p 8183:8183 -p 8184:8184 
       -e DYNAMODB_HOSTPORT=http://dynamodb-local:8000 
       -e AWS_ACCESS_KEY_ID=notcheckedlocallybutmustbeprovided 
       -e AWS_SECRET_ACCESS_KEY=notcheckedlocallybutmustbeprovided 
       -e GRAPH_NAME=yourdatabasename 
       brainframe/titan-on-dynamodb"

<a name="DEPLOYMENT2"/>

# DETAILS DEPLOYMENT 2
Runs docker for Titan locally and uses AWS DynamoDB in the cloud.

## 1. PREPARE AWS

- To access AWS DynamoDB create a new user with the policy "AmazonDynamoDBFullAccess" via AWS IAM on Amazon AWS console. 
(this will allow the titan-on-dynamodb docker to create the required structure inside dynamodb)
  
- Then also add an access key for that user under "security credentials" which you use for the AWS_ACCESS_KEY_ID and
AWS_SECRET_ACCESS_KEY in the scripts below. In the docker command we replaced these keys with XXX and YYY respectively.
 
## 2. RUN DOCKER MANUALLY

### 2.1 dynamodb-local

- Not needed, since we will use AWS DynamoDB to connect to from titan-on-dynamodb

### 2.2 titan-on-dynamodb

- Depending on the region your AWS DynamoDB is in, update the DYNAMODB_HOSTPORT. The example connects to eu-west-1.

- (in vagrant vm via ssh) "docker run -t --name titan-on-dynamodb -p 8182:8182  -p 8183:8183 -p 8184:8184
       -e DYNAMODB_HOSTPORT=https://dynamodb.eu-west-1.amazonaws.com 
       -e AWS_ACCESS_KEY_ID=XXX
       -e AWS_SECRET_ACCESS_KEY=YYY
       -e GRAPH_NAME=yourdatabasename
       brainframe/titan-on-dynamodb"

## 2. RUN DOCKER MANUALLY  (with bash for debugging)

### 2.1 dynamodb-local

- Non needed, since we will use AWS DynamoDB to connect to from titan-on-dynamodb

### 2.2 titan-on-dynamodb

- Depending on the region your AWS DynamoDB is in, update the DYNAMODB_HOSTPORT. The example connects to eu-west-1.

- (in vagrant vm via ssh) "docker run -ti --entrypoint /bin/bash --name titan-on-dynamodb -p 8182:8182  -p 8183:8183 -p 8184:8184
       -e DYNAMODB_HOSTPORT=https://dynamodb.eu-west-1.amazonaws.com 
       -e AWS_ACCESS_KEY_ID=XXX
       -e AWS_SECRET_ACCESS_KEY=YYY
       -e GRAPH_NAME=yourdatabasename
       brainframe/titan-on-dynamodb"

<a name="DEPLOYMENT3"/>

# DETAILS DEPLOYMENT 3
Runs docker for Titan on AWS EC2 Container Services (ECS) and uses AWS DynamoDB in the cloud

## 1. PREPARE AWS
- To access AWS DynamoDB create a new user with the policy "AmazonDynamoDBFullAccess" via AWS IAM on Amazon AWS console. 
(this will allow the titan-on-dynamodb docker to create the required structure inside dynamodb)
  
- Then also add an access key for that user under "security credentials" which you use for the AWS_ACCESS_KEY_ID and
AWS_SECRET_ACCESS_KEY in the scripts below. In the docker command we replaced these keys with XXX and YYY respectively.

## 2. CREATE DOCKER TASKS
- via the AWS console, click on "EC2 Container Service", and follow the tutorial to create your default cluster. 
This will automatically start an EC2 instance with the docker services pre-installed which will take a similar role as our local "vagrant"
during the local deployments. This EC2 instance will be running our 2 Dockers.
 
- Ensure the security group of your EC2 instance has the right security rules to access the ports from the dockers.
(TCP: 8000, 8182, 8183, 8184)

- Now go back to "EC2 Container Service", and select "Task Definitions"

- Now click "create new task definition" and give it a name (ex: titan-on-dynamodb)

- Now click "add container definition"

- Container name: "titan-on-dynamodb"

- image: "brainframe/titan-on-dynamodb"
 
- for the memory you define the amount of memory you have available for your ec2 instance (ex: micro instance = 1024)

- for port mapping you add 8182 to 8182 tcp, 8183 to 8183 tcp, 8184 to 8184 tcp
 
- (advanced) for the cpu you need to define how much cpu from the EC2 instance's can be used. each core/vCPU equals 1024, so 2 cores = 2048. (ex: micro instance = 1024)
 
- (advanced) add Env Variables: DYNAMODB_HOSTPORT=https://dynamodb.eu-west-1.amazonaws.com 

- (advanced) add Env Variables: AWS_ACCESS_KEY_ID=XXX

- (advanced) add Env Variables: AWS_SECRET_ACCESS_KEY=YYY

- (advanced) add Env Variables: GRAPH_NAME=yourdatabasename

- Select "Add" and select "Create"

- Now go to "clusters" in the top left

- Click on your cluster (default)

- Click "Create"

- Select as Task definition "titan-on-dynamodb" and give it Service name "titan-on-dynamodb" and number of tasks 1 

- Click create service

- This should now start the docker image for titan on the EC2 instance, and use DynamoDB as a backend.

- By going into the DynamoDB console, under tables, you should be seeing multiple new tables starting with newdb_ after +- 1 minute

# PORTS

- 8182: HTTP port for REST API

- 8183: RexPro for native access (Binary protocol)

- 8184: JMX Port

# ATTENTION!
The default dockers will create the necessary dynamodb tables to provision a fairly heavy load graph DB. Especially the
edgestore and graphindex are provisioned with high throughput, (bot 100 read and 400 write). 
Either modifying these values at the bottom of the rexter-dynamodb.xml.template file, and rebuild the dockers.
An even easier solution is to have the backend create the tables with the high values, but simply  
modify the read & write throughput for both tables via the console on the dynamodb tables according to your needs. 

If you do not do this, you'll end up with a high aws bill (reserved throughput for dynamodb tables costs even when not used) 

# Credits
The code is based on two existing projects:

- For the titan server: https://github.com/azylman/titan-rexster

- For the DynamoDB local provider: http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.DynamoDBLocal.html