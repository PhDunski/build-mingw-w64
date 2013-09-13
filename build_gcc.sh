#!/bin/bash
# NOTA: Ce script fait tout pour vous !!!
# il crée une arborescence proche de
# <root>
#	|-> le script se trouve ici (quel que soit le nom du dossier
#	|-> archives : dossier dans lequel les archives sont récupérées
#	|-> source   : dossier dans lequel les archives seront décompressées
#
# il récupère les différentes archives indispensables avant de les décompresser
# puis il compile l'ensemble en deux passes
#
# vous devez disposer de msys-wget et de la possibilité d'utiliser SVN en ligne de commande
#
# Vous devez également veiller à ce que votre variable PATH connaisse le chemin d'accès pour les outils préinstallés
#
# vous devez veiller à utiliser un autre répertoire que celui dans lequel
# se trouve votre installation actuelle de Gcc pour éviter les conflits

# les dossiers de compilation : la plupart des outils supportent mal d'être 
# compilés dans le même répertoire que leurs source. Nous devons donc prévoir
#  un dossier de compilation pour chacun d'eux
BASE_DIR=`pwd`
BUILD_DIR="${BASE_DIR}/build"
cd ${BUILD_DIR}
NEED_SOURCES="yes"
NEED_EXTRACTION="yes"
NEED_CLEAR_SOURCE="no"
NEED_CLEAR_PREFIX="no"
NEED_FIRST_PASS="yes"
WANT_GDB="yes"
WANT_MAKE="yes"
WANT_ICONV="yes"
WANT_GETTEXT="yes"
WANT_LIBXML2="yes"
WANT_ICU="yes"
WANT_OPENSSL="yes"
USE_SYSROOT="yes"
COPY_LIBS_IN_GCC="no"
PREFIX="/mingw"

GMP_VER=-5.1.2
MPFR_VER=-3.1.2
MPC_VER=-1.0.1
ISL_VER=-0.11.1
CLOOG_VER=-0.18.0
MINGW_VER=v2.0.8
BINUTILS_VER=-2.23.1
GCC_VER=-4.8.1
GDB_VER=-7.6.1
MAKE_VER=-3.82
LIBXML2_VER=-2.9.1
ICONV_VER=-1.14
GETTEXT_VER=-0.18.3.1
OPENSSL_VER=-1.0.1e
ICU_VER=51.2
ICU_VER_STRING="-51_2"
ICU_SRCNAME="${ICU_VER_STRING}-src"
ICU_FILENAME="icu4c${ICU_VER_STRING}-src"
GCC_FLAVOUR="release"
BINUTILS_FLAVOUR="release"

LOG_DIR="${BASE_DIR}/logs"
SRC_DIR="${BASE_DIR}/source/"
TAR_DIR="${BASE_DIR}/archives"

LANGUAGES="c,c++,fortran,objc,obj-c++,lto"

if [ "${NEED_SOURCE}" == "yes" ]; then
    NEED_EXTRACTION="yes"
fi
if [ "$WANT_GETTEXT" == "yes" ]; then
	WANT_ICONV="yes"
fi
PASS="1"
if [ "${NEED_FIRST_PASS}" == "yes" ];then
	PASS="1"
else
	PASS="2"
fi
BIT_32="on"
BIT_64="on"
if [ "$BUILD" == "x86-w64-mingw32" ]; then
	BIT_64="off"
elif [ "$BUILD" neq "x86_64-w64-mingw32" ]; then
	echo "what build do you want?"
	exit 1
fi
GZ=".tar.gz"
TGZ=".tgz"
BZ=".tar.bz2"
GMP="gmp"
MPFR="mpfr"
MPC="mpc"
ISL="isl"
CLOOG="cloog"
HEADERS="headers"
CRT="crt"
WPT_COMMON="winpthreads"
WPT_64="${WPT_COMMON}_64"
WPT_32="${WPT_COMMON}_32"

BINUTILS="binutils"
GCC="gcc"
GDB="gdb"
MAKE="make"
LIBXML2="libxml2"
ICONV="libiconv"
GETTEXT="gettext"
ICU="icu"
OPENSSL="openssl"
DEP_BUILD="${GMP} ${MPFR} ${MPC} ${ISL} ${CLOOG}"
ALL_BUILD="${DEP_BUILD} ${HEADERS} ${CRT} ${BINUTILS} ${GCC} ${WPT_64} ${WPT_32}"
if [ "${WANT_MAKE}" == "yes" ];then
	ALL_BUILD="${ALL_BUILD} ${MAKE}"
fi
if [ "${WANT_GDB}" == "yes" ];then
	ALL_BUILD="${ALL_BUILD} ${GDB}"
fi
if [ "${WANT_GETTEXT}" == "yes" ];then
	ALL_BUILD="${ALL_BUILD} ${GETTEXT}"
fi
if [ "${WANT_ICU}" == "yes" ];then
	ALL_BUILD="${ALL_BUILD} ${ICU}"
fi
if [ "${WANT_LIBXML2}" == "yes" ];then
	ALL_BUILD="${ALL_BUILD} ${LIBXML2}"
fi

GZ=".tar.gz"
TGZ=".tgz"
BZ=".tar.bz2"
GMP_TAR=${BZ}
MPFR_TAR=${BZ}
MPC_TAR=${GZ}
ISL_TAR=${BZ}
CLOOG_TAR=${GZ}
MINGW_TAR=${GZ}
BINUTILS_TAR=${BZ}
GCC_TAR=${BZ}
GDB_TAR=${BZ}
MAKE_TAR=${BZ}
LIBXML2_TAR=${GZ}
ICONV_TAR=${GZ}
GETTEXT_TAR=${GZ}
ICU_TAR=${TGZ}
OPENSSL_TAR=${GZ}

GMP_URL="ftp://ftp.gmplib.org/pub/gmp"
MPFR_URL="http://www.mpfr.org/mpfr-current"
MPC_URL="http://www.multiprecision.org/mpc/download"
ISL_URL="ftp://gcc.gnu.org/pub/gcc/infrastructure"
CLOOG_URL="ftp://gcc.gnu.org/pub/gcc/infrastructure"
BINUTILS_URL="ftp://sourceware.org/pub/binutils"
GCC_URL="ftp://gcc.gnu.org/pub/gcc"
MINGW_SVN="svn://svn.code.sf.net/p/mingw-w64/code/tags"

MAKE_URL="ftp://ftp.gnu.org/gnu/make"
GDB_URL="ftp://ftp.gnu.org/gnu/gdb"
LIBXML2_URL="ftp://xmlsoft.org/libxml2/"
ICONV_URL="ftp://ftp.gnu.org/gnu/libiconv"
GETTEXT_URL="http://ftp.gnu.org/pub/gnu/gettext"
ICU_URL="http://download.icu-project.org/files/icu4c"
OPENSSL_URL="http://www.openssl.org/source"
GMP_SRC="${SRC_DIR}/${GMP}${GMP_VER}"
MPFR_SRC="${SRC_DIR}/${MPFR}${MPFR_VER}"
MPC_SRC="${SRC_DIR}/${MPC}${MPC_VER}"
ISL_SRC="${SRC_DIR}/${ISL}${ISL_VER}"
CLOOG_SRC="${SRC_DIR}/${CLOOG}${CLOOG_VER}"
MIGW_BASE_SRC="${SRC_DIR}/mingw-w64"
HEADERS_SRC="${MIGW_BASE_SRC}/mingw-w64-${HEADERS}"
CRT_SRC="${MIGW_BASE_SRC}/mingw-w64-${CRT}"
WINPTHREAD_SRC="${MINGW_BASE_SRC}/mingw-w64-libraries/winpthreads"
BINUTILS_SRC="${SRC_DIR}/${BINUTILS}${BINUTILS_VER}"
GCC_SRC="${SRC_DIR}/${GCC}${GCC_VER}"
GETTEXT_SRC="${SRC_DIR}/${GETTEXT}-${GETTEXT_VER}"
ICU_SRC="${SRC_DIR}/${ICU}/source"
DEPS_PREFIX="${PREFIX}/deps"
BUILD="x86_64-w64-mingw32"
MINGW_PREFIX="${PREFIX}/${BUILD}"
PREFIX_OPT="--prefix=${PREFIX}"
if [ "$USE_SYSROOT" == yes ]; then
	SYSROOT_OPT="--with-sysroot=${PREFIX}"
else 
	SYSROOT_OPT=
fi
DEPS_PREFIX_OPT="--prefix=${DEPS_PREFIX}"
BUILD_OPT="--build=${BUILD}"
COMMON_DEPS_OPT="${DEPS_PREFIX_OPT} ${BUILD_OPT} --disable-shared --enable-static"
GMP_OPT="${COMMON_DEPS_OPT}"
MPFR_OPT="${COMMON_DEPS_OPT} --with-gmp=${DEPS_PREFIX}"
MPC_OPT="${COMMON_DEPS_OPT} --with-gmp=${DEPS_PREFIX} --with-mpfr=${DEPS_PREFIX}"
ISL_OPT="${COMMON_DEPS_OPT} --with-gmp=system --with-gmp-prefix=${DEPS_PREFIX}"
CLOOG_OPT="${COMMON_DEPS_OPT} --with-gmp=system --with-gmp-prefix=${DEPS_PREFIX} \
		   --with-isl=system --with-isl-prefix=${DEPS_PREFIX}"
MINGW_PREFIX_OPT="--prefix=${MINGW_PREFIX}"
HEADERS_OPT="${MINGW_PREFIX_OPT} ${BUILD_OPT} --enable-sdk=all --enable-secure-api --enable-idl"
CRT_OPT="${MINGW_PREFIX_OPT} ${BUILD_OPT} ${SYSROOT_OPT}"
WPT_COMMON_FIRST="--disable-shared --enable-static"
WPT_COMMON_SECOND="--enable-shared --enable-static"
WPT_32_COMMON="CFLAGS=-m32 RCFLAGS='-U_WIN64 -f pe-i386'"
WPT_64_FIRST_OPT="--prefix=${PREFIX}/wpt64 ${BUILD_OPT} {WPT_COMMON_FIRST}"
WPT_64_FIRST_OPT="--prefix=${PREFIX}/wpt64 ${BUILD_OPT} {WPT_COMMON_SECOND}"
WPT_32_FIRST_OPT="--prefix=${PREFIX}/wpt32 ${BUILD_OPT} {WPT_COMMON_FIRST} ${WPT_32_COMMON}"
WPT_32_FIRST_OPT="--prefix=${PREFIX}/wpt32 ${BUILD_OPT} {WPT_COMMON_SECOND} ${WPT_32_COMMON}"
BINUTILS_OPT="${PREFIX_OPT} ${SYSROOT_OPT} ${BUILD_OPT} --disable-nls --enable-auto-import"
LANGUAGES_OPT="--enable-languages={LANGUAGES}"
BOOSTRAP_OFF="--disable-bootstrap"
WERROR_OFF="--disable-werror"
GCC_DEPS="--with-gmp=${DEPS_PREFIX} --with-mpfr=${DEPS_PREFIX} --with-mpc=${DEPS_PREFIX} \
	--with-isl=${DEPS_PREFIX} --with-cloog=${DEPS_PREFIX} --with-cloog-backend=isl"
if [ $"COPY_LIBS_IN_GCC" == "yes" ]; then
	GCC_DEPS="--with-cloog-backend=isl"
fi
GCC_LIBS="--enable-libstdcxx-time --enable-libstdcxx-threads --enable-libgomp --enable-libatomic --enable-libssp"
GCC_ENABLE_FIRST_OPT="--enable-shared --enable-static --enable-threads=posix"
GCC_ENABLE_SECOND_OPT="--enable-lto --enable-graphite --enable-fully-dynamic-string"
GCC_ENABLE_THIRD_OPT="--enable-version-specific-runtime-libs  --enable-sjlj-exceptions"
GCC_DISABLE_OPT="--disable-win32-registry --disable-nls"
GCC_OPT_BASE="${PREFIX_OPT} ${SYSROOT_OPT} ${BUILD_OPT} ${LANGUAGES_OPT} ${GCC_ENABLE_FIRST_OPT} \
 ${GCC_ENABLE_SECOND_OPT} ${GCC_ENABLE_THIRD_OPT} ${GCC_DISABLE_OPT} ${GCC_LIBS} ${GCC_DEPS}"
GCC_OPT_FIRST="${GCC_OPT_BASE} ${BOOTSTRAP_OFF}"
GCC_OPT_SECOND="${GCC_OPT_BASE} ${WERROR_OFF}"
TOOLS_OPT=" ${PREFIX_OPT} ${SYSROOT_OPT} ${BUILD_OPT}"
suppress_logs(){
	cd ${BUILD_DIR}
	echo "removing old compilation log"
    rm -rf *.log
}
erase_prefix_files(){
	if [ "$NEED_CLEAR_PREFIX" == "yes" ]; then
		echo "removing all file in ${PREFIX}"
		rm -rf ${PREFIX}/*
	fi
}
create_symlinks(){
	if [ -d ${PREFIX}/${mingw} ]; then
		rm -rf ${PREFIX}/${mingw}
	fi
	ln -s ${PREFIX}/${BUILD} ${PREFIX}/mingw
}
copy_libdir(){
	if [ -d "${PREFIX}/${BUILD}/lib64" ]; then
		rm -rf ${PREFIX}/${BUILD}/lib64 
	fi
	if [ -d "${PREFIX}/${BUILD}/lib32" ]; then
		rm -rf ${PREFIX}/${BUILD}/lib32 
	fi
	if [ -d "${PREFIX}/${BUILD}/lib" ]; then
		if [ "$BUILD" == "x86_64-w64-mingw32"]
			cp -rf ${PREFIX}/${BUILD}/lib ${PREFIX}/${BUILD}/lib64
		elif [ "$BUILD" == "x86-w64-mingw32"]
			cp -rf ${PREFIX}/${BUILD}/lib ${PREFIX}/${BUILD}/lib32
		fi
	fi
}
create_build_directories(){
    for dir in ${ALL_BUILD}; do
		if [ ! -d "${BUILD_DIR}/${dir}" ]; then
			mkdir -p ${dir}
		else
			rm -rf ${BUILD_DIR}/${dir}/*
		fi
	done
	if [ ! -d "${TAR_DIR}" ]; then
		mkdir -p ${TAR_DIR}
	fi 
	if [ ! -d "${SRC_DIR}" ]; then
		mkdir -p ${SRC_DIR}
	fi
	suppress_logs
}
suppress_sources(){
	if [ "${NEED_CLEAR_SOURCE}" == "yes" ]; then
		echo "suppressing all source directories"
		cd ${SRC_DIR}
		rm -rf *
		cd ${BUILD_DIR}
	fi
}
wget_archive(){
	if [ "$#" == "4" ]; then
		wget ${1}/${2}${3}${4}  -P ${TAR_DIR}  || exit 1
	elif [ "$#" == "3" ]; then
		wget ${1}/${2}${3}  -P ${TAR_DIR}  || exit 1
	else
		echo "Are you sure to want download ${1}/${2} ?"
		exit  1
	fi
}
get_archives(){
	if [ "$NEED_SOURCES" == "yes" ]; then
		if [ ! -d "${TAR_DIR}" ]; then
			mkdir -p ${TAR_DIR}
		fi 
		cd ${TAR_DIR}
		wget_archive ${GMP_URL} ${GMP} ${GMP_VER} ${GMP_TAR}  
		wget_archive ${MPFR_URL} ${MPFR} ${MPFR_VER} ${MPFR_TAR}
		wget_archive ${MPC_URL} ${MPC} ${MPC_VER} ${MPC_TAR}
		wget_archive ${ISL_URL} ${ISL} ${ISL_VER} ${ISL_TAR}
		wget_archive ${CLOOG_URL} ${CLOOG} ${CLOOG_VER} ${CLOOG_TAR}
		wget_archive "${BINUTILS_URL}/${BINUTILS_FLAVOUR}s" ${BINUTILS} ${BINUTILS_VER} ${BINUTILS_TAR}
		wget_archive "${GCC_URL}/${GCC_FLAVOUR}s/${GCC}${GCC_VER}" ${GCC} ${GCC_VER} ${GCC_TAR}
		echo "getting mingw-w64 source from SVN"
		svn checkout ${MINGW_SVN}/${MINGW_VER} ${MIGW_BASE_SRC} > ${LOG_DIR}/mingw_checkout.log 2>&1  || exit 1
		
		cd ${BUILD_DIR}
	fi
}
extract_source(){
	cd  ${TAR_DIR}
	ARGLIST=("$@")
	ARGNUM=${#ARGLIST[@]}
	FILE=""
	EXTRACT=""
	if [ "${GZ}" == "${ARGLIST[${i}-1]}" ] ||
		   [ "${TGZ}" == "${ARGLIST[${i}-1]}"]; then
			EXTRACT="-vxzf"
		elif[ "${BZ}" == "$3" ]; then
			EXTRACT="-vxjf"
		else 
			echo "what's that for an archive ?"
			exit 1
		fi
		for ((i = 0; i<$ARGNUM;++i)); do
			FILE="${FILE}${ARGLIST[${i}]}"
		done
	fi
	echo "extracting source from ${FILE}"
	tar ${EXTRACT} ${FILE} -C ${SRC_DIR} > ${LOG_DIR}/${1}_untar.log  || exit 1
	cd ${BUILD_DIR}
}

extract_all(){
	if [ "${NEED_EXTRACTION}" == "yes" ]; then
		cd ${TAR_DIR}
		extract_source ${GMP}  ${GMP_VER} ${GMP_TAR}
		extract_source ${MPFR} ${MPFR_VER} ${MPFR_TAR}
		extract_source ${MPC} ${MPC_VER} ${MPC_TAR}
		extract_source ${ISL} ${ISL_VER} ${ISL_TAR}
		extract_source ${CLOOG} ${CLOOG_VER} ${CLOOG_TAR}
		extract_source ${BINUTILS} ${BINUTILS_VER} ${BINUTILS_TAR}
		extract_source ${GCC} ${GCC_VER} ${GCC_TAR}
		cd ${BUILD_DIR}
	fi
}
copy_src_libs(){
	if [ ! -d "${GCC_SRC}/${GMP}" ]; then
		cp -rf ${GMP_SRC} ${GCC_SRC}/${GMP}
	fi
	if [ ! -d "${GCC_SRC}/${MPFR}" ]; then
		cp -rf ${MPFR_SRC} ${GCC_SRC}/${MPFR}
	fi
	if [ ! -d "${GCC_SRC}/${MPC}" ]; then
		cp -rf ${MPC_SRC} ${GCC_SRC}/${MPC}
	fi
	if [ ! -d "${GCC_SRC}/${ISL}" ]; then
		cp -rf ${ISL_SRC} ${GCC_SRC}/${ISL}
	fi
	if [ ! -d "${GCC_SRC}/${CLOOG}" ]; then
		cp -rf ${CLOOG_SRC} ${GCC_SRC}/${CLOOG}
	fi
}
configure(){
	
	ARGLIST=("$@")
	ARGNUM=${#ARGLIST[@]}
	THISBUILD_DIR=${ARGLIST[0]}
	SRC="${ARGLIST[1]}"
	COMMAND="configure "
	PASSNUMBER=${ARGLIST[2]}
	echo "configuring ${THISBUILD_DIR} with sources from ${SRC} with-options"
	for ((i = 3; i<$ARGNUM;++i)); do
		echo "    ${ARGLIST[${i}]}"
		COMMAND="${COMMAND} ${ARGLIST[${i}]}"
	done
	cd ${BUILD_DIR}/${THISBUILD_DIR}
	${SRC}/${COMMAND} > ${BUILD_DIR}/${THISBUILD_DIR}_pass_${PASSNUMBER}_configure.log 2>&1  || exit 1
	echo "done"
	echo
	echo
	cd ${BUILD_DIR}
}
build_and_install(){
    cd ${BUILD_DIR}/${1}
	echo "building ${1} pass ${2}"
	make > ${BUILD_DIR}/${1}_pass_${2}_make.log 2>&1  || exit 1
	echo "done"
	echo
	echo
	echo "installing ${1} pass ${2}"
	make install >${BUILD_DIR}/${1}_pass_${2}_install.log 2>&1  || exit 1
	echo "done"
	echo
	echo
	cd ${BUILD_DIR}
}
make_all_gcc(){
	cd ${GCC}
	echo "making all-gcc pass ${1}"
	make all-gcc > ${BUILD_DIR}/all-gcc_pas${1}_make.log 2>&1  || exit 1
	echo "installing all-gcc pass ${1}"
	make install-gcc > ${BUILD_DIR}/all-gcc_pas${1}_install.log 2>&1  || exit 1
	cd ${BUILD_DIR}
}
correct_libgcc_dir(){
	if  -d "${PREFIX}/lib/gcc/${BUILD}/lib" ]; then
		cp -f ${PREFIX}/lib/gcc/${BUILD}/lib/* ${PREFIX}/lib/gcc/${BUILD}/${GCC_VER}/lib
	fi
	
	if [ -d "${PREFIX}/lib/gcc/${BUILD}/lib32" ]; then
		cp -f ${PREFIX}/lib/gcc/${BUILD}/lib32/* ${PREFIX}/lib/gcc/${BUILD}/${GCC_VER}/lib/32
	fi
}
make_libgcc(){
	cd ${GCC}
	echo "making all-gcc pass ${1}"
	make all-target-libgccgcc > ${BUILD_DIR}/libgcc_pas${1}_make.log 2>&1  || exit 1
	echo "installing all-gcc pass ${1}"
	make install-gcc > ${BUILD_DIR}/libgcc_pas${1}_install.log 2>&1  || exit 1
	correct_libgcc_dir
	cd ${BUILD_DIR}
}
build_winpthreads (){
	OPT_64=""
	OPT_32=""
	rm -rf ${WPT_64_BUILD}/*
	rm -rf ${WPT_32_BUILD}/*
    if [ "${1}" = "1" ]; then
		OPT_64="${WPT_64_FIRST_OPT}"
		OPT_32="${WPT_32_FIRST_OPT}"
	else
		OPT_64="${WPT_64_SECOND_OPT}"
		OPT_32="${WPT_32_SECOND_OPT}"
	fi
	if [ "${BIT_64}"= "on" ]; then 
		configure ${WPT_64} ${WPT_SRC} ${1} ${OPT_64}
		build_and_install ${WPT_64} ${1}
	fi
	if [ "${BIT_64}" == "on" ] ||
	   [ "${BIT_32}" == "on" ]  ; then 
		configure ${WPT_32} ${WPT_SRC}  ${1} ${OPT_32}
		build_and_install ${WPT_32} ${1}
		mkdir ${PREFIX}/bin/32
	fi
	if [ -d ${PREFIX}/wpt64/include ]; then
		cp -f ${PREFIX}/wpt64/include/* ${PREFIX}/${BUILD}/include
	fi
	if [ -d ${PREFIX}/wpt64/lib ]; then
		cp -f ${PREFIX}/wpt64/lib/* ${PREFIX}/${BUILD}/lib
	fi
	if [ -d ${PREFIX}/wpt32/lib ]; then
		cp -f ${PREFIX}/wpt32/lib/* ${PREFIX}/${BUILD}/lib32
	fi
	if [ -d ${PREFIX}/wpt64/bin ]; then
		cp ${PREFIX}/wpt64/bin/* ${PREFIX}/bin
	fi
	if [ -d ${PREFIX}/wpt64/bin ]; then
		cp ${PREFIX}/wpt32/bin/* ${PREFIX}/bin/32
	fi
	if [ "${BIT_64}" == "off" ] &&
		[ -d ${PREFIX}/wpt32/include ]; then
		cp -f ${PREFIX}/wpt32/include/* ${PREFIX}/${BUILD}/include
	fi
	
}
gcc_process(){
	 if [ "$1" == "1" ]; then
		OPTIONS="${GCC_OPT_FIRST}"
	else
		OPTIONS="${GCC_OPT_SECOND}"
	fi
	configure ${GCC} ${GCC_SRC} ${1} ${OPTIONS}
	make_all_gcc ${1}
	configure ${CRT} ${CRT_SRC} ${1} ${CRT_OPT}
	build_and_install ${CRT} ${1}
	copy_libdir
	if [ "$1" = "1" ]; then
		build_winpthreads ${1}
		copy_libdir
		create_symlink
		build_libgcc
		build_winpthreads "2"
	else
		build_winpthreads "3"
	fi
	copy_libdir
	create_symlink
	build_and_install ${GCC} ${1}
	#copy_dlls
}
build_binutils(){
	configure ${BINUTILS} "${BINUTILS_SRC}" ${PASS} ${BINUTILS_OPT} &&
	build_and_install ${BINUTILS} ${PASS}
}
build_gmp(){
	configure ${GMP} ${GMP_SRC} ${PASS} ${GMP_OPT} &&
	build_and_install ${GMP} ${PASS}
}
build_mpfr(){
	configure ${MPFR} ${MPFR_SRC} ${PASS} ${MPFR_OPT} &&
	build_and_install ${MPFR} ${PASS}
}
build_mpc(){
	configure ${MPC} ${MPC_SRC} ${PASS} ${MPC_OPT} &&
	build_and_install ${MPC} ${PASS}
}
build_isl(){
	configure ${ISL} ${ISL_SRC} ${PASS} ${ISL_OPT} &&
	build_and_install ${ISL} ${PASS}
}
build_cloog(){
	configure ${CLOOG} ${CLOOG_SRC} ${PASS} ${CLOOG_OPT} &&
	build_and_install ${CLOOG} ${PASS}
}
build_headers(){
	configure ${HEADERS} ${HEADERS_SRC} ${PASS} ${HEADERS_OPT} &&
	build_and_install ${HEADERS} ${PASS} 
}
build_gettext(){
	if [ "$WANT_GETTEXT" == "yes" ]; then
		if [ "$NEED_SOURCES" == "yes" ]; then
			wget_archive ${GETTEXT_URL} ${GETTEXT} ${GETTEXT_VER} ${GETTEXT_TAR}
		fi
		if [ "$NEED_EXTRACTION" == "yes" ]; then
			extract_source  ${GETTEXT} ${GETTEXT_VER} ${GETTEXT_TAR}
		fi
	configure ${GETTEXT} ${GETTEXT_SRC} ${PASS} ${TOOLS_OPT} &&
	build_and_install ${GETTEXT} ${PASS} 
		
	fi
}
build_icu(){
	if [ "$WANT_ICU" == "yes" ]; then
		if [ "$NEED_SOURCES" == "yes" ]; then
			wget_archive "${ICU_URL}/${ICU_VER}" ${ICU_FILENAME} ${ICU_TAR} 
		fi
		if [ "$NEED_EXTRACTION" == "yes" ]; then
			cd  ${TAR_DIR}
			tar -vxzf ${ICU_FILENAME}.tgz -C ${SRC_DIR} > ${LOG_DIR}/icu_untar.log  || exit 1
			cd ${BUILD_DIR}
		fi
	configure ${ICU} ${ICU_SRC} ${PASS} ${TOOLS_OPT} &&
	build_and_install ${ICU} ${PASS} 
		
	fi

}
build_openssl(){
	if [ "$WANT_OPENSSL" == "yes" ]; then
		if [ "$NEED_SOURCES" == "yes" ]; then
			wget_archive ${OPENSSL_URL} ${OPENSSL} ${OPENSSL_VER} ${OPENSSL_TAR}
		fi
		if [ "$NEED_EXTRACTION" == "yes" ]; then
			extract_source  ${OPENSSL} ${OPENSSL_VER} ${OPENSSL_TAR}
		fi
	configure ${OPENSSL} ${OPENSSL_SRC} ${PASS} ${TOOLS_OPT} &&
	build_and_install ${OPENSSL} ${PASS} 
	fi
}
build_iconv(){
	if [ "$WANT_ICONV" == "yes" ]; then
		if [ "$NEED_SOURCES" == "yes" ]; then
			wget_archive ${ICONV_URL} ${ICONV} ${ICONV_VER} ${ICONV_TAR}
		fi
		if [ "$NEED_EXTRACTION" == "yes" ]; then
			extract_source  ${ICONV} ${ICONV_VER} ${ICONV_TAR}
		fi
	configure ${ICONV} ${ICONV_SRC} ${PASS} ${TOOLS_OPT} &&
	build_and_install ${ICONV} ${PASS} 
		
	fi

}
build_gdb(){
	if [ "$WANT_GDB" == "yes" ]; then
		if [ "$NEED_SOURCES" == "yes" ]; then
			wget_archive ${GDB_URL} ${GDB} ${GDB_VER} ${GDB_TAR}
		fi
		if [ "$NEED_EXTRACTION" == "yes" ]; then
			extract_source  ${GDB} ${GDB_VER} ${GDB_TAR}
		fi
	# configure ${GDB} ${GDB_SRC} ${PASS} ${TOOLS_OPT} &&
	# build_and_install ${GDB} ${PASS} 
		
	fi

}
build_make(){
	if [ "$WANT_MAKE" == "yes" ]; then
		if [ "$NEED_SOURCES" == "yes" ]; then
			wget_archive ${MAKE_URL} ${MAKE} ${MAKE_VER} ${MAKE_TAR}
		fi
		if [ "$NEED_EXTRACTION" == "yes" ]; then
			extract_source  ${MAKE} ${MAKE_VER} ${MAKE_TAR}
		fi
	configure ${MAKE} ${MAKE_SRC} ${PASS} ${TOOLS_OPT} &&
	build_and_install ${MAKE} ${PASS} 
		
	fi
}
build_libxml2(){
	if [ "$WANT_MAKE" == "yes" ]; then
		if [ "$NEED_SOURCES" == "yes" ]; then
			wget_archive ${LIBXML2_URL} ${LIBXML2} ${LIBXML2_VER} ${LIBXML2_TAR}
		fi
		if [ "$NEED_EXTRACTION" == "yes" ]; then
			extract_source  ${LIBXML2} ${LIBXML2_VER} ${LIBXML2_TAR}
		fi
	configure ${LIBXMX2} ${LIBXMX2_SRC} ${PASS} ${TOOLS_OPT} &&
	build_and_install ${LIBXMX2} ${PASS} 
		
	fi
}
build_it(){ 
	build_headers
	build_binutils
	if [ ${COPY_LIBS_IN_GCC} == "yes" ]; then
		copy_src_libs
	else
		build_gmp
		build_mpfr
		build_mpc
		build_isl
		build_cloog
	fi
	create_symlinks
	gcc_process ${PASS}
}
create_build_directories
get_archives
extract_all
export PATH=${PREFIX}/bin:${PREFIX}/bin/32:$PATH
echo "PATH set to ${PATH}"
if [ "${PASS}" == "1" ]; then
	build_it
	suppress_dir
	create_dir
	PASS="2"
 fi
 #build_it
 # build_iconv
 # build_gettext
 # build_icu
 # build_openssl
 # build_libxml2