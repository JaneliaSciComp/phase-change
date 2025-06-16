#!/usr/bin/zsh

level=$1

hotpath=$TMPPREFIX/hot
coldpath=$TMPPREFIX/cold
tmppath=$TMPPREFIX/tmp

rm -rf $hotpath $coldpath $tmppath
mkdir -p $hotpath $coldpath $tmppath

mkdir $hotpath/data1
touch $hotpath/data1/file1
touch $hotpath/data1/file2
mkdir $hotpath/data1/folder1
touch $hotpath/data1/folder1/file3
touch $hotpath/data1/folder1/file4
mkdir $hotpath/data1/folder2
touch $hotpath/data1/folder2/file5
touch $hotpath/data1/folder2/file6
mkdir $hotpath/data1/folder2/folder3
touch $hotpath/data1/folder2/folder3/file7
touch $hotpath/data1/folder2/folder3/file8

cp -R $hotpath/data1 $hotpath/data1-copy

./freeze.zsh $hotpath $coldpath $tmppath data1 $level
./thaw.zsh $hotpath $coldpath data1
diff -r $hotpath/data1 $hotpath/data1-copy
