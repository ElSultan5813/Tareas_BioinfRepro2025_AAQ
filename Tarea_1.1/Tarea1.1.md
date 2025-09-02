#codigo para crear un archivo de texto que enlista las muestras de maiz
#Estando en: /home/ahumada_quintanilla/Escritorio/BioinfinvRepro-master/Unidad1/Sesion1/Prac_Uni1/Maiz
#se ejecuta el siguiente comando:
cat nuevos_final.fam *log > nombres_muestras_maiz.txt

##script para crear directorios PobA, PobB, PobC y PobD y dentro de cada uno un archivo de texto que dice "Este es un individuo de la poblacion x)
#este comando creo las cuatro carpetas Pob y los archivos de texto correspondientes en cada carpeta
#el comando funciona y cera lo solicitado pero arroja el siguiente error "mv: no se puede efectuar `stat' sobre 'pobC': No existe el archivo o el directorio", lo logre descifrar por qué
for i in A B C D;do mkdir Pob$i;  echo "Este es un individuo de la poblacion Pob$i" >pob$i ; mv pobA ./PobA ; mv pobB ./PobB ; mv pobC ./PobC ; mv pobD ./PobD  ; done


#!/bin/bash
##script para bajar las secuencias el NCBI y analizar la secuencia TGCA
#crear carpeta para el guardado de las secuencias
mkdir E.coli

#Descarga todas las secuencias juntas desde el ncbi
curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&rettype=fasta&id=HQ833340.1,OL457181.1,PQ656130.1,FN297865.1,GQ925859.1" > E.coli/tolCluxSgyrBlacZlacY.fasta

#comando para buscar la secuencia TGCA
grep -i  "tgca" E.coli/tolCluxSgyrBlacZlacY.fasta
grep -i -o  "tgca" E.coli/tolCluxSgyrBlacZlacY.fasta | wc -l



#Según la búsqueda realizada en internet la secuencia TGCA no tiene una función aparente en el genoma, sino que es el el programa The Cancer Genome Atlas, una herramienta en linea que cataloga alteraciones genómicas del cáncer

