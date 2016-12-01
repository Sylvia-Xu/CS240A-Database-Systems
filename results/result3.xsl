<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">  
       <xsl:template match="/">
            <html>
                <body>
                    <h2>Temporal Slicing: History of departments in the period starting on 1994-05-01 and ending 1996-05-06.</h2>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th style="text-align:center">Department No</th>
                            <th style="text-align:center">Department name</th>
                            <th style="text-align:center">Manager No</th>
                        </tr>
                        <xsl:for-each select="slice/department">
                            <tr>
                                <td><xsl:value-of select="deptno"/></td>
                                <td><xsl:value-of select="deptname"/></td>
                                <td><xsl:value-of select="mgrno"/></td>
                            </tr>
                        </xsl:for-each>
                    </table>
                </body>
            </html>
        </xsl:template>
    </xsl:stylesheet>