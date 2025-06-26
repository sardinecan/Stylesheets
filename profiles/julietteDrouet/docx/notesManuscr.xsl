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

    <xsl:template match="tei:notesManuscr" mode="notesManuscr">
        <xsl:comment><xsl:copy-of select="."/></xsl:comment>
    </xsl:template>

    <xsl:template match="tei:notesManuscr" mode="insert">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:notesManuscr/text()[1]" mode="insert">
        <xsl:value-of select="normalize-space(substring(., 3))"/>
    </xsl:template>

    <xsl:template match="tei:hi[not(ancestor::tei:note)][@rend='superscript'][string-length(normalize-space(.)) = 1][matches(., '[a-z]{1}')][normalize-space(.)=('a', 'b', 'c', 'd', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm')]" mode="notesManuscr">
         <xsl:variable name="call" select="normalize-space(.)"/>
        <!--<xsl:variable name="notes" select="tei:formatNotes(following::*:notesMascrupt[1][starts-with(., $call)])"/>-->
        <!--<note type="manuscriptologique"><xsl:apply-templates select="$notes//*:note[@key = $call]/node()"/></note>-->
        <!--<note type="manuscriptologique"><xsl:apply-templates select="following::*[starts-with(., $call)][self::*:notesManuscr][1]/node()" mode="insert"/></note>-->
        <xsl:choose>
            <xsl:when test="./ancestor::tei:body//*:notesManuscr[starts-with(., $call)]/node()">
                <note type="manuscriptologique"><xsl:apply-templates select="./ancestor::tei:body//*:notesManuscr[starts-with(., $call)]/node()" mode="insert"/></note>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
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
