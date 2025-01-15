<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:jd="http://juliettedrouet.org"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math tei"
    version="3.0">
    
    <xsl:output method="xml" indent="true" encoding="UTF-8" />
    <!-- @todo
        smallcaps => Majuscule
    -->
    <xsl:template match="node() | @*" mode="teiCorpus">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="teiCorpus"/>
        </xsl:copy>
    </xsl:template>
    
    <!--<xsl:template match="tei:p[jd:separator]"/>-->
    <xsl:template match="@xml:space" mode="teiCorpus"/>
    <xsl:template match="tei:resp[not(ancestor::tei:respStmt)]" mode="teiCorpus"/>
    <xsl:template match="tei:lieuConservation" mode="teiCorpus"/>
    <xsl:template match="tei:sourcesImprimees" mode="teiCorpus"/>
    <xsl:template match="tei:notesManuscr" mode="teiCorpus"/>
    <xsl:template match="tei:notesManuscr" mode="insert">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:hi[not(ancestor::tei:note)]" mode="teiCorpus">
        <xsl:choose>
            <xsl:when test="@rend='italic allcaps' or @rend='allcaps italic'">
                <hi rend="underline"><xsl:value-of select="upper-case(normalize-space(.))"/></hi>
            </xsl:when>
            <xsl:when test="@rend='allcaps' or @rend='smallcaps'">
                <xsl:value-of select="upper-case(normalize-space(.))"/>
            </xsl:when>
            <xsl:when test=".[@rend='superscript'][string-length(.) = 1][matches(., '[a-z]{1}')][normalize-space(.)=('a', 'b', 'c', 'd', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm')]">
                <!--<xsl:variable name="notes" select="tei:formatNotes(ancestor::*:div[@type='letter']//*:p[last()])"/>-->
                <xsl:variable name="call" select="normalize-space(.)"/>
                <!--<xsl:variable name="notes" select="tei:formatNotes(following::*:notesMascrupt[1][starts-with(., $call)])"/>-->
                <!--<note type="manuscriptologique"><xsl:apply-templates select="$notes//*:note[@key = $call]/node()"/></note>-->
                <note type="manuscriptologique"><xsl:apply-templates select="following::*[starts-with(., $call)][self::*:notesManuscr][1]/node()" mode="insert"/></note>
            </xsl:when>
            
            <xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend='underline'][ancestor::tei:note]" mode="teiCorpus">
        <emph><xsl:apply-templates mode="teiCorpus"/></emph>
    </xsl:template>
    
    <xsl:template match="tei:notesManuscr/text()[1]" mode="insert">
        <xsl:value-of select="normalize-space(substring(., 3))"/>
    </xsl:template>
    
    <xsl:template match="/" mode="teiCorpus">
        <teiCorpus xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>title of corpus</title>
                        <author>author</author>
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Information about the source</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <xsl:for-each-group select=".//tei:body/*" group-ending-with="*[tei:pb]">
                <teiCorpus xmlns="http://www.tei-c.org/ns/1.0">
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title>title of corpus</title>
                                <author>author</author>
                            </titleStmt>
                            <publicationStmt>
                                <p>Publication Information</p>
                            </publicationStmt>
                            <sourceDesc>
                                <p>Information about the source</p>
                            </sourceDesc>
                        </fileDesc>
                    </teiHeader>
                    <xsl:for-each-group select="current-group()" group-starting-with="tei:opener">
                        <TEI>
                            <teiHeader>
                                <fileDesc>
                                    <titleStmt>
                                        <title><!-- ... --></title>
                                        <xsl:apply-templates select="jd:responsabilities(current-group()[self::tei:resp])" mode="teiCorpus"/>
                                        <!--<xsl:value-of select="foo:responsability(current-group()[self::tei:resp])"/>-->
                                    </titleStmt>
                                    <publicationStmt>
                                        <p><!-- ... --></p>
                                    </publicationStmt>
                                    <sourceDesc>
                                        <msDesc>
                                            <msIdentifier>
                                                <repository>
                                                    <xsl:value-of select="current-group()[self::tei:lieuConservation]"/>
                                                </repository>
                                                
                                            </msIdentifier>
                                        </msDesc>
                                        <xsl:if test="current-group()[self::tei:sourcesImprimees]">
                                            <listBibl>
                                                <xsl:variable name="rgx" as="xs:string" expand-text="no">\[([^?\]]*)\]</xsl:variable>
                                                <xsl:analyze-string select="current-group()[self::tei:sourcesImprimees]/normalize-space()" regex="{$rgx}">
                                                    <xsl:matching-substring>
                                                        <xsl:for-each select="tokenize(regex-group(1), ',')">
                                                            <bibl><xsl:value-of select="normalize-space(.)"/></bibl>
                                                        </xsl:for-each>
                                                    </xsl:matching-substring>
                                                </xsl:analyze-string> 
                                            </listBibl>
                                        </xsl:if>
                                    </sourceDesc>
                                </fileDesc>
                                <profileDesc>
                                    <correspDesc>
                                        <correspAction type="written">
                                            <persName>Juliette Drouet</persName>
                                            <date when=""><xsl:value-of select="current-group()//tei:dateline/string-join(tei:date)"/></date>
                                            <placeName>
                                                <xsl:choose>
                                                    <xsl:when test="current-group()//tei:dateline/tei:placeName">
                                                        <xsl:value-of select="current-group()[1]//tei:dateline/string-join(tei:placeName)"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>Paris</xsl:otherwise>
                                                </xsl:choose>
                                            </placeName>
                                        </correspAction>
                                        <correspAction type="received">
                                            <persName>Victor Hugo</persName>
                                        </correspAction>
                                    </correspDesc>
                                </profileDesc>
                            </teiHeader>
                            <text>
                                <body>
                                    <div type="letter">
                                        <xsl:apply-templates select="current-group()" mode="teiCorpus"/>
                                    </div>
                                </body>
                            </text>
                        </TEI>
                    </xsl:for-each-group>
                </teiCorpus>
            </xsl:for-each-group>
        </teiCorpus>
    </xsl:template>
    
    <xsl:function name="jd:responsabilities">
        <xsl:param name="resp"/>
        <xsl:variable name="completepattern">Transcription d[e|'|’]\s*(.+)\s+assisté(?:e)?(?:s)?\s+d[e|'|’]\s*(.+)</xsl:variable>
        <xsl:variable name="shortpattern">Transcription d[e|'|’]\s*(.+)</xsl:variable>
        
        <xsl:analyze-string select="$resp" regex="{$completepattern}">
            <xsl:matching-substring>
                <respStmt><resp>Transcription</resp><persName><xsl:value-of select="regex-group(1)"/></persName></respStmt>
                <respStmt><resp>Contrôle</resp><persName><xsl:value-of select="regex-group(2)"/></persName></respStmt>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="$resp" regex="{$shortpattern}">
                    <xsl:matching-substring>
                        <respStmt><resp>Transcription</resp><persName><xsl:value-of select="regex-group(1)"/></persName></respStmt>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    <xsl:function name="jd:responsability">
        <xsl:param name="resp"/>
        <xsl:variable name="completepattern">Transcription d[e|'|’]\s*(.+)\s+assisté(?:e)?(?:s)?\s+d[e|'|’]\s*(.+)</xsl:variable>
        <xsl:variable name="shortpattern">Transcription d[e|'|’]\s*(.+)</xsl:variable>
        <xsl:variable name="transcribers">
            <xsl:choose>
                <xsl:when test="$resp[matches(normalize-space(.), $completepattern)]">
                    <xsl:apply-templates select="analyze-string($resp, $completepattern)//*:match/*:group" mode="teiCorpus"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="analyze-string($resp, $shortpattern)//*:match/*:group" mode="teiCorpus"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="$transcribers">
            <xsl:variable name="i" select="position()"/>
            <xsl:choose>
                <xsl:when test="$i = 1 ">
                    <xsl:for-each select="tokenize(., ' et ')">
                        <respStmt><resp>Transcription</resp><persName><xsl:apply-templates select="$transcribers" mode="teiCorpus"/></persName></respStmt>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <respStmt><resp>Contrôle</resp><persName><xsl:value-of select="."/></persName></respStmt>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="jd:formatNotes">
        <xsl:param name="rawNotes"/>
        <notes>
            <xsl:for-each-group select="$rawNotes/node()" group-ending-with="*:lb">
                <xsl:variable name="note" select="normalize-space(string-join(current-group()[not(self::*:lb)]))"/>
                <xsl:variable name="key" select="substring($note, 1, 1)"/>
                <xsl:variable name="type">
                    <xsl:choose>
                        <xsl:when test="substring($note, 4, 1) = '«'"><xsl:text>correction</xsl:text></xsl:when>
                        <xsl:otherwise><xsl:text>footnote</xsl:text></xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="body">
                    <xsl:choose>
                        <!--a priori les corrections sont toujours des nœuds `texte`-->
                        <xsl:when test="$type = 'correction'"><xsl:value-of select="normalize-space(substring(., 4))"/></xsl:when>
                        <!--les autres notes peuvent être composées de contenu mixte-->
                        <xsl:otherwise>
                            <xsl:for-each select="current-group()">
                                <xsl:choose>
                                    <!--le premier nœud est toujours du texte-->
                                    <xsl:when test="position() = 1"><xsl:value-of select="normalize-space(substring(., 4))"/></xsl:when>
                                    <!--si contenu mixte, il sera copié-->
                                    <xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <note key="{$key}" type="{$type}">
                    <xsl:apply-templates select="$body" mode="teiCorpus"/>
                </note>
            </xsl:for-each-group>
        </notes>
    </xsl:function>
    
</xsl:stylesheet>