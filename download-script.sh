#!/bin/bash

set -e

# Reuqired input file: 'igsr_30x GRCh38.tsv.tsv'  (see notes.txt).


counter=1
for path in `cut -f1 'igsr_30x GRCh38.tsv.tsv' | grep '\.final\.cram$' | shuf`
do
    echo "Sample $counter: $path"
    if [ -e $( basename $path ) ]
    then
	    echo "$( basename $path ) existed; skipping"
	    continue
    fi
    wget -N $path
    counter=$((counter+1))
done

