<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:jd="http://juliettedrouet.org"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math tei"
    version="3.0">

    <xsl:template match="@xml:space" mode="specialChars"/>

    <xsl:template match="/" mode="specialChars">
        <xsl:apply-templates mode="specialChars"/>
    </xsl:template>

    <xsl:template match="@* | node()" mode="specialChars">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="specialChars"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" mode="specialChars">
        <xsl:variable name="half" as="xs:string" expand-text="no">1/2</xsl:variable>
        <xsl:analyze-string select="." regex="{$half}">
            <xsl:matching-substring>½</xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:variable name="quarter" as="xs:string" expand-text="no">1/4</xsl:variable>
                <xsl:analyze-string select="." regex="{$quarter}">
                    <xsl:matching-substring>¼</xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:variable name="threeQuarter" as="xs:string" expand-text="no">3/4</xsl:variable>
                        <xsl:analyze-string select="." regex="{$threeQuarter}">
                            <xsl:matching-substring>¾</xsl:matching-substring>
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
