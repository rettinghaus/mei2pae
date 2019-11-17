<?xml version="1.0" encoding="UTF-8" ?>

<!--

	add-incipit.xsl - a simple XSLT (1.0) stylesheet for adding incipits to MEI files

    Klaus Rettinghaus <rettinghaus@bach-leipzig.de>
    Leipzig University

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:mei="http://www.music-encoding.org/ns/mei" exclude-result-prefixes="mei">
    <xsl:import href="mei2pae.xsl" />

    <xsl:output method="xml" indent="yes" omit-xml-declaration="no" />
    <xsl:strip-space elements="*" />

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="mei:meiHead">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="mei:titleStmt">
        <!-- MEI3 -->
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" />
        </xsl:copy>
        <xsl:if test="parent::mei:work">
            <xsl:call-template name="create-incipit" />
        </xsl:if>
    </xsl:template>

    <xsl:template match="mei:title">
        <!-- MEI4 -->
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" />
        </xsl:copy>
        <xsl:if test="parent::mei:work">
            <xsl:call-template name="create-incipit" />
        </xsl:if>
    </xsl:template>

    <xsl:template name="create-incipit">
        <xsl:element name="incip" namespace="http://www.music-encoding.org/ns/mei">
            <xsl:element name="incipCode" namespace="http://www.music-encoding.org/ns/mei">
                <xsl:attribute name="form">plaineAndEasie</xsl:attribute>
                <xsl:apply-templates select="//mei:staffDef[@n = $staff]|/descendant::mei:measure[position() &lt;= $measures]" mode="music" />
            </xsl:element>
            <xsl:if test="//mei:verse">
                <xsl:element name="incipText" namespace="http://www.music-encoding.org/ns/mei">
                    <xsl:element name="p" namespace="http://www.music-encoding.org/ns/mei">
                        <xsl:apply-templates select="//mei:staffDef[@n = $staff]|/descendant::mei:measure[position() &lt;= $measures]" mode="lyrics" />
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>