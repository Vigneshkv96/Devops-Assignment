#!/usr/bin/env bash

#### Removing the Buildvar.txt file if presnet ######
rm -rf buildvar.txt

##### Extracting the Version from package.json ######

ver=$(grep version package.json | awk -F \" '{print $4}')
echo $ver

####### Creating the next version ##########
lst=${ver:0-1}
sum=$(expr $lst + 13)
nxtvr=${ver:0:3}.$sum

######## Creating a branch with new version creater ###
git checkout -b $nxtvr
git push origin $nxtvr

######## preparing the Environment variable required for Release #######
touch buildvar.txt
gituser=$(echo $GIT_URL | awk -F '/' '{print $4}'| xargs)
url="${GIT_URL##*/}" # Remove all up to and including last /
url="${url%.*}"  # Remove up to the . (including) from the right
echo "export gituser=$gituser" >> buildvar.txt
echo "export repository=$url" >> buildvar.txt
echo "export title=Jenkins::$BUILD_NUMBER" >> buildvar.txt
echo "export description='BuildTag::$BUILD_TAG\nBuildurl::$BUILD_URL\nGiTurl::$GIT_URL'" >> buildvar.txt
echo "export version=$ver" >> buildvar.txt
echo "export nextversion=$nxtvr" >> buildvar.txt
echo "export token=$GIT_USERNAME" >> buildvar.txt

############## End of Script ##########################
