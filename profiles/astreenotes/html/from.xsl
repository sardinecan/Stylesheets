<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:m="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="tei xs m" version="3.0"
    xmlns:html="http://www.w3.org/1999/xhtml" xpath-default-namespace="http://www.w3.org/1999/xhtml">

  <xsl:output method="xml" indent="true" />
  <xsl:strip-space elements="*" />

  <xsl:import href="../../default/html/from.xsl"/>

  <!--
  @todo
  - span @class=debut_livre => hi rend lettrine ?
  - span @class=micro => idem ? 
  - span @class=first => idem aussi ?
  - span class="var_init" contenant une étoile *
  - span class="cache" avant les notes

  @todo vérifier les ancres => création d'ancres et de pb, qui sont aussi des ancres l'origine, mais utilisation de @n
  -->
  <xsl:variable name="documentName" select="substring-before(tokenize(base-uri(), '/')[last()], '.')"/>
  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>

   <xsl:template match="a[@class]">
    <xsl:choose>
      <xsl:when test="@class = 'glossaire'">
        <term ref="{ substring-after(@href, '.html') }"><xsl:apply-templates/></term>
      </xsl:when>
      <xsl:when test="@class = 'bibliographie'">
        <bibl source="{ substring-after(@href, '.html') }"><xsl:apply-templates/></bibl>
      </xsl:when>
      <xsl:when test="@class = 'personnage'">
        <persName ref="{ substring-after(@href, '.html') }"><xsl:apply-templates/></persName>
      </xsl:when>
      <xsl:when test="@class = 'repertoire'">
        <rs type="{ @class }" ref="{ substring-after(@href, '.html') }"><xsl:apply-templates/></rs>
      </xsl:when>
      <xsl:when test="@class = 'note'">
        <note target="{ @href }" />
      </xsl:when>
      <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="div[@id = 'Page_content_goes_here']/table">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="div[@id = 'Page_content_goes_here']/table/tr">
    <div type="note" xml:id="{ $documentName || '.' || td[1]/a[not(following-sibling::*[1][self::em])]/@id }">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="div[@id = 'Page_content_goes_here']/table/tr/td">
    <xsl:choose>
      <xsl:when test="position() = 1">
        <label><xsl:apply-templates /></label>
      </xsl:when>
      <xsl:otherwise>
        <div type="noteContent">
          <p><xsl:apply-templates /></p>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="span[@class='italics']">
    <emph><xsl:apply-templates /></emph>
  </xsl:template>

  <xsl:template match="nav" />
  <xsl:template match="footer" />
  <xsl:template match="@onclick" />
  <xsl:template match="script" />

</xsl:stylesheet>
