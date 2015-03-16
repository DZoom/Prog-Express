# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

DESCRIPTION="Prog-Express is a modern, intuitive and free control software for the Batronix USB programming devices"
HOMEPAGE="http://www.batronix.com/"
SRC_URI="x86?	( http://www.batronix.com/exe/Batronix/Prog-Express/deb/${P}-1.i386.deb )
		amd64?	( http://www.batronix.com/exe/Batronix/Prog-Express/deb/${P}-1.amd64.deb )"
RESTRICT="mirror"

LICENSE="freedist no-source-code"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

DEPEND="dev-libs/libusb
		dev-db/sqlite:3
		dev-dotnet/libgdiplus
		dev-lang/mono
		dev-lang/mono-basic
		sys-fs/udev
		gnome? ( gnome-extra/zenity )"

RDEPEND=""

S=${WORKDIR}

src_unpack() {
	# unpack debian package
	if use x86; then
		ar x ${DISTDIR}/${P}-1.i386.deb
	fi
	if use amd64; then
		ar x ${DISTDIR}/${P}-1.amd64.deb
	fi

	# unpack debian package data file
	unpack ./data.tar.xz
	cd "${S}"

	# remove debian package files
	rm control.tar.gz data.tar.xz debian-binary
}

src_install() {
	# install udev rule
	insinto /lib/udev/rules.d
	doins ${S}/lib/udev/rules.d/85-batronix-devices.rules

	# install bin files
	dobin ${S}/usr/bin/bxusb
	dobin ${S}/usr/bin/bxusb-gui
	dobin ${S}/usr/bin/prog-express

	# install lib files
	insinto /usr/lib/bxusb
	doins -r ${S}/usr/lib/bxusb/*
	insinto /usr/lib/prog-express
	doins -r ${S}/usr/lib/prog-express/*
	doins ${FILESDIR}/pe.exe.config

	# install sbin file
	dosbin ${S}/usr/sbin/bxfxload

	# install menu entry
	domenu ${S}/usr/share/applications/prog-express.desktop
	
	# install docs
	dodoc -r ${S}/usr/share/doc/prog-express/*

	# install man
	doman ${S}/usr/share/man/man1/bxfxload.1.gz
	doman ${S}/usr/share/man/man1/bxusb.1.gz
	doman ${S}/usr/share/man/man1/bxusb-gui.1.gz
	doman ${S}/usr/share/man/man1/prog-express.1.gz

	# install icon
	doicon ${S}/usr/share/pixmaps/prog-express.png
}
