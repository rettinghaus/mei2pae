<?xml version="1.0" encoding="UTF-8"?>

<!--

	mei2pae.xsl - XSLT (1.1.1) stylesheet for creating incipits in Plaine & Easie Code from MEI

  Klaus Rettinghaus <klaus.rettinghaus@enote.com>
  Enote GmbH

	For info on MEI, see http://music-encoding.org
	For info on Plaine & Easie Code, see https://www.iaml.info/plaine-easie-code

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:mei="http://www.music-encoding.org/ns/mei" exclude-result-prefixes="mei">
  <xsl:output method="text" encoding="UTF-8" indent="no" media-type="text/txt" />
  <xsl:strip-space elements="*" />

  <!-- Parameters -->
  <!-- These define the "leading voice" and the length of the incipit -->
  <!-- Default is the first voice with a length of 4 measures -->
  <xsl:param name="staff">1</xsl:param>
  <xsl:param name="layer">1</xsl:param>
  <xsl:param name="measures">4</xsl:param>

  <!-- Global variables -->
  <!-- version -->
  <xsl:variable name="version">
    <xsl:text>1.1.1</xsl:text>
  </xsl:variable>

  <!-- Main ouput templates -->
  <xsl:template match="mei:meiHead" />

  <xsl:template match="mei:measure" mode="music">
    <xsl:apply-templates select="mei:staff[@n = $staff]|mei:staffDef" mode="music" />
    <xsl:call-template name="setBarline" />
  </xsl:template>

  <xsl:template match="mei:measure" mode="lyrics">
    <xsl:if test="position() &lt;= $measures">
      <xsl:apply-templates select="mei:staff[@n = $staff]/mei:layer[1]//mei:syl" mode="plainText" />
    </xsl:if>
  </xsl:template>

  <!-- MEI annotation -->
  <xsl:template match="mei:annot" mode="plaineAndEasie" />

  <!-- MEI beam -->
  <xsl:template match="mei:beam" mode="plaineAndEasie">
    <xsl:value-of select="'{'" />
    <xsl:apply-templates mode="plaineAndEasie" />
    <xsl:value-of select="'}'" />
  </xsl:template>

  <!-- MEI beam span -->
  <xsl:template match="mei:beamSpan" mode="plaineAndEasie" />

  <!-- MEI clef -->
  <xsl:template name="setClef" match="mei:clef" mode="plaineAndEasie">
    <xsl:param name="clefShape">
      <xsl:choose>
        <xsl:when test="((//@shape|ancestor-or-self::*/@clef.shape)[1] = 'G') and ((//@dis|ancestor-or-self::*/@clef.dis)[1] = '8')">
          <xsl:value-of select="'g'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="(//@shape|ancestor-or-self::*/@clef.shape)[1]" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="clefLine" select="(//@line|ancestor-or-self::*/@clef.line)[1]" />
    <xsl:choose>
      <xsl:when test="contains(ancestor-or-self::*/@notationtype, 'mensural')">
        <xsl:value-of select="concat('%', $clefShape, '+', $clefLine)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('%', $clefShape, '-', $clefLine)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- MEI chord -->
  <xsl:template match="mei:chord" mode="plaineAndEasie">
    <xsl:call-template name="setDuration" />
    <xsl:for-each select="mei:note">
      <xsl:call-template name="setOctave" />
      <xsl:call-template name="setAccidental" />
      <xsl:value-of select="translate(@pname, 'cdefgab', 'CDEFGAB')" />
      <xsl:if test="position() != last()">
        <xsl:value-of select="'^'" />
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- MEI dynamic -->
  <xsl:template match="mei:dynam" mode="plaineAndEasie" />

  <!-- MEI key signature -->
  <xsl:template name="setKey" match="mei:keySig|@*[starts-with(name(),'key')]" mode="plaineAndEasie">
    <xsl:param name="keyTonic" select="(@pname|ancestor-or-self::*/@key.pname)[1]" />
    <xsl:param name="keyAccid" select="(@accid|ancestor-or-self::*/@key.accid)[1]" />
    <xsl:param name="keyMode" select="(@mode|ancestor-or-self::*/@key.mode)[1]" />
    <xsl:param name="keysig" select="(@sig|ancestor-or-self::*/@keysig)[1]" />
    <xsl:if test="$keysig != 'mixed'">
      <xsl:value-of select="'$'" />
      <xsl:choose>
        <xsl:when test="$keysig='1s'">
          <xsl:text>xF</xsl:text>
        </xsl:when>
        <xsl:when test="$keysig='2s'">
          <xsl:text>xFC</xsl:text>
        </xsl:when>
        <xsl:when test="$keysig='3s'">
          <xsl:text>xFCG</xsl:text>
        </xsl:when>
        <xsl:when test="$keysig='4s'">
          <xsl:text>xFCGD</xsl:text>
        </xsl:when>
        <xsl:when test="$keysig='5s'">
          <xsl:text>xFCGDA</xsl:text>
        </xsl:when>
        <xsl:when test="$keysig='6s'">
          <xsl:text>xFCGDAE</xsl:text>
        </xsl:when>
        <xsl:when test="$keysig='7s'">
          <xsl:text>xFCGDAEB</xsl:text>
        </xsl:when>
        <xsl:when test="$keysig='1f'">
          <xsl:text>bB</xsl:text>
        </xsl:when>
        <xsl:when test="$keysig='2f'">
          <xsl:text>bBE</xsl:text>
        </xsl:when>
        <xsl:when test="$keysig='3f'">
          <xsl:text>bBEA</xsl:text>
        </xsl:when>
        <xsl:when test="$keysig='4f'">
          <xsl:text>bBEAD</xsl:text>
        </xsl:when>
        <xsl:when test="$keysig='5f'">
          <xsl:text>bBEADG</xsl:text>
        </xsl:when>
        <xsl:when test="$keysig='6f'">
          <xsl:text>bBEADGC</xsl:text>
        </xsl:when>
        <xsl:when test="$keysig='7f'">
          <xsl:text>bBEADGCF</xsl:text>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- MEI layer -->
  <xsl:template match="mei:layer[not(@n)][1]" mode="plaineAndEasie">
    <xsl:apply-templates mode="plaineAndEasie" />
  </xsl:template>
  <xsl:template match="mei:layer[@n = $layer]" mode="plaineAndEasie">
    <xsl:apply-templates mode="plaineAndEasie" />
  </xsl:template>

  <!-- MEI measure rest -->
  <xsl:template match="mei:mRest" mode="plaineAndEasie">
    <xsl:text>=</xsl:text>
  </xsl:template>

  <!-- MEI meter signature -->
  <xsl:template name="meterSig" match="mei:meterSig" mode="plaineAndEasie">
    <xsl:param name="meterSymbol" select="@sym" />
    <xsl:param name="meterCount" select="@count" />
    <xsl:param name="meterUnit" select="@unit" />
    <xsl:param name="meterRend" select="@form" />
    <xsl:value-of select="'@'" />
    <xsl:choose>
      <xsl:when test="$meterRend = 'invis'"></xsl:when>
      <xsl:when test="$meterSymbol">
        <!-- data.METERSIGN -->
        <xsl:choose>
          <xsl:when test="$meterSymbol = 'common'">
            <xsl:value-of select="'c'" />
          </xsl:when>
          <xsl:when test="$meterSymbol = 'cut'">
            <xsl:value-of select="'c/'" />
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$meterRend = 'num'">
        <xsl:value-of select="$meterCount" />
      </xsl:when>
      <xsl:when test="$meterUnit">
        <xsl:value-of select="concat($meterCount,'/',$meterUnit)" />
      </xsl:when>
      <xsl:otherwise />
    </xsl:choose>
  </xsl:template>

  <!-- MEI multi measure rest -->
  <xsl:template match="mei:multiRest" mode="plaineAndEasie">
    <xsl:value-of select="concat('=', @num)" />
  </xsl:template>

  <!-- MEI note -->
  <xsl:template match="mei:note" mode="plaineAndEasie">
    <xsl:variable name="noteKey" select="concat('#',./@xml:id)" />
    <xsl:call-template name="setOctave" />
    <xsl:call-template name="setDuration" />
    <xsl:if test="@grace">
      <xsl:text>q</xsl:text>
    </xsl:if>
    <xsl:call-template name="setAccidental" />
    <xsl:value-of select="translate(@pname, 'cdefgab', 'CDEFGAB')" />
    <xsl:if test="contains(@ornam, 't')">
      <xsl:call-template name="addTrill" />
    </xsl:if>
    <xsl:if test="@tie='i' or @tie='m'">
      <xsl:call-template name="addTie" />
    </xsl:if>
    <xsl:apply-templates select="ancestor::mei:measure/*[@startid = $noteKey]" mode="plaineAndEasie" />
  </xsl:template>

  <!-- MEI rest -->
  <xsl:template match="mei:rest" mode="plaineAndEasie">
    <xsl:call-template name="setDuration" />
    <xsl:text>-</xsl:text>
  </xsl:template>

  <!-- MEI score -->
  <xsl:template match="mei:score[1]">
    <xsl:apply-templates select="//mei:staffDef[@n = $staff]|/descendant::mei:measure[position() &lt;= $measures]" mode="music" />
  </xsl:template>

  <!-- MEI section -->
  <xsl:template match="mei:section">
    <xsl:apply-templates />
  </xsl:template>

  <!-- MEI staff -->
  <xsl:template match="mei:staff" mode="music">
    <xsl:apply-templates mode="plaineAndEasie" />
  </xsl:template>

  <!-- MEI staff definition -->
  <xsl:template match="mei:staffDef" mode="music">
    <xsl:if test="@notationtype = 'neume'">
      <xsl:message>WARNING: Neumes are not supported!</xsl:message>
    </xsl:if>
    <xsl:variable name="accidental" select="ancestor-or-self::*/@keysig" />
    <!-- clef -->
    <xsl:call-template name="setClef" />
    <!-- key -->
    <xsl:choose>
      <xsl:when test="(substring($accidental, string-length($accidental), 1) = 'f') or (substring($accidental, string-length($accidental), 1) = 's')">
        <xsl:call-template name="setKey" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="mei:keySig" mode="plaineAndEasie" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- meter -->
    <xsl:if test="ancestor-or-self::*/@*[starts-with(name(),'meter')]">
      <xsl:call-template name="meterSig">
        <xsl:with-param name="meterSymbol" select="ancestor-or-self::*/@meter.sym[1]" />
        <xsl:with-param name="meterCount" select="ancestor-or-self::*/@meter.count[1]" />
        <xsl:with-param name="meterUnit" select="ancestor-or-self::*/@meter.unit[1]" />
        <xsl:with-param name="meterRend" select="ancestor-or-self::*/@meter.form[1]" />
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="position()=1 and parent::*[1]=local-name(score)">
      <xsl:value-of select="' '" />
    </xsl:if>
  </xsl:template>

  <!-- MEI syllable -->
  <xsl:template match="mei:syl" mode="plainText">
    <xsl:value-of select="text()" />
    <xsl:if test="not(@wordpos!='t' or @con='d')">
      <xsl:value-of select="' '" />
    </xsl:if>
  </xsl:template>

  <!-- MEI tempo -->
  <xsl:template match="mei:tempo" mode="plaineAndEasie" />

  <!-- MEI tie -->
  <xsl:template match="mei:tie" name="addTie" mode="plaineAndEasie">
    <xsl:text>+</xsl:text>
  </xsl:template>

  <!-- MEI trill -->
  <xsl:template match="mei:trill" name="addTrill" mode="plaineAndEasie">
    <xsl:text>t</xsl:text>
  </xsl:template>

  <!-- MEI tuplet -->
  <xsl:template match="mei:tuplet" mode="plaineAndEasie">
    <xsl:if test="@num != '3'">
      <xsl:message>Only triplets are supported!</xsl:message>
    </xsl:if>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates mode="plaineAndEasie" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- MEI tuplet span -->
  <xsl:template match="mei:tupletSpan" mode="plaineAndEasie" />

  <!-- MEI unclear -->
  <xsl:template match="mei:unclear" mode="plaineAndEasie" />


  <!-- Helper templates -->
  <!-- set accidental -->
  <xsl:template name="setAccidental">
    <xsl:param name="accidental" select=".//@accid" />
    <!-- data.ACCIDENTAL.WRITTEN -->
    <xsl:if test="$accidental = 's'">
      <xsl:text>x</xsl:text>
    </xsl:if>
    <xsl:if test="$accidental = 'f'">
      <xsl:text>b</xsl:text>
    </xsl:if>
    <xsl:if test="$accidental = 'ss'">
      <xsl:text>xx</xsl:text>
    </xsl:if>
    <xsl:if test="$accidental = 'x'">
      <xsl:text>xx</xsl:text>
    </xsl:if>
    <xsl:if test="$accidental = 'ff'">
      <xsl:text>bb</xsl:text>
    </xsl:if>
    <xsl:if test="$accidental = 'n'">
      <xsl:text>n</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="setBarline">
    <xsl:param name="barLineStyle" select="@right" />
    <!-- data.BARRENDITION -->
    <xsl:choose>
      <xsl:when test="starts-with($barLineStyle, 'dbl')">
        <xsl:text>//</xsl:text>
      </xsl:when>
      <xsl:when test="$barLineStyle='invis'"></xsl:when>
      <xsl:when test="$barLineStyle='rptstart'">
        <xsl:text>//:</xsl:text>
      </xsl:when>
      <xsl:when test="$barLineStyle='rptboth'">
        <xsl:text>://:</xsl:text>
      </xsl:when>
      <xsl:when test="$barLineStyle='rptend'">
        <xsl:text>://</xsl:text>
      </xsl:when>
      <xsl:when test="$barLineStyle='single'">
        <xsl:text>/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>/</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="setDuration">
    <xsl:param name="durval" select="@dur" />
    <!-- data.DURATION -->
    <xsl:choose>
      <!-- data.DURATION.cmn -->
      <xsl:when test="@dur = 'long'">
        <xsl:text>0</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = 'breve'">
        <xsl:text>9</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = '1'">
        <xsl:text>1</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = '2'">
        <xsl:text>2</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = '4'">
        <xsl:text>4</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = '8'">
        <xsl:text>8</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = '16'">
        <xsl:text>6</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = '32'">
        <xsl:text>3</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = '64'">
        <xsl:text>5</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = '128'">
        <xsl:text>7</xsl:text>
      </xsl:when>
      <!-- data.DURATION.mensural -->
      <xsl:when test="@dur = 'maxima'"></xsl:when>
      <xsl:when test="@dur = 'longa'">
        <xsl:text>0</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = 'brevis'">
        <xsl:text>9</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = 'semibrevis'">
        <xsl:text>1</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = 'minima'">
        <xsl:text>2</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = 'semiminima'">
        <xsl:text>4</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = 'fusa'">
        <xsl:text>8</xsl:text>
      </xsl:when>
      <xsl:when test="@dur = 'semifusa'">
        <xsl:text>6</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>Shorter durations than 128th are not supported.</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="setDots" />
  </xsl:template>

  <xsl:template name="setDots">
    <xsl:param name="dots" select="@dots" />
    <xsl:if test="$dots &gt; 0">
      <xsl:text>.</xsl:text>
      <xsl:call-template name="setDots">
        <xsl:with-param name="dots" select="$dots - 1" />
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates select="mei:dot" />
  </xsl:template>

  <xsl:template name="setOctave">
    <xsl:param name="oct">
      <xsl:choose>
        <xsl:when test="@oct &gt; 3">
          <xsl:value-of select="@oct - 3" />
        </xsl:when>
        <xsl:when test="@oct &lt; 4">
          <xsl:value-of select="@oct - 4" />
        </xsl:when>
      </xsl:choose>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="$oct &lt; 0">
        <xsl:text>,</xsl:text>
        <xsl:call-template name="setOctave">
          <xsl:with-param name="oct" select="$oct + 1" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$oct &gt; 0">
        <xsl:text>'</xsl:text>
        <xsl:call-template name="setOctave">
          <xsl:with-param name="oct" select="$oct - 1" />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
