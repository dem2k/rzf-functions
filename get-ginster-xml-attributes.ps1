function Get-GinsterXmlNamespace {
    param ( [parameter(Mandatory = $true)] $GinsterXml )

    if (-not((cat $GinsterXml | sls "<GINSTER.*xmlns=") -match 'xmlns="(.*?)"')) {
        throw "namespace not found"
    }
    return $matches[1] 
}

function Get-GinsterXmlVersion {
    param ( [parameter(Mandatory = $true)] $GinsterXml )

    $ver = cat $GinsterXml | sls "<GINSTER.*version="
    if (-not($ver -match 'version="(.*?)"')) {
        throw "version not found"
    }
    return $matches[1] 
}

function Get-GinsterXmlStnr {
    param ( [parameter(Mandatory = $true)] $GinsterXml )
    $ns = Get-GinsterXmlNamespace $GinsterXml
    $SelectXmlParams = @{
        Path      = $GinsterXml
        XPath     = '//ns:Steuerkonto/@stNr'
        Namespace = @{ ns = $ns }
    }
    $xml = Select-Xml @SelectXmlParams
    return $xml.Node."#text"
}

function Get-GinsterXmlStnrTyp {
    param ([parameter(Mandatory = $true)] $GinsterXml )
    $ns = Get-GinsterXmlNamespace $GinsterXml
    $SelectStnr = @{
        Path      = $GinsterXml
        XPath     = '//ns:Steuerkonto/@stNr'
        Namespace = @{ ns = $ns }
    }
    $xmlStnr = Select-Xml @SelectStnr
    $SelectTyp = @{
        Path      = $GinsterXml
        XPath     = '//ns:Steuerkonto/@typ'
        Namespace = @{ ns = $ns }
    }
    $xmlTyp = Select-Xml @SelectTyp
    return ("{0}-{1}" -f ([string]$xmlStnr.Node."#text"), ([string]$xmlTyp.Node."#text"))
}
