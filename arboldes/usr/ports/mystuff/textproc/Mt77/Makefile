# $adJ$

# Porte de dominio público

COMMENT=	"Search engine, fast and precise"

VERSION=1.0a2
REVISION= 
DISTNAME=v${VERSION}
CATEGORIES=     textproc
PKGNAME=Mt77-${VERSION}
GH_TAGNAME=v${VERSION}
GH_PROJECT=Mt77

HOMEPAGE=http://pasosdeJesus.github.io/Mt77/
PKGSPEC = Mt77->=1.0,<1.1
MAINTAINER=     Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

MASTER_SITES=https://github.com/pasosdeJesus/Mt77/archive/
#EXTRACT_SUFX=.tar.gz
#DCOMP ?=${DISTNAME}
#WRKSRC = ${PKGNAME}
TEST_TARGET = regr
#Public domain
PERMIT_PACKAGE=   	Yes

CONFIGURE_STYLE=        simple
CONFIGURE_SCRIPT=       conf.sh

prueba:
	echo ${WRKCONF}
do-regress:
	echo "Intentando en ${WRKSRC}";
	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${MAKE_PROGRAM} ${MAKE_FLAGS} regr

do-install:
	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} DESTDIR=${DESTDIR} ${MAKE_PROGRAM} ${MAKE_FLAGS} instala 


.include <bsd.port.mk>
