#/usr/lib/R/bin/Rscript

##########################################
#
# This is an R function# for selecting signatures for re-fitting.
#
#
# Selection criteria:
#    Cosine similarity goes above 0.9 OR
#    difference in cosine similarity become less than 0.1
#
# Returns selected signatures for all samples.
#
##########################################


select_signatures <- function( sel_mut_mat, sampleID ) {


out.pdf <- paste(wd, sampleID, "_cosSim.pdf", sep="")


   # fitting with signature 1 and 5
fit_res <- fit_to_signatures(sel_mut_mat, as.matrix(sig1_sig5))
reconst_mat <- fit_res$reconstructed

sel_cos_sim <- cos_sim_matrix(sel_mut_mat, reconst_mat)[1]



sel_sig_names <- vector()

for ( nsig in 1:10 ) { 

   # excluding signatures that are already selected
test_sig <- sig_rest[, !(colnames(sig_rest) %in% sel_sig_names), drop=FALSE]


   # refitting by adding signatures one by one
test_reconst_mat <- matrix( , nrow=96, ncol=0 )
iterate <- 1

for ( iterate in 1:ncol(test_sig) ) {

  signatures <- cbind(sig1_sig5, sig_rest[, sel_sig_names], test_sig[,iterate])
  refit_res <- fit_to_signatures(sel_mut_mat, signatures)
  test_reconst_mat <- cbind(test_reconst_mat, refit_res$reconstructed)

}

colnames(test_reconst_mat) <- colnames(test_sig)
cos_sim_ori_rec <- cos_sim_matrix(sel_mut_mat, test_reconst_mat)


#  cos_sim_diff <<- c( cos_sim_diff, cos_sim_ori_rec[max.col(cos_sim_ori_rec)] - tail(sel_cos_sim,1) )
#  print(cos_sim_diff)

   cos_sim_diff <- cos_sim_ori_rec[max.col(cos_sim_ori_rec)] - tail(sel_cos_sim,1)
   if ( cos_sim_diff < 0.01 ) break

  # extracting selected signature name
sel_sig_names <- c(sel_sig_names, colnames(cos_sim_ori_rec)[max.col(cos_sim_ori_rec)])
sel_cos_sim <- c(sel_cos_sim, cos_sim_ori_rec[max.col(cos_sim_ori_rec)])

  if ( cos_sim_ori_rec[max.col(cos_sim_ori_rec)] > 0.90 ) break
}

  pdf(out.pdf, height=5, width=5)

    barplot(sel_cos_sim, las=2, ylim=range(0.5,1), xpd = FALSE, col="#dddddd", ylab="Cosine similarity", names=c("SBS1+5", sel_sig_names), main=sampleID, cex.names=0.5)
    abline(h=0.90, lty=2)
    abline(h=0.85, lty=2)

  dev.off()

  return(sel_sig_names)
    # returning selected signatures

}
