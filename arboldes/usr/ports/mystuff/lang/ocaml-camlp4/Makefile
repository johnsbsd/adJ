# $OpenBSD: Makefile,v 1.7 2016/06/24 15:59:12 krw Exp $

COMMENT =	OCaml Preprocessor and Pretty-Printer
CATEGORIES =	lang

V =		4.05+2
GH_ACCOUNT =	ocaml
GH_PROJECT =	camlp4
GH_TAGNAME =	${V}
WRKDIST =	${WRKDIR}/${GH_PROJECT}-${GH_TAGNAME:S/+/-/}
PKGNAME =	ocaml-${DISTNAME}
REVISION = 	
# No dynlink compatibility between releases
PKGSPEC =	ocaml-camlp4-=${V}

HOMEPAGE =	https://github.com/ocaml/camlp4/

MAINTAINER =	Christopher Zimmermann <chrisz@openbsd.org>

# LGPL >=2.1
PERMIT_PACKAGE_CDROM =	Yes

MODULES =		lang/ocaml

WANTLIB +=		c m

USE_GMAKE =		Yes

CONFIGURE_STYLE =	simple

BUILD_DEPENDS =         devel/ocaml-ocamlbuild

MAKE_ENV =		DESTDIR=${WRKINST}

ALL_TARGET =		byte

.include <bsd.port.arch.mk>
.if ${PROPERTIES:Mocaml_native}
ALL_TARGET +=		native
.endif

INSTALL_TARGET =	install install-META


pre-install:
	echo PKGDIR=${LOCALBASE}/lib/ocaml >>${WRKSRC}/config.sh
	echo LIBDIR=${LOCALBASE}/lib/ocaml >>${WRKSRC}/config.sh
	echo BINDIR=${LOCALBASE}/bin >>${WRKSRC}/config.sh


.include <bsd.port.mk>
