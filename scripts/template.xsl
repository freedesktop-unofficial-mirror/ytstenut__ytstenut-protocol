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

  <!-- annotations output -->
  <xsl:template match="annotation[@role='comment']">
    <xsl:if test="$show.annotations.comments != 0">
    <fo:block xsl:use-attribute-sets="annotations.comment">
      <fo:block font-weight="bold" color="darkred">
	<xsl:text>Comment by </xsl:text>
	<fo:inline color="darkblue">
	  <xsl:value-of select="descendant::authorinitials"/>
	</fo:inline>
      </fo:block>
      <xsl:apply-templates/>
    </fo:block>
    </xsl:if>
  </xsl:template>

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
	</fo:inline>
      </fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:attribute-set name="annotations.comment">
    <xsl:attribute name="space-before">0.5em</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="line-height">10pt</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="end-indent">2mm</xsl:attribute>
    <xsl:attribute name="padding">1mm</xsl:attribute>
    <xsl:attribute name="border">0.75pt solid darkred</xsl:attribute>
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

<xsl:attribute-set name="section.title.level2.properties">
  <xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
  <xsl:attribute name="space-before.optimum">1.0em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">1.0em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="shade.verbatim.style">
  <xsl:attribute name="background-color">#f4f4f4</xsl:attribute>
  <xsl:attribute name="border">0.5pt solid black</xsl:attribute>
  <xsl:attribute name="padding-left">1pc</xsl:attribute>
  <xsl:attribute name="padding-right">1pc</xsl:attribute>
  <xsl:attribute name="space-before">0</xsl:attribute>
</xsl:attribute-set>
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
