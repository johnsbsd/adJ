adJ
===

Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos 
y Educativas y que anhelamos que Jesús use durante el Milenio.


Concepto de estas fuentes
-------------------------

Estas fuentes buscan expresar brevemente los cambios por hacer a las fuentes de OpenBSD (y al sistema donde está desarrollando) para obtener adJ.  Una vez transformado puede compilar para generar juegos de distribución, instalador y el DVD de distribución de adJ.


Prerequisitos
-------------

1. Computador con procesador de 64 bits.
2. OpenBSD o adJ para 64 bits instalados.
3. Fuentes de la versión de OpenBSD que usa descargadas e instaladas en ```/usr/src```, ```/usr/src/sys```, ```/usr/ports``` y ```/usr/xenocara```
4. Desde github bifurque (fork) la rama de la versión que desea del repositorio https://github.com/pasosdeJesus/adJ.  La versión estable ya publicada 5.6 está en la rama ```ADJ_5_6``` y la versión en desarrollo --que sera 5.7-- esta en la rama ```master```. Para apoyar desarrollo de OpenBSD por un periodo de tiempo proponemos cambios a la rama ```current``` de OpenBSD desde la rama ```OBSD_CURRENT```.
5. Clone su bifuración a su directorio preferido, (cambie en el siguiente ejemplo ```pasosdeJesus``` por su usuario en github y ```ADJ_5_6``` por ```master``` si prefier trabajar sobre la versión en desarrollo o por ```OBSD_CURRENT``` si prefiere trabajar sobre la versión para ```current``` de OpenBSD):
```
mkdir ~/comp; cd ~/comp; git clone -b ADJ_5_6r git://github.com/pasosdeJesus/adJ.git
```


Organización de fuentes
-----------------------

- ```arboldvd```   Directorios y archivos de un DVD instalador
- ```arboldd```    Directorios y archivos de un adJ instalado
- ```arboldes```   Directorios, archivos y parches para desarrollar adJ
- ```distribucion.sh```	Archivo de comandos para generar distribución
- ```hdes```       Herramientas de desarrollo
- ```pruebas```    Scripts que ayudan a hacer pruebas
- ```tminiroot```  Transforma instalador que va en DVD a español
- ```ver.sh```     Valores por defecto que controlan distribucion.sh
- ```ver-local.sh```		Personalización de ver.sh



Pasos típicos para desarrollar
------------------------------

Muchas de las operaciones típicas se controlan activando o desactivando pasos 
que el archivo de comandos ```distribucion.sh``` hará.  Los pasos se 
activan/desactivan en el archivo ```ver-local.sh``` (si no tiene uno ejecute 
```cp ver-local.sh.plantilla ver-local.sh```), activa un paso poniendo ```s``` 
en la variable asociada y lo desactiva poniendo ```n```.

* Enlace ```arboldes/usr/ports/mystuff``` en ```/usr/ports/mystuff```:  
	```
	sudo ln -s ~/comp/adJ/usr/ports/mystuff /usr/ports
	```
* Actualice fuentes de ```/usr/src``` (con periodicidad) para mezclar cambios de OpenBSD activando ```autoCVS``` en ```ver.sh``` y ejecutando:
	```
	sudo ./distribucion.sh
	```
* Implemente mejoras a ```/usr/src``` bien como archivos de comandos (por ubicar en ```hdes/``` o en ```arboldd/usr/local/adJ```) que son llamados por ```distribucion.sh``` y hacen cambios automáticos  o bien como parches (se ubican en ```arboldes/usr/src```)
* Actualice/mejore portes o cree nuevos en ```arboldes/usr/ports/mystuff```.  Al agregar o retirar actualizar ```distribucion.sh```
* Mejore programas especiales distribuidos en adJ y los portes asociados
* Actualice manuales básico, escritorio y cortafuegos/servidor, así como los portes asociados
* Compile fuentes y portes siguiendo pasos de ```distribucion.sh``` cambiando paulatinamente variables ```auto*``` en ```ver.sh```: transforme y compile kernel (```autoKernel```), instalelo (```autoInsKernel```), transforme y compile base (```autoCompBase```), instale y genere ```.tgz``` del sistema base (```autoDist```), genere ```bsd.rd``` (```autoBsdrd```), transforme y compile Xenocara (```autoX```), instale y genere ```.tgz``` de Xenocara (```autoXDist```), copie juegos de instalación a subdirectorio de la forma ```5.x-amd64``` (```autoJuegosInst```), compile portes particulares (```autoPaquetes```), descargue otros paquetes de repositorio (```autoMasPaquetes```), genere el juego de instalación ```siteXX.tgz``` empleando ```arboldd``` y listado ```lista-site``` (```autoSite```), genere textos en el instalador (```autoContenido```)
* Una vez con juegos de instalación, paquetes y textos listos en subdirectorio ```5.x-amd64``` genere imagen ISO con: 
	```
	sudo hdes/creaiso.sh
	```
* Pruebe ISO con QEMU, primero arrancando desde CD (en ```ver-local.sh``` ponga ```qemuboot=d```) con: 
	```hdes/qemu.sh```
	Si no existe creara una máquina virtual ```virtual.vid```.  Después de instalar en la máquina virtual pruebe arrancando desde disco (en ```ver-local.sh``` ponga ```qemuboot=c```).   Si prefiere ejecutar en modo texto (por ejemplo remotamente es rápido): 
	```TEXTO=1 dhes/qemu.sh```
* Envie sus mejoras al repositorio en github.com.  Respecto a ramas (branches) y etiquetas (tags), ponemos una etiqueta cada vez que publicamos en http://aprendiendo.pasosdeJesus.org (e.g ```v5.6p1```), y mantenemos una rama para cada versión mayor publicada (e.g ```ADJ_5_6```) en la que eventualmente se aplicarán actualizaciones de seguridad para esa versión, la versión en desarrollo se mantiene en la rama ```master```.
* Para aportar mejoras a OpenBSD procuramos crear parches que se apliquen limpiamente --pero en orden-- sobre la respectiva versión de OpenBSD en ```hdes/src/```.

