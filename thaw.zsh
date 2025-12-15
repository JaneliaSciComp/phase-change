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
    subdir=$hotpath/$(dirname $1)
    mkdir -p $subdir
    tar xf $coldpath/$1 -C $subdir
}

mkdir $hotpath/$folder
cd $coldpath
for file in $(find . -path "./${folder}*tar.xz") ; do
    doit $file &
    pids+=($!)
done
for pid in ${pids[@]}; do
    wait $pid || return 1
done
[[ $? ]] && touch $hotpath/$folder/RESTORED-FROM-NEARLINE
