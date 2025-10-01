#Ejecutar el script desde la carpeta code
setwd("/home/ahumada_quintanilla/Escritorio/Bioinformatica/Tareas_BioinfRepro2025_AAQ/Unidad_2/Tarea_2.1/code")

# Cargar librerías necesarias
library(readr)
library(dplyr)

# Leer el archivo popinfo
popinfo <- read_csv("../data/ChileGenomico/chilean_all48_hg19_popinfo.csv")

# Estandarizar valores de sexo si es necesario
popinfo <- popinfo %>%
  mutate(Sex_clean = case_when(
    Sex %in% c("M", "Male", "MALE") ~ "Male",
    Sex %in% c("F", "Female", "FEMALE") ~ "Female",
    TRUE ~ "Unknown"
  ))

# Crear tabla de contingencia: conteo por sexo y ancestría
contingency_table <- table(popinfo$Sex_clean, popinfo$Ancestry)

# Mostrar en consola
print(contingency_table)


