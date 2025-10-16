# Installing required packages:
#install.packages("devtools") # if "devtools" is not installed already
#devtools::install_github("uqrmaie1/admixtools")

# If not working, install dependencies manually:
install.packages("Rcpp")
install.packages("tidyverse")
install.packages("igraph")
install.packages("plotly")

# And again
#devtools::install_github("uqrmaie1/admixtools")

# Another option:
#install.packages("remotes")
#remotes::install_github("uqrmaie1/admixtools")


# Once installed, load packages:
library(admixtools)
library(tidyverse)
library(ggplot2)
library(dplyr)

# Set working directory
setwd("/home/ahumada_quintanilla/Escritorio/Bioinformatica/popgen_shared")

# Load metadata
metadf = read.table("v62.0_1240k_public_metadata2.csv", header = T, sep = ",")

#--------------------------------------------------------------
# 1.  Generate f2 blocks (transversions only and all)
#--------------------------------------------------------------
# Path to your genotype data in EIGENSTRAT format (without extensions)
# Path prefix to genotype files

prefix <- "/popgen_shared/v62.0_1240k_public"  

# Directory to store f2 results
#outdir <- "aadr_1000G_f2_transversions"
outdir_all <- "aadr_1000G_f2_all"

# demo_pops <- c("Altai_Neanderthal.DG", 
#                "Denisova.DG", 
#                "Russia_UstIshim_IUP.DG",
#                "Luxembourg_Mesolithic.DG", 
#                "Turkey_Marmara_Barcin_N.AG", 
#                "Russia_Samara_EBA_Yamnaya.AG",
#                "England_C_EBA.AG",
#                "Germany_CordedWare.AG",
#                "Mbuti.DG", 
#                "Papuan.DG", 
#                "CHB.DG", 
#                "Adygei.DG",
#                "Basque.DG",
#                "Druze.DG",
#                "French.DG",
#                "Italian_North.DG", 
#                "Italian_Sardinian.DG", 
#                "Orcadian.DG", 
#                "Russian.DG", 
#                "Sardinian.DG",
#                "FIN.DG", 
#                "GBR.DG", 
#                "IBS.DG", 
#                "TSI.DG",
#                "Chimp.REF",
#                "MXL.DG",
#                "Karitiana.DG",
#                "PEL.DG",
#                "Mixe.DG")
# 
# # Extract f2, but only using transversions (exclude transitions)
# extract_f2(
#   pref = prefix,
#   outdir = outdir,
#   pops = demo_pops,          # only the demo populations
#   transitions = FALSE,       # exclude transitions (ancient DNA caution)
#   transversions = TRUE,      # keep transversions only
#   overwrite = TRUE,
#   blgsize = 0.05,            # block size in Morgans (default fine)
#   verbose = TRUE
# )
# 
# # Extract f2, all positions
# extract_f2(
#   pref = prefix,
#   outdir = outdir_all,
#   pops = demo_pops,          # only the demo populations
#   overwrite = TRUE,
#   blgsize = 0.05,            # block size in Morgans (default fine)
#   verbose = TRUE
# )
# 
# # Load the f2 cache
# f2_blocks_transv <- f2_from_precomp(outdir)

f2_blocks_all <- f2_from_precomp(outdir_all)

#--------------------------------------------------------------
# 1. admix-f3: Detecting admixture in a target population
#--------------------------------------------------------------
# 

# Expectation:
# Negative f3(MXL; IBS, Karitiana): confirms admixed European × Native ancestry.

popA = c("MXL.DG","PEL.DG","Mixe.DG") #poblaciones target
popB = "IBS.DG"  #Posibles poblaciones de mestizaje
popC = "Karitiana.DG"  #posible poblacion de mestizaje

# Run f3
f3res <- f3(f2_blocks_all, popA, popB, popC)

## si hay mestizaje los valores seran negativos

#--------------------------------------------------------------
# 2. outgroup-f3: Shared drift between Loschbour (WHG, Luxembourg_Mesolithic) and moderns populations
#--------------------------------------------------------------
# 
## outgup f3 solo entrega valores positivos y permite ver cual de las poblaciones actuales tiene mas relacion con la 
## poblacion del mesolitico

# Define populations
popA1 = c("Luxembourg_Mesolithic.DG")
popB1 = c("Adygei.DG","Basque.DG","Druze.DG","French.DG","Italian_North.DG", 
         "Italian_Sardinian.DG", "Orcadian.DG", "Russian.DG", "Sardinian.DG",
         "FIN.DG", "GBR.DG", "IBS.DG", "TSI.DG")
outg1 = c("Mbuti.DG")

# Run f3
f3res1 <- f3(f2_blocks_all, outg, popA, popB)

# Plot
f3res$pop3_region = metadf$region[match(f3res$pop3, metadf$popid)]

ggplot(f3res, aes(x = reorder(pop3, est), y = est, color = pop3_region)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = (est - se*3), ymax = (est + se*3)), width = 0.2) +
  scale_color_manual(values = c("orange2", "steelblue1", "cyan4", 
                               "yellow2", "pink3")) +
  coord_flip() +
  labs(x = "Target population",
    y = expression(f[3]),
    color = "Region") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),
    legend.position = "right")



#--------------------------------------------------------------
# 3. f4 / D-statistic — testing tree symmetry (ABBA-BABA)
#--------------------------------------------------------------

# If D ~ 0, pop1 and pop2 are symmetrically related to pop3 (pop4 is outgroup to all)
# If D >> 0, pop1 shared more alleles with pop3 than pop2
# If D << 0, pop2 shared more alleles with pop3 than pop1

qpdstat(f2_blocks_all, pop1="GBR.DG", pop2="TSI.DG", pop3="Mbuti.DG", pop4="Chimp.REF")

f4res = qpdstat(f2_blocks_all, pop1="GBR.DG", pop2=c("TSI.DG","CHB.DG","Mbuti.DG","Papuan.DG"), pop3="Altai_Neanderthal.DG", pop4="Chimp.REF")

# Papuans may have similar Neanderthal affinity but more Denisovan affinity.
qpdstat(f2_blocks_all,
        pop1 = "Altai_Neanderthal.DG",
        pop2 = "Denisova.DG",
        pop3 = "Papuan.DG",
        pop4 = "GBR.DG")



#--------------------------------------------------------------
# 5. qpWave / qpAdm: model an european target as mix of sources
#--------------------------------------------------------------

## se evaluan las oleadas migratorias

# The qpwave() function tests whether a set of Left populations can be explained as 
# descending from a given number of ancestral streams relative to a set of Right 
# populations (which serve as references or outgroups).

# Can the target me modeled as related to left populations? 
# How many independent ancestry streams are needed to explain their allele frequency relationships relative to your set of Right populations.

target <- "England_C_EBA.AG"  # You can replace with an ancient/modern European population
right_qpwave <- c("Mbuti.DG", "Papuan.DG", "CHB.DG", "Denisova.DG", "Russia_UstIshim_IUP.DG")

wave <- qpwave(
  f2_blocks_all,
  left = c(target, "Turkey_Marmara_Barcin_N.AG", "Luxembourg_Mesolithic.DG", "Russia_Samara_EBA_Yamnaya.AG"),
  right = right_qpwave)

wave

# k = tested number of streams (rank + 1)
# Null hypothesis (H0): “The Left populations can be explained by ≤ k ancestry streams relative to the Right populations.”
# Alternative hypothesis (H1): “The Left populations require more than k ancestry streams relative to the Right populations.”

# The p-value in qpWave is:
# High p-value (p > 0.05): Fail to reject H0 → the tested number of ancestry streams is sufficient.
# Low p-value (p < 0.05): Reject H0 → the tested number of ancestry streams is not sufficient; more streams are needed.

# Rank = 2: 3 ancestry streams. At least two admixture events, etc.
# Rank = 1: 2 ancestry streams. At least one admixture event between Left pops
# Rank = 0: Left pops share 1 ancestry stream relative to Right. All Left pops form a clade with respect to Right

# Proportion of ancestry from source populations
adm <- qpadm(
  f2_blocks_all,
  left = c(target, "Turkey_Marmara_Barcin_N.AG", 
           "Luxembourg_Mesolithic.DG", "Russia_Samara_EBA_Yamnaya.AG"),
  right = right_qpwave,
  target = target)

view(adm$weights)
view(adm$popdrop)
## REPEAT WITH Germany_CordedWare.AG AS TARGET






#