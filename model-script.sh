#!/bin/bash

set -e

# Define other required files
REFERENCE="/data0/paalmbj/gcnv-caller-model/GRCh38_full_analysis_set_plus_decoy_hla.fa"

inputs=`for f in *.h5; do echo -I $f; done`

# The contig ploidy priors (chr20XY_contig_ploidy_priors.tsv) is from the tutorial at:
# https://gatk.broadinstitute.org/hc/en-us/articles/360035531152--How-to-Call-common-and-rare-germline-copy-number-variants

mkdir -p ploidy
gatk DetermineGermlineContigPloidy \
	$inputs \
        --contig-ploidy-priors chr20XY_contig_ploidy_priors.tsv \
        --output ploidy \
        --output-prefix ploidy \
	--verbosity DEBUG &> log-ploidy.txt

gatk GermlineCNVCaller \
	--run-mode COHORT \
	$inputs \
	--contig-ploidy-calls ploidy/ploidy-calls \
	--annotated-intervals twelveregions.annotated.tsv \
	--interval-merging-rule OVERLAPPING_ONLY \
	--output model \
	--output-prefix model-1kg30x \
	--verbosity DEBUG &> log-model.txt

