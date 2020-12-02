function Set-NextGinsterXmlFile {
    param (
        [Parameter(Mandatory)]
        $GinsterXml
    )
    $fileItem = Get-Item $GinsterXml -ErrorAction Stop
    $prefix = ($fileItem.basename -split "_\d+")[0]
    $sufix = [int]($fileItem.basename -split "_")[-1] + 1
    $outFile = "{0}_{1:d5}.xml" -f $prefix, $sufix
    $timeNow = "{0:yyyyMMddHHmmss}" -f $(Get-Date)
    $encodingIso885915 = [System.Text.Encoding]::GetEncoding('ISO-8859-15')
    $xml = [xml](Get-Content -Encoding $encodingIso885915 $GinsterXml)
    if(-not $xml) {throw "wrong xml"}
    $writer = New-Object System.IO.StreamWriter($OutFile, $false, $encodingIso885915)
    $xml.GINSTER.Request.SetAttribute("lfdLieferung", $sufix)
    $xml.GINSTER.Request.UpdateList.Update.AnwInfo.SetAttribute("technBearbDat", $timeNow)
    $xml.Save($writer)
    $writer.Close()
    Move-Item $GinsterXml $env:TEMP -Force
    return "$outfile"
}
