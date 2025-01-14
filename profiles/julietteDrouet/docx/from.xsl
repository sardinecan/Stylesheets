<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:iso="http://www.iso.org/ns/1.0"
    xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
    xmlns:o="urn:schemas-microsoft-com:office:office"
    xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
    xmlns:rel="http://schemas.openxmlformats.org/package/2006/relationships"
    xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
    xmlns:v="urn:schemas-microsoft-com:vml"
    xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
    xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
    xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
    xmlns:w10="urn:schemas-microsoft-com:office:word"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
    xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:tbx="http://www.lisa.org/TBX-Specification.33.0.html"
    version="3.0"
    exclude-result-prefixes="ve o r m v wp w10 w wne mml tbx pic rel a         tei teidocx xs iso">
    <xsl:strip-space elements="*"/>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
        <desc>
            <p> TEI stylesheet for simplifying TEI ODD markup </p>
            <p>This software is dual-licensed:
                
                1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
                Unported License http://creativecommons.org/licenses/by-sa/3.0/ 
                
                2. http://www.opensource.org/licenses/BSD-2-Clause
                
                Redistribution and use in source and binary forms, with or without
                modification, are permitted provided that the following conditions are
                met:
                
                * Redistributions of source code must retain the above copyright
                notice, this list of conditions and the following disclaimer.
                
                * Redistributions in binary form must reproduce the above copyright
                notice, this list of conditions and the following disclaimer in the
                documentation and/or other materials provided with the distribution.
                
                This software is provided by the copyright holders and contributors
                "as is" and any express or implied warranties, including, but not
                limited to, the implied warranties of merchantability and fitness for
                a particular purpose are disclaimed. In no event shall the copyright
                holder or contributors be liable for any direct, indirect, incidental,
                special, exemplary, or consequential damages (including, but not
                limited to, procurement of substitute goods or services; loss of use,
                data, or profits; or business interruption) however caused and on any
                theory of liability, whether in contract, strict liability, or tort
                (including negligence or otherwise) arising in any way out of the use
                of this software, even if advised of the possibility of such damage.
            </p>
            <p>Author: See AUTHORS</p>
            
            <p>Copyright: 2013, TEI Consortium</p>
        </desc>
    </doc>
    <!-- import base conversion style -->
    
    <xsl:import href="../../default/docx/from.xsl"/>
    <xsl:import href="teiCorpus.xsl"/>
    <xsl:import href="analyzeString.xsl"/>
    <xsl:template match="/" mode="pass2">
        <xsl:variable name="pass2">
            <xsl:apply-templates mode="pass2"/>
        </xsl:variable>
        <xsl:variable name="teiCorpus">
            <xsl:apply-templates select="$pass2" mode="teiCorpus"/>
        </xsl:variable>
        <xsl:apply-templates select="$teiCorpus" mode="analyzeString"/>
    </xsl:template>
    
    <xsl:template match="@style" mode="pass2"/>
    <xsl:template match="@xml:space" mode="pass2"/>
    <xsl:template match="tei:p/@rend[lower-case(.) = 'normal']" mode="pass2"/>
    <xsl:template match="tei:dateline" mode="pass2">
        <opener>
            <xsl:copy>
                <xsl:apply-templates select="node() | @*" mode="pass2"/>
            </xsl:copy>
        </opener>
    </xsl:template>
    <xsl:template match="tei:hi[not(@rend)]" mode="pass2">
        <xsl:apply-templates select="node()" mode="pass2"/>
    </xsl:template>
    
    <xsl:template match="tei:seg[@rend]" mode="pass2">
        <hi>
            <xsl:apply-templates select="node() | @*" mode="pass2"/>
        </hi>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend[. = 'italic']]" mode="pass2">
        <xsl:choose>
            <xsl:when test=".[normalize-space(.)='illis.' or normalize-space(.)='illis']">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:when test=".[normalize-space(.)='plusieurs mots illisibles' or normalize-space(.)='plusieurs mots illisibles.']">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:when test=".[normalize-space(.)='plusieurs lignes illisibles' or normalize-space(.)='plusieurs lignes illisibles.']">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <hi rend="underline"><xsl:apply-templates mode="pass2"/></hi>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*[not(self::tei:hi)][@rend[. = 'italic']]" mode="pass2">
        <xsl:attribute name="rend" select="'underline'"/>
    </xsl:template>
    
    <!--<xsl:template match="tei:resp" mode="pass2">
        <resp><xsl:value-of select="normalize-space(.)"/></resp>
        <xsl:if test="descendant::tei:pb"><pb/></xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:repository" mode="pass2">
        <repository><xsl:value-of select="normalize-space(.)"/></repository>
    </xsl:template>-->
    
    <xsl:template match="tei:note[@place='foot']" mode="pass2">
        <note type="footnote"><xsl:apply-templates select="tei:p/node()" mode="pass2"/></note>
    </xsl:template>
    
    <xsl:template match="tei:signed" mode="pass2">
        <closer>
            <xsl:copy>
                <xsl:apply-templates select="node() | @*" mode="pass2"/>
            </xsl:copy>
        </closer>
    </xsl:template>
    
    <xsl:template match="tei:g" mode="pass2">
        <xsl:choose>
            <xsl:when test="@n = '5b'"><xsl:text>[</xsl:text></xsl:when>
            <xsl:when test="@n = '5d'"><xsl:text>]</xsl:text></xsl:when>
            <xsl:otherwise><xsl:apply-templates mode="pass2"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
