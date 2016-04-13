#!/bin/bash

GITHUB_HOST="https://github.com"
GITHUB_REPO="tianon/gosu"
RELEASE_PATTERN="gosu-amd64"
SLEEPYNESS=0.5

function fetch_relase_paths () {
    curl -vL ${GITHUB_HOST}/${GITHUB_REPO}/releases/ |\
        grep ${RELEASE_PATTERN} |\
        grep href |\
        grep releases |\
        awk -F\" '{ print $2 }'
}

function process_releases () {
    read this_release
    release_dir=`echo ${this_release} | awk -F\/ '{print $6}'`
    mkdir -p ${release_dir}
}

function download_releases () {
    read this_release
    download_url="${GITHUB_HOST}${this_release}"
    release_dir=`echo ${this_release} | awk -F/ '{print $6}'`
    filename=`echo ${this_release} | awk -F/ '{print $NF}'`
    curl -L "${download_url}" -o "./${release_dir}/${filename}"
}

main () {
    release_paths=`fetch_relase_paths`
    for i in ${release_paths[@]}; do
        echo $i | process_releases
        echo $i | download_releases
    done
    sleep ${SLEEPYNESS}
}

main
