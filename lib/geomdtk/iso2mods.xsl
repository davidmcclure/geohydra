<?xml version="1.0" encoding="UTF-8"?>
<!-- 
     iso19139_to_mods.xsl - Transformation from ISO 19139 XML into MODS v3 
     
     Copyright 2013, Stanford University Libraries.
     
     Created by Kim Durante and Darren Hardy.
     -->
<xsl:stylesheet 
  xmlns="http://www.loc.gov/mods/v3" 
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmi="http://www.isotc211.org/2005/gmi" 
  xmlns:gmd="http://www.isotc211.org/2005/gmd" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0" 
  exclude-result-prefixes="gmd gco gmi">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <!-- The coordinates value for MODS v3 is quite vague, 
       so we have a variety of formats: 
       WMS, GML, GeoRSS, MARC034, MARC255 (default)
       -->
  <xsl:variable name="geoformat" select="'GeoRSS'"/>
  <xsl:template match="/">
    <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
          xmlns="http://www.loc.gov/mods/v3" 
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd">
      <xsl:for-each select="/gmi:MI_Metadata|/gmd:MD_Metadata">
        <xsl:for-each select="gmd:fileIdentifier/gco:CharacterString/text()">
          <identifier type="local" displayLabel="file_identifier_id">
            <xsl:text>geonetwork:</xsl:text>
            <xsl:value-of select="."/></identifier>
        </xsl:for-each>
        <xsl:for-each select="gmd:dataSetURI/gco:CharacterString/text()">
          <identifier type="local" displayLabel="data_set_uri">
            <xsl:value-of select="." />
          </identifier>
          <xsl:if test="starts-with(., 'http://purl.stanford.edu/')">
            <identifier type="local" displayLabel="druid">
              <xsl:text>druid:</xsl:text>
              <xsl:value-of select="substring-after(., 'http://purl.stanford.edu/')" />
            </identifier>
            <location>
              <url displayLabel="PURL">
                <xsl:value-of select="."/>
              </url>
            </location>
          </xsl:if>      
        </xsl:for-each>
        <!-- TODO: need to handle alternate and translated titles -->
        <titleInfo>
          <title type="main">
            <xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title"/>
          </title>
        </titleInfo>
        <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:organisationName">
          <name type="corporate">
            <namePart>
              <xsl:value-of select="gco:CharacterString"/>
            </namePart>
            <role>
              <!-- TODO: what is the appropriate role here? -->
              <roleTerm type="text" authority="marcrelator">Publisher</roleTerm>
            </role>
          </name>
        </xsl:for-each>
        <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:personalName">
          <name type="personal">
            <namePart>
              <xsl:value-of select="gco:CharacterString"/>
            </namePart>
            <role>
              <!-- TODO: what is the appropriate role here? -->
              <roleTerm type="text" authority="marcrelator">Metadata contact</roleTerm>
            </role>
          </name>
        </xsl:for-each>
        <!-- typeOfResource for SW -->
        <typeOfResource>cartographic</typeOfResource>
        <typeOfResource>software, multimedia</typeOfResource>
        <genre>GIS Datasets</genre>
        <originInfo>
          <xsl:for-each select="gmd:citedResponsibleParty/gmd:CI_ResponsibleParty">
            <!-- TODO: is this the correct rolecode for the publisher? -->
            <xsl:if test="gmd:role/gmd:CI_RoleCode[@codeListValue='originator']">
              <publisher>
                <xsl:value-of select="gmd:organisationName/gco:CharacterString"/>
              </publisher>
              <xsl:for-each select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address">
                <place>
                  <!-- TODO: is there a better way to generate the publication address? -->
                  <placeTerm type="text">
                    <xsl:value-of select="gmd:city/gco:CharacterString"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="gmd:administrativeArea/gco:CharacterString"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="gmd:country/gmd:Country/@codeListValue"/>
                    </placeTerm>
                </place>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>
          <dateIssued encoding="w3cdtf">
            <xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date"/>
          </dateIssued>
        </originInfo>
        <language>
          <languageTerm authority="iso639-2b">
            <xsl:apply-templates select="gmd:language"/>
          </languageTerm>
        </language>
        <physicalDescription>
          <form>
            <xsl:apply-templates select="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name"/>
          </form>
          <xsl:for-each select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:transferSize">
            <!-- TODO: is there a type that goes with the extent here? -->
            <extent>
              <xsl:value-of select="gco:Real"/>
            </extent>
          </xsl:for-each>
          <!-- TODO: is the origin available as a code? -->
          <digitalOrigin>born digital</digitalOrigin>
        </physicalDescription>
        <!-- TODO: need to map scale resolution -->
        <subject>
          <cartographics>
            <projection><!-- TODO: need better way to extract URI for projection -->
              <xsl:text>urn:ogc:def:crs:</xsl:text>
              <xsl:value-of select="gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString"/>
              <xsl:text>::</xsl:text>
              <xsl:value-of select="gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString"/>
            </projection>
            <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
              <coordinates>       
                <xsl:choose>
                  <xsl:when test="$geoformat = 'WMS'">
                    <!-- WMS
                         Uses min/max as attributes
                         
                         Example:
                         
                         <wms:BoundingBox xmlns:wms="http://www.opengis.net/wms" 
                                          CRS="EPSG:4326" 
                                          minx="-97.119945" miny="25.467075" 
                                          maxx="-82.307619" maxy="30.665492"/>
                      -->
                    <wms:BoundingBox xmlns:wms="http://www.opengis.net/wms">
                      <xsl:attribute name="CRS">EPSG:4326</xsl:attribute>
                      <xsl:attribute name="minx">
                        <xsl:value-of select="gmd:westBoundLongitude/gco:Decimal"/>
                      </xsl:attribute>
                      <xsl:attribute name="miny">
                        <xsl:value-of select="gmd:southBoundLatitude/gco:Decimal"/>
                      </xsl:attribute>
                      <xsl:attribute name="maxx">
                        <xsl:value-of select="gmd:eastBoundLongitude/gco:Decimal"/>
                      </xsl:attribute>
                      <xsl:attribute name="maxy">
                        <xsl:value-of select="gmd:northBoundLatitude/gco:Decimal"/>
                      </xsl:attribute>
                    </wms:BoundingBox>
                  </xsl:when>
                  <xsl:when test="$geoformat = 'GML'">
                  <!-- GML
                       Using SW and NE corners in (x, y) coordinates
                       
                       Example:
                       
                       <gml:Envelope xmlns:gml="http://www.opengis.net/gml/3.2" srsName="EPSG:4326">
                         <gml:lowerCorner>-97.119945 25.467075</gml:lowerCorner>
                         <gml:upperCorner>-82.307619 30.665492</gml:upperCorner>
                       </gml:Envelope>
                    -->
                  <gml:Envelope xmlns:gml="http://www.opengis.net/gml/3.2" srsName="EPSG:4326">
                   <gml:lowerCorner>
                     <xsl:value-of select="gmd:westBoundLongitude/gco:Decimal"/>
                     <xsl:text> </xsl:text>
                     <xsl:value-of select="gmd:southBoundLatitude/gco:Decimal"/>
                   </gml:lowerCorner>
                   <gml:upperCorner>
                     <xsl:value-of select="gmd:eastBoundLongitude/gco:Decimal"/>
                     <xsl:text> </xsl:text>
                     <xsl:value-of select="gmd:northBoundLatitude/gco:Decimal"/>
                   </gml:upperCorner>
                 </gml:Envelope>
               </xsl:when>
               <xsl:when test="$geoformat = 'GeoRSS'">
                 <!-- GeoRSS:
                      Rectangular envelope property element containing two pairs of coordinates 
                      (lower left envelope corner, upper right envelope corner) representing 
                      latitude then longitude in the WGS84 coordinate reference system.
                      
                      Example:
                      
                      <georss:box>42.943 -71.032 43.039 -69.856</georss:box>
                      -->
                 <georss:box xmlns:georss="http://www.georss.org/georss">
                   <xsl:value-of select="gmd:southBoundLatitude/gco:Decimal"/>
                   <xsl:text> </xsl:text>
                   <xsl:value-of select="gmd:westBoundLongitude/gco:Decimal"/>
                   <xsl:text> </xsl:text>
                   <xsl:value-of select="gmd:northBoundLatitude/gco:Decimal"/>
                   <xsl:text> </xsl:text>
                   <xsl:value-of select="gmd:eastBoundLongitude/gco:Decimal"/>
                 </georss:box>
                </xsl:when>
                <xsl:when test="$geoformat = 'MARC034'">
                  <!-- MARC 034
                       Subfields $d, $e, $f, and $g always appear together. The coordinates 
                       may be recorded in the form hdddmmss (hemisphere-degrees-minutes-seconds), 
                       however, other forms are also allowed, such as decimal degrees. 
                       The subelements are each right justified and unused positions contain zeros.

                       $d - Coordinates - westernmost longitude (NR)
                       $e - Coordinates - easternmost longitude (NR)
                       $f - Coordinates - northernmost latitude (NR)
                       $g - Coordinates - southernmost latitude (NR)
                       
                       Example:
                       
                       $d-097.119945$e-082.307619$f+30.665492$g+25.467075

                       See http://www.w3.org/TR/1999/REC-xslt-19991116#format-number
                    -->
                    <xsl:text>($d</xsl:text>
                    <xsl:value-of select="format-number(gmd:westBoundLongitude/gco:Decimal, '+000.000000;-000.000000')"/>
                    <xsl:text>$e</xsl:text>
                    <xsl:value-of select="format-number(gmd:eastBoundLongitude/gco:Decimal, '+000.000000;-000.000000')"/>
                    <xsl:text>$f</xsl:text>
                    <xsl:value-of select="format-number(gmd:northBoundLatitude/gco:Decimal, '+00.000000;-00.000000')"/>
                    <xsl:text>$g</xsl:text>
                    <xsl:value-of select="format-number(gmd:southBoundLatitude/gco:Decimal, '+00.000000;-00.000000')"/>
                    <xsl:text>)</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- MARC 255 $c:
                         Coordinates are recorded in the order of 
                         westernmost longitude, easternmost longitude, 
                         northernmost latitude, and southernmost latitude,
                         and separated with double-hyphen and / characters.
                         
                         Example:
                         
                         -97.119945 &#x002D;&#x002D; -82.307619/30.665492 &#x002D;&#x002D; 25.467075
                         
                         See http://www.loc.gov/marc/bibliographic/bd255.html $c
                         -->
                    <xsl:text>(</xsl:text>
                    <xsl:value-of select="gmd:westBoundLongitude/gco:Decimal"/>
                    <xsl:text> &#x002D;&#x002D; </xsl:text>
                    <xsl:value-of select="gmd:eastBoundLongitude/gco:Decimal"/>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="gmd:northBoundLatitude/gco:Decimal"/>
                    <xsl:text> &#x002D;&#x002D; </xsl:text>
                    <xsl:value-of select="gmd:southBoundLatitude/gco:Decimal"/>
                    <xsl:text>)</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </coordinates>
            </xsl:for-each>
          </cartographics>
        </subject>
        <!-- TODO: is the language available for these abstracts? -->
        <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract">
          <abstract displayLabel="abstract">
            <xsl:attribute name="lang">eng</xsl:attribute>
            <xsl:value-of select="gco:CharacterString"/>
          </abstract>
        </xsl:for-each>
        <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:purpose">
            <abstract displayLabel="purpose">
            <xsl:attribute name="lang">eng</xsl:attribute>
            <xsl:value-of select="gco:CharacterString"/>
          </abstract>
        </xsl:for-each>
        <xsl:for-each select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_QuantitativeAttributeAccuracy/gmd:evaluationMethodDescription">
          <note displayLabel="quality">
            <xsl:attribute name="lang">eng</xsl:attribute>
            <xsl:value-of select="gco:CharacterString"/>
          </note>
        </xsl:for-each>
        <xsl:for-each select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source/gmd:LI_Source/gmd:sourceCitation/gmd:CI_Citation">
          <relatedItem type="preceding">
            <titleInfo>
              <title>
                <xsl:value-of select="gmd:title/gco:CharacterString"/>
              </title>
            </titleInfo>
            <xsl:if test="//gmd:sourceCitation/gmd:CI_Citation/gmd:date">
              <originInfo>
                <dateIssued>
                  <xsl:value-of select="gmd:date/gmd:CI_Date/gmd:date/gco:Date"/>
                  <!--  <xsl:apply-templates select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source/gmd:LI_Source/gmd:sourceCitation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date"/> -->
                </dateIssued>
              </originInfo>
            </xsl:if>
            <xsl:if test="//gmd:presentationForm">
              <physicalDescription>
                <form>
                  <xsl:value-of select="gmd:presentationForm/gmd:CI_PresentationFormCode"/>
                </form>
              </physicalDescription>
            </xsl:if>
          </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords">
          <xsl:choose>
            <xsl:when test="gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='theme']">
              <subject>
                <topic>
                  <xsl:value-of select="gmd:keyword/gco:CharacterString"/>
                </topic>
              </subject>
            </xsl:when>
            <xsl:when test="gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='place']">
              <subject>
                <geographic>
                  <xsl:value-of select="gmd:keyword/gco:CharacterString"/>
                </geographic>
              </subject>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
        <!-- add temporal subject -->
        <xsl:for-each select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource">
          <location>
            <url>
              <xsl:attribute name="displayLabel">
                <xsl:value-of select="gmd:name/gco:CharacterString/text()"/>
              </xsl:attribute>
              <xsl:apply-templates select="gmd:linkage"/>
            </url>
          </location>
          <identifier type="local" displayLabel="filename">
            <xsl:value-of select="gmd:name/gco:CharacterString/text()" />
          </identifier>
        </xsl:for-each>
        <xsl:if test="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints">
          <accessCondition type="restrictionsOnAccess">
            <xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints"/>
          </accessCondition>
          <accessCondition type="useAndReproduction">
            <xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints"/>
          </accessCondition>
          <xsl:if test="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints">
            <accessCondition>
              <xsl:value-of select="gco:CharacterString"/>
            </accessCondition>
          </xsl:if>
        </xsl:if>
        <xsl:for-each  select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_Constraints">
          <xsl:for-each select="gmd:useLimitation">
            <accessCondition type="useLimitation">
              <xsl:value-of select="gco:CharacterString"/>
            </accessCondition>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>
      <accessCondition><!-- TODO what is the type here? -->
        <xsl:text>
          Access is granted to Stanford University affiliates only. 
          Affiliates are limited to current faculty, staff and students.
        </xsl:text>
      </accessCondition>
    </mods>
  </xsl:template>
</xsl:stylesheet>
