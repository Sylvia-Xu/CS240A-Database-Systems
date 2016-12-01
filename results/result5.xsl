<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">  
       <xsl:template match="/">
            <html>
                <body>
                    <h2>Temporal Join: Title history and manager history of each employee</h2>
                    <xsl:for-each select="temporalJoin/employee">
                    	<h4><xsl:value-of select="name"/></h4>
                    	<h4>Title history</h4>
                    	<table border="1">
                    		<tr bgcolor="#9acd32">
                    			<th style="text-align:center">Title</th>
                            	<th style="text-align:center">Start Date</th>
                            	<th style="text-align:center">End Date</th>
                    		</tr>
                    		<xsl:for-each select="titles/title">
                    			<tr>
									<td><xsl:value-of select="@tstart"/></td>
                                	<td><xsl:value-of select="@tend"/></td>
                                	<td><xsl:value-of select="."/></td>
                                </tr>
                    		</xsl:for-each>
                    	</table>
                    	<h4>Manager History</h4>
                    	<table border="1">
                    		<tr bgcolor="#9acd32">
                    			<th style="text-align:center">Manager</th>
                            	<th style="text-align:center">Start Date</th>
                            	<th style="text-align:center">End Date</th>
                    		</tr>
                    		<xsl:for-each select="managers/manager">
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