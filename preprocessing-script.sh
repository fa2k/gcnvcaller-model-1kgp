#!/bin/bash

set -e

# Define directories
INPUT_DIR="/data0/paalmbj/1000genomes-30x"
OUTPUT_DIR="$PWD"

# Define other required files
REFERENCE="/data0/paalmbj/gcnv-caller-model/GRCh38_full_analysis_set_plus_decoy_hla.fa"

THREADS=32

# Perform preprocessing
if [ ! -f  ${OUTPUT_DIR}/processed.interval_list ]; then
        gatk PreprocessIntervals \
                -R $REFERENCE \
                --bin-length 1000 \
                --padding 0 \
                -O ${OUTPUT_DIR}/processed.interval_list &> $OUTPUT_DIR/log-ProcessIntervals.txt
fi

# Create function for parallel processing
process_file() {
  file=$1
  FILENAME=$(basename "$file" .final.cram)
  
  if [[ `echo $(( $(date +%s) - $(stat $file  -c %Y) ))`  -le 120 ]]; then
          echo "$file is recently modified, skipping."
          return
  fi

  if [ ! -f "${OUTPUT_DIR}/${FILENAME}.processed" ]; then
    echo "Processing ${FILENAME}"
    samtools index $file
    gatk CollectReadCounts \
      -L ${OUTPUT_DIR}/processed.interval_list \
      -R $REFERENCE \
      -I $file \
      --interval-merging-rule OVERLAPPING_ONLY \
      -O ${OUTPUT_DIR}/${FILENAME}.processed.h5 &> $OUTPUT_DIR/log-${FILENAME}-CollectReadCounts.txt
  else
    echo "${FILENAME} has already been processed, skipping."
  fi
}

export -f process_file
export OUTPUT_DIR
export REFERENCE

# Parallel processing
find ${INPUT_DIR} -name "*.cram" | xargs -I {} -P $THREADS bash -c 'process_file "$@"' _ {}

