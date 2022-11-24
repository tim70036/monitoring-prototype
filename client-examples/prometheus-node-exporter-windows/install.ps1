# Make sure following variables are correct.
$PORT = "9100"
$NODE_EXPORTER_EXECUTABLE = "$PSScriptRoot\windows_exporter-0.20.0-amd64.exe"

Write-Host "Deploying prometheus node exporter with following variables:"
Write-Host "PORT: $PORT"
Write-Host "NODE_EXPORTER_EXECUTABLE: $NODE_EXPORTER_EXECUTABLE "
Read-Host -Prompt "Press any key to continue or CTRL+C to quit" 

Write-Host "Setting firewall rule for prometheus node exporter"
$RULE_NAME = "Prometheus Scraping"
Remove-NetFirewallRule -DisplayName $RULE_NAME
New-NetFirewallRule -DisplayName $RULE_NAME -Direction Inbound -Program $NODE_EXPORTER_EXECUTABLE -RemoteAddress Any -Action Allow
Read-Host -Prompt "Press any key to continue or CTRL+C to quit" 

"Installing prometheus node exporter as windows service..."
.\nssm.exe install prometheus-service $NODE_EXPORTER_EXECUTABLE --telemetry.addr=":$PORT"
.\nssm.exe set prometheus-service Application $NODE_EXPORTER_EXECUTABLE
.\nssm.exe set prometheus-service AppDirectory $PSScriptRoot
.\nssm.exe set prometheus-service AppParameters --telemetry.addr=":$PORT"
.\nssm.exe set prometheus-service Start SERVICE_DELAYED_AUTO_START
.\nssm.exe set prometheus-service AppExit Default Restart
.\nssm.exe set prometheus-service AppRestartDelay 30000
.\nssm.exe start prometheus-service
.\nssm.exe status prometheus-service
.\nssm.exe edit prometheus-service

Read-Host -Prompt "Press any key to continue or CTRL+C to quit" 
