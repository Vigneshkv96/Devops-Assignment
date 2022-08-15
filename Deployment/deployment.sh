#!/usr/bin/env bash

###### getting the zip file from build ####
echo ${upstream}
cp ${JENKINS_HOME}/workspace/${upstream}/*.gz .
tar -xvf *.gz
cat Dockerfile

####### logging into Docker ########
docker login  -u ${usr} -p ${pw}

####### Finding out the data file based on branch codition ####

if [[ $GIT_BRANCH == 'staging' ]] then;
     data=Responses-other.json
else
     data=Response.json
fi

####### docker build command with argument and push it to DockerHub #############
docker build . -t vigneshvalsan/nodejs:$BUILD_NUMBER_$GIT_BRANCH --build-arg data=$data
docker push vigneshvalsan/nodejs:$BUILD_NUMBER_$GIT_BRANCH

###### exporting the DockerImage name so kubectl can use it for deploying it to AWS EKS ######
export DOCKER_IMAGE=vigneshvalsan/nodejs:$BUILD_NUMBER_$GIT_BRANCH
envsubst <  deployment-manifest.yml | kubectl apply -f -
docker logout
