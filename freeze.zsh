#!/usr/bin/zsh

# compress each folder at a given level in a hierarchy to a .tar.xz, in parallel

# usage freeze.zsh <hotpath> <coldpath> <tmppath> <folder> <level>
# e.g. nohup ./freeze.zsh /groups/genie/genie /nearline/genie /nrs/genie 20180228_ArcLight96f 1 &

# nohup ./freeze.zsh /groups/genie/genie/GECIScreenData/GECI_Imaging_Data/SCaMP /nearline/genie/SCaMP2 /nrs/genie/arthurb/tar.xz 20250324_SCaMP_raw 1 &!

set -o errexit

if [[ $# != '5' ]] ; then
    echo wrong number of input arguments
    exit
fi

hotpath=$1
coldpath=$2
tmppath=$3
folder=$4
level=$5

set -o xtrace

[[ -z $(find $hotpath/$folder -type f ! -writable) ]] || ( echo ERROR: not all files are writeable ; return 1 )

IFS=$'\n'

doit() {
    mkdir -p $coldpath/$(dirname $1)
    XZ_OPT=-1 tar cJf $coldpath/${1}.tar.xz -C $(dirname $1) $(basename $1)
    
    filesizes=$(du -s --bytes $coldpath/${1}.tar.xz $1 | cut -f1)
    echo compression ratio = $(dc -e "3 k $filesizes / p") for $1
    
    sync
    
    mkdir -p $tmppath/$(dirname $1)
    tar xf $coldpath/${1}.tar.xz -C $tmppath/$(dirname $1)
    
    if diff -r --no-dereference $1 $tmppath/$1; then
        rm -rf $1
        chmod ug+w -R $tmppath/$1
        rm -rf $tmppath/$1
    fi
}

cd $hotpath
for subfolder in $(find $folder -mindepth $level -maxdepth $level -type d) ; do
    doit $subfolder &
done
for file in $(find $folder -maxdepth $level -type f) ; do
    doit $file &
done
wait
[[ -d $tmppath/$folder ]] && find $tmppath/$folder -depth -type d -exec rmdir \{\} \;
[[ -d $hotpath/$folder ]] && find $hotpath/$folder -depth -type d -exec rmdir \{\} \;
[[ $? ]] && touch $hotpath/${folder}-MOVED-TO-NEARLINE
