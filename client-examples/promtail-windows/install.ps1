# Make sure following variables are correct.
$PUBLIC_IP = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
$INSTANCE = "game-server:$PUBLIC_IP"
$ENVIRONMENT = "staging"
$PHOTON_SERVER_DIR = "C:\Users\Administrator\Desktop\joker-photon-server"
Write-Host "Deploying promtail with following variables:"
Write-Host "Public ip of this machine: $PUBLIC_IP"
Write-Host "INSTANCE: $INSTANCE"
Write-Host "ENVIRONMENT: $ENVIRONMENT"
Write-Host "PHOTON_SERVER_DIR: $PHOTON_SERVER_DIR"
Read-Host -Prompt "Press any key to continue or CTRL+C to quit" 

# TODO: firewall, no need for promtail?
# New-NetFirewallRule -DisplayName "Allow Promtail" -Direction Inbound -Program $PROMTAIL_EXECUTABLE -LocalPort 9100 -RemoteAddress LocalSubnet -Action Allow

"Installing promtail as windows service..."
$PROMTAIL_EXECUTABLE = "$PSScriptRoot\promtail-windows-amd64.exe"
.\nssm.exe install promtail-service $PROMTAIL_EXECUTABLE --config.file="config.yml" --config.expand-env=true
.\nssm.exe set promtail-service Application $PROMTAIL_EXECUTABLE
.\nssm.exe set promtail-service AppDirectory $PSScriptRoot
.\nssm.exe set promtail-service AppParameters --config.file="config.yml" --config.expand-env=true
.\nssm.exe set promtail-service Start SERVICE_DELAYED_AUTO_START
.\nssm.exe set promtail-service AppExit Default Restart
.\nssm.exe set promtail-service AppRestartDelay 30000
.\nssm.exe set photon-service AppEnvironmentExtra INSTANCE=$INSTANCE ENVIRONMENT=$ENVIRONMENT PHOTON_SERVER_DIR=$PHOTON_SERVER_DIR
.\nssm.exe start promtail-service
.\nssm.exe status promtail-service
.\nssm.exe edit promtail-service

Read-Host -Prompt "Press any key to continue or CTRL+C to quit" 
