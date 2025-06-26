<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:jd="http://juliettedrouet.org"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math tei"
    version="3.0">
    
    <xsl:template match="/" mode="blop">
        <xsl:apply-templates mode="blop"/>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="blop">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="blop"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*:blop" mode="blop"/>
</xsl:stylesheet>
