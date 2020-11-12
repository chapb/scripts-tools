If (-NOT ([Security.Principal.WindowsPrincipal][
    Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $args = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $args
    Break
}

Write-Host "Stopping audio services..."
Stop-Service audiosrv
Stop-Service AudioEndpointBuilder

Write-Host "Removing mixer level properties..."
Remove-Item -Path 'hkcu:\Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore' -Recurse

Write-Host "Starting audio services..."
Start-Service audiosrv


# From https://www.jdknight.me/docs/su/misc/reset-volume-mixer.html