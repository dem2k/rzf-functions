function Get-StnrFromRequest {
    param (
        [parameter(Mandatory = $true)]
        $RequestXml
    )

    $SelectXmlParams = @{
        Path      = $RequestXml
        XPath     = '/ns:GINSTER/ns:Request/ns:UpdateList/ns:Update/ns:Steuerkonto/@stNr'
        Namespace = @{ns = "http://ginster.hzd.hessen.de/2006/XMLSchema" }
    }

    $xml = Select-Xml @SelectXmlParams
    return $xml.Node."#text"
}
