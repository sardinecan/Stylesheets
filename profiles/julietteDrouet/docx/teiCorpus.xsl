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

    <xsl:template match="tei:hi[@rend[. = 'italic']]" mode="teiCorpus">
        <xsl:choose>
            <xsl:when test="ancestor::tei:note">
                <emph><xsl:apply-templates mode="teiCorpus" /></emph>
            </xsl:when>
            <xsl:otherwise>
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
                    <xsl:when test=".[normalize-space(.)='?' or normalize-space(.)=' ?'] or normalize-space(.)=' '">
                        <xsl:value-of select="normalize-space(.)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <hi rend="underline"><xsl:apply-templates mode="teiCorpus"/></hi>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='baseline']" mode="teiCorpus">
        <xsl:apply-templates select="node()" mode="teiCorpus"/>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='smallcaps' or @rend='allcaps']" mode="teiCorpus">
        <xsl:apply-templates select="node()" mode="teiCorpus"/>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='smallcaps' or @rend='allcaps']/descendant::text()" mode="teiCorpus">
        <xsl:choose>
            <xsl:when test="ancestor::tei:note">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="upper-case(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="/" mode="teiCorpus">
        <teiCorpus xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>title of corpus</title>
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
                <xsl:variable name="corpusID" select="'jd.entry.' || generate-id(.)" />
                <teiCorpus xml:id="{$corpusID}">
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title>title of corpus</title>
                            </titleStmt>
                            <publicationStmt>
                                <p>Publication Information</p>
                            </publicationStmt>
                            <sourceDesc>
                                <p>Information about the source</p>
                            </sourceDesc>
                        </fileDesc>
                        <profileDesc>
                            <langUsage>
                                <language ident="fre">Français</language>
                            </langUsage>
                            <textClass></textClass>
                        </profileDesc>
                    </teiHeader>
                    <xsl:for-each-group select="current-group()" group-starting-with="*:dateline | *:opener">
                        <xsl:variable name="position" select="format-number(position(), '00')"/>
                        <TEI xml:id="{$corpusID || '.' || $position}">
                            <teiHeader>
                                <fileDesc>
                                    <titleStmt>
                                        <title><!-- ... --></title>
                                        <xsl:apply-templates select="jd:responsabilities(current-group()[self::tei:resp][1])" mode="teiCorpus"/>
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

    <xsl:template match="tei:body/descendant::tei:persName" mode="teiCorpus">
        <persName ref=""><xsl:apply-templates select="node() | @*" mode="teiCorpus"/></persName>
    </xsl:template>

    <xsl:template match="tei:body/descendant::tei:term" mode="teiCorpus">
        <term ref=""><xsl:apply-templates select="node() | @*" mode="teiCorpus"/></term>
    </xsl:template>

    <xsl:template match="tei:p[tei:pb][normalize-space(.)='']" mode="teiCorpus"/>

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
