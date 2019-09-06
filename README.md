# MutSigPipe
Mutational signature selection and refitting pipeline

This script tries to select the best combination of signatures for individual sample in the input 96-nt mutational matrix.  
The signature selection always starts with signature 1 and 5, assuming these signatures are present in all samples.  Then it iterates over the rest of the signature pool, calculate the increase in the cosine similarity by adding another signature in the selection, and keep the signature which gives the highest cosine similarity.  
When the overall cosine similarity reaches to 0.9 or the increase becomes less than 0.01, the script stops and reports the final set of signatures.



# Dependency

The followig R packages need to be installed.

* MutationalPatterns
* BSgenome
* BSgenome.Hsapiens.UCSC.hg19



# Required input data and paths to modify

## In functions/DataLoad.R

* 96-nt mutation matrix of the new cosmic signatures published by Alexandrov et al (https://doi.org/10.1101/322859, https://www.synapse.org/#!Synapse:syn11967914)
* 96-nt mutation matrix of the signatures published by Ma et al (https://doi.org/10.1038/nature25795)

## In MutSigPipe.R

* 96-nt mutation matrix of your samples
* Path to the directory where the functions scripts are located
* Output directory path



# Usage:
```
	Rscripts MutSigPipe.R
```


# Output

* contribution_heatmap.pdf (Signature contribution matrix in a heatmap)
* sig_contribution_mat.txt (Signature contribution matrix in a table)
* cos_sim_orig_reconst.txt (Cosine similarity between the orignal mutational pattern and reconstructed pattern)
* sel_sig_reconst_mat.txt (96nt matrix of the reconstructed pattern)
* bar plots indicating the cosine similarity increase by adding the selected signature for every sample
