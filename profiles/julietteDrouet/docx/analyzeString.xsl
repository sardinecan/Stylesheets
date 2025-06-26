<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:jd="http://juliettedrouet.org"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math tei"
    version="3.0">
    
    <xsl:import href="blop.xsl"/>
    <xsl:import href="gap.xsl"/>
    <xsl:import href="unclear.xsl"/>
    <xsl:import href="supplied.xsl"/>
    <xsl:import href="notesManuscr.xsl"/>
    <xsl:import href="specialChars.xsl"/>
    
    <xsl:template match="@* | node()" mode="analyzeString">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="analyzeString"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/" mode="analyzeString">
        <xsl:processing-instruction name="xml-model">
            href="https://gitlab.huma-num.fr/ceen/juliette-drouet/model/-/raw/main/juliettedrouet.odd.rng?ref_type=heads"
            type="application/xml"
            schematypens="http://relaxng.org/ns/structure/1.0"
        </xsl:processing-instruction>
        
        <xsl:variable name="blop">
            <xsl:apply-templates mode="blop"/>
        </xsl:variable>

        <xsl:variable name="gap">
            <xsl:apply-templates select="$blop" mode="gap"/>
        </xsl:variable>
        <xsl:variable name="unclear">
            <xsl:apply-templates select="$gap" mode="unclear"/>
        </xsl:variable>
        <xsl:variable name="supplied">
            <xsl:apply-templates select="$unclear" mode="supplied"/>
        </xsl:variable>
        <xsl:variable name="notesManuscr">
            <xsl:apply-templates select="$supplied" mode="notesManuscr"/>
        </xsl:variable>
        <xsl:apply-templates select="$notesManuscr" mode="specialChars"/>
        
    </xsl:template>
    
</xsl:stylesheet>
