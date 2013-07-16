druid = "druid:hf367pv5638"
i = Dor::Item.find(druid)
xml = <<-EOM
<?xml version="1.0" encoding="UTF-8"?>
<mods xmlns="http://www.loc.gov/mods/v3"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.3"
  xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-3.xsd">
  <identifier type="local" displayLabel="reference_id">geonetwork:ad78de38-212e-4131-856d-22719145d5dc</identifier>
  <identifier type="local" displayLabel="projection_id">EPSG_4269</identifier>
  <titleInfo type="main">
    <title>Carbon Dioxide (CO2) Pipelines in the United States, 2011</title>
  </titleInfo>
  <originInfo>
    <publisher>Hart Energy</publisher>
    <place>
      <placeTerm type="text">San Diego, California, US</placeTerm>
    </place>
    <dateCreated encoding="w3cdtf">2012-01-01</dateCreated>
  </originInfo>
  <note displayLabel="abstract">Dataset represents locations of existing and proposed CO2 pipelines. Includes all interstate pipelines and major intrastate pipelines.</note>
  <note displayLabel="purpose">Locating Carbon Dioxide (CO2) pipelines in the United States.</note>
  <subject>
    <geographic>United States</geographic>
  </subject>
  <subject>
    <topic>Carbon Dioxode</topic>
  </subject>
  <subject>
    <topic>Pipelines</topic>
  </subject>
  <subject>
    <genre>Downloadable Data</genre>
  </subject>
  <genre>location</genre>
  <genre>utilitiesCommunication</genre>
  <note displayLabel="Use limitation">Use is restriced to the Stanford Community only.</note>
  <note displayLabel="Legal constraints">
          Access: restricted.
          Use: restricted.
        </note>
  <subject>
    <cartographic>
      <coordinates>-109.758319 --
              -88.990844,
              48.999336 --
              29.423028</coordinates>
    </cartographic>
  </subject>
  <identifier type="local" displayLabel="distribution_format">Shapefile</identifier>
  <note displayLabel="provenance">
        Source: 
        Hart Energy: http://www.rextag.com.
        Hart Energy.
        2011-07-01.
        publication.
      </note>
  <note displayLabel="quality">The accuracy of Rextag’s GIS Data varies per area and pipeline operator. In a study conducted from random locations in rural well as in urban areas in the US we overplayed our pipeline data on various high resolution area photography tiles to compare the centerline with the ROW “scars” on the ground. We then tallied the offset distances in feet per all the pipelines shown in that area. This exercise was repeated multiple times to reach a sample size of 1000.</note>
  <genre>GIS Datasets</genre>
</mods>
EOM


i.datastreams['descMetadata'].content = xml


xml = <<-EOM
<?xml version="1.0" encoding="UTF-8"?>
<MD_Metadata xmlns="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <fileIdentifier>
    <gco:CharacterString>FA6ED959-7DED-4722-B1FB-A85FB79725BA</gco:CharacterString>
  </fileIdentifier>
  <language>
    <LanguageCode codeList="http://www.loc.gov/standards/iso639-2/php/code_list.php" codeListValue="eng" codeSpace="ISO639-2">eng</LanguageCode>
  </language>
  <characterSet>
    <MD_CharacterSetCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode" codeListValue="utf8" codeSpace="ISOTC211/19115">utf8</MD_CharacterSetCode>
  </characterSet>
  <hierarchyLevel>
    <MD_ScopeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_ScopeCode" codeListValue="dataset" codeSpace="ISOTC211/19115">dataset</MD_ScopeCode>
  </hierarchyLevel>
  <hierarchyLevelName>
    <gco:CharacterString>dataset</gco:CharacterString>
  </hierarchyLevelName>
  <contact>
    <CI_ResponsibleParty>
      <organisationName>
        <gco:CharacterString>Stanford Geospatial Center</gco:CharacterString>
      </organisationName>
      <positionName>
        <gco:CharacterString>Metadata Analyst</gco:CharacterString>
      </positionName>
      <contactInfo>
        <CI_Contact>
          <phone>
            <CI_Telephone>
              <voice>
                <gco:CharacterString>650-723-2746</gco:CharacterString>
              </voice>
            </CI_Telephone>
          </phone>
          <address>
            <CI_Address>
              <deliveryPoint>
                <gco:CharacterString>Branner Earth Sciences Library</gco:CharacterString>
              </deliveryPoint>
              <deliveryPoint>
                <gco:CharacterString>Mitchell Building, 2nd Floor</gco:CharacterString>
              </deliveryPoint>
              <deliveryPoint>
                <gco:CharacterString>397 Panama Mall</gco:CharacterString>
              </deliveryPoint>
              <city>
                <gco:CharacterString>Stanford</gco:CharacterString>
              </city>
              <administrativeArea>
                <gco:CharacterString>California</gco:CharacterString>
              </administrativeArea>
              <postalCode>
                <gco:CharacterString>94305</gco:CharacterString>
              </postalCode>
              <country>
                <gco:CharacterString>US</gco:CharacterString>
              </country>
              <electronicMailAddress>
                <gco:CharacterString>brannerlibrary@stanford.edu</gco:CharacterString>
              </electronicMailAddress>
            </CI_Address>
          </address>
        </CI_Contact>
      </contactInfo>
      <role>
        <CI_RoleCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_RoleCode" codeListValue="pointOfContact" codeSpace="ISOTC211/19115">pointOfContact</CI_RoleCode>
      </role>
    </CI_ResponsibleParty>
  </contact>
  <dateStamp>
    <gco:Date>2013-04-18</gco:Date>
  </dateStamp>
  <metadataStandardName>
    <gco:CharacterString>ISO 19139 Geographic Information - Metadata - Implementation Specification</gco:CharacterString>
  </metadataStandardName>
  <metadataStandardVersion>
    <gco:CharacterString>2007</gco:CharacterString>
  </metadataStandardVersion>
  <spatialRepresentationInfo>
    <MD_VectorSpatialRepresentation>
      <topologyLevel>
        <MD_TopologyLevelCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_TopologyLevelCode" codeListValue="geometryOnly" codeSpace="ISOTC211/19115">geometryOnly</MD_TopologyLevelCode>
      </topologyLevel>
      <geometricObjects>
        <MD_GeometricObjects>
          <geometricObjectType>
            <MD_GeometricObjectTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_GeometricObjectTypeCode" codeListValue="composite" codeSpace="ISOTC211/19115">composite</MD_GeometricObjectTypeCode>
          </geometricObjectType>
          <geometricObjectCount>
            <gco:Integer>1128</gco:Integer>
          </geometricObjectCount>
        </MD_GeometricObjects>
      </geometricObjects>
    </MD_VectorSpatialRepresentation>
  </spatialRepresentationInfo>
  <referenceSystemInfo>
    <MD_ReferenceSystem>
      <referenceSystemIdentifier>
        <RS_Identifier>
          <code>
            <gco:CharacterString>4269</gco:CharacterString>
          </code>
          <codeSpace>
            <gco:CharacterString>EPSG</gco:CharacterString>
          </codeSpace>
          <version>
            <gco:CharacterString>7.11.2</gco:CharacterString>
          </version>
        </RS_Identifier>
      </referenceSystemIdentifier>
    </MD_ReferenceSystem>
  </referenceSystemInfo>
  <identificationInfo>
    <MD_DataIdentification>
      <citation>
        <CI_Citation>
          <title>
            <gco:CharacterString>Carbon Dioxide (CO2) Pipelines in the United States, 2011 - 1007 Update</gco:CharacterString>
          </title>
          <date>
            <CI_Date>
              <date>
                <gco:Date>2012-01-01</gco:Date>
              </date>
              <dateType>
                <CI_DateTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" codeSpace="ISOTC211/19115">publication</CI_DateTypeCode>
              </dateType>
            </CI_Date>
          </date>
          <citedResponsibleParty>
            <CI_ResponsibleParty>
              <organisationName>
                <gco:CharacterString>Hart Energy</gco:CharacterString>
              </organisationName>
              <contactInfo>
                <CI_Contact>
                  <phone>
                    <CI_Telephone>
                      <voice>
                        <gco:CharacterString>619.564.7313</gco:CharacterString>
                      </voice>
                      <facsimile>
                        <gco:CharacterString>619.564.7314</gco:CharacterString>
                      </facsimile>
                    </CI_Telephone>
                  </phone>
                  <address>
                    <CI_Address>
                      <deliveryPoint>
                        <gco:CharacterString>8745 Aero Drive, Suite 305</gco:CharacterString>
                      </deliveryPoint>
                      <city>
                        <gco:CharacterString>San Diego</gco:CharacterString>
                      </city>
                      <administrativeArea>
                        <gco:CharacterString>California</gco:CharacterString>
                      </administrativeArea>
                      <postalCode>
                        <gco:CharacterString>92123</gco:CharacterString>
                      </postalCode>
                      <country>
                        <gco:CharacterString>US</gco:CharacterString>
                      </country>
                      <electronicMailAddress>
                        <gco:CharacterString>info@rextag.com</gco:CharacterString>
                      </electronicMailAddress>
                    </CI_Address>
                  </address>
                </CI_Contact>
              </contactInfo>
              <role>
                <CI_RoleCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_RoleCode" codeListValue="originator" codeSpace="ISOTC211/19115">originator</CI_RoleCode>
              </role>
            </CI_ResponsibleParty>
          </citedResponsibleParty>
          <presentationForm>
            <CI_PresentationFormCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_PresentationFormCode" codeListValue="mapDigital" codeSpace="ISOTC211/19115">mapDigital</CI_PresentationFormCode>
          </presentationForm>
        </CI_Citation>
      </citation>
      <abstract>
        <gco:CharacterString>Dataset represents locations of existing and proposed CO2 pipelines. Includes all interstate pipelines and major intrastate pipelines.</gco:CharacterString>
      </abstract>
      <purpose>
        <gco:CharacterString>Locating Carbon Dioxide (CO2) pipelines in the United States.</gco:CharacterString>
      </purpose>
      <status>
        <MD_ProgressCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_ProgressCode" codeListValue="onGoing" codeSpace="ISOTC211/19115">onGoing</MD_ProgressCode>
      </status>
      <pointOfContact>
        <CI_ResponsibleParty>
          <organisationName>
            <gco:CharacterString>Hart Energy</gco:CharacterString>
          </organisationName>
          <contactInfo>
            <CI_Contact>
              <phone>
                <CI_Telephone>
                  <voice>
                    <gco:CharacterString>619.564.7313</gco:CharacterString>
                  </voice>
                  <facsimile>
                    <gco:CharacterString>619.564.7314</gco:CharacterString>
                  </facsimile>
                </CI_Telephone>
              </phone>
              <address>
                <CI_Address>
                  <deliveryPoint>
                    <gco:CharacterString>8745 Aero Drive, Suite 305</gco:CharacterString>
                  </deliveryPoint>
                  <city>
                    <gco:CharacterString>San Diego</gco:CharacterString>
                  </city>
                  <administrativeArea>
                    <gco:CharacterString>California</gco:CharacterString>
                  </administrativeArea>
                  <postalCode>
                    <gco:CharacterString>92123</gco:CharacterString>
                  </postalCode>
                  <country>
                    <gco:CharacterString>US</gco:CharacterString>
                  </country>
                  <electronicMailAddress>
                    <gco:CharacterString>info@rextag.com</gco:CharacterString>
                  </electronicMailAddress>
                </CI_Address>
              </address>
            </CI_Contact>
          </contactInfo>
          <role>
            <CI_RoleCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_RoleCode" codeListValue="pointOfContact" codeSpace="ISOTC211/19115">pointOfContact</CI_RoleCode>
          </role>
        </CI_ResponsibleParty>
      </pointOfContact>
      <resourceMaintenance>
        <MD_MaintenanceInformation>
          <maintenanceAndUpdateFrequency>
            <MD_MaintenanceFrequencyCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_MaintenanceFrequencyCode" codeListValue="asNeeded" codeSpace="ISOTC211/19115">asNeeded</MD_MaintenanceFrequencyCode>
          </maintenanceAndUpdateFrequency>
        </MD_MaintenanceInformation>
      </resourceMaintenance>
      <descriptiveKeywords>
        <MD_Keywords>
          <keyword>
            <gco:CharacterString>United States</gco:CharacterString>
          </keyword>
          <type>
            <MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_KeywordTypeCode" codeListValue="place" codeSpace="ISOTC211/19115">place</MD_KeywordTypeCode>
          </type>
          <thesaurusName>
            <CI_Citation>
              <title>
                <gco:CharacterString>GeoNames</gco:CharacterString>
              </title>
              <date gco:nilReason="missing"/>
            </CI_Citation>
          </thesaurusName>
        </MD_Keywords>
      </descriptiveKeywords>
      <descriptiveKeywords>
        <MD_Keywords>
          <keyword>
            <gco:CharacterString>Carbon Dioxode</gco:CharacterString>
          </keyword>
          <keyword>
            <gco:CharacterString>Pipelines</gco:CharacterString>
          </keyword>
          <type>
            <MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_KeywordTypeCode" codeListValue="theme" codeSpace="ISOTC211/19115">theme</MD_KeywordTypeCode>
          </type>
          <thesaurusName>
            <CI_Citation>
              <title>
                <gco:CharacterString>Library of Congress Subject Headings (LCSH)</gco:CharacterString>
              </title>
              <date gco:nilReason="missing"/>
            </CI_Citation>
          </thesaurusName>
        </MD_Keywords>
      </descriptiveKeywords>
      <descriptiveKeywords>
        <MD_Keywords>
          <keyword>
            <gco:CharacterString>Downloadable Data</gco:CharacterString>
          </keyword>
          <thesaurusName uuidref="723f6998-058e-11dc-8314-0800200c9a66"/>
        </MD_Keywords>
      </descriptiveKeywords>
      <resourceConstraints>
        <MD_Constraints>
          <useLimitation>
            <gco:CharacterString>Use is restriced to the Stanford Community only.</gco:CharacterString>
          </useLimitation>
        </MD_Constraints>
      </resourceConstraints>
      <resourceConstraints>
        <MD_LegalConstraints>
          <accessConstraints>
            <MD_RestrictionCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_RestrictionCode" codeListValue="restricted" codeSpace="ISOTC211/19115">restricted</MD_RestrictionCode>
          </accessConstraints>
          <useConstraints>
            <MD_RestrictionCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_RestrictionCode" codeListValue="restricted" codeSpace="ISOTC211/19115">restricted</MD_RestrictionCode>
          </useConstraints>
          <otherConstraints>
            <gco:CharacterString>Access is granted to Stanford University affiliates only. Affiliates are limited to current faculty, staff and students.</gco:CharacterString>
          </otherConstraints>
        </MD_LegalConstraints>
      </resourceConstraints>
      <spatialRepresentationType>
        <MD_SpatialRepresentationTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_SpatialRepresentationTypeCode" codeListValue="vector" codeSpace="ISOTC211/19115">vector</MD_SpatialRepresentationTypeCode>
      </spatialRepresentationType>
      <language>
        <LanguageCode codeList="http://www.loc.gov/standards/iso639-2/php/code_list.php" codeListValue="eng" codeSpace="ISO639-2">eng</LanguageCode>
      </language>
      <characterSet>
        <MD_CharacterSetCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode" codeListValue="utf8" codeSpace="ISOTC211/19115">utf8</MD_CharacterSetCode>
      </characterSet>
      <topicCategory>
        <MD_TopicCategoryCode>location</MD_TopicCategoryCode>
      </topicCategory>
      <topicCategory>
        <MD_TopicCategoryCode>utilitiesCommunication</MD_TopicCategoryCode>
      </topicCategory>
      <environmentDescription>
        <gco:CharacterString>Microsoft Windows 7 Version 6.1 (Build 7601) Service Pack 1; Esri ArcGIS 10.1.1.3143</gco:CharacterString>
      </environmentDescription>
      <extent>
        <EX_Extent>
          <geographicElement>
            <EX_GeographicBoundingBox>
              <extentTypeCode>
                <gco:Boolean>true</gco:Boolean>
              </extentTypeCode>
              <westBoundLongitude>
                <gco:Decimal>-109.758319</gco:Decimal>
              </westBoundLongitude>
              <eastBoundLongitude>
                <gco:Decimal>-88.990844</gco:Decimal>
              </eastBoundLongitude>
              <southBoundLatitude>
                <gco:Decimal>29.423028</gco:Decimal>
              </southBoundLatitude>
              <northBoundLatitude>
                <gco:Decimal>48.999336</gco:Decimal>
              </northBoundLatitude>
            </EX_GeographicBoundingBox>
          </geographicElement>
        </EX_Extent>
      </extent>
      <extent>
        <EX_Extent>
          <description>
            <gco:CharacterString>ground condition</gco:CharacterString>
          </description>
          <temporalElement>
            <EX_TemporalExtent>
              <extent>
                <gml:TimePeriod gml:id="idm12877856">
                  <gml:beginPosition>2011-01-01T00:00:00</gml:beginPosition>
                  <gml:endPosition>2011-12-31T00:00:00</gml:endPosition>
                </gml:TimePeriod>
              </extent>
            </EX_TemporalExtent>
          </temporalElement>
        </EX_Extent>
      </extent>
    </MD_DataIdentification>
  </identificationInfo>
  <distributionInfo>
    <MD_Distribution>
      <distributionFormat>
        <MD_Format>
          <name>
            <gco:CharacterString>Shapefile</gco:CharacterString>
          </name>
          <version gco:nilReason="missing"/>
        </MD_Format>
      </distributionFormat>
      <transferOptions>
        <MD_DigitalTransferOptions>
          <transferSize>
            <gco:Real>0.178</gco:Real>
          </transferSize>
        </MD_DigitalTransferOptions>
      </transferOptions>
    </MD_Distribution>
  </distributionInfo>
  <dataQualityInfo>
    <DQ_DataQuality>
      <scope>
        <DQ_Scope>
          <level>
            <MD_ScopeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_ScopeCode" codeListValue="dataset" codeSpace="ISOTC211/19115">dataset</MD_ScopeCode>
          </level>
        </DQ_Scope>
      </scope>
      <report>
        <DQ_QuantitativeAttributeAccuracy>
          <evaluationMethodDescription>
            <gco:CharacterString>The accuracy of Rextag’s GIS Data varies per area and pipeline operator. In a study conducted from random locations in rural well as in urban areas in the US we overplayed our pipeline data on various high resolution area photography tiles to compare the centerline with the ROW “scars” on the ground. We then tallied the offset distances in feet per all the pipelines shown in that area. This exercise was repeated multiple times to reach a sample size of 1000.</gco:CharacterString>
          </evaluationMethodDescription>
          <result gco:nilReason="missing"/>
        </DQ_QuantitativeAttributeAccuracy>
      </report>
      <lineage>
        <LI_Lineage>
          <source>
            <LI_Source>
              <description>
                <gco:CharacterString>Hart Energy: http://www.rextag.com</gco:CharacterString>
              </description>
              <sourceCitation>
                <CI_Citation>
                  <title>
                    <gco:CharacterString>Hart Energy</gco:CharacterString>
                  </title>
                  <date>
                    <CI_Date>
                      <date>
                        <gco:Date>2011-07-01</gco:Date>
                      </date>
                      <dateType>
                        <CI_DateTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" codeSpace="ISOTC211/19115">publication</CI_DateTypeCode>
                      </dateType>
                    </CI_Date>
                  </date>
                </CI_Citation>
              </sourceCitation>
            </LI_Source>
          </source>
        </LI_Lineage>
      </lineage>
    </DQ_DataQuality>
  </dataQualityInfo>
</MD_Metadata>
EOM
i.datastreams['geoMetadata'].content = xml
i.save