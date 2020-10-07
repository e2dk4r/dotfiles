function Music {
    param(
        [string]$Path = "${ENV:USERPROFILE}\Music"
    )

    $exec = 'mpv.exe'
    $args = @('--profile=music', $Path)
    Start-Process -FilePath $exec -ArgumentList $args -NoNewWindow -Wait
}

function Youtube {
    param(
        [String][Parameter(Position = 0, ValueFromRemainingArguments)]$Query,
        [Int]$Count = 5
    )

    $exec = 'mpv.exe'
    $args = @('"ytdl://ytsearch{0}:{1}"' -f $Count, $Query)
    Start-Process -FilePath $exec -ArgumentList $args -NoNewWindow -Wait
}
