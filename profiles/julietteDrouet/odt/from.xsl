<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="3.0">
    <!-- import base conversion style -->
    <xsl:strip-space elements="*"/>
    <xsl:import href="../../../odt/odttotei.xsl"/>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
        <desc>
            <p>TEI stylesheet for simplifying TEI ODD markup</p>
            <p>This software is dual-licensed: 1. Distributed under a Creative Commons Attribution-ShareAlike 3.0 Unported License http://creativecommons.org/licenses/by-sa/3.0/ 2. http://www.opensource.org/licenses/BSD-2-Clause Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met: * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution. This software is provided by the copyright holders and contributors "as is" and any express or implied warranties, including, but not limited to, the implied warranties of merchantability and fitness for a particular purpose are disclaimed. In no event shall the copyright holder or contributors be liable for any direct, indirect, incidental, special, exemplary, or consequential damages (including, but not limited to, procurement of substitute goods or services; loss of use, data, or profits; or business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of the use of this software, even if advised of the possibility of such damage.</p>
            <p>Author: See AUTHORS</p>
            <p>Copyright: 2013, TEI Consortium</p>
        </desc>
    </doc>
    <xsl:import href="teiCorpus.xsl"/>
    <xsl:import href="analyzeString.xsl"/>

    <xsl:template match="/" mode="pass3">
        <xsl:variable name="pass3">
            <xsl:apply-templates mode="pass3"/>
        </xsl:variable>
        <xsl:variable name="teiCorpus">
            <xsl:apply-templates select="$pass3" mode="teiCorpus"/>
        </xsl:variable>
        <xsl:apply-templates select="$teiCorpus" mode="analyzeString"/>
    </xsl:template>

    <xsl:template match="@style" mode="pass3"/>
    <xsl:template match="@xml:space" mode="pass3"/>
    <xsl:template match="tei:p/@rend[lower-case(.) = 'normal']" mode="pass3"/>
    <xsl:template match="tei:p/@rend[lower-case(.) = 'justify']" mode="pass3"/>
    <xsl:template match="@rend[. = 'end']" mode="pass3" />

    <xsl:template match="tei:dateline | tei:p[tei:date]" mode="pass3">
        <opener>
            <dateline>
                <xsl:apply-templates select="node() | @*" mode="pass3"/>
            </dateline>
        </opener>
    </xsl:template>

    <xsl:template match="tei:seg[@rend]" mode="pass3">
        <hi><xsl:apply-templates select="node() | @*" mode="pass3"/></hi>
    </xsl:template>

    <xsl:template match="tei:seg[normalize-space(.)=''][tei:g]" mode="pass3">
        <xsl:apply-templates select="node()" mode="pass3"/>
    </xsl:template>

    <xsl:template match="tei:hi" mode="pass3">
        <xsl:call-template name="process-rend">
            <xsl:with-param name="rend-values" select="tokenize(@rend, ' ')"/>
            <xsl:with-param name="content" select="node()"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="tei:head" mode="pass3">
        <p>
            <xsl:apply-templates select="node() | @*" mode="pass3"/>
        </p>
    </xsl:template>

    <!-- Processus récursif pour imbriquer les balises hi -->
    <xsl:template name="process-rend">
        <xsl:param name="rend-values"/>
        <xsl:param name="content"/>
        <xsl:choose>
            <xsl:when test="count($rend-values) &gt; 0">
                <xsl:variable name="current-rend" select="$rend-values[1]"/>
                <xsl:variable name="remaining-rend" select="subsequence($rend-values, 2)"/>
                <hi>
                    <xsl:attribute name="rend">
                        <xsl:value-of select="$current-rend"/>
                    </xsl:attribute>
                    <xsl:call-template name="process-rend">
                        <xsl:with-param name="rend-values" select="$remaining-rend"/>
                        <xsl:with-param name="content" select="$content"/>
                    </xsl:call-template>
                </hi>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$content" mode="pass3"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[not(self::tei:hi)]/@rend[. = 'italic']" mode="pass3">
        <xsl:attribute name="rend" select="'underline'"/>
    </xsl:template>

    <xsl:template match="tei:note[@place='foot']" mode="pass3">
        <note type="footnote">
            <xsl:apply-templates select="node()" mode="pass3"/>
        </note>
    </xsl:template>

    <xsl:template match="tei:signed" mode="pass3">
        <closer>
            <xsl:copy>
                <xsl:apply-templates select="node() | @*" mode="pass3"/>
            </xsl:copy>
        </closer>
    </xsl:template>

    <xsl:template match="tei:g" mode="pass3">
        <xsl:choose>
            <xsl:when test="matches(@n, '5b', 'i')"><xsl:text>[</xsl:text></xsl:when>
            <xsl:when test="matches(@n, '5d', 'i')"><xsl:text>]</xsl:text></xsl:when>
            <xsl:otherwise><xsl:apply-templates mode="pass3"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
