#!/bin/sh

# run this from withing the protocols directory
# must have xsltcproc, nwalsh stylesheets, and fop installed; for fop you
# probably need to export JAVA_HOME pointing to wherever the java install
# directory is (that's the java dir that holds a 'bin' dir, e.g.,
# /usr/lib/jvm/java-6-openjdk/jre/ on my Debian box

annot="1"
impl="1"
draft="maybe"
sfx="-internal"

while [ "x$1" != x ]; do
    case "$1" in
	--final )
	    annot="0"
	    annot="0"
	    draft="no"
	    sfx="";;
	--help )
	  echo "\n  Usage: $0 [options]\n"
	  echo "  Run from withing the directory cotaining nscreen-protocol.xml"
	  echo "\n  Options:"
	  echo "       --final : don't include annotations"
	  exit 1 ;;
	* )
	    echo "Unknown option $1"
	    exit 1 ;;
    esac
    shift
done

xsltproc -o /tmp/titlepage.xsl                                           \
         --stringparam show.annotations.comments "$annot"                \
         --stringparam show.annotations.implementation "$impl"           \
         --stringparam draft.mode "$draft"                               \
	 --xinclude                                                      \
         /usr/share/xml/docbook/stylesheet/nwalsh/template/titlepage.xsl \
         scripts/titlepage.templates.xml || exit 1

xsltproc \
    --xinclude \
    --stringparam show.annotations.comments "$annot"                          \
    --stringparam show.annotations.implementation "$impl"                     \
    --stringparam draft.mode "$draft"                                         \
    -o nscreen-protocol.fo scripts/template.xsl nscreen-protocol.xml || exit 1;

fop -fo nscreen-protocol.fo -pdf nscreen-protocol${sfx}.pdf || exit 1

#rm -f nscreen-protocol.fo
#rm -f  /tmp/titlepage.xsl
