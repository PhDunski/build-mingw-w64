#!/bin/bash

BASE_DIR=`pwd`
BUILD_DIR=build
LOG_DIR=logs
TAR_DIR=archives
BASE_SRC=source
PATCHES_DIR=patches
BUILD=x86_64-w64-mingw32
ENABLE_MULTILIB=yes
ENABLE_SECURE_API=yes
PREFIX=/mingw
CLEAN_SRC=no
CLEAN_TAR=no
CLEAN_LOG=no
CLEAN_BUILD=no

FORCE_RECONFIGURE=no
FORCE_REBUILD=no
FORCE_REINSTALL=no
FIRST_PASS_ENABLED=yes
SECOND_PASS_ENABLED=no
WANT_GDB=yes
WANT_MAKE=yes
WANT_ICONV=yes
WANT_GETTEXT=yes
WANT_OPENSSL=yes
WANT_XML2=yes
KEEP_DEPENDENCIES=no

NEED_SYMLINK=yes
PASS="1"
if [ "$FIRST_PASS_ENABLED" == "yes" ]; then
	PASS="1"
else
	PASS="2"
fi
if [ "${FORCE_RECONFIGURE}" == "yes" ]; then
	FORCE_REBUILD=yes
fi
if [ "${FORCE_REBUILD}" == "yes" ]; then
	FORCE_REINSTALL=yes
fi
if [ "${WANT_GETTEXT}" == "yes" ]; then
	if [ "${WANT_ICONV}" == "no" ]; then
		echo "libiconv is needed to build gettext, enabling it"
	fi
	WANT_ICONV=yes
fi
SRC_DIR="../../source"

declare -a BINUTILS
BINUTILS[0]=binutils
BINUTILS[1]=-2.24.51
BINUTILS[2]=.tar.bz2
# make your choice between 'release' and 'snapshot'
BINUTILS[3]=snapshot
BINUTILS[4]=ftp://gcc.gnu.org/pub/${BINUTILS[0]}/${BINUTILS[3]}s
BINUTILS[5]=
BINUTILS[6]=doit
BINUTILS[7]=--build=${BUILD}
BINUTILS[8]=--prefix=${PREFIX}
BINUTILS[9]=--with-sysroot=${PREFIX}
BINUTILS[10]=--enable-auto-import 
BINUTILS[11]=--enable-shared 
BINUTILS[12]=--enable-static
BINUTILS[13]=--disable-nls
DEPS_PREFIX=${PREFIX}/deps
declare -a GMP
GMP[0]=gmp
GMP[1]=-5.1.2
GMP[2]=.tar.bz2
GMP[3]=release
GMP[4]=ftp://ftp.gmplib.org/pub/gmp
GMP[5]=
GMP[6]=doit
GMP[7]=--build=${BUILD}
GMP[8]=--prefix=${DEPS_PREFIX}
GMP[10]=--disable-shared 
GMP[11]=--enable-static
declare -a MPFR
MPFR[0]=mpfr
MPFR[1]=-3.1.2
MPFR[2]=.tar.bz2
MPFR[3]=release
MPFR[4]=http://www.mpfr.org/mpfr-current
MPFR[5]=
MPFR[6]=doit
MPFR[7]=--build=${BUILD}
MPFR[8]=--prefix=${DEPS_PREFIX}
MPFR[10]=--disable-shared 
MPFR[11]=--enable-static
MPFR[12]=--with-gmp=${DEPS_PREFIX}
declare -a MPC
MPC[0]=mpc
MPC[1]=-1.0.1
MPC[2]=.tar.gz
MPC[3]=release
MPC[4]=http://www.multiprecision.org/mpc/download/
MPC[5]=
MPC[6]=doit
MPC[7]=--build=${BUILD}
MPC[8]=--prefix=${DEPS_PREFIX}
MPC[10]=--disable-shared 
MPC[11]=--enable-static
MPC[12]=--with-gmp=${DEPS_PREFIX}
MPC[13]=--with-mpfr=${DEPS_PREFIX}
declare -a ISL
ISL[0]=isl
ISL[1]=-0.11.1
ISL[2]=.tar.bz2
ISL[3]=release
ISL[4]=ftp://gcc.gnu.org/pub/gcc/infrastructure
ISL[5]=
ISL[6]=doit
ISL[7]=--prefix=${DEPS_PREFIX}
ISL[7]=--build=${BUILD}
ISL[8]=--prefix=${DEPS_PREFIX}
ISL[10]=--disable-shared 
ISL[11]=--enable-static
ISL[12]=--with-gmp-prefix=${DEPS_PREFIX}
ISL[13]=--with-gmp=system
declare -a CLOOG
CLOOG[0]=cloog
CLOOG[1]=-0.18.0
CLOOG[2]=.tar.gz
CLOOG[3]=release
CLOOG[4]=ftp://gcc.gnu.org/pub/gcc/infrastructure/
CLOOG[5]=
CLOOG[6]=doit
CLOOG[7]=--prefix=${DEPS_PREFIX}
CLOOG[7]=--build=${BUILD}
CLOOG[8]=--prefix=${DEPS_PREFIX}
CLOOG[10]=--disable-shared 
CLOOG[11]=--enable-static
CLOOG[12]=--with-gmp=system
CLOOG[13]=--with-gmp-prefix=${DEPS_PREFIX}
CLOOG[11]=--with-isl=system
CLOOG[12]=--with-isl-prefix=${DEPS_PREFIX}
declare -a HEADERS
HEADERS[0]=headers
HEADERS[1]=6299
HEADERS[3]=release
HEADERS[4]=
HEADERS[5]=
HEADERS[6]=doit
HEADERS[7]=--prefix=${PREFIX}/${BUILD}
HEADERS[8]=--build=${BUILD}
HEADERS[9]=--enable-secure-api
HEADERS[10]=--enable-sdk=all
declare -a CRT
CRT[0]=crt
CRT[1]='v2.0.8'
CRT[3]=release
CRT[4]=
CRT[5]=
CRT[6]=doit
CRT[7]=--prefix=${PREFIX}/${BUILD}
CRT[8]=--with-sysroot=${PREFIX}
CRT[9]=--build=${BUILD}
CRT[10]=--enable-lib32
CRT[11]=--enable-lib64
declare -a GCC
GCC[0]=gcc
GCC[1]=-4.8.1
GCC[2]=.tar.bz2
# make your choice between 'release' and 'snapshot'
GCC[3]=release
GCC[4]=ftp://gcc.gnu.org/pub/${GCC[0]}/${GCC[3]}s/${GCC[0]}${GCC[1]}
if [ "${GCC[3]}" == "snapshot" ]; then
	VAR=`echo "${GCC[1]}" |sed 's/-//'`
	GCC[4]=ftp://gcc.gnu.org/pub/${GCC[0]}/${GCC[3]}s/${VAR}
fi
GCC[5]=
GCC[6]=4.8.1
GCC[7]=--build=${BUILD}
GCC[8]=--prefix=${PREFIX}
GCC[9]=--with-sysroot=${PREFIX}
GCC[10]=--enable-languages=c,c++,fortran,objc,obj-c++
GCC[11]=--enable-shared 
GCC[12]=--enable-static
GCC[13]=--disable-nls
GCC[14]=--enable-libstdcxx-time
GCC[15]=--enable-threads=posix
GCC[16]=--enable-libstdcxx-threads
GCC[17]=--enable-libgomp
GCC[18]=--enable-libssp
GCC[19]=--enable-graphite
GCC[20]=--enable-sjlj-exceptions
GCC[21]=--enable-fully-dynamic-string
GCC[22]=--enable-version-specific-runtime-libs
GCC[23]=--disable-bootstrap
GCC[24]=--disable-win32-registry
GCC[25]=--with-gmp=${DEPS_PREFIX}
GCC[26]=--with-mpfr=${DEPS_PREFIX}
GCC[27]=--with-mpc=${DEPS_PREFIX}
GCC[28]=--with-isl=${DEPS_PREFIX}
GCC[29]=--with-cloog=${DEPS_PREFIX}
GCC[30]=--with-cloog-backend=isl
declare -a WPT32
WPT32[0]=winpthread_32
WPT32[1]=
WPT32[2]=
WPT32[3]=
WPT32[4]=
WPT32[5]=
WPT32[6]=
WPT32[7]=--build=${BUILD}
WPT32[8]=--prefix=${PREFIX}/${WPT32[0]}
WPT32[9]=--with-sysroot=${PREFIX}
WPT32[10]=--disable-shared
WPT32[11]=--enable-static
WPT32[12]=CFLAGS=-m32
declare -a WPT32_2
WPT32_2[0]=winpthread_32_2
WPT32_2[1]=
WPT32_2[2]=
WPT32_2[3]=
WPT32_2[4]=
WPT32_2[5]=
WPT32_2[6]=
WPT32_2[7]=--build=${BUILD}
WPT32_2[8]=--prefix=${PREFIX}/${WPT32_2[0]}
WPT32_2[9]=--with-sysroot=${PREFIX}
WPT32_2[10]='CFLAGS=-m32'
WPT32_2[11]=--enable-shared
WPT32_2[12]=--enable-static

declare -a WPT64
WPT64[0]=winpthread_64
WPT64[1]=
WPT64[2]=
WPT64[3]=
WPT64[4]=
WPT64[5]=
WPT64[6]=
WPT64[7]=--build=${BUILD}
WPT64[8]=--prefix=${PREFIX}/${WPT64[0]}
WPT64[9]=--with-sysroot=${PREFIX}
WPT64[10]=--disable-shared
WPT64[11]=--enable-static
declare -a WPT64_2
WPT64_2[0]=winpthread_64_2
WPT64_2[1]=
WPT64_2[2]=
WPT64_2[3]=
WPT64_2[4]=
WPT64_2[5]=
WPT64_2[6]=
WPT64_2[7]=--build=${BUILD}
WPT64_2[8]=--prefix=${PREFIX}/${WPT64_2[0]}
WPT64_2[9]=--with-sysroot=${PREFIX}
WPT64_2[10]=--enable-shared
WPT64_2[11]=--enable-static

declare -a MINGW_BASE
MINGW_BASE[0]=mingw
MINGW_BASE[1]=6299
MINGW_BASE[3]=release
MINGW_BASE[5]=svn://svn.code.sf.net/p/mingw-w64/code/trunk

declare -a GDB
GDB[0]=gdb
GDB[1]=-7.6.1
GDB[2]=.tar.gz
GDB[3]=release
GDB[4]=ftp://gcc.gnu.org/pub/${GDB[0]}/${GDB[3]}s/
if [ "${GDB[3]}" == "snapshot" ]; then
	GDB[4]=ftp://gcc.gnu.org/pub/${GDB[0]}/${GDB[3]}s/branch
fi
GDB[5]=
GDB[6]=doit
GDB[7]=--build=${BUILD}
GDB[8]=--prefix=${PREFIX}
GDB[9]=--with-sysroot=${PREFIX}
GDB[10]=--enable-shared
GDB[11]=--enable-static
GDB[11]=--disable-nls
GDB[12]='CFLAGS=-m64'
declare -a MAKE
MAKE[0]=make
MAKE[1]=-3.82
MAKE[2]=.tar.gz
MAKE[3]=release
MAKE[4]=ftp://ftp.gnu.org/gnu/make
MAKE[5]=
MAKE[6]=
MAKE[7]=--build=${BUILD}
MAKE[8]=--prefix=${PREFIX}
MAKE[9]=--with-sysroot=${PREFIX}
MAKE[10]=--disable-nls
declare -a ICONV
ICONV[0]=libiconv
ICONV[1]=-1.14
ICONV[2]=.tar.gz
ICONV[3]=release
ICONV[4]=ftp://ftp.gnu.org/gnu/libiconv
ICONV[5]=
ICONV[6]=doit
ICONV[7]=--build=${BUILD}
ICONV[8]=--prefix=${PREFIX}
ICONV[9]=--enable-shared
ICONV[10]=--enable-static
ICONV[11]=--disable-nls
declare -a GETTEXT
GETTEXT[0]=gettext
GETTEXT[1]=-0.18.3
GETTEXT[2]=.tar.gz
GETTEXT[3]=release
GETTEXT[4]=ftp://ftp.gnu.org/gnu/gettext
GETTEXT[5]=
GETTEXT[6]=
GETTEXT[7]=--build=${BUILD}
GETTEXT[8]=--prefix=${PREFIX}
GETTEXT[9]=--enable-shared
GETTEXT[10]=--enable-static
GETTEXT[11]=--disable-nls
declare -a OPENSSL
OPENSSL[0]=openssl
OPENSSL[1]=-1.0.1e
OPENSSL[2]=.tar.gz
OPENSSL[3]=release
OPENSSL[4]=http://www.openssl.org/source
OPENSSL[5]=
OPENSSL[6]=
OPENSSL[7]=mingw64
OPENSSL[8]=--prefix=${PREFIX}/openssl

declare -a XML2
XML2[0]=libxml2
XML2[1]=-2.9.1
XML2[2]=.tar.gz
XML2[3]=release
XML2[4]=ftp://xmlsoft.org/libxml2
XML2[5]=doit
XML2[6]=
XML2[7]=--build=${BUILD}
XML2[8]=--prefix=${PREFIX}/libxml2
XML2[9]=--enable-shared
XML2[10]=--enable-static
XML2[11]=--disable-nls


PREREQ='BINUTILS GMP MPFR MPC ISL CLOOG'

# echo "\$BASE_DIR    set to $BASE_DIR"
# echo "\$BUILD_DIR   set to $BUILD_DIR"
# echo "\$LOG_DIR     set to $LOG_DIR"
# echo "\$TAR_DIR     set to $TAR_DIR"
# echo "\$BASE_SRC    set to $BASE_SRC"
# echo "\$CLEAN_SRC   set to $CLEAN_SRC"
# echo "\$CLEAN_TAR   set to $CLEAN_TAR"
# echo "\$CLEAN_LOG   set to $CLEAN_LOG"
# echo "\$CLEAN_BUILD set to $CLEAN_BUILD"
test_directories(){
	# echo "create ${1} clean = ${2}"
	if [ -d ${1} ] && [ -n "${1}" ]; then
		echo -n "${1} exists "
		if [ "x${2}" == "xyes" ]; then
			echo "cleaning it "
			cd ${1}
			 rm -rf *
			cd ..
		else
			echo ""
		fi
	elif [ ! -d "${1}" ]; then
		mkdir "${1}"
	else
		echo "which dir?"
		exit 1
	fi	
}

patch_sources(){
	cd  ${BASE_DIR}
	if [ -d ${PATCHES_DIR} ]; then
			eval DIR="\${$1[0]}\${$1[1]}"
			echo " ${DIR} "
		# added due to issue N° 1 : Gcc-4.8.1 need a patch which is not applied to the archive
		# ... but they will maybe are more than one
		cd ${BASE_DIR}/${LOG_DIR}
		if [ -f ${DIR}_patching.log ]; then
			echo "${DIR}  dir already patched ... skipped"
		else
			cd ${BASE_DIR}/${PATCHES_DIR}
			if [ -d ${DIR} ]; then
				cd ${BASE_DIR}/${BASE_SRC}/${DIR}
				echo -n "applying patch  to ${DIR} ..."
				for file in $(ls ../../${PATCHES_DIR}/${DIR}); do
					echo "applying ${file} ..."
					patch -p0 < ../../${PATCHES_DIR}/${DIR}/${file} >${BASE_DIR}/${LOG_DIR}/${DIR}_patching.log
					echo "done"
				done
			else
				echo "fine, there are not patch to be applied"
			fi
		fi
	fi
	cd ${BASE_DIR}
}
extract_archive(){
	cd $BASE_DIR
	cd $TAR_DIR
	eval EXT=\${$1[2]}
	eval VERSION=\${$1[1]}
	eval NAME=\${$1[0]}
	FILENAME=${NAME}${VERSION}${EXT}
	if [ -z $EXT ] || [ -z $VERSION ] || [ -z $NAME ]; then
		echo cannot extract file from archive
		exit 1
	fi
	OPT=
	if [ "$EXT" == ".tar.gz" ] || [ "$EXT" == ".tgz" ]; then
		OPT="-vxzf"
	elif [ "$EXT" == ".tar.bz2" ]; then
		OPT="-vxjf"
	else
		echo "unrecognized archive format"
		exit 1
	fi
	cd $BASE_DIR
	cd ${LOG_DIR}
	if [ -f ${NAME}${VERSION}_unarchive.log ]; then
		echo "$FILENAME archives files allready extracted ... skipped"
	else
		cd $BASE_DIR
		cd ${TAR_DIR}
		echo "extracting with $OPT command line option"
		tar $OPT $FILENAME -C ../${BASE_SRC} > ../${LOG_DIR}/${NAME}${VERSION}_unarchive.log
		patch_sources ${1}
	fi
	cd $BASE_DIR
}
use_wget(){
	cd $BASE_DIR
	cd $TAR_DIR
	eval FILENAME=\${$1[0]}\${$1[1]}\${$1[2]}
	eval DATA=\${$1}

	if [ -f ${FILENAME} ]; then
	echo "${FILENAME} exist ... skipped"
	else
		echo "using wget to get ${FILENAME}"
		wget ${2}/${FILENAME}
	fi
	extract_archive ${1}
	cd $BASE_DIR
}
use_svn(){
	cd $BASE_DIR
	cd $BASE_SRC
	eval eval NAME=\${$1[0]}
	if [ -d $NAME ] && [ -n "$NAME" ]; then
		echo "allready downloaded... skipped"
	else
		echo -n "checkout of ${NAME}"
		eval svn checkout \${$1[5]}/@\${$1[1]} \${$1[0]} >../${LOG_DIR}/${NAME}_svn_checkout.log 2>&1 || exit 1 
		echo "done"
	fi
}
get_source(){
	eval USE_WGET=\${$1[4]}
	if [ -n "${USE_WGET}" ]; then 
		use_wget ${1} ${USE_WGET}
	else
		eval USE_SVN=\${$1[5]}
		if [ -n "${USE_SVN}" ]; then 
			use_svn ${1}
		else
			echo "how can i get sources ?"
			exit 1
		fi
	fi
}
configure_elem(){
	cd ${BASE_DIR}/${LOG_DIR}
	TAB=($(eval echo $(echo \${$1[@]})))
	NAME=${TAB[0]}
	if [ "$FORCE_RECONFIGURE" == "yes" ]; then
		if [ -f ${NAME}_pass_${PASS}_configure.log ]; then
			rm ${NAME}_pass_${PASS}_configure.log
		fi
	fi
	if [ -f ${NAME}_pass_${PASS}_configure.log ]; then
		echo "${NAME} allready configured ... skipped"
	elif [ -z "${NAME}" ]; then
		echo "what package ?"
		exit 1
	else
		cd "${BASE_DIR}/${BUILD_DIR}"
		test_directories "${NAME}" "${FORCE_RECONFIGURE}"
		cd ${NAME}
		
	OPTIONS=
	for ((i = 6; i<= ${#TAB[@]} ; ++i )) do
		OPTIONS="${OPTIONS} ${TAB[$i]}"
		echo "${TAB[$i]}"
	done
		eval THIS_SRC_DIR="${TAB[0]}${TAB[1]}"
		echo -n "configuring ${NAME} ..."
		../../${BASE_SRC}/${THIS_SRC_DIR}/configure ${OPTIONS}  >../../${LOG_DIR}/${NAME}_pass_${PASS}_configure.log 2>&1 || exit 1
		echo "done"
	fi
	cd ${BASE_DIR}
}
make_elem(){
	if [ -z "${1}" ]; then
		echo "what would you want to build ?"
		exit 1
	fi
	cd "${BASE_DIR}/${LOG_DIR}"
	if [ "$FORCE_REBUILD" == "yes" ]; then
		if [ -f ${1}_pass_${PASS}_make.log ]; then
		rm ${1}_pass_${PASS}_make.log
		fi
	fi
	if [ -f ${1}_pass_${PASS}_make.log ]; then
		echo "${1} allready build ... skipped"
	else 
		cd "${BASE_DIR}/${BUILD_DIR}/${1}"
		echo -n "building ${1} ..."
		make > ../../${LOG_DIR}/${1}_pass_${PASS}_make.log 2>&1 || exit 1
		echo "done"
	fi
	cd ${BASE_DIR}
	
}
install_elem(){

	if [ -z "${1}" ]; then
		echo "what would you want to install ?"
		exit 1
	fi
	cd "${BASE_DIR}/${LOG_DIR}"
	if [ "$FORCE_REINSTALL" == "yes" ]; then
		if [ -f ${1}_pass_${PASS}_install.log ]; then
		rm ${1}_pass_${PASS}_install.log
		fi
	fi
	if [ -f ${1}_pass_${PASS}_install.log ]; then
		echo "${1} allready installed ... skipped"
	else
		cd "${BASE_DIR}/${BUILD_DIR}/${1}"
		echo -n "installing ${1} ..."
		make install> ../../${LOG_DIR}/${1}_pass_${PASS}_install.log 2>&1 || exit 1
		echo "done"
	fi
	cd ${BASE_DIR}
	
}
build_elem(){
	configure_elem ${1}
	make_elem "${NAME}"
	install_elem "${NAME}"
}
build_prereq(){
	for elem in $PREREQ ; do
		eval DOIT=\${$elem[6]}
		eval NAME=\${$elem[0]}
		if [ -n "${DOIT}" ] ; then
			echo "building $NAME"
			get_source $elem
			build_elem $elem
		else
			echo "skipped $NAME"
		fi
	done
}
configure_headers(){
	NAME=headers
	cd ${BASE_DIR}/${LOG_DIR}
		
	if [ "$FORCE_RECONFIGURE" == "yes" ]; then
		if [ -f ${NAME}_pass_${PASS}_configure.log ]; then
			rm ${NAME}_pass_${PASS}_configure.log
		fi
	fi
	if [ -f ${NAME}_pass_${PASS}_configure.log ]; then
		echo "${NAME} allready configured ... skipped"
	else
		cd "${BASE_DIR}/${BUILD_DIR}"
		test_directories "${NAME}" "${FORCE_RECONFIGURE}"
		cd ${NAME}
	OPTIONS=
	for ((i = 7; i<= 10 ; ++i )) do
		OPTIONS="${OPTIONS} ${HEADERS[$i]}"
		echo "${HEADERS[$i]}"
	done
	
		echo -n "configuring ${NAME} ..."
		 ../../${BASE_SRC}/${MINGW_BASE[0]}/mingw-w64-headers/configure ${OPTIONS}  >../../${LOG_DIR}/${NAME}_pass_${PASS}_configure.log 2>&1 || exit 1
		echo "done"
	fi
	cd ${BASE_DIR}
}
build_headers(){
	configure_headers
	make_elem "headers"
	install_elem "headers"
}
create_symlinks(){
	if [ "$NEED_SYMLINK" == "yes" ]; then
		cd ${PREFIX}/${BUILD}
		if [ -d lib ] && [ -d lib64 ]; then
			echo -n"removing ${PREFIX}/${BUILD}/lib64..."
			rm -rf lib64
			echo "done"
		fi	
		echo -n "linking ${PREFIX}/${BUILD}/lib to ${PREFIX}/${BUILD}/lib64..."
		ln -s lib lib64
		echo done
		cd ${PREFIX}
		if [ -d mingw ]; then
			echo -n "removing ${PREFIX}/mingw sub directory ..."
			rm -rf mingw
			echo "done"
		fi
		echo -n "linking ${PREFIX}/${BUILD} to ${PREFIX}/mingw  ..."
		ln -s "${BUILD}" mingw
		echo "done"
		
		# with Gcc 4.8.x, there is a miss configuration in the libgcc/32 script which
		# only set ${PREFIX}/mingw/lib and ${PREFIX}/${BUILD}/lib as libraries search paths
		# this trick ensure that there will always one of those path which provides 32bits 
		# but allows correct configurations to work too
		cd ${PREFIX}/mingw
		if [ -d lib ] &&
		   [ -d lib64 ] &&
		   [ -d lib32 ]	; then
			echo -n "correcting ${PREFIX}/mingw/lib symlink ..."
			rm -rf ${PREFIX}/mingw/lib
			ln -s ${PREFIX}/mingw/lib32 ${PREFIX}/mingw/lib
			echo done
		fi
		NEED_SYMLINK=no
	fi
	cd ${BASE_DIR}
}
make_all_gcc(){
	cd ${BASE_DIR}/${LOG_DIR}
	NAME=${GCC[0]}
	if [ -f ${NAME}_pass_${PASS}_make_all_gcc.log ]; then
		echo "${NAME} allready build ... skipped"
	else
		echo "building all-gcc"
		cd "${BASE_DIR}/${BUILD_DIR}"
		cd ${NAME}
		make all-gcc  >../../${LOG_DIR}/${NAME}_pass_${PASS}_make_all_gcc.log 2>&1 || exit 1
	fi
	cd ${BASE_DIR}
}
make_install_gcc(){
	cd ${BASE_DIR}/${LOG_DIR}
	NAME=${GCC[0]}
	if [ -f ${NAME}_pass_${PASS}_make_gcc_install.log ]; then
		echo "${NAME} allready installed ... skipped"
	else
		echo "installing all-gcc"
		cd "${BASE_DIR}/${BUILD_DIR}"
		cd ${NAME}
		make install-gcc  >../../${LOG_DIR}/${NAME}_pass_${PASS}_make_gcc_install.log 2>&1 || exit 1
	fi
	cd ${BASE_DIR}
}
make_winpthread_1(){ 
	cd ${BASE_DIR}/${LOG_DIR}
	NAME=${WPT64[0]}
	if [ -f ${NAME}_pass_${PASS}_configure.log ]; then
		echo "${NAME} allready configured ... skipped"
	else
		cd "${BASE_DIR}/${BUILD_DIR}"
		test_directories "${NAME}" "${FORCE_RECONFIGURE}"
		cd ${NAME}
	OPTIONS=
	for ((i = 7; i<= 12 ; ++i )) do
		OPTIONS="${OPTIONS} ${WPT64[$i]}"
		echo "${WPT64[$i]}"
	done
	
		echo -n "configuring ${NAME} ..."
		 ../../${BASE_SRC}/${MINGW_BASE[0]}/mingw-w64-libraries/winpthreads/configure ${OPTIONS}  >../../${LOG_DIR}/${NAME}_pass_${PASS}_configure.log 2>&1 || exit 1
		echo "done"
		make_elem "${NAME}"
		install_elem "${NAME}"
		NEED_SYMLINK=yes
	fi
	cd ${BASE_DIR}/${LOG_DIR}
	NAME=${WPT32[0]}
	if [ -f ${NAME}_pass_${PASS}_configure.log ]; then
		echo "${NAME} allready configured ... skipped"
	else
		cd "${BASE_DIR}/${BUILD_DIR}"
		test_directories "${NAME}" "${FORCE_RECONFIGURE}"
		cd ${NAME}
	OPTIONS=
	for ((i = 7; i<= 12 ; ++i )) do
		OPTIONS="${OPTIONS} ${WPT32[$i]}"
		echo "${WPT32[$i]}"
	done
	
		echo -n "configuring ${NAME} ..."
		 ../../${BASE_SRC}/${MINGW_BASE[0]}/mingw-w64-libraries/winpthreads/configure ${OPTIONS}  >../../${LOG_DIR}/${NAME}_pass_${PASS}_configure.log 2>&1 || exit 1
		echo "done"
		echo -n "building ${NAAME} ..."
		make >../../${LOG_DIR}/${NAME}_pass_${PASS}_make.log 2>&1 || exit 1
		echo "done"
		make_elem "${NAME}"
		install_elem "${NAME}"
		NEED_SYMLINK=yes
	fi
	cp -rf ${PREFIX}/${WPT64[0]}/include/* ${PREFIX}/${BUILD}/include
	cp -rf ${PREFIX}/${WPT64[0]}/lib/* ${PREFIX}/${BUILD}/lib
	if [ ! -d ${PREFIX}/${BUILD}/lib32 ]; then
		mkdir ${PREFIX}/${BUILD}/lib32 
	fi
	cp -rf ${PREFIX}/${WPT32[0]}/lib/* ${PREFIX}/${BUILD}/lib32

	
	create_symlinks
	cd ${BASE_DIR}
}

make_winpthread_2(){ 
cd ${BASE_DIR}
OLD_RECONF=${FORCE_RECONFIGURE}
OLD_REBUILD=${FORCE_REBUILD}
OLD_REINSTALL=${FORCE_REINSTALL}
FORCE_RECONFIGURE=yes
FORCE_REBUILD=yes
FORCE_REINSTALL=yes	cd ${BASE_DIR}/${LOG_DIR}
	NAME=${WPT64_2[0]}
	if [ -f ${NAME}_pass_${PASS}_configure.log ]; then
		echo "${NAME} allready configured ... skipped"
	else
		cd "${BASE_DIR}/${BUILD_DIR}"
		test_directories "${NAME}" "${FORCE_RECONFIGURE}"
		cd ${NAME}
	OPTIONS=
	for ((i = 7; i<= 11 ; ++i )) do
		OPTIONS="${OPTIONS} ${WPT64_2[$i]}"
		echo "${WPT64_2[$i]}"
	done
	
		echo -n "configuring ${NAME} ..."
		 ../../${BASE_SRC}/${MINGW_BASE[0]}/mingw-w64-libraries/winpthreads/configure ${OPTIONS}  >../../${LOG_DIR}/${NAME}_pass_${PASS}_configure.log 2>&1 || exit 1
		echo "done"
		echo -n "building ${NAAME} ..."
		make >../../${LOG_DIR}/${NAME}_pass_${PASS}_make.log 2>&1 || exit 1
		echo "done"
		make_elem "${NAME}"
		install_elem "${NAME}"
		NEED_SYMLINK=yes
	fi
	cd ${BASE_DIR}/${LOG_DIR}
	NAME=${WPT32_2}
	if [ -f ${NAME}_pass_${PASS}_configure.log ]; then
		echo "${NAME} allready configured ... skipped"
	else
		cd "${BASE_DIR}/${BUILD_DIR}"
		test_directories "${NAME}" "${FORCE_RECONFIGURE}"
		cd ${NAME}
	OPTIONS=
	for ((i = 7; i<= 13 ; ++i )) do
		OPTIONS="${OPTIONS} ${WPT32_2[$i]}"
		echo "${WPT32_2[$i]}"
	done
		echo "${OPTIONS}"
		echo -n "configuring ${NAME} ..."
		 ../../${BASE_SRC}/${MINGW_BASE[0]}/mingw-w64-libraries/winpthreads/configure ${OPTIONS} RCFLAGS="-U_WIN64 -F pe-i386" >../../${LOG_DIR}/${NAME}_pass_${PASS}_configure.log 2>&1 || exit 1
		echo "done"
		make_elem "${NAME}"
		install_elem "${NAME}"
		NEED_SYMLINK=yes
	fi
	if [ -d ${PREFIX}/${WPT64_2[0]}/include ]; then
	cp -rf ${PREFIX}/${WPT64_2[0]}/include/* ${PREFIX}/${BUILD}/include
	fi
	if [ -d ${PREFIX}/${WPT64_2[0]}/lib ]; then
	cp -rf ${PREFIX}/${WPT64_2[0]}/lib/* ${PREFIX}/${BUILD}/lib
	fi
	if [ -d ${PREFIX}/${WPT32_2[0]}/lib ]; then
	cp -rf ${PREFIX}/${WPT32_2[0]}/lib/* ${PREFIX}/${BUILD}/lib32
	fi
	if [ -d ${PREFIX}/${WPT64_2[0]}/bin ]; then
	cp -rf ${PREFIX}/${WPT64_2[0]}/bin/* ${PREFIX}/bin
	fi
	if [ ! -d ${PREFIX}/bin/32 ]; then
		mkdir ${PREFIX}/bin/32
	fi
	if [ -d  ${PREFIX}/${WPT32_2[0]}/bin ]; then
		cp -rf ${PREFIX}/${WPT32_2[0]}/bin/* ${PREFIX}/bin/32
	fi
	create_symlinks

FORCE_RECONFIGURE=${OLD_RECONF}
FORCE_REBUILD=${OLD_REBUILD}
FORCE_REINSTALL=${OLD_REINSTALL}

cd ${BASE_DIR}
}
build_crt(){
	cd ${BASE_DIR}/${LOG_DIR}
	NAME=${CRT[0]}
	if [ -f ${NAME}_pass_${PASS}_configure.log ]; then
		echo "${NAME} allready configured ... skipped"
	else
		cd "${BASE_DIR}/${BUILD_DIR}"
		test_directories "${NAME}" "${FORCE_RECONFIGURE}"
		cd ${NAME}
		OPTIONS=
		for ((i = 7; i<= 11 ; ++i )) do
			OPTIONS="${OPTIONS} ${CRT[$i]}"
		echo "${CRT[$i]}"
		done
		echo -n "configuring ${NAME}..."
		 ../../${BASE_SRC}/${MINGW_BASE[0]}/mingw-w64-${CRT[0]}/configure ${OPTIONS}  >../../${LOG_DIR}/${NAME}_pass_${PASS}_configure.log 2>&1 || exit 1
		echo done
		make_elem "${NAME}"
		install_elem "${NAME}"
		NEED_SYMLINK=yes
	fi
	create_symlinks
	cd ${BASE_DIR}
}
make_all_target(){
	cd ${BASE_DIR}/${LOG_DIR}
	NAME=${GCC[0]}
	if [ -f ${NAME}_pass_${PASS}_make_all_target_libgcc.log ]; then
		echo "${NAME} allready build ... skipped"
	else
		echo "building all-target-libgcc"
		cd "${BASE_DIR}/${BUILD_DIR}"
		cd ${NAME}
		make all-target-libgcc  >../../${LOG_DIR}/${NAME}_pass_${PASS}_make_all_target_libgcc.log 2>&1 || exit 1
	fi
	cd ${BASE_DIR}
}
make_install_target(){
	cd ${BASE_DIR}/${LOG_DIR}
	NAME=${GCC[0]}
	if [ -f ${NAME}_pass_${PASS}_make_install_target_libgcc.log ]; then
		echo "${NAME} allready installed ... skipped"
	else
		echo "installing all-target-libgcc"
		cd "${BASE_DIR}/${BUILD_DIR}"
		cd ${NAME}
		make install-target-libgcc >../../${LOG_DIR}/${NAME}_pass_${PASS}_make_install_target_libgcc.log 2>&1 || exit 1
	fi
	cd ${BASE_DIR}
}
correct_libdir(){
    cd ${PREFIX}/lib/gcc/${BUILD}
	if [ -d lib ]; then
		echo "copying all libs from ${PREFIX}/lib/gcc/${BUILD}/lib to ${GCC[6]}"
		cp -f lib/* ${GCC[6]}
	fi
	if [ -d lib32 ]; then
	
		echo "copying all libs from ${PREFIX}/lib/gcc/${BUILD}/lib to ${GCC[6]}/32"
		cp -f lib/* ${GCC[6]}/32
	fi
	cd ${BASE_DIR}
}
copy_dlls(){
	NAME=${GCC[0]}
	echo "ensuring that correct dlls are at the good place..."
	cd "${BASE_DIR}/${BUILD_DIR}"
	cd ${NAME}
	for dir in libgcc libgfortran libgomp libobjc libquadmath libssp libstdc++v3; do
		echo "searching in $dir"
		if [ -d ${BUILD}/32/${dir}/32/shlib ]; then
			echo "found ${BUILD}/32/${dir}/32/shlib"
			cp ${BUILD}/32/${dir}/32/shlib/*.dll ${PREFIX}/bin/32
		fi
		if [ -d ${BUILD}/32/${dir}/.libs ]; then
			echo "found ${BUILD}/32/${dir}/.libs"
			cp ${BUILD}/32/${dir}/.libs/*.dll ${PREFIX}/bin/32
		fi
		if [ -d ${BUILD}/32/${dir}/src/.libs ]; then
			echo "found ${BUILD}/32/${dir}/src/.libs"
			cp ${BUILD}/32/${dir}/.libs/src/*.dll ${PREFIX}/bin/32
		fi
		if [ -d ${BUILD}+${dir}/shlib ]; then
			echo "found ${BUILD}/${dir}/shlib"
			cp ${BUILD}+${dir}/shlib/*.dll ${PREFIX}/bin
		fi
		if [ -d ${BUILD}/${dir}/.libs ]; then
			echo "found ${BUILD}/${dir}/.libs"
			cp ${BUILD}/${dir}/.libs/*.dll ${PREFIX}/bin
		fi
		if [ -d ${BUILD}/${dir}/src/.libs ]; then
			echo "found ${BUILD}/${dir}/src/.libs"
			cp ${BUILD}/${dir}/src/.libs/*.dll ${PREFIX}/bin
		fi
	done
	echo "done"
	cd ${BASE_DIR}
}
final_cleanup(){

	echo "--- final cleanup --- "
	echo  "cleaning up ${PREFIX} directory ..."
	cd ${PREFIX}
	echo `pwd`
	DIRS_TO_CLEAN='mingw winpthread_32 winpthread_32_2 winpthread_64 winpthread_64_2'
	for dir in $DIRS_TO_CLEAN; do
		echo -n "removing ${dir} if exists..."
		if [ -d ${dir} ]; then
			rm -rf ${dir}
		fi
		echo "done"
	done
	echo "done"
	cd ${BASE_DIR}
	
}
create_batch_file(){
	cd ${PREFIX}
	echo "creating batch for new environment variables"
	if [ -f "mingw64env.cmd" ]; then
		NOW=$(date +"%Y-%m-%d-%H-%M")
		echo "oops batch file allready exists, baking it up as mingw64env.cmd_bak-${NOW}"
		mv mingw64env.cmd mingw64env.cmd_bak-${NOW}
	fi
	echo "@title MinGW-w64 64-bit GCC build environment" > mingw64env.cmd
	echo "@set MINGW_PATH=%CD%" >> mingw64env.cmd
	echo "@set PATH=%MINGW_PATH%\bin;%MINGW_PATH%\bin\32;%PATH%;" >> mingw64env.cmd
	echo "call cmd" >> mingw64env.cmd
	echo "done"
	cd ${BASE_DIR}
}
get_patches(){
	cd ${BASE_DIR}/${TAR_DIR}
	if [ ! -f patches.tar.bz2 ] ; then
		wget --no-check-certificate https://github.com/PhDunski/build-mingw-w64/blob/master/patches.tar.bz2?raw=true
	fi
	echo -n "extracting patches..."
	if [ ! -d ..${PATCHES_DIR} ]; then
		tar -vxjf patches.tar.bz2 -C .. > ../${LOG_DIR}/patches_unarchive.log
		echo "done"
	elif [ -d ..${PATCHES_DIR} ]; then
		echo " skipped"
	fi
	cd ${BASE_DIR}
}
clean_builddir(){
	cd ${BASE_DIR}/${BUILD_DIR}
	echo -n "removing pass 1 build directories ... "
	rm -rf *
	echo "done"
	cd ${BASE_DIR}
}
build_gdb(){
	if [ "$WANT_GDB" == "yes" ]; then
		get_source "GDB"
		build_elem "GDB"
	fi
	cd ${BASE_DIR}
}
build_make(){
	if [ "$WANT_MAKE" == "yes" ]; then
		get_source "MAKE"
		extract_archive "MAKE"
		configure_elem "MAKE"
		make_elem "MAKE"
		# there seem to be a problem with the "install" script for make.
		# we turn this problem around by simply copying the newly compiled make.exe as
		# mingw32-make.exe in the ${PREFIX}/bin directory
		cd ${BASE_DIR}/${BUILD_DIR}/make
		cp make.exe ${PREFIX}/bin/mingw32-make.exe
	fi
	cd ${BASE_DIR}
}
build_iconv(){
	if [ "$WANT_ICONV" == "yes" ]; then
		get_source "ICONV"
		build_elem "ICONV"
	fi
	cd ${BASE_DIR}
}
build_gettext(){
	if [ "$WANT_GETTEXT" == "yes" ]; then
		get_source "GETTEXT"
		build_elem "GETTEXT"
	fi
	cd ${BASE_DIR}
}
build_xml2(){
	if [ "$WANT_XML2" == "yes" ]; then
		cd ${BASE_DIR}/${TAR_DIR}
		if [ ! -f ${XML2[0]}${XML2[1]}${XML2[2]} ]; then
			wget --no-check-certificate ${XML2[4]}/${XML2[0]}${XML2[1]}${XML2[2]}
		fi
		get_source "XML2"
		build_elem "XML2"
	fi
	cd ${BASE_DIR}
}
build_openssl(){
	if [ "$WANT_openssl" == "yes" ]; then
		get_source "XML2"
		cd ${BASE_DIR}/${BASE_SRC}/${OPENSSL[0]}${OPENSSL[1]}
		Configure ${OPENSSL[7]} ${OPENSSL[8]} > ../../${LOG_DIR}/${OPENSSL[0]}_configure.log 2>&1 || exit 1
		make > ../../${LOG_DIR}/${OPENSSL[0]}_build.log 2>&1 || exit 1
		make install > ../../${LOG_DIR}/${OPENSSL[0]}_install.log 2>&1 || exit 1
	fi
	cd ${BASE_DIR}

}
test_directories "${BUILD_DIR}" "${CLEAN_BUILD}"
test_directories "${TAR_DIR}" "${CLEAN_TAR}"
test_directories "${BASE_SRC}" "${CLEAN_SRC}"
test_directories "${LOG_DIR}" "${CLEAN_LOG}"
get_patches
get_source MINGW_BASE
if [ "${PASS}" == "1" ]; then
	build_prereq
	build_headers
	create_symlinks
	get_source "GCC"
	extract_archive "GCC"
	configure_elem "GCC"
	make_all_gcc
	make_install_gcc
	make_winpthread_1
	build_crt
	make_all_target
	make_install_target 
	correct_libdir
	make_winpthread_2
	make_elem "GCC"
	install_elem "GCC"
	copy_dlls
	final_cleanup
	correct_libdir
	PASS=2
	build_elem  "BINUTILS"
fi
if [ "$SECOND_PASS_ENABLED" == "yes" ]; then
	clean_builddir
	build_prereq
	create_symlinks
	GCC[23]=--disable-bootstrap
	configure_elem "GCC"
	make_elem "GCC"
	install_elem "GCC"
fi
build_gdb
build_make
build_iconv
build_gettext
build_openssl
build_xml2
create_batch_file
