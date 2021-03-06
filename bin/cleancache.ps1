$fileList = Get-ChildItem -Path "$($env:SCOOP)\\cache"
$cacheList = @{}

$fileList | ForEach-Object {
    $part = $_.Name -Split "#"

    if ($part.Count -eq 3) {
        if (!$cacheList.ContainsKey($part[0]) -or $_.LastWriteTime -gt $cacheList[$part[0]].lastWriteTime) {
            $cacheList[$part[0]] = @{
                version = $part[1]
                lastWriteTime = $_.LastWriteTime
            }
        }
    }
}

$fileList | ForEach-Object {
    $part = $_.Name -Split "#"

    if ($part.Count -eq 3 -and $part[1] -ne $cacheList[$part[0]].version) {
        Write-Output "Trash: $($_.Name)"
        Invoke-Expression -Command "trash `"$($_.FullName)`""
    }
}
