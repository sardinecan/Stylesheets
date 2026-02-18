<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:foo="foo/bar"
    exclude-result-prefixes="tei xs foo" version="3.0"
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
  - span class="erreur1610" voir (https://astree.univ-rouen.fr/_analyse/note_2.html#2_lacune) et II, 12, 804

  @todo vérifier les ancres => création d'ancres et de pb, qui sont aussi des ancres l'origine, mais utilisation de @n
  -->


    <xsl:template match="p[@class = 'italicspage'] | span[@class = 'italicspage']">
        <xsl:variable name="name" select="./local-name()"/>
        <xsl:variable name="id" select="'pb' ||  ./a[@id][1]/@id"/>
        <xsl:element name="{$name}">
            <xsl:attribute name="xml:id" select="./a[@id][1]/@id"/>
            <pb n="{ ./a[@id][1]/@id }"/>
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>


    <xsl:template match="p[@class = 'italicspage']/text()"/>
    <xsl:template match="p[@class = 'italicspage']/a[@id]"/>


    <xsl:template match="img[@class='signet']"  />

    <xsl:template match="a[@id][not(ancestor::*[@class = 'italicspage'])]">
        <anchor xml:id="{ foo:normalize-id(normalize-space(@id)) }"/>
    </xsl:template>

    <xsl:variable name="documentname" select="base-uri()"/>
    <xsl:function name="foo:normalize-id">
        <xsl:param name="id"/>
        <xsl:variable name="filename" select="tokenize($documentname, '/')[last()]"/>
        <xsl:variable name="basename" select="substring-before($filename, '.html')"/>
        <xsl:value-of select="concat($basename, '.', $id)" />
    </xsl:function>

</xsl:stylesheet>
