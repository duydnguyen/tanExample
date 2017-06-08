# number of sample for each condition
nSamples <- 3
### parameters ###
s.size <- 500; LHD <- TRUE; Uniform <- FALSE
bNormWidth <- FALSE; bSampleMean <- FALSE
# quantile vector for binning
quantprobs <- seq(0, 1, 0.05) # this is the default binning for down sampling
## set lower bound for minGlobal (length of pooled var vector for each bins)
# Global_lower <- floor(s.size/2) # defaul value: Global_lower <- 0
Global_lower <- 100 # defaul value: Global_lower <- 0
## pooled quantile at each genomic position: (for calculateVariance())
poolQuant <- 0.5
# number of points for moving average
movAve <- 20

