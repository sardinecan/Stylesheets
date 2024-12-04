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

  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="div">
    <div>
      <xsl:if test="@id"><xsl:attribute name="type" select="@id"/></xsl:if>
      <xsl:if test="@class"><xsl:attribute name="rend" select="@class"/></xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
 
  <!-- 
  <xsl:template match="div[@id='banderole']">
    <head><xsl:apply-templates/></head>
  </xsl:template>

  <xsl:template match="div[@id='document']">
    <div type="{ @id }">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="div[@id='Page_content_goes_here']">
    <div type="livre">
      <xsl:apply-templates />
    </div>
  </xsl:template>
  -->
  
  <xsl:template match="a[@class]">
    <xsl:choose>
      <xsl:when test="@class = 'glossaire'">
        <term ref="{ substring-after(@href, '.html') }"><xsl:apply-templates/></term>
      </xsl:when>
      <xsl:when test="@class = 'bibliographie'">
        <bibl ref="{ substring-after(@href, '.html') }"><xsl:apply-templates/></bibl>
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

  <xsl:template match="span[@class='var_init'][following-sibling::*[1][self::span[@class='varp']]][following-sibling::*[2][self::span[@class='var21']]]">
    <!--
      https://astree.tufts.edu/_analyse/guide.html#variantes
    -->
    <app type="modification">
      <xsl:if test="matches(., '\*')"><xsl:attribute name="subtype" select="'important'"/></xsl:if>
      <lem wit="#var21"><xsl:apply-templates select="./following-sibling::*[2][self::span[@class='var21']]/node()" /></lem>
      <rdg wit="#varp"><xsl:apply-templates select="./following-sibling::*[1][self::span[@class='varp']]/node()" /></rdg>
    </app>
  </xsl:template>

  <xsl:template 
    match="span[@class='var21'][preceding-sibling::*[2][self::span[@class='var_init']]]
    | span[@class='varp'][preceding-sibling::*[1][self::span[@class='var_init']]]" />


  <xsl:template match="span[@class='var21nouveau'] | span[@class='var21titresnouveau']">
    <app type="addition">
      <xsl:if test="preceding-sibling::*[1][self::span[@class='var_init']][matches(., '\*')]"><xsl:attribute name="subtype" select="'important'"/></xsl:if>
      <lem wit="#var21">
        <xsl:choose>
          <xsl:when test="@class='var21titresnouveau'"><hi rend="titre"><xsl:apply-templates /></hi></xsl:when>
          <xsl:otherwise><xsl:apply-templates /></xsl:otherwise>
        </xsl:choose>
     </lem>
      <rdg wit="#varp"/>
    </app>
  </xsl:template>

  <xsl:template match="span[@class='var_init'][following-sibling::*[1][self::span[@class='var21nouveau']]]" />

  <xsl:template match="span[@class='var_init'][following-sibling::*[1][self::span[@class='varp']]][not(following-sibling::*[2][self::span[@class='var21']])]">
    <!--
      https://astree.tufts.edu/_analyse/guide.html#variantes
    -->
    <app type="omission">
      <xsl:if test="matches(., '\*')"><xsl:attribute name="subtype" select="'important'"/></xsl:if>
      <lem wit="#var21" />
      <rdg wit="#varp"><xsl:apply-templates select="./following-sibling::*[1][self::span[@class='varp']]/node()" /></rdg>
    </app>
  </xsl:template>

  <xsl:template match="p[@class = 'italicspage']">
        <pb n="{ ./a[@id][1]/@id }"/>
  </xsl:template>

  <xsl:template match="a[@id][not(ancestor::*[@class = 'italicspage'])]">
    <anchor xml:id="{ normalize-space(@id) }"/>
  </xsl:template>


  <xsl:template match="nav" />
  <xsl:template match="footer" />
  <xsl:template match="@onclick" />
  <xsl:template match="script" />

</xsl:stylesheet>
