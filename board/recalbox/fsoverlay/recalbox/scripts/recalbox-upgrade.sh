#!/bin/bash

recalboxupdateurl="http://archive.recalbox.com"
systemsetting="python /usr/lib/python2.7/site-packages/configgen/settings/recalboxSettings.pyc"

arch=$(cat /recalbox/recalbox.arch)
majorversion=4
updatetype="`$systemsetting  -command load -key updates.type`"

if test "${updatetype}" != "stable" -a "${updatetype}" != "unstable" -a "${updatetype}" != "beta"
then
    # force a default value in case the value is removed or miswritten
    updatetype="stable"
fi

if ! mkdir -p /recalbox/share/system/upgrade
then
    exit 1
fi

if ! wget "${recalboxupdateurl}/${majorversion}/${arch}/${updatetype}/last/boot.tar.xz" -O /recalbox/share/system/upgrade/boot.tar.xz.part
then
    exit 1
fi

if ! wget "${recalboxupdateurl}/${majorversion}/${arch}/${updatetype}/last/root.tar.xz" -O /recalbox/share/system/upgrade/root.tar.xz.part
then
    rm "/recalbox/share/system/upgrade/boot.tar.xz.part"
    exit 1
fi

if ! mv /recalbox/share/system/upgrade/boot.tar.xz.part /recalbox/share/system/upgrade/boot.tar.xz
then
    rm /recalbox/share/system/upgrade/boot.tar.xz.part
    rm /recalbox/share/system/upgrade/root.tar.xz.part
    exit 1
fi

if ! mv /recalbox/share/system/upgrade/root.tar.xz.part /recalbox/share/system/upgrade/root.tar.xz
then
    rm /recalbox/share/system/upgrade/boot.tar.xz
    rm /recalbox/share/system/upgrade/root.tar.xz.part
    exit 1
fi

for file in root.tar.xz boot.tar.xz; do
    # the file may not have a .sha1, so skip in that case
    wget ${recalboxupdateurl}/${majorversion}/${arch}/${updatetype}/last/${file}.sha1 -O /recalbox/share/system/upgrade/${file}.sha1 || continue
    computedSum=`sha1sum /recalbox/share/system/upgrade/${file} | cut -d ' ' -f 1`
    buildSum=`cat /recalbox/share/system/upgrade/${file}.sha1 | cut -d ' ' -f 1`
    if [[ $computedSum != $buildSum ]]; then
        recallog -e "Checksums differ for ${file}. Aborting upgrade !"
        rm -rf /recalbox/share/system/upgrade/*
        exit 8
    fi
done

exit 0
