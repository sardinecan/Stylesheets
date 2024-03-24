<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
   xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
   xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
   xmlns="http://www.tei-c.org/ns/1.0"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   exclude-result-prefixes="#all"
   version="2.0">
   
   <xsl:import href="../../default/docx/from.xsl"/>
   
   <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
   
   <xsl:template match="/">
      <xsl:apply-templates/>
   </xsl:template>
   
   <xsl:template match="*[local-name()='t'][normalize-space(.)=''][ancestor::w:p[normalize-space(.)='']]">
      <!--<xsl:copy>
         <xsl:text>séparation</xsl:text>
      </xsl:copy>-->
      <xsl:comment>séparation</xsl:comment>
   </xsl:template>
   
   <!-- la modification du template au-dessus induit le maintien des bookmarks -->
   <xsl:template match="w:bookmarkStart"/>
</xsl:stylesheet>