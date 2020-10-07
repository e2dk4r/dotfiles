function poweroff {
    Stop-Computer -Force
}

function reboot {
    Restart-Computer -Force
}

function wipe {
    Param([string]$path)

    $exec = 'sdelete.exe'
    $args = @('-p', '3', '-r', '-s', $path)
    Start-Process -FilePath $exec -ArgumentList $args -NoNewWindow -Wait

}

function search {
    Param([string]$query)

    $exec = 'ag.exe'
    $args = @('--silent', '-g', $query)
    Start-Process -FilePath $exec -ArgumentList $args -NoNewWindow -Wait
}

function kill-gpg-agent {
    $exec = 'gpgconf.exe'
    $args = @('--kill', 'gpg-agent')
    Start-Process -FilePath $exec -ArgumentList $args -NoNewWindow -Wait
}
