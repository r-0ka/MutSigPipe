#/usr/lib/R/bin/Rscript

#=========== PLEASE MODIFY ============#

   # 96nt mutation matrix created using MutationalPatterns package in R
mut_mat <- read.table("96mutation_matrix.txt")

  # directory where the scripts are located
func_dir <- "MutSigPipe/functions/"

  # output directory
wd <- "mut_sig_pipe_v1/"

#=========== PLEASE MODIFY ============#



source( paste( func_dir, "DataLoad.R", sep="" ) )
source( paste( func_dir, "select_signatures.R", sep="" ) )

sel_reconst_mat <- matrix(, nrow=96, ncol=0 )
sig_contribution_mat <- matrix(, nrow=length(signature_names), ncol=0 )
rownames(sig_contribution_mat) <- signature_names


for ( nSample in 1:ncol(mut_mat) ) {
  # iterating over samples in the mutation table

  sel_mut_mat <- as.matrix(mut_mat[,nSample])
  sampleID <- colnames(mut_mat)[nSample]
    # select sample to analyze 

  sel_signatures <- select_signatures( sel_mut_mat, sampleID ) 

  signatures <- cbind(sig1_sig5, sig_rest[, sel_signatures])
  colnames(signatures) <- c( "SBS1", "SBS5", sel_signatures )
  refit_res <- fit_to_signatures( sel_mut_mat, signatures )

  sig_contribution_mat <- transform( merge( sig_contribution_mat, refit_res$contribution, by=0, all=TRUE ), row.names=Row.names, Row.names=NULL )
  colnames(sig_contribution_mat) <- replace(colnames(sig_contribution_mat), length(colnames(sig_contribution_mat)), sampleID)

  sel_reconst_mat <- transform( cbind( sel_reconst_mat, refit_res$reconstructed ))
  colnames(sel_reconst_mat) <- replace(colnames(sel_reconst_mat), length(colnames(sel_reconst_mat)), sampleID)


}

sig_contribution_mat[is.na(sig_contribution_mat)] <- 0

cos_sim_ori_rec <- cos_sim_matrix(mut_mat, sel_reconst_mat)
cos_sim_ori_rec <- as.data.frame(diag(cos_sim_ori_rec))


write.table(sig_contribution_mat, paste(wd, "sig_contribution_mat.txt", sep=""), sep="\t", quote=F)
write.table(cos_sim_ori_rec, paste(wd, "cos_sim_orig_reconst.txt", sep=""), sep="\t", quote=F)
write.table(sel_reconst_mat, paste(wd, "sel_sig_reconst_mat.txt", sep=""), sep="\t", quote=F)


pdf(paste(wd, "contribution_heatmap.pdf", sep=""), height=15, width=15)
  plot_contribution_heatmap(as.matrix(sig_contribution_mat), sig_order=signature_names)
dev.off()