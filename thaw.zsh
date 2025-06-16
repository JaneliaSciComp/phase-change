#!/usr/bin/zsh

# uncompress a hierarchy of .tar.xz into a folder, in parallel

# usage thaw.sh <hotpath> <coldpath> <folder>
# e.g. nohup ./thaw.sh /groups/genie/genie /nearline/genie 20180228_ArcLight96f &

set -o errexit

hotpath=$1
coldpath=$2
folder=$3

set -o xtrace

IFS=$'\n'

doit() {
}

mkdir $hotpath/$folder
cd $coldpath
find . -path "./${folder}*tar.xz" -exec zsh -c ' \
        subdir=$0/$(dirname {}); \
        mkdir -p $subdir; \
        tar xf $1/{} -C $subdir' \
    $hotpath $coldpath \;
