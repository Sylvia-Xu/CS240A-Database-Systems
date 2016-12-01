<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">  
    <xsl:template match="/">
        <html>
            <body>
                <h2>Temporal Count: History  of  employee count for each department</h2>
                <xsl:for-each select="department_count/department">
                	<h4>
                        <xsl:value-of select="@deptno"/>
                        <xsl:value-of select="@deptname"/>
                    </h4>
                	<table border="1">
                    	<tr bgcolor="#9acd32">
                        	<th style="text-align:center">Start Date</th>
                        	<th style="text-align:center">End Date</th>
                        	<th style="text-align:center">Employee Count</th>
                    	</tr>
                    	<xsl:for-each select="count">
                        	<tr>
                            	<td><xsl:value-of select="@tstart"/></td>
                            	<td><xsl:value-of select="@tend"/></td>
                            	<td><xsl:value-of select="."/></td>
                        	</tr>
                    	</xsl:for-each>
                	</table>
                </xsl:for-each>
                
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>