<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		version="1.0">

  <xsl:import href="file:///usr/share/xml/docbook/stylesheet/nwalsh/fo/docbook.xsl"/>

  <xsl:template match="processing-instruction('hard-pagebreak')">
    <fo:block break-before='page' />
  </xsl:template>
  <xsl:template match="processing-instruction('hard-pagebreak-after')">
    <fo:block break-after='page' />
  </xsl:template>

<xsl:include href="/tmp/titlepage.xsl"/>

<!--  <xsl:include href="titlepage.xsl"/> -->

  <!-- general settings -->

  <xsl:param name="fop1.extensions" select="1"></xsl:param>
  <xsl:param name="fop.extensions" select="0"></xsl:param>
  <xsl:param name="paper.type" select="'A4'"></xsl:param>
  <xsl:param name="section.autolabel" select="1"></xsl:param>
  <xsl:param name="process.empty.source.toc" select="1"></xsl:param>
  <xsl:param name="generate.toc">article toc,title</xsl:param>
  <xsl:param name="show.annotations.comments" select="1"/>
  <xsl:param name="body.start.indent" select="'4pc'"/>
  <xsl:param name="bibliography.style" select="iso690"/>
  <xsl:param name="highlight.source" select="0"></xsl:param>
  <xsl:param name="shade.verbatim" select="1"></xsl:param>
  <xsl:param name="toc.section.depth">3</xsl:param>
  <xsl:param name="draft.mode">maybe</xsl:param>
  <xsl:param name="draft.watermark.image"></xsl:param>

  <!-- want bit more content over the draft text output in the header based
       on its position, but the stock header.content template does not pass that
       parameter in, so we copy it here, with that singular addition. -->
  <xsl:template name="header.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>

    <fo:block>
      <!-- sequence can be odd, even, first, blank -->
      <!-- position can be left, center, right -->
      <xsl:choose>
	<xsl:when test="$sequence = 'blank'">
	  <!-- nothing -->
	</xsl:when>

	<xsl:when test="$position='left'">
	  <!-- Same for odd, even, empty, and blank sequences -->
	  <xsl:call-template name="draft.text">
	    <xsl:with-param name="position" select="$position"/>
	  </xsl:call-template>
	</xsl:when>

	<xsl:when test="($sequence='odd' or $sequence='even') and $position='center'">
	  <xsl:if test="$pageclass != 'titlepage'">
	    <xsl:choose>
	      <xsl:when test="ancestor::book and ($double.sided != 0)">
		<fo:retrieve-marker retrieve-class-name="section.head.marker"
				    retrieve-position="first-including-carryover"
				    retrieve-boundary="page-sequence"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:apply-templates select="." mode="titleabbrev.markup"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:if>
	</xsl:when>

	<xsl:when test="$position='center'">
	  <!-- nothing for empty and blank sequences -->
	</xsl:when>

	<xsl:when test="$position='right'">
	  <!-- Same for odd, even, empty, and blank sequences -->
	  <xsl:call-template name="draft.text">
	    <xsl:with-param name="position" select="$position"/>
	  </xsl:call-template>
	</xsl:when>

	<xsl:when test="$sequence = 'first'">
	  <!-- nothing for first pages -->
	</xsl:when>

	<xsl:when test="$sequence = 'blank'">
	  <!-- nothing for blank pages -->
	</xsl:when>
      </xsl:choose>
    </fo:block>
  </xsl:template>

  <!-- * make the 'Draft' text in page headers bold and red,
       * different text by position in the header -->
  <xsl:template name="draft.text">
    <xsl:param name="position" select="''"/>
    <xsl:choose>
      <xsl:when test="$draft.mode = 'yes'">
	<xsl:call-template name="draft.header.text">
	  <xsl:with-param name="position" select="$position"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="$draft.mode = 'no'">
	<!-- nop -->
      </xsl:when>
      <xsl:when test="ancestor-or-self::*[@status][1]/@status = 'draft'">
	<xsl:call-template name="draft.header.text">
	  <xsl:with-param name="position" select="$position"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<!-- nop -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- helper template that generates the required draft header text -->
  <xsl:template name="draft.header.text">
    <xsl:param name="position" select="''"/>

    <xsl:choose>
      <xsl:when test="$position = 'left'">
	<fo:block text-align="center" color="red" font-weight="bold">
	  <xsl:text>***&#xA0;EARLY DRAFT&#xA0;***</xsl:text>
	</fo:block>
      </xsl:when>
      <xsl:when test="$position = 'right'">
	<fo:block text-align="center"
		  space-before="0em"
		  space-after="0em"
		  color="red"
		  font-size="9pt">
	  <xsl:text>Do not distribute outwith CC POC team please</xsl:text>
	</fo:block>
      </xsl:when>
      <xsl:otherwise>
	<!-- nop -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- the autogenerated org content just concats everything, so provide
       custom template -->
  <xsl:template match="org" mode="article.titlepage.recto.auto.mode">
    <fo:block xsl:use-attribute-sets="article.titlepage.recto.style"
	      space-before="0.5em"
	      space-after="6.0em"
	      start-indent="0pt"
	      end-indent="0pt">

      <fo:block space-before="1.5em"
		font-size="12pt"
		space-after="0.5em">

	<xsl:apply-templates select="orgname"
			     mode="article.titlepage.recto.mode"/>
      </fo:block>

      <fo:block space-before="1.5em"
		font-size="14.4pt"
		space-after="0.5em">

	<xsl:apply-templates select="orgdiv"
			     mode="article.titlepage.recto.mode"/>
      </fo:block>
    </fo:block>
  </xsl:template>

  <!-- - - - - - - - - - - -->
  <!-- annotations output  -->
  <!-- - - - - - - - - - - -->

  <!-- comments -->
  <xsl:template match="annotation[@role='comment']">
    <xsl:if test="$show.annotations.comments != 0">
    <fo:block xsl:use-attribute-sets="annotations.comment">
      <fo:block font-weight="bold" color="darkred">
	<xsl:text>Comment by </xsl:text>
	<fo:inline color="darkblue">
	  <xsl:value-of select="descendant::authorinitials"/>
	  <xsl:text> (</xsl:text>
	  <xsl:value-of select="descendant::orgname"/>
	  <xsl:text>)</xsl:text>
	</fo:inline>
      </fo:block>
      <xsl:apply-templates/>
    </fo:block>
    </xsl:if>
  </xsl:template>

  <!-- implementation notes -->
  <xsl:template match="annotation[@role='implementation']">
    <xsl:if test="$show.annotations.implementation != 0">
    <fo:block xsl:use-attribute-sets="annotations.implementation">
      <fo:block font-weight="bold" color="green">
	<xsl:text>Implementation note by </xsl:text>
	<fo:inline color="darkblue">
	  <xsl:value-of select="descendant::authorinitials"/>
	  <xsl:text> (</xsl:text>
	  <xsl:value-of select="descendant::orgname"/>
	  <xsl:text>)</xsl:text>
	</fo:inline>
      </fo:block>
      <xsl:apply-templates/>
    </fo:block>
    </xsl:if>
  </xsl:template>

  <!-- TODO notes (read and error if trying to generate final version) -->
  <xsl:template match="annotation[@role='todo']">
    <xsl:if test="$show.annotations.comments = 0">
      <xsl:message terminate="yes">
	Final version of document must not contain TODO items !!!
      </xsl:message>
    </xsl:if>
    <fo:block xsl:use-attribute-sets="annotations.todo">
      <fo:block font-weight="bold" color="red">
	<xsl:text>TODO by </xsl:text>
	<fo:inline color="blue">
	  <xsl:value-of select="descendant::authorinitials"/>
	  <xsl:text> (</xsl:text>
	  <xsl:value-of select="descendant::orgname"/>
	  <xsl:text>)</xsl:text>
	</fo:inline>
      </fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- attribute sets for annotations -->
  <xsl:attribute-set name="annotations.comment">
    <xsl:attribute name="space-before">0.5em</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="line-height">10pt</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="end-indent">2mm</xsl:attribute>
    <xsl:attribute name="padding">1mm</xsl:attribute>
    <xsl:attribute name="border">0.75pt solid darkred</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="annotations.implementation">
    <xsl:attribute name="space-before">0.5em</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="line-height">10pt</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="end-indent">2mm</xsl:attribute>
    <xsl:attribute name="padding">1mm</xsl:attribute>
    <xsl:attribute name="border">0.75pt solid green</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="annotations.todo">
    <xsl:attribute name="space-before">0.5em</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="line-height">10pt</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="end-indent">2mm</xsl:attribute>
    <xsl:attribute name="padding">1mm</xsl:attribute>
    <xsl:attribute name="border">1pt solid red</xsl:attribute>
  </xsl:attribute-set>

  <!-- tweak level two title spacing a bit -->
  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-before.optimum">1.0em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">1.0em</xsl:attribute>
  </xsl:attribute-set>

  <!-- border around the shading of verbatim styles (e.g., programlisting) -->
  <xsl:attribute-set name="shade.verbatim.style">
    <xsl:attribute name="background-color">#f4f4f4</xsl:attribute>
    <xsl:attribute name="border">0.5pt solid black</xsl:attribute>
    <xsl:attribute name="padding-left">1pc</xsl:attribute>
    <xsl:attribute name="padding-right">1pc</xsl:attribute>
    <xsl:attribute name="space-before">0</xsl:attribute>
  </xsl:attribute-set>

  <!-- fixup spacing around verbatim environments -->
  <xsl:attribute-set name="monospace.verbatim.properties"
		     use-attribute-sets="verbatim.properties monospace.properties">
    <xsl:attribute name="start-indent">5pc</xsl:attribute>
    <xsl:attribute name="end-indent">1pc</xsl:attribute>
  </xsl:attribute-set>

<!-- not sure why, but the appendix title is indented like the body text,
     not like section title; this overrides that. -->
<xsl:attribute-set name="article.appendix.title.properties">
  <xsl:attribute name="margin-{$direction.align.start}">
    -4pc
  </xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
