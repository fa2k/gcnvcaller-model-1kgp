# Model for GATK GermlineCNVCaller based on data from the 1000 Genomes Project

**This is incomplete work. It's published on github only as a backup.**

These are scripts to produce a GermlineCNVCaller model based on public WGS data from the
International Genome Sample Resource. It requires a lot of data transfer and processing,
and it's not necessarily recommended to repeat this. The model may be uploaded as an
asset when finished, if possible.

The purpose is to allow small research labs that don't have hundreds of WGS samples
to use the GermlineCNVCaller on their WGS data. The hope is that data from IGSR is 
technically diverse enough to allow generalisation to other datasets. If it works,
it will be less sensitive than making a dedicated cohort model, as there is more 
uncertainty due to sample variation.

This model should at the very least be benchmarked against other CNV calls on the
same dataset, and ideally also applied to other samples, but this is not yet done.


## `download-script.sh`

Download 30X WGS data from International Genome Sample Resource.

Data collection: https://www.internationalgenome.org/data-portal/data-collection/30x-grch38


## `preprocessing-script.sh`

Prepare read counts. Reference fasta from here:
https://www.internationalgenome.org/category/reference/

## `model-script.sh`

TODO
