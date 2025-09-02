#!/bin/bash
##script para bajar las secuencias el NCBI y analizar la secuencia TGCA
#crear carpeta para el guardado de las secuencias
mkdir E.coli

#Descarga todas las secuencias juntas desde el ncbi
curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&rettype=fasta&id=HQ833340.1,OL457181.1,PQ656130.1,FN297865.1,GQ925859.1" > E.coli/tolCluxSgyrBlacZlacY.fasta

#comando para buscar la secuencia TGCA
grep -i  "tgca" E.coli/tolCluxSgyrBlacZlacY.fasta
grep -i -o  "tgca" E.coli/tolCluxSgyrBlacZlacY.fasta | wc -l



