# Tarea 3.5

Alejandro Ahumada Quintanilla

# Introduccion

En esta terea se realizara un analisis usando el programa nf-core/sarek, el cual nos permitira comparar las variantes encontradas entre el modo germinal y el modo somatico. Dentro de este informe se inculiran imagenes de referencia de los analisis realizados y de los resultados obtenidos.
Luego de tener algunos problemas para ejectar los scripts logre solucionarlos y ejecutarlos correctamente

# Metodologia

Se cambiaron los campos necesarios del script para poder ser ejecutados con mis muestras asignadas, las cual es la muestra S3 (R1 y R2)

sarek_germinal.sh

```
#!/bin/bash

# Ejecuta nf-core/sarek en modo GERMINAL para una sola muestra (normal/germinal).
# Uso:
#   A) Nombre de muestra automático (recomendado para alumnos):
# bash sarek_germinal.sh /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R1.fastq.gz /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R2.fastq.gz /home/bioinfo1/aahumada/Unidad_3/Tarea_3.5/results

#   B) Nombre de muestra explícito:
#        bash sarek_germinal.sh R1.fastq.gz R2.fastq.gz /ruta/output nombre_muestra
#
# El script crea internamente un samplesheet CSV como requiere nf-core/sarek
# y luego llama a:
#   nextflow run nf-core/sarek --input samplesheet.csv ...

if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]; then
    echo "Uso: bash sarek_germinal.sh /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R1.fastq.gz /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R2.fastq.gz /home/bioinfo1/aahumada/Unidad_3/Tarea_3.5/results sarek_$
    exit 1
fi

R1=$1
R2=$2
OUT=$3

mkdir -p "$OUT"

# Si se entrega un cuarto argumento, se usa como nombre de muestra
if [ "$#" -eq 4 ]; then
    SAMPLE=$4
else
    # Detección automática del nombre de muestra desde R1
    base=$(basename "$R1")

    # Elimina sufijos comunes de R1
    sample=${base%%_R1.fastq.gz}
    sample=${sample%%_R1.fq.gz}
    sample=${sample%%_1.fastq.gz}
    sample=${sample%%_1.fq.gz}
    sample=${sample%%.fastq.gz}
    sample=${sample%%.fq.gz}

    SAMPLE=$sample
    echo "Detectado nombre de muestra automáticamente: ${SAMPLE}"
fi

# Intentar obtener rutas absolutas (si readlink -f está disponible)
if command -v readlink >/dev/null 2>&1; then
    R1_ABS=$(readlink -f "$R1")
    R2_ABS=$(readlink -f "$R2")
else
    R1_ABS="$R1"
    R2_ABS="$R2"
fi
SHEET="${OUT}/samplesheet_germline_${SAMPLE}.csv"

echo "Creando samplesheet: $SHEET"
cat > "$SHEET" <<EOF
patient,sex,status,sample,lane,fastq_1,fastq_2
${SAMPLE},NA,0,${SAMPLE},L1,${R1_ABS},${R2_ABS}
EOF

echo "Lanzando nf-core/sarek en modo germinal..."
nextflow run nf-core/sarek \
    --input "$SHEET" \
    --genome GATK.GRCh38 \
    --outdir "$OUT" \
    --tools haplotypecaller \
    -profile singularity \
      -c /home/bioinfo1/aahumada/Unidad_3/Tarea_3.5/code/local_sarek_8cpus.config \
    -resume
```

sarek_somatic.sh

```
#!/bin/bash
# Ejecuta nf-core/sarek en modo SOMÁTICO (tumor-only).
# Uso:
#   A) Nombre de muestra automático:
# bash sarek_germinal.sh /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R1.fastq.gz /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R2.fastq.gz /home/bioinfo1/aahumada/Unidad_3/Tarea_3.5/results
#   B) Nombre de muestra explícito:
#        bash sarek_somatic.sh R1.fastq.gz R2.fastq.gz /ruta/output nombre_muestra
#
# El script crea internamente un samplesheet CSV como requiere nf-core/sarek.

if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]; then
    echo "Uso:  bash sarek_germinal.sh /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R1.fastq.gz /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R2.fastq.gz /home/bioinfo1/aahumada/Unidad_3/Tarea_3.5/results sarek$
    exit 1
fi

R1=$1
R2=$2
OUT=$3

mkdir -p "$OUT"

# Si se entrega un cuarto argumento, se usa como nombre de muestra
if [ "$#" -eq 4 ]; then
    SAMPLE=$4
else
    base=$(basename "$R1")

    sample=${base%%_R1.fastq.gz}
    sample=${sample%%_R1.fq.gz}
    sample=${sample%%_1.fastq.gz}
    sample=${sample%%_1.fq.gz}
    sample=${sample%%.fastq.gz}
    sample=${sample%%.fq.gz}

    SAMPLE=$sample
    echo "Detectado nombre de muestra automáticamente: ${SAMPLE}"
fi

# Rutas absolutas
if command -v readlink >/dev/null 2>&1; then
    R1_ABS=$(readlink -f "$R1")
    R2_ABS=$(readlink -f "$R2")
else
    R1_ABS="$R1"
    R2_ABS="$R2"
fi

SHEET="${OUT}/samplesheet_somatic_${SAMPLE}.csv"
echo "Creando samplesheet: $SHEET"
cat > "$SHEET" <<EOF
patient,sex,status,sample,lane,fastq_1,fastq_2
${SAMPLE},NA,1,${SAMPLE},L1,${R1_ABS},${R2_ABS}
EOF

echo "Lanzando nf-core/sarek en modo somático (tumor-only)..."
nextflow run nf-core/sarek \
    --input "$SHEET" \
    --genome GATK.GRCh38 \
    --outdir "$OUT" \
    --tools mutect2 \
    -profile singularity \
    -c /home/bioinfo1/aahumada/Unidad_3/Tarea_3.5/code/local_sarek_8cpus.config \
    -resume
```

los comandos se ejecutaron desde /home/bioinfo1/aahumada/Unidad_3/Tarea_3.5/code

Los comandos para ejecutar los scripts fueron

```
bash sarek_germinal.sh /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R1.fastq.gz /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R2.fastq.gz ../result_germinal
```

```
bash sarek_somatic.sh /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R1.fastq.gz /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R2.fastq.gz ../results_somatic
```

# Resultados

Los resultados obtenidos se representan a continuacion
Se logro ejecutar el script y arrojo los siguientes resultados
![](./img/7.png)
![](./img/8.png)
![](./img/9.png)
![](./img/10.png)
![](./img/11.png)

### Analisis germinal

Ruta del archivo
[result_somatic](./result_germinal/multiqc)

### Analisis somatico

Ruta del archivo
[result_somatic](./result_somatic/multiqc)

### Imagenes del resultado multiqc

Las imagenes a continuacion son una referencia de los datos obtenidos en el multiqc, para ambos analisis, somatico y germinal el miltiqc es exactamente igual
![](./img/1.png)
![](./img/2.png)
![](./img/3.png)
![](./img/4.png)
![](./img/5.png)
![](./img/6.png)

### Comparacion entre analisis germinal y somatico

para realizar estas comparaciones se utilizo la herramienta bcftools, en particular se uso el comando

```
##realiza comparaciones entre los archivos S3.haplotypecaller.filtered.vcf.gz (germinal) y S3.mutect2.filtered.vcf.gz (somatico)
bcftools isec /home/elsultan/Desktop/Tareas_BioinfRepro2025_AAQ/Unidad_3/Tarea_3.5/result_germinal/variant_calling/haplotypecaller/S3/S3.haplotypecaller.filtered.vcf.gz /home/elsultan/Desktop/Tareas_BioinfRepro2025_AAQ/Unidad_3/Tarea_3.5/result_somatic/variant_calling/mutect2/S3/S3.mutect2.filtered.vcf.gz -p comparacion_somatic_germinal
##visualiza los archivos por comparaciones
#00000 indica variantes unicas en el archivo 1
#00001 indica las variantes unicas en el archivo 2
#00002 indica las variantes comunes en ambos archivos
#00003 indica las variantes totales
 bcftools view 0000.vcf 
 bcftools view 0001.vcf 
 bcftools view 0002.vcf 
 bcftools view 0003.vcf 
##luego se cuentan las variantes comunes entre ambos archivos
 grep -c "^#" -v 0002.vcf
```

Visualizacion de la cantidad de variantes en cada archivo vcf obtenido de la comparacion
![](./img/14.png)
Visualizacion de las variantes comunes 
![](./img/12.png)
![](./img/13.png)

# Busqueda de algunas variantes comunes

Se busco algunas de las variantes que presentaban ID en las bases de datos OncoKB y gnomAD

- rs12621129 (gnomAD)
  Esta variante recae en 4 transcripciones de 1 gen.
  ![](./img/15.png)
  ![](./img/16.png)
  ![](./img/17.png)

- rs788019 (gnomAD)
  This variant falls on 5 transcripts in 1 gene. 
  ![](./img/18.png)
  ![](./img/19.png)
  ![](./img/20.png)

- rs699318 (gnomAD)
  This variant falls on 6 transcripts in 1 gene.
  ![](./img/21.png)
  ![](./img/22.png)
  ![](./img/23.png)

- rs1492765 (gnomAD)
  This variant falls on 4 transcripts in 2 genes. 
  ![](./img/24.png)
  ![](./img/25.png)
  ![](./img/26.png)

- rs2229307    (OncoKB)
  Efecto desconocido
  ![](./img/27.png)

- rs773239394 (OncoKB)
  Efecto desconocido
  ![](./img/28.png)

- rs1933437 (OncoKB)
  Efecto desconocido
  ![](./img/29.png)

# Discusion y conclusiones

De estas busquedas rapidas realizadas en ambas bases de datos, las variantes germinales estan mejor anotadas en la base de datos gnomAD y en general estan mejor estudiadas
  ![](./img/30.png)
Por otro lado, como se ve en la imagen anterior, las variantes somaticas que se filtraron no presentan numeros ID de referencia, y al buscarlas en la base de datos de oncoKB, la gran mayoria no se encuentran anotadas o tienen un efecto desconocido.

En conclusion el analisis realizado por el programa nf-core/sarek es sumamente util, ya que el mismo programa entrega resultados del control de calidad por cada muestra (R1 y R2) y ademas un multiqc que mezcla ambos y entrega un informe completo comparando las calidades de ambas mueestras, ademas permite ahorrar tiempo en los flujos de trabajo, ya que permite obtener varios resultados a la vez, ademas del resultado de qc permite obtener las variantes y las variantes ya filtradas
