function Get-ConsoleDatePicker {
    param (
        $Text = "Datum"
    )

    $initDate = $(Get-Date).AddDays(-1)
    if ($initDate.DayOfWeek -eq "Sunday") {
        $initDate = $(Get-Date).AddDays(-3)
    }
    $dd = "{0:d2}" -f $initDate.Day
    $mm = "{0:d2}" -f $initDate.Month
    $yy = "{0:d4}" -f $initDate.Year

    $ed = ""
    while ($ed.Length -lt 6) {
        $ResultDate = Get-Date ("{0}.{1}.{2}" -f $dd, $mm, $yy)
        Write-Host ("`r{2} ? {0:dd.MM.yyyy} > {1}" -f $ResultDate, $ed, $Text) -NoNewline
        $console = [System.Console]::ReadKey()
        if ($console.Key -eq [System.ConsoleKey]::Enter) { break }
        if ($ed.Length -gt 0 -and $console.Key -eq [System.ConsoleKey]::Delete -or $console.Key -eq [System.ConsoleKey]::Backspace ) { $ed = $ed.Substring(0, $ed.Length - 1) }

        if ($console.keychar -lt '0' -or $console.keychar -gt '9') { continue }
        $ed += $console.KeyChar
        if ($ed.length -gt 0) {
            $dd = "{0:d2}" -f $ed.substring(0, 1)
        }
        if ($ed.length -gt 1) {
            $dd = "{0:d2}" -f $ed.substring(0, 2)
        }
        if ($ed.length -gt 2) {
            $mm = "{0:d2}" -f $ed.substring(2, 1)
        }
        if ($ed.length -gt 3) {
            $mm = "{0:d2}" -f $ed.substring(2, 2)
        }
        if ($ed.length -gt 4) {
            $yy = "{0:d2}" -f $ed.substring(4, 1)
        }
        if ($ed.length -gt 5) {
            $yy = "{0:d2}" -f $ed.substring(4, 2)
        }
    }
    Write-Host ("{1} : {0:dd.MM.yyyy}                        " -f $ResultDate, $Text)
    return $ResultDate
}
