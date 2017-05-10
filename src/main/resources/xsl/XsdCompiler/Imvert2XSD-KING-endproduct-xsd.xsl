<?xml version="1.0" encoding="UTF-8"?>
<!-- 
 * Copyright (C) 2016 Dienst voor het kadaster en de openbare registers
 * 
 * This file is part of Imvertor.
 *
 * Imvertor is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Imvertor is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Imvertor.  If not, see <http://www.gnu.org/licenses/>.
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:UML="omg.org/UML1.3"
    
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    xmlns:imvert-result="http://www.imvertor.org/schema/imvertor/application/v20160201"
    xmlns:ep="http://www.imvertor.org/schema/endproduct"
    
    xmlns:bg="http://www.egem.nl/StUF/sector/bg/0310" 
    xmlns:metadata="http://www.kinggemeenten.nl/metadataVoorVerwerking" 
    xmlns:ztc="http://www.kinggemeenten.nl/ztc0310" 
    xmlns:stuf="http://www.stufstandaarden.nl/onderlaag/stuf0302" 
    
    xmlns:ss="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
    
    version="2.0">
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="Imvert2XSD-KING-common.xsl"/>
    
    <xsl:import href="Imvert2XSD-KING-create-endproduct-schema.xsl"/>
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8" exclude-result-prefixes="#all"/>
    
    <!-- set the processing parameters of the stylesheets. -->
    <xsl:variable name="stylesheet-code">SKS</xsl:variable>
    <xsl:variable name="debugging" select="imf:debug-mode($stylesheet-code)" as="xs:boolean"/>

    <xsl:variable name="use-EAPconfiguration" select="'yes'"/>
    
    <!--xsl:variable name="imvert-endproduct" select="imf:document(imf:get-config-string('properties','RESULT_ENDPRODUCT_XML_FILE_PATH'))"/-->  
    <!--xsl:variable name="imvert-endproduct" select="imf:document(imf:get-config-string('properties','RESULT_ORDERED_ENDPRODUCT_XML_FILE_PATH'))"/-->  
    
    
    <!--xsl:variable name="xsd-folder-path" select="imf:get-config-string('system','xsd-folder-path')"/-->
    <!--xsl:variable name="koppelvlak-folder" select="substring-after(ep:message-sets/ep:message-set[@KV-namespace='yes']/ep:namespace,'http://www.stufstandaarden.nl/koppelvlak/')"/-->
    <xsl:variable name="xsd-file-folder-path" select="imf:get-config-string('properties','RESULT_XSD_APPLICATION_FOLDER')"/>
    <!--xsl:variable name="xsd-file-url" select="imf:file-to-url(concat($xsd-file-folder-path,'/koppelvlak.xsd'))"/-->
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ep:message-sets">
        <!--xsl:for-each select="$imvert-endproduct/ep:message-set"-->
        <xsl:for-each select="ep:message-set">
            <xsl:variable name="xsd-file-url">
                <xsl:choose>
                    <xsl:when test="ep:name = 'STUF'"><xsl:value-of select="imf:file-to-url(concat($xsd-file-folder-path,'/StUF-simpleTypes.xsd'))"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="imf:file-to-url(concat($xsd-file-folder-path,'/',ep:name,'.xsd'))"/></xsl:otherwise>
                    <!--xsl:when test="ep:name = 'STUF'"><xsl:value-of select="imf:file-to-url(concat($xsd-file-folder-path,'/',$koppelvlak-folder,'/StUF-simpleTypes.xsd'))"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="imf:file-to-url(concat($xsd-file-folder-path,'/',$koppelvlak-folder,'/',ep:name,'.xsd'))"/></xsl:otherwise-->
                </xsl:choose>
            </xsl:variable>
            <result>
                <xsl:comment select="concat('XSD voor ', imvert:name, ' is geplaatst in ', $xsd-file-url)"/>
            </result>
            <xsl:result-document href="{$xsd-file-url}">
                <xsl:apply-templates select="."/>
            </xsl:result-document>
        </xsl:for-each>
        
        <xsl:for-each select="ep:message-set[1]">
            <!-- singleton -->
            <xsl:sequence select="imf:set-config-string('system','xsd-result-subpath-BSM',concat(ep:project,'/',ep:name,'/',ep:release))"/>
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template match="/imvert:dummy"/>
    
</xsl:stylesheet>
