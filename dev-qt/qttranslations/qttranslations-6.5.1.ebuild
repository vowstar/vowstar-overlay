# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Translation files for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

KEYWORDS="~amd64"

DEPEND="
	=dev-qt/qtbase-${PV}*
	=dev-qt/qttools-${PV}*
"
RDEPEND=""
