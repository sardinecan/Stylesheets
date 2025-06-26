<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:jd="http://juliettedrouet.org"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math tei"
    version="3.0">
    
    <xsl:template match="/" mode="gap">
        <xsl:apply-templates mode="gap"/>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="gap">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="gap"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()" mode="gap">
        <xsl:variable name="gap" as="xs:string" expand-text="no">\[illis\.?\]</xsl:variable>
        <xsl:analyze-string select="." regex="{$gap}">
            <xsl:matching-substring>
                <gap/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:variable name="wordsGap" as="xs:string" expand-text="no">\[plusieurs mots illisibles\.?\]</xsl:variable>
                <xsl:analyze-string select="." regex="{$wordsGap}">
                    <xsl:matching-substring>
                        <!--<gap extent="few words"/>-->
                        <note type="editor">plusieurs mots illisibles.</note>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:variable name="linesGap" as="xs:string" expand-text="no">\[plusieurs lignes illisibles\.?\]</xsl:variable>
                        <xsl:analyze-string select="." regex="{$linesGap}">
                            <xsl:matching-substring>
                                <!--<gap extent="few lines"/>-->
                                <note type="editor">plusieurs lignes illisibles.</note>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:value-of select="."/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
</xsl:stylesheet>
