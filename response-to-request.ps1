function Convert-GinsterResponseToRequest {
    param ($InputFile, $OutFile, [switch]$ClipBoard)
    # ----------------------------------------------
    $SelectXmlParams = @{
        XPath     = '/ns:GINSTER/ns:Response/ns:GetErgebnisListe/ns:Ergebnis/ns:Steuerkonto'
        Namespace = @{ns = "http://ginster.hzd.hessen.de/2006/XMLSchema" }
    }

    if ($InputFile) {
        $SelectXmlParams['Path'] = $InputFile
    }
    
    if ($ClipBoard) {
        $SelectXmlParams['Content'] = Get-Clipboard -Raw
    }

    $BvKonto = $(Select-Xml @SelectXmlParams).Node.OuterXml -replace '\s+xmlns="http://ginster.hzd.hessen.de/2006/XMLSchema"', '' 

    $timeNow = "{0:yyyyMMddHHmmss}" -f $(Get-Date)
    
    $result = @"
<?xml version="1.0" encoding="ISO-8859-15"?>
<GINSTER xmlns="http://ginster.hzd.hessen.de/2006/XMLSchema" land="nw" version="000016">
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

    if (-not $OutFile) {
        $result
    }
    else {
        [System.IO.File]::WriteAllText($OutFile, $result,
            [System.Text.Encoding]::GetEncoding("iso-8859-1"))
    }

}

#Convert-GinsterResponseToRequest -ClipBoard
