COMO PUBLICAR
=============

Anhelamos publicar versión mayor (e.g 6.4) 3 meses después de OpenBSD:

	11.Ene
	1.Jul

También publicamos revisiones (e.g 6.4p1) si la seguridad o calidad lo ameritan.

Anhelamos publicar al menos una versión beta (e.g 6.4b1 en directorio
```desarrollo``` del sitio de distribución) en:

	10.Dic
	10.Jun

Sería ideal publicar una versión alfa mucho antes (24.Sep y 24.Mar, e.g 6.4a1).


Pasos importantes para publicar versión beta
--------------------------------------------

1. Actulizar parches de locale y xlocale de forma que puedan aplicarse
   sobre la nueva versión de OpenBSD.
2. Recompilar kernel, perl, sistema base y asegurar que puede crearse una 
   distribución inicial 
3. Recompilar paquetes con actualizaciones de seguridad o mejoras
4. Retroportar paquetes, dejar resultados no incluidos en DVD pero
   útiles en 6.4-amd64-extra
5. Cambiar versión en ver.sh, arboldd/usr/local/adJ/inst-adJ.sh, Actualiza.md,
	ComoPublicar.md, {$V-amd64,arboldvd}/util/preact-adJ.sh, Novedades.md,
	{$V-amd64,arboldvd}/util/actbase.sh, 
6. Retocar ```Dedicatoria.md``` y archivos *.md (por lo menos versión),
   regenerar en distribución (sin paquetes ni otras compilaciones) con:
	```
	doas ./distribucion.sh
	```
7. Retocar fecha de publicacion en ```Novedades.md``` y publicar escondido en
   http://aprendiendo.pasosdeJesus.org
8. Generar distribución, imagen iso (```hdes/creaiso.sh```)
9. Probar por ejemplo en ```qemu``` (```hdes/qemu.sh``` o remotamente 
  ```TEXTO=1 hdes/qemu.sh```): 
- Instalación de sistema base, `uname -a` debe reportar APRENDIENDODEJESUS
- Verificar que kernel tiene renombramiento de daemon por servicio con:
	$  vmstat -s | grep servicio
          	4 pages reserved for pageservicio
          	0 number of times the pageservicio woke up
          	0 pages freed by pageservicio
          	0 pages scanned by pageservicio
          	0 pages reactivated by pageservicio
          	0 busy pages found by pageservicio

- Verificar que se usa la bitácora /var/log/servicio:
	$ ls -lat /var/log/servicio  
		-rw-r-----  1 root  wheel  149983 Sep 19 18:48 /var/log/servicio

- Verificar que libc incluye funciones de locale por ejemplo editando
  un archivo `l.c` con el siguiente contenido, tras compilar con `cc -o l l.c`
  y ejecutar con `./l` el resulado debería ser `1.000.000,200000`:
```
#include "locale.h"  
#include "stdio.h"
int main() {  
  setlocale(LC_ALL, "es_CO.UTF-8");
  printf("%'f", 1000000.2);

  return 0;
}
```
- Operación de locale numeric en perl. El siguiente programa en perl debe 
  dar respuesta 1987,23:
```perl
# Basado en http://perldoc.perl.org/perllocale.html
use locale;
use POSIX qw(locale_h);
setlocale(LC_NUMERIC, "es_CO.UTF-8") or die "No pone locale LC_NUMERIC en es_CO.UTF-8";                                                        
my $a = 1987.23;
printf "%g\n", $a;
```
- Con paquete colorls modificado y actualizado, verificar cotejacion en español:
  touch a
  touch í
  touch o
  ls -l
  Debe mostrar los directorios en orden alfabético correcto (í entre a y o).
- Con paquete postgresql modificado y actualizado, verificar que coteja
  en español con:
doas su - _postgresql
```sh
cat > /tmp/cot.sql <<EOF
SELECT 'Á' < 'B' COLLATE "es_co_utf_8";
EOF
psql -h /var/www/var/run/postgresql/ -Upostgres -f /tmp/cot.sql
```
  que debe responder con
```
 ?column?
----------
 t
(1 row)
```
- ejecución de /inst-adJ.sh en nuevo y actualización, 
- ejecución de /usr/local/adJ/inst-sivel.sh, que opere SIVeL1.2,
- que toda entrada del menú desde la interfaz gráfica opere.  
- que opere bien una aplicación Ruby on Rails
  Arreglar y repetir hasta que no haya errores.
10. En computador de desarrollo tras configurar ```var-local.sh``` enviar a
   adJ.pasosdeJesus.org:
	```
	hdes/rsync-aotro.sh
	```
11. En adJ.pasosdeJesus.org
	```
	hdes/creaiso.sh
	cp -rf AprendiendoDeJesus-6.4-amd64.iso 6.4-amd64 /dirftp
	mkdir /dirftp/6.4-amd64-extra
	rsync compdes:comp/adJ/extra-6.4/* /dirftp/6.4-amd64-extra
	```
12. Verificar operación de:
  * http://pasosdeJesus.github.io/basico_adJ http://pasosdeJesus.github.io/usuario_adJ http://pasosdeJesus.github.io/servidor_adJ
  * http://sivel.sf.net/
  * http://aprendiendo.pasosdeJesus.org
  * http://www.pasosdeJesus.org
  * http://adJ.pasosdeJesus.org
  * rsync://adJ.pasosdeJesus.org

13. Poner Tag en github e iniciar rama al publicar version beta (antes en master)
	```
	git tag -a v6.4a1 -m "Version 6.4b1"
	git push origin v6.4b1
	...
	git checkout -b ADJ_6_4
	git push origin ADJ_6_4
	```
14. Publicar en lista de desarrollo

Pasos importantes para publicar versión mayor
--------------------------------------------

1. Usar la rama ADJ_6_4
	git checkout ADJ_6_4
2. Actualizar SIVeL, evangelios, Mt77, cor1440, sal7711 y paquetes propios de 
   adJ.
3. Actualizar documentación (basico_adJ, usuario_adJ y servidor_adJ), 
   publicar en Internet
4. Actualizar versión en logo que presenta xenodm
5. Análogo a pasos de versión beta
6. Actualizar version en reto de P2PU (las 4 primeras tareas) 
   https://p2pu.org/es/groups/openbsd-adj-como-sistema-de-escritorio/
7. Actualizar Artículo como Noticia en http://aprendiendo.pasosdeJesus.org,
   http://aprendiendo.pasosdejesus.org/?id=MainMenu,  
8. Poner Tag en github
	```
	git tag -a v6.4 -m "Version 6.4"
	git push origin v6.4
	```
9. Publicar en Twitter que retrasnmite a cuenta y página en Facebook. 
   Si es tambien publicacion de SIVeL en sitio de noticias de SIVeL y Structio.

	Publicado adJ 6.4 distribución para servidores y cortafuegos, 
	segura, amigable para cristian@s y en español, ver 
	http://aprendiendo.pasosdejesus.org/
10. Correo a listas: 
    openbsd-colombia@googlegroups.com, 
    openbsd-mexico@googlegroups.com, sivel-soporte@lists.sourceforge.net

	Tema: Publicado adJ 6.4 para amd64

	Para instalar por primera vez descarga la imagen para DVD de:
	  http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/
	O solicita un DVD o una USB de instalacion por correo postal.

	Si planeas actualizar de una version anterior a 6.4
	hay un procedimiento mas rápido con ```rsync``` (ver
	https://github.com/pasosdeJesus/adJ/blob/master/Actualiza.md ).

	Si no tienes experiencia con esta distribución de OpenBSD para 
	servidores y cortafuegos, que es segura, usable en español y amigable 
	para cristian@s, puedes aprender a instalar o actualizar con:
	  1. El curso/reto que da una medalla a quienes completen:
	  https://p2pu.org/es/groups/openbsd-adj-como-sistema-de-escritorio/
	  2. La guía de instalación:
	  http://pasosdeJesus.github.io//usuario_adJ/sobre-la-instalacion.html

	Mira las novedades completas de la versión 6.4 en:
	  http://aprendiendo.pasosdejesus.org/?id=AdJ+6.4+-+Aprendiendo+de+Jesus+6.4

	De estas destacamos:
	...

	Bendiciones

11. Actualiza artículos de Wikipedia 
   https://en.wikipedia.org/wiki/AdJ y https://es.wikipedia.org/wiki/AdJ 

12. Publicar noticia en http://sivel.sf.net y en  http://structio.sf.net

