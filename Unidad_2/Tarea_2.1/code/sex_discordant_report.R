#Ejecutar el script desde la carpeta code
setwd("/home/ahumada_quintanilla/Escritorio/Bioinformatica/Tareas_BioinfRepro2025_AAQ/Unidad_2/Tarea_2.1/code")
# Leer archivo generado por PLINK
sexcheck <- read.table("../results/chilean_all48_hg19_sex_check.sexcheck", header = TRUE)

# Filtrar los que tienen discordancia
discordant <- subset(sexcheck, STATUS == "PROBLEM")

# Seleccionar columnas clave para el reporte
report <- discordant[, c("FID", "IID", "PEDSEX", "SNPSEX", "F")]

# Renombrar columnas para claridad
colnames(report) <- c("FamilyID", "IndividualID", "Sex_FAM", "Sex_PLINK", "X_Fstat")

# Guardar como CSV para revisión
write.csv(report, "../results/sex_discordances_report.csv", row.names = FALSE)

  # Mostrar resumen por consola
cat("Número de individuos con discordancia de sexo:", nrow(report), "\n\n")
print(report)
