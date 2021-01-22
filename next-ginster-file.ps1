function Set-NextGinsterXmlFile {
    param (
        [Parameter(Mandatory)]
        $GinsterXml,
        [ValidateSet("Neu","Aend")]
        $Anweisung,
        [ValidateSet("export","update","rueckmigration","ginsterdialog")]
        $Lieferant
    )
    # -------------------------------------------------------------------------------
    $fileItem = Get-Item $GinsterXml -ErrorAction Stop
    $prefix = ($fileItem.basename -split "_\d+")[0]
    $sufix = [int]($fileItem.basename -split "_")[-1] + 1
    $outFile = "{0}_{1:d5}.xml" -f $prefix, $sufix
    $timeNow = "{0:yyyyMMddHHmmss}" -f $(Get-Date)
    $encodingIso885915 = [System.Text.Encoding]::GetEncoding('ISO-8859-15')
    $xml = [xml](Get-Content -Encoding $encodingIso885915 $GinsterXml)
    $writer = New-Object System.IO.StreamWriter($OutFile, $false, $encodingIso885915)
    # -------------------------------------------------------------------------------
    if(-not $xml) {throw "wrong xml"}
    $xml.GINSTER.Request.SetAttribute("lfdLieferung", $sufix)
    if($Lieferant -ne $null){
        $xml.GINSTER.Request.SetAttribute("lieferant", $Lieferant)
    }
    if($Anweisung -ne $null){
        $xml.GINSTER.Request.UpdateList.Update.AnwInfo.SetAttribute("anw", $Anweisung)
    }
    $xml.GINSTER.Request.UpdateList.Update.AnwInfo.SetAttribute("technBearbDat", $timeNow)
    $xml.Save($writer)
    $writer.Close()
    Move-Item $GinsterXml $env:TEMP -Force
    return "$outfile"
}
