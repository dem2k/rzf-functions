function Get-ConsoleDatePicker {
    param (
        $Text = "Datum"
    )

    $mmChanged = $false
    $initDate = $(Get-Date).AddDays(-1)
    if ($initDate.DayOfWeek -eq "Sunday") {
        $initDate = $(Get-Date).AddDays(-3)
    }
    [int]$dd = "{0:d2}" -f $initDate.Day
    [int]$mm = "{0:d2}" -f $initDate.Month
    [int]$yy = "{0:d4}" -f $initDate.Year

    $buf = ""
    while ($buf.Length -le 6) {
        $ResultDate = Get-Date ("{0}.{1}.{2}" -f $dd, $mm, $yy)
        Write-Host ("`r{2} ? {0:dd.MM.yyyy} > {1}    " -f $ResultDate, $buf, $Text) -NoNewline
        $console = [System.Console]::ReadKey()
        if ($console.Key -eq [System.ConsoleKey]::Enter) { break }
        if ($buf.Length -gt 0 -and $console.Key -eq [System.ConsoleKey]::Delete -or $console.Key -eq [System.ConsoleKey]::Backspace ) { $buf = $buf.Substring(0, $buf.Length - 1) }

        if ($console.keychar -lt '0' -or $console.keychar -gt '9') { continue }
        $buf += $console.KeyChar
        if ($buf.length -gt 0) {
            $dd = "{0:d2}" -f $buf.substring(0, 1)
        }
        if ($buf.length -gt 1) {
            $dd = "{0:d2}" -f $buf.substring(0, 2)
        }
        if ($buf.length -gt 2) {
            $mm = "{0:d2}" -f $buf.substring(2, 1)
        }
        if ($buf.length -gt 3) {
            $mm = "{0:d2}" -f $buf.substring(2, 2)
        }
        if ($buf.length -gt 4) {
            $yy = "200{0:d2}" -f $buf.substring(4, 1)
        }
        if ($buf.length -gt 5) {
            $yy = "20{0:d2}" -f $buf.substring(4, 2)
        }
        if (-not $mmChanged -and $buf.length -eq 2 -and $dd -gt $initDate.Day) {
            $mm = $mm - 1
            if ($mm -eq 0) {
                $mm = 12
                $yy = $yy - 1
            }
            $mmChanged = $true
        }
        if ($buf.length -eq 1 -and $dd -gt 3) {
            $buf = "{0:d2}" -f $dd
        }
    }
    Write-Host ("{1} : {0:dd.MM.yyyy}                        " -f $ResultDate, $Text)
    return $ResultDate
}
