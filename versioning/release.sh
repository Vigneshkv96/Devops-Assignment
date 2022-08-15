#!/usr/bin/env bash

########## Exporting the Required Environments #######
source buildvar.txt

########### Removing if any zip file present in workspace ######
rm -rf *.zip

########## Compressing the code with zip ####################
zip -xvf $nextversion.zip *

######## Creating the git release tag #####################
git tag $nextversion -m "Patch version bumped from ${version} to ${nextversion}"
tag=$(git describe --tags)
description="$(echo "$description"|tr -d '\n')"

######### creating the release using by invoking the githubApi using CURL ####
release=$(curl -XPOST -H "Authorization:token $token" --data "{\"tag_name\": \"$tag\", \"target_commitish\": \"master\", \"name\": \"$gituser\", \"body\": \"$description\", \"draft\": false, \"prerelease\": true}" https://api.github.com/repos/${gituser}/${repository}/releases)
id=$(echo "$release" | grep -m 1 "id" |awk '{ gsub(/ /,""); print }'|awk -F ':' '{print $2}'|sed 's/,//g')
echo $id
curl -XPOST -H "Authorization:token $token" -H "Content-Type:application/octet-stream" -T "$nextversion.zip" https://uploads.github.com/repos/${gituser}/${repository}/releases/$id/assets?name=$nextversion.zip

########## End of script ##################################
