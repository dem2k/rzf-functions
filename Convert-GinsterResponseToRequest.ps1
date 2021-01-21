function Convert-GinsterResponseToRequest {
    param (
        [Parameter(Mandatory, ParameterSetName='one')]
        $InputFile,
        [Parameter(Mandatory)]
        $OutFile,
        [Parameter(Mandatory, ParameterSetName='two')]
        [switch]$FromClipBoard

    )
    # -------------------------------------------------------------------------------
    $timeNow = "{0:yyyyMMddHHmmss}" -f $(Get-Date)

    if ($FromClipBoard) {
        $InputFile = "C:\TEMP\Response_${timeNow}.xml"
        Get-Clipboard | Out-File -Encoding utf8 -FilePath $InputFile
    }

    $SelectXmlParams = @{
        Path      = $InputFile
        XPath     = '/ns:GINSTER/ns:Response/ns:GetErgebnisListe/ns:Ergebnis/ns:Steuerkonto'
        Namespace = @{ns = "http://ginster.hzd.hessen.de/2006/XMLSchema" }
    }

    $BvKonto = $(Select-Xml @SelectXmlParams).Node.OuterXml

@"
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
"@ | Out-File -Encoding ascii $OutFile

}
