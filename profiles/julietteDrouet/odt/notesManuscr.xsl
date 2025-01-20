<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:jd="http://juliettedrouet.org"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math tei"
    version="3.0">
    
    <xsl:template match="/" mode="notesManuscr">
        <xsl:apply-templates mode="notesManuscr"/>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="notesManuscr">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="notesManuscr"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()" mode="notesManuscr">
        <xsl:variable name="noteManuscr" as="xs:string" expand-text="no">\{([^\}]*)\}</xsl:variable>
        <xsl:analyze-string select="." regex="{$noteManuscr}">
            <xsl:matching-substring><note type="manuscriptologique"><xsl:value-of select="regex-group(1)"/></note></xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
</xsl:stylesheet>