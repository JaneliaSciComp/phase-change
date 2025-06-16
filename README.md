phase-change is a pair of shell scripts to archive and retrieve folders of
files to and from cold storage using the unix `tar` utility.  it provides a
means to control the size of the resulting tar.gz files by specifying at what
level in the hierarchy folders should be compressed.

# basic usage #

say you have a raw data set on a "hot" fileshare (meaning it's meant for high
throughput usage and so costs a lot):

```
/hot
└── data1
    ├── file1
    ├── file2
    ├── folder1
    │   ├── file3
    │   └── file4
    └── folder2
        ├── file5
        ├── file6
        └── folder3
            ├── file7
            └── file8
```

you can copy it to "cold" storage with:

```
$ ./freeze.zsh /hot /cold /tmp data1 1

$ tree /cold
/cold
└── data1
    ├── file1.tar.xz
    ├── file2.tar.xz
    ├── folder1.tar.xz
    └── folder2.tar.xz
```

afterwards the copied data is automatically uncompressed to the specified
temporary directory, compared to the original, and if it is the same, the
original is deleted.

to retrieve it execute:

```
$ ./thaw.zsh /hot/restored /cold data1`

$ tree /hot/restored 
/hot/restored
└── data1
    ├── file1
    ├── file2
    ├── folder1
    │   ├── file3
    │   └── file4
    └── folder2
        ├── file5
        ├── file6
        └── folder3
            ├── file7
            └── file8
```

here we chose to concatenate and compress the subfolders one level deep by
specifying `1` as the last input argument to `freeze.sh`.  using `0` and `2`
result in the following respectively:

```
/cold
└── data1.tar.xz
```

```
/cold
└── data1
    ├── file1.tar.xz
    ├── file2.tar.xz
    ├── folder1
    │   ├── file3.tar.xz
    │   └── file4.tar.xz
    └── folder2
        ├── file5.tar.xz
        ├── file6.tar.xz
        └── folder3.tar.xz
```
