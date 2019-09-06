#/usr/lib/R/bin/Rscript

#=========== PLEASE MODIFY ============#

	# Signature data published by Alexandrov et al (https://doi.org/10.1101/322859, 
	#									            https://www.synapse.org/#!Synapse:syn11967914)
cancer_signatures <- read.table("sigProfiler_SBS_working_signatures.txt", sep = "\t", header = T)

	# Signature data published by Ma et al 2018 (https://doi.org/10.1038/nature25795)
StJude_signatures <- read.table("StJude_signatures.txt", sep = "\t", header = T)

#=========== PLEASE MODIFY ============#


library(MutationalPatterns)
library(BSgenome)
library("BSgenome.Hsapiens.UCSC.hg19")
ref_genome <- "BSgenome.Hsapiens.UCSC.hg19"


sig_names <- colnames(cancer_signatures)

cancer_signatures <- cbind(cancer_signatures, StJude_signatures$Signature.T.10)
colnames(cancer_signatures) <- c(sig_names, "T10")

signature_names <- c(sig_names[-(1:2)], "T10")


	### for selecting signatures for refit ###

   # matrix with signature 1 and 5
sig1_sig5 <- as.matrix(cancer_signatures[,c(3,7)])

   # rest of the signatures
sig_rest <-  as.matrix(cancer_signatures[,-c(1:3,7)])

