getwd()


ruta.data<- "Escritorio/Bioinformatica/Tareas_BioinfRepro2025_AAQ/Tarea_1.3/PracUni1Ses3/maices/meta/maizteocintle_SNP50k_meta_extended.txt"
meta_maiz <- read.table(ruta.data, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
print(meta_maiz)
#cuando se carga el archivo se crea un dataframe

#primeras 6 filas
head(meta_maiz, 6)

#cantidad de muestras
nrow(meta_maiz)

#cantidad de estados
length(unique(meta_maiz$Estado))

#muestras recolectadas antes de 1980
sum(meta_maiz[["A.o._de_colecta"]] < 1980,  na.rm = TRUE)
n_antes_1980 <- sum(meta_maiz$A.o._de_colecta < 1980)

#conteo de razas
table(meta_maiz$Raza)
conteo_razas <- table(meta_maiz$Raza)
print(conteo_razas)

#promedio de altura recolectadas
mean(meta_maiz$Altitud, na.rm = TRUE)

#maxima y minima actitud
max_altitud <- max(meta_maiz$Altitud, na.rm = TRUE)
cat("Altitud máxima:", max_altitud)
min_altitud <- min(meta_maiz$Altitud, na.rm = TRUE)
cat("Altitud mínima:", min_altitud)


#dataframe solo con los datos de Olotillo
olotillo.df <- subset(meta_maiz, Raza == "Olotillo")


#dataframe para la raza Reventador, Jala y Ancho
razas <- c("Reventador", "Jala", "Ancho")
muestras_filtradas <- subset(meta_maiz, Raza %in% razas)

#Creacion de archivo csv, ojo que se debe cambiar la ruta absoluta a conveniencia
write.csv(muestras_filtradas, file = "Escritorio/Bioinformatica/Tareas_BioinfRepro2025_AAQ/Tarea_1.3/PracUni1Ses3/maices/meta/muestras_seleccionadas.csv", row.names = FALSE)
