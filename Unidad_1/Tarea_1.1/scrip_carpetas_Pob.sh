##script para crear directorios PobA, PobB, PobC y PobD y dentro de cada uno un archivo de texto que dice "Este es un individuo de la poblacion x)
#este comando creo las cuatro carpetas Pob y los archivos de texto correspondientes en cada carpeta
#el comado funciona y cera lo solicitado pero arroja el siguiente error "mv: no se puede efectuar `stat' sobre 'pobC': No existe el archivo o el directorio", lo logre descifrar por qué
for i in A B C D;do mkdir Pob$i;  echo "Este es un individuo de la poblacion Pob$i" >pob$i ; mv pobA ./PobA ; mv pobB ./PobB ; mv pobC ./PobC ; mv pobD ./PobD  ; done




