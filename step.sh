#!/bin/bash

# exit if a command fails
set -e

#
# Required parameters
if [ -z "${manifest_file}" ] ; then
  echo " [!] Missing required input: manifest_file"
  exit 1
fi
if [ ! -f "${manifest_file}" ] ; then
  echo " [!] File doesn't exist at specified AndroidManifest.xml path: ${manifest_file}"
  exit 1
fi

# ---------------------
# --- Configs:

echo " (i) Provided Android Manifest path: ${manifest_file}"
echo

# ---------------------
# --- Main

VERSIONCODE=`grep versionCode ${manifest_file} | sed 's/.*versionCode="//;s/".*//'`
VERSIONNAME=`grep versionName ${manifest_file} | sed 's/.*versionName\s*=\s*\"\([^\"]*\)\".*/\1/g'`
PACKAGENAME=`grep package ${manifest_file} | sed 's/.*package\s*=\s*\"\([^\"]*\)\".*/\1/g'`
MINSDKVERSION=`grep minSdkVersion ${manifest_file} | sed 's/.*minSdkVersion="//;s/".*//'`
TARGETSDKVERSION=`grep targetSdkVersion ${manifest_file} | sed 's/.*targetSdkVersion="//;s/".*//'`

if [ -z "${VERSIONCODE}" ] ; then
  echo " [!] Could not find version code!"
  exit 1
fi

envman add --key AMI_VERSION_CODE --value "${VERSIONCODE}"
echo " (i) Version Code: ${VERSIONCODE} -> Saved to \$AMI_VERSION_CODE environment variable."

if [ -z "${VERSIONNAME}" ] ; then
  echo " [!] Could not find version name!"
  exit 1
fi

envman add --key AMI_VERSION_NAME --value "${VERSIONNAME}"
echo " (i) Version Name: ${VERSIONNAME} -> Saved to \$AMI_VERSION_NAME environment variable."

if [ -z "${PACKAGENAME}" ] ; then
  echo " [!] Could not find package name!"
  exit 1
fi

envman add --key AMI_PACKAGE_NAME --value "${PACKAGENAME}"
echo " (i) Package Name: ${PACKAGENAME} -> Saved to \$AMI_PACKAGE_NAME environment variable."

if [ -z "${MINSDKVERSION}" ] ; then
  echo " No minimum SDK version found in manifest"
else
  envman add --key AMI_MIN_SDK_VERSION --value "${MINSDKVERSION}"
  echo " (i) Minimum SDK version: ${MINSDKVERSION} -> Saved to \$AMI_MIN_SDK_VERSION environment variable."
fi

if [ -z "${TARGETSDKVERSION}" ] ; then
  echo " No target SDK version found in manifest"
else
  envman add --key AMI_TARGET_SDK_VERSION --value "${TARGETSDKVERSION}"
  echo " (i) Target SDK version: ${TARGETSDKVERSION} -> Saved to \$AMI_TARGET_SDK_VERSION environment variable."
fi
