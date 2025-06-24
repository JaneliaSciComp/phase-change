#!/usr/bin/zsh

# uncompress a hierarchy of .tar.xz into a folder, in parallel

# usage thaw.zsh <hotpath> <coldpath> <folder>
# e.g. nohup ./thaw.zsh /groups/genie/genie /nearline/genie 20180228_ArcLight96f &!

set -o errexit

if [[ $# != '3' ]] ; then
    echo wrong number of input arguments
    exit
fi

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
