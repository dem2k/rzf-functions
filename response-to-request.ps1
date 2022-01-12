function _Get-GinsterXmlNamespace {
    param ( [parameter(Mandatory = $true)] $GinsterXml )

    $ns = $GinsterXml | sls "<GINSTER.*xmlns="
    if (-not($ns -match 'xmlns="(.*?)"')) {
        throw "namespace not found"
    }
    return $matches[1] 
}

function _Get-GinsterXmlVersion {
    param ( [parameter(Mandatory = $true)] $GinsterXml )

    $ver = $GinsterXml | sls "<GINSTER.*version="
    if (-not($ver -match 'version="(.*?)"')) {
        throw "version not found"
    }
    return $matches[1] 
}

function Convert-GinsterResponseToRequest {
    param ($InputXml)
    # ----------------------------------------------
    $XmlContent = $InputXml -join ""
    $version    = _Get-GinsterXmlVersion   $XmlContent
    $xmlns      = _Get-GinsterXmlNamespace $XmlContent
    $timeNow    = "{0:yyyyMMddHHmmss}" -f $(Get-Date)
    
    $SelectXmlParams = @{
        XPath     = '/ns:GINSTER/ns:Response/ns:GetErgebnisListe/ns:Ergebnis/ns:Steuerkonto'
        Namespace = @{ns = $xmlns}
        Content   = $XmlContent
    }

    $BvKonto = $(Select-Xml @SelectXmlParams).Node.OuterXml -replace '\s+xmlns="http://ginster.hzd.hessen.de/2006/XMLSchema"', '' 
    
    $result  = @"
<?xml version="1.0" encoding="ISO-8859-15"?>
<GINSTER xmlns="$xmlns" land="nw" version="$version">
    <Request benutzerId="batch" lieferant="export" lfdLieferung="001">
        <UpdateList>
            <Update>
                <AnwInfo anw="Neu" benutzerId="$env:USERNAME" fachlVerfuegungsDat="$timeNow" technBearbDat="$timeNow" />
    $BvKonto
            </Update>
        </UpdateList>
    </Request>
</GINSTER>
"@

    return $result
}

#Convert-GinsterResponseToRequest $(Get-Clipboard)
