# Lista de comandos Curso Bioinformactica

ssh -Y bioinfo1@genoma.med.uchile.cl
Password: n0TALca

pwd : Directorio de trabajo (donde estoy)
cd .  : donde estoy ahora o para bajar en el directorio
cd .. : Sube un nivel en el directorio
cd "NOMBRE DIRECTORIO" : me mueve hacia los directorios
$ indica que son varibales

ls : muestra los archivos que hay en un directorio
ls -l : muestra mas detalles de los archivos
ls -a : muestra los archivos ocultos
ls -lt ordena los archivos por fecha
man ls : abre el manual de ls

* : sirve para buscar o filtar cosas, dependiedo de is esta a la izquierda o derecha del *, el comando buscara eso
  [] : sirve para agrupar terminos de busqueda, ej: [a-z] y acompaña al *

grep : sirve para buscar cosas especificas en un archivo de texto (como buscar sitios de restriccion en una secuencia de dna)

less : permite ver archivos (su contenido)
head : muestra las primeras lineas de un archivo
trail : muestra las ultimas lineas de un archivo
wc: da el numero de lineas, palabra y caracteres de un archivo
cat: viene de "concatenate" y serve para juntar archivos

cp -r : copia un archivo o directorio
mv : mueve archivo de A a B, ejemplo: $ mv ../Prueba ../Manzanas
rm -r : borra archivos o directorios
tar : utilizado  para comprimir archivos (mucho)

touch : crea archivos de texto vacios
nano : creo archivos de texto que se puede editar directamente de la consola
vim : hace algo parecido a nano

curl : descarga archivos desde internet, incluso desde GenBank
wget ; hace lo mismo que curl pero crea un archivo con la descarga

grep : se utiliza para buscar cosas en un archivo o directorio

chmod : se usa para cambiar los permisos de un archivo, ej: volverlo ejecutable

which : sirve para buscar rutas de archivos

EN windows las rutas absolutas parten con la letra del disco duro seguido de la direccion

mkdir : crea directorios (carpetas)
rmdir : remueve o borra directorios

LAs variables que se van formando se creal localmente, hay que exportarlas para que esten disponibles para todos

export : envia las variables a las terminales o directorios que son hijos del actual

para que las variables sean permanetes se deben guardar en un archivo que se cargue al iniciar la sesion

para ejecutar comandos hay dos formas, darle la ruta o que este incluido en el PATH

scp : Protocolo de copia segura



## Uso de Git

git config --global --edit  :  Permite configurar el usuario y correo
git status  :  Permite ver el estatus del repositorio local (en que rama estoy trabajando)
git add  :  Te permite agregar un archivo que no existía en el repositorio o prepara las modificaciones a archivos existentes. Esto no lo "guarda" (commit), solo hace que "lo sigas". Si modificas un archivo es necesario que vuelvas a dar add.
git commit  :  Confirma y agrega los cambios a la branch en la que estas trabajando. Utiliza la flag -m para escribirun mensaje breve. 
git diff   :  Para ver los cambios que se hicieron a un archivo.
git rm  :  Si quieres borrar un archivo que ya había formado parte de un commit no sólo de tu compu sino del sistema de versiones de git, lo mejor es NO utilizar rm, sino git rm
git push  :  Una vez que quieres integrar tus cambios a una rama, este comando te permite fusionar ramas. Debes decirle el origen (rama donde hiciste los commits) y el destino (por ejemplo master u otra rama).



#Para subir cosas al git hub tuviste que cambiar de https a formato ssh, de esta forma no pide clave
Comando para cambiar el modo :  git remote set-url origin git@github.com:ElSultan5813/Tareas_BioinfRepro2025_AAQ.git
