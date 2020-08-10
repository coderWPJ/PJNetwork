#!/bin/bash

curPath=${0}
curFileName="${curPath##*/}"
targetSpec=`echo ${curFileName} | cut -d '_' -f 1`
targetSpecFileName="${targetSpec}.podspec"

cd $(dirname $0)
versionLine=`grep -E 's.version.*=' ${targetSpecFileName}`
version=`echo ${versionLine} | cut -d '"' -f 2`


echo "Current version is ${version}"

git add --all
git commit -am "Commit ${version}"
git tag ${version}
git push origin master --tags
pod trunk push ./${targetSpecFileName} --verbose --use-libraries --allow-warnings


exit 0