#!/bin/bash

recalboxupdateurl="http://archive.recalbox.com/updates/v1.0"
systemsetting="python /usr/lib/python2.7/site-packages/configgen/settings/recalboxSettings.pyc"

arch=$(cat /recalbox/recalbox.arch)
updatetype="`$systemsetting  -command load -key updates.type`"

function cancelUpgrade() {
    rm -rf /recalbox/share/system/upgrade/*
    exit 1
}

if test "${updatetype}" = "beta"
then
    # force a default value in case the value is removed or miswritten
    updatetype="stable"
fi

if ! mkdir -p /recalbox/share/system/upgrade
then
    exit 1
fi

if ! wget "${recalboxupdateurl}/${updatetype}/${arch}/boot.tar.xz" -O /recalbox/share/system/upgrade/boot.tar.xz.part
then
    exit 1
fi

if ! wget "${recalboxupdateurl}/${updatetype}/${arch}/root.tar.xz" -O /recalbox/share/system/upgrade/root.tar.xz.part
then
    rm "/recalbox/share/system/upgrade/boot.tar.xz.part"
    exit 1
fi

mv /recalbox/share/system/upgrade/boot.tar.xz.part /recalbox/share/system/upgrade/boot.tar.xz || cancelUpgrade
mv /recalbox/share/system/upgrade/root.tar.xz.part /recalbox/share/system/upgrade/root.tar.xz || cancelUpgrade

wget "${recalboxupdateurl}/${updatetype}/${arch}/root.list" -O /recalbox/share/system/upgrade/root.list || cancelUpgrade


for file in root.tar.xz boot.tar.xz; do
    # the file may not have a .sha1, so skip in that case
    wget ${recalboxupdateurl}/${updatetype}/${arch}/${file}.sha1 -O /recalbox/share/system/upgrade/${file}.sha1 || cancelUpgrade
    computedSum=`sha1sum /recalbox/share/system/upgrade/${file} | cut -d ' ' -f 1`
    buildSum=`cat /recalbox/share/system/upgrade/${file}.sha1 | cut -d ' ' -f 1`
    if [[ $computedSum != $buildSum ]]; then
        recallog -e "Checksums differ for ${file}. Aborting upgrade !"
        cancelUpgrade
    fi
done

exit 0
