rm(list=ls(all.names=TRUE))
rm(list=objects(all.names=TRUE))

library(tan)

source("params_example1.R")

### load coverage
load(file = "../extdata/coverage_vignette.RData")

tanDb <- new("tanDb", coverage = coverage)

print("create Designs")
tanDb <- createDesigns(tanDb, s.size = s.size, LHD = LHD, Uniform = Uniform )

tanDb <- calculateTotalCounts(tanDb, nSamples = nSamples, bNormWidth = bNormWidth, bSampleMean = bSampleMean)

tanDb <- calculateWithinSites(tanDb, quantprobs = quantprobs)

tanDb <- calculateVariance(tanDb, minus_condition = TRUE, Global_lower = Global_lower, poolQuant = poolQuant, movAve = movAve )

tanDb <- calculateVariance(tanDb, minus_condition = FALSE, Global_lower = Global_lower, poolQuant = poolQuant, movAve = movAve )

tanDb <- generateWithinTan(tanDb, minus_condition = TRUE)

tanDb <- generateWithinTan(tanDb, minus_condition = FALSE)

system.time(tanDb <- computePvalues(tanDb, quant = 1, poolQuant = poolQuant, movAve =movAve,
                                    Global_lower = Global_lower, ignore_sitesUnused = TRUE,
                                    na_impute = FALSE))
tanDb@coverage <- list()
save(tanDb, file = "~/Downloads/Vignette_stuffs/tanDb_Gl_100.RData")

## user  system elapsed
## 669.712   1.348 670.865
pvals <- tanDb@PvalList[['pval']][, 16]
summary(pvals)
## Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's
##  0.0093  0.4870  0.6894  0.6737  0.8901  1.0000    1154

dfPval <- data.table::data.table("sites" = 1:length(pvals), "pvals" = pvals)
dfPval_sort <- dfPval[order(pvals, decreasing = FALSE)]

de <- dfPval_sort[1:50, ]$sites
nonde <- dfPval_sort[length(pvals):(length(pvals) - 50), ]$sites

library(ggplot2); library(gridExtra)
plotfoo <- function(i) {
    p1 <-plotCoverage(coverage[[de[i]]], geneNames = 'de', size = 1.5) + ylim(0,30)
    p2 <- plotCoverage(coverage[[nonde[i]]], geneNames = 'nonde', size = 1.5) + ylim(0,30)
    p <- grid.arrange( p1, p2, nrow=2, ncol = 1)
    print(p)
    return(p)
}

pdf("~/Downloads/Vignette_stuffs/coverage_vignette_gl_100.pdf")
for(i in 1:50) {
    print(i)
    plotfoo(i)
}
dev.off()
