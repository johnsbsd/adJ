#!/bin/sh
# Preparar para actualizar un Aprendiendo de Jesús 
# Dominio público de acuerdo a legislación colombiana. http://www.pasosdejesus.org/dominio_publico_colombia.html. 
# 2014. vtamara@pasosdeJesus.org

VER=5.9
REV=0
VESP="b1"
VERP=59

ACVERC=`uname -r`
ACVER=`echo $ACVERC | sed -e "s/\.//g"`
ARQ=`uname -m`
u=`whoami`
if (test "$u" != "root") then {
	echo "Este script debe ser ejecutado por root o con sudo";
	exit 1;
} fi;

mkdir -p /var/tmp
if (test "$?" != "0") then {
	echo "No pudo crearse directorio /var/tmp para la bitácora";
	exit 1;
} fi;

echo "-+-+-+-+-+-+" >> /var/tmp/preact-adJ.bitacora
echo "Script de preactualización de adJ $VER ($ARCVER, $ARQ)" >> /var/tmp/preact-adJ.bitacora
echo "---------------------------- " >> /var/tmp/preact-adJ.bitacora
echo "Se recomienda ejecutarlo desde una terminal en X-Window" >> /var/tmp/preact-adJ.bitacora

l=`ls /var/db/pkg/ | grep "^dialog-"`
if (test "$l" = "") then {
	echo "El paquete dialog es indispensable";
	exit 1;
} fi;

dialog --title 'Prepara actualización' --msgbox "\\nPor preparar actualización de $ACVERC a $VER\\n" 15 60
vac="";
mac="";

if (test -f /$RUTAIMG/post.img) then {
	echo "Existe imagen para datos encriptados de PostgreSQL /$RUTAIMG/post.img. " >> /var/tmp/preact-adJ.bitacora
	echo "Suponiendo que la base PostgreSQL tendrá datos encriptados allí" >> /var/tmp/preact-adJ.bitacora
	postencripta="s";
} fi
clear;


sh /etc/rc.local >> /var/tmp/preact-adJ.bitacora 2>&1; # En caso de que falte montar bien

if (test "$postencripta" = "s") then {
	echo "* Montar imagenes encriptadas durante arranque" >> /var/tmp/preact-adJ.bitacora;
	activarcs montaencres
	activarcs montaencpos

} fi; #postencripta

uspos='postgres'; # Antes de 4.1 era _postgresql

acuspos="-U$uspos"

# Codificacion por defecto en versiones hasta 5.0
dbenc="LATIN1";

if (test "$SOCKPSQL" != "") then {
  sockpsql="$SOCKPSQL";
} else {
  sockpsql="/var/www/var/run/postgresql"
} fi;
echo "* Detectando socket de PostgreSQL en $sockpsql" >> /var/tmp/preact-adJ.bitacora
# Detectar socket de PostgreSQL
if (test ! -S "$sockpsql/.s.PGSQL.5432") then {
  echo "* No se encontró socket de PostgreSQL en $sockpsql">> /var/tmp/preact-adJ.bitacora;
  sockpsql="/var/www/tmp"
  echo "* Detectando socket de PostgreSQL en $sockpsql" >> /var/tmp/preact-adJ.bitacora
  if (test ! -S "$sockpsql/.s.PGSQL.5432") then {
    echo "* Tampoco se encontró socket de PostgreSQL en $sockpsql" | tee -a /var/tmp/preact-adJ.bitacora;
    echo "* Puede ejecutar especificando la ruta del socket de PostgreSQL en variable SOCKPSQL";
    exit 1;
  } fi;
} fi;

echo "* De requerirlo sacar respaldo de datos" >> /var/tmp/preact-adJ.bitacora
pgrep post > /dev/null 2>&1
if (test "$?" = "0") then {
	echo -n "psql -h $sockpsql $acuspos -c \"select usename from pg_user where usename='postgres';\"" > /tmp/cu.sh
       	su - _postgresql /tmp/cu.sh
	if (test "$?" != "0") then {
		us='_postgresql';
		acus="-U$uspos";
	} fi;

	nb=1;
	while (test -f /var/www/resbase/pga-$nb.sql) do
		nb=`expr $nb + 1`;
	done;
	dialog --title 'Respaldo de datos de PostgreSQL' --yesno "\\n¿Intentar sacar copia de respaldo de todas las bases PostgreSQL en /var/www/resbase/pga-$nb.sql ?\n" 15 60
	if (test "$?" = "0") then {
		pgrep post > /dev/null 2>&1
		if (test "$?" = "0") then {
			mkdir -p /var/www/resbase
			touch /var/www/resbase/pga-$nb.sql
			chown _postgresql:_postgresql /var/www/resbase/pga-$nb.sql
			touch /var/www/resbase/pga-conc.sql
			chmod +x /var/www/resbase/
			chown _postgresql:_postgresql /var/www/resbase/pga-conc.sql
			rm -f /tmp/penc.txt
			echo "psql -h$sockpsql $acuspos -c 'SHOW SERVER_ENCODING' > /tmp/penc.txt" > /tmp/cu.sh
			chmod +x /tmp/cu.sh
			cat /tmp/cu.sh >> /var/tmp/preact-adJ.bitacora
			su - _postgresql /tmp/cu.sh >> /var/tmp/preact-adJ.bitacora;
			if (test -f /tmp/penc.txt -a ! -z /tmp/penc.txt) then {
				dbenc=`grep -v "(1 row)" /tmp/penc.txt | grep -v "server_encoding" | grep -v "[-]-----" | grep -v "^ *$" | sed -e "s/  *//g"`
			} fi;
			echo -n "pg_dumpall $acuspos --inserts --column-inserts --host=$sockpsql > /var/www/resbase/pga-conc.sql" > /tmp/cu.sh
			chmod +x /tmp/cu.sh
			cat /tmp/cu.sh >> /var/tmp/preact-adJ.bitacora
			su - _postgresql /tmp/cu.sh >> /var/tmp/preact-adJ.bitacora;
			grep "CREATE DATABASE" /var/www/resbase/pga-conc.sql | grep -v "ENCODING" > /tmp/cb.sed
			sed -e "s/\(.*\);$/s\/\1;\/\1 ENCODING='$dbenc';\/g/g" /tmp/cb.sed  > /tmp/cb2.sed
			cat /tmp/cb2.sed >> /var/tmp/preact-adJ.bitacora
			grep -v "ALTER ROLE $uspos" /var/www/resbase/pga-conc.sql | sed -f /tmp/cb2.sed > /var/www/resbase/pga-$nb.sql
		} else {
			echo "PostgreSQL no está corriendo, no fue posible sacar copia" >> /var/tmp/preact-adJ.bitacora;
		} fi;
		if (test ! -s /var/www/resbase/pga-$nb.sql) then {
			echo "* No fue posible sacar copia, por favor saquela manualmente en un archivo de nombre /var/www/resbase/pga-$nb.sql o asegurarse de sacarlo con pg_dumpall o en último caso sacando una copia del directorio /var/postgresql/data" | tee -a /var/tmp/preact-adJ.bitacora;
			echo "* Vuelva a este script con 'exit'" 
			sh
		} fi;
	} fi;
} else {
	if (test -d "/var/postgresql") then {
		dialog --title 'PostgreSQL no opera' --yesno "\\nAunque PostgreSQL no esta operando en el disco parece haber datos para ese motor.  Puede detener este archivo de comandos para verificar.\\n   ¿Continuar?\\n" 15 60
		if (test "$?" != "0") then {
			echo "";
        		echo "Vuelva a ejecutar este script cuando termine de verificar" 
			exit 1;
		} fi;
	} fi;
} fi;

if (test "$ACVER" -lt "55") then {
	dialog --title 'Advertencia: respaldar datos binarios' --yesno "\\nPara actualizar de versiones anteriores a 5.5 deben detenerse servicios y \\n
eliminar todos los paquetes del sistema.\\n
Este archivo de comandos hará eso a continuación,\\n
pero antes le recomendamos (1) sacar en un formato portable\\n
copias de otras bases de datos o datos binarios usados\\n
por los paquetes instalados (por ejemplo mysql, rrdtol,\\n
ldapd, OpenLDAP, etc) y (2) configurar métodos alternos de \\n
ingreso si depende de paquetes para ingresar al sistema\\n
(e.g interprete de comandos, VPN, etc).\\n\\n
¿Aún le falta respaldar datos en formatos portables?" 17 60
	if (test "$?" = "0") then {
		echo "";
		echo "Saque copia portable de los datos binarios que usen los paquetes y despues"
		echo "ejecute nuevamente este archivo de comandos";
		exit 0;
	} fi;
	if (test -f /etc/rc.d/postgresql) then {
		sh /etc/rc.d/postgresql stop
	} fi;
	if (test -f /etc/rc.d/cupsd) then {
		sh /etc/rc.d/cupsd stop
	} fi;
	cd /var/db/pkg
	pkg_delete *
	echo "\\nSistema preparado para actualizar\\n"
} else {
	dialog --title 'Preparado' --msgbox "\\nSistema preparado para actualizar\\n" 15 60
	clear
} fi;
