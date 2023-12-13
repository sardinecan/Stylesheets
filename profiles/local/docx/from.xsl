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
   
   <xsl:template match="/">
      <xsl:apply-templates/>
   </xsl:template>
   
   <xsl:template match="*[local-name()='t'][normalize-space(.)='']">
      <xsl:copy>
         <xsl:text>séparation</xsl:text>
      </xsl:copy>
   </xsl:template>
</xsl:stylesheet>