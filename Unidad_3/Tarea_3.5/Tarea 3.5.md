# Tarea 3.5

Se cambiaron los campos necesarios del script para poder ser ejecutados con mis muestras asignadas, las cual es la muestra S3 (R1 y R2)

sarek_germinal.sh

```
#!/bin/bash

# Ejecuta nf-core/sarek en modo GERMINAL para una sola muestra (normal/germinal).
# Uso:
#   A) Nombre de muestra automático (recomendado para alumnos):
 bash sarek_germinal.sh /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R1.fastq.gz /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R2.fastq.gz /home/bioinfo1/aahumada/Unidad_3/Tarea_3.5/results

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
 bash sarek_germinal.sh /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R1.fastq.gz /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R2.fastq.gz /home/bioinfo1/aahumada/Unidad_3/Tarea_3.5/results
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
bash sarek_germinal.sh /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R1.fastq.gz /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R2.fastq.gz ../results

bash sarek_germinal.sh /home/elsultan/Desktop/S3_R1.fastq.gz /home/elsultan/Desktop/S3_R2.fastq.gz ../results

```

```
bash sarek_somatic.sh /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R1.fastq.gz /home/bioinfo1/181004_curso_calidad_datos_NGS/fastq_raw/S3_R2.fastq.gz ../results
```

Para ejecutar estos scrpts se utilizo el comando screen
[detached from 104533.pts-6.genoma]
