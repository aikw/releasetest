#!/bin/bash -eu

cd "cappella-web"

OWNER=aikw
REPO=releasetest

VERSION=`node -e '\
const p=require("./package.json");\
const ver=p.version;\
const r=p.ricohLsSdk;\
const pre=r&&r.preRelease?"-"+r.preRelease:"";\
console.log(ver+pre)'`

PRE_RELEASE=`node -e '\
const p=require("./package.json");
const r=p.ricohLsSdk;\
const pr=r&&r.preRelease?"true":"false";
console.log(pr)'`

HASH=`echo $VERSION | sed 's/\.//g' | sed 's/\+[0-9]*//g'`
DESCRIPTION="CHANGE LOG: https://github.com/${OWNER}/${REPO}/blob/master/README.md#v${HASH}"

API_ENDPOINT="https://api.github.com/repos/${OWNER}/${REPO}"
ACCEPT_HEADER="Accept: application/vnd.github.v3+json"
TOKEN_HEADER="Authorization: token ${GITHUB_TOKEN}"

echo "creatting new release for ${VERSION}"

REPLY=$(curl \
  -H "${ACCEPT_HEADER}" \
  -H "${TOKEN_HEADER}" \
  -d "{\"tag_name\": \"${VERSION}\", \"name\": \"${VERSION}\", \"body\": \"${DESCRIPTION}\", \"prerelease\": ${PRE_RELEASE}}" \
  "${API_ENDPOINT}/releases" \
  )