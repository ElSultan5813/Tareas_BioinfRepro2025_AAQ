#Ejecutar el script desde la carpeta code
setwd("/home/ahumada_quintanilla/Escritorio/Bioinformatica/Tareas_BioinfRepro2025_AAQ/Unidad_2/Tarea_2.1/code")
#Instalar paquetes
#install.packages("dplyr")
#install.packages("readr")
# Cargar paquetes
library(dplyr)
library(readr)

# Leer archivo FAM
fam <- read.table("../data/ChileGenomico/chilean_all48_hg19.fam", header = FALSE, stringsAsFactors = FALSE)
colnames(fam) <- c("FID", "IID", "PID", "MID", "Sex_fam", "Phenotype")

# Leer archivo de info poblacional
popinfo <- read_csv("../data/ChileGenomico/chilean_all48_hg19_popinfo.csv")


# Normalizar sexo en popinfo a formato numérico PLINK (1 = M, 2 = F)
popinfo_clean <- popinfo %>%
  mutate(Sex_popinfo = case_when(
    Sex %in% c("M", "Male", "MALE") ~ 1,
    Sex %in% c("F", "Female", "FEMALE") ~ 2,
    TRUE ~ 0  # desconocido o no especificado
  ))

# Unir ambos datasets
sex_compare <- fam %>%
  inner_join(popinfo_clean, by = c("IID" = "IndID"))

# Comparar
sex_compare <- sex_compare %>%
  mutate(Discordant = ifelse(Sex_fam != Sex_popinfo, 1, 0))


# Calcular proporción
total <- nrow(sex_compare)
discordant <- sum(sex_compare$Discordant)
prop_discordant <- discordant / total

# Mostrar resultado
cat("Total de muestras comparadas:", total, "\n")
cat("Número de discordancias de sexo:", discordant, "\n")
cat("Proporción de discordancias:", round(prop_discordant, 4), "\n")
