#!/bin/bash

cd $(dirname $0)
versionLine=`grep -E 's.version.*=' PJNetwork.podspec`
version=`echo ${versionLine} | cut -d '"' -f 2`

echo "Current version is ${version}"

git add --all
git commit -am "Commit ${version}"
git tag ${version}
git push origin master --tags
pod trunk push ./PJNetwork.podspec --verbose --use-libraries --allow-warnings


exit 0