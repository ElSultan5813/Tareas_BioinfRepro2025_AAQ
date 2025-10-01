#Ejecutar el script desde la carpeta code
setwd("/home/ahumada_quintanilla/Escritorio/Bioinformatica/Tareas_BioinfRepro2025_AAQ/Unidad_2/Tarea_2.1/code")

# Cargar librerías
library(ggplot2)
library(readr)
library(dplyr)

# Leer archivo de frecuencias generado por PLINK
freq <- read_table("../results/CLG_Chr4_0bp-2Mb_Frecuencias.frq", comment = "")

colnames(freq)
names(freq)[names(freq) == "{ALLELE:FREQ}"] <- "MAF"
colnames(freq)
freq$MAF_numeric <- as.numeric(sub(".*:", "", freq$MAF))

# Filtrar valores válidos de MAF entre 0 y 0.5
freq_clean <- freq %>%
  filter(MAF_numeric > 0 & MAF_numeric <= 0.5)

# Graficar histograma
p <- ggplot(freq_clean, aes(x = MAF_numeric)) +
  geom_histogram(binwidth = 0.01, fill = "#3E8EDE", color = "black") +
  labs(title = "Espectro de Frecuencia Alélica Menor (MAF)",
       x = "Frecuencia alélica menor (MAF)",
       y = "Número de variantes") +
  theme_minimal()

# Guardar la figura como PNG
ggsave("../results/histogram.png", plot = p, width = 8, height = 5, dpi = 300)

