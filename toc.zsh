#!/usr/bin/zsh

# generate a table-of-contents text file for a folder that was frozen before
# freeze.zsh did this automatically

# usage ./toc.zsh <path-to-folder>

# e.g. ./toc.zsh /nearline/genie/GETIScreenData/RawImageData/20231113_iGluSnFR_raw0

# to view a compressed table of contents:  tar xOf toc.txt.tar.xz | less

set -o xtrace

cd $1

doit() {
    tar tfJ "$1" > "$1.toc"
}

pids=()
for tarfile in * ; do
    doit "$tarfile" &
    pids+=($!)
done
for pid in ${pids[@]}; do
    wait $pid || return 1
done

cat *toc > toc.txt
XZ_OPT=-1 tar cJf toc.txt.tar.xz toc.txt
rm *toc toc.txt
