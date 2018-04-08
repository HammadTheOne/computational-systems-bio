
# Begin by installing the vcfR package is a set of tools designed to read, write,
# manipulate and analyze VCF data.

if (! require(vcfR, quietly=TRUE)) {
  if (! exists("vcfR")) {
    source("https://CRAN.R-project.org/package=vcfR")
  }
  install.packages("vcfR")
  library(vcfR)
}

# Used command line grep to subset to just chromosome 20.
#grep -w '^#\|^#CHROM\|^chr[20]' PGPC_0015_S1.flt.vcf.gz > chrom20.vcf# <- Did not work.

#%%bash
#tabix -p vcf PGPC_0015_S1.flt.vcf.gz
#tabix -h PGPC_0015_S1.flt.vcf.gz chr20 > chr20.vcf   <- Worked.


# Read in the compressed vcf file (may need to change directory):
my_vcf <- read.vcfR("C:/Users/Hammad/Desktop/vcf/chr20.vcf")
#Test code to see if other way of subsetting chr20 is better:
#my_vcf <- read.vcfR("C:/Users/Hammad/Desktop/vcf/PGPC_0015_S1.flt.vcf.gz")


# Explore and validate the data and what its contents are.


my_vcf
head(my_vcf)

# Load in GRCH37 RefSeq annotation data to idenfity gene locations.
gff <- read.table("C:/Users/Hammad/Desktop/vcf/GRCh37_latest_genomic.gff.gz", 
                  sep="\t", quote="")

#Attempt to subset the gff file to chromosome 20 - Needs adjustment.
gff2 <- gff[grep("chromosome=20", gff[,]),]


# Create a chromR object.
chrom <- create.chromR(name='chrom', vcf=my_vcf, ann=gff)

# Use the masker function to filter out lower confidence data based on quality,
#depth, and mapping quality.
chrom <- masker(chrom, min_QUAL = 1, min_DP = 300, max_DP = 700, min_MQ = 59.9,  max_MQ = 60.1)

# Process the chromR object with proc.chromR(). This function calls
#several helper functions to process the variant, sequence and annotation data for visualization.
chrom <- proc.chromR(chrom, verbose=TRUE)

#Initial visualization of data, shows quality and variant count.
plot(chrom)

# Use chromoQc, which uses layout() to make composite plots for better visualization of data.
# has potential to be useful.
chromoqc(chrom, dp.alpha=20)


#Zoom into the data we're looking at, and want to look at.
chromoqc(chrom, xlim=c(0e+00, 6.2e+07))


# Output the vcf file for downstream analysis:
write.vcf(chrom, file = 'C:/Users/Hammad.Hammad-PC/Desktop/vcf/finalvcf.vcf.gz')

#-Total number of Variants in file: 4,748,927
#-Variants only in gene regions: 52,533


#-Total Length of Chromosome 20 = ~63,000,000
#-Total Length of Gene Sequence = 34,946,003


#-Variant Density by Length of Gene Sequence: 0.0013151 
#-Variant Density by Length of Non-gene Sequence: 0.075379794

#-Non-gene Sequences have about 57x more variants even when normalizing for density. 
