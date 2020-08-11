#!/bin/bash

# 获取spec文件
curPath=${0}
curFileName="${curPath##*/}"
targetSpec=`echo ${curFileName} | cut -d '_' -f 1`
targetSpecFileName="${targetSpec}.podspec"


# 获取版本号
cd $(dirname $0)
versionLine=`grep -E 's.version.*=' ${targetSpecFileName}`
version=`echo ${versionLine} | cut -d '"' -f 2`
versionLineNumber=`grep -nE 's.version.*=' ${targetSpecFileName} | cut -d : -f1`

### 实现版本号的自增+1
versionStr=${version}
let versionNum=0
for((i=0;i<${#versionStr};i++))
do
    subNum=`echo "${versionStr:$i:1}"`
    if [ "${subNum}" != '.' ];
    then
        let value=$((versionNum))*10+$((subNum))
        versionNum="${value}"
    fi
done
let targetVersionNum=versionNum+1
targetVersionTemp=${targetVersionNum}

targetVersionStr=""
let targetLength=${#targetVersionTemp}
for((idx=0;idx<targetLength;idx++))
do
    subNum=`echo "${targetVersionTemp:$idx:1}"`
    let lastValue=targetLength-1 
    if [ "${subNum}" != '.' ]; then
        if [ ${idx} -gt 0 ]
        then
            targetVersionStr="${targetVersionStr}.${subNum}"
        else
            targetVersionStr="${subNum}"
        fi
    fi
done


sed -i "" "${versionLineNumber}s/${versionStr}/${targetVersionStr}/g" ${targetSpecFileName}
echo "版本号：  ${versionStr} >>>>>> 更新到 >>>>>> ${targetVersionStr}"

# git 操作
git add --all
git commit -am "Commit ${targetVersionStr}"
git tag ${targetVersionStr}
git push origin master --tags

# 推送spec文件
pod trunk push ./${targetSpecFileName} --verbose --use-libraries --allow-warnings


exit 0