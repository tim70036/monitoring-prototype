# Make sure following variables are correct.
$PUBLIC_IP = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
$INSTANCE = "game-server:$PUBLIC_IP"
$ENVIRONMENT = "staging"
$PHOTON_SERVER_DIR = "C:\Users\Administrator\Desktop\joker-photon-server"
$PROMTAIL_EXECUTABLE = "$PSScriptRoot\promtail-windows-amd64.exe"

Write-Host "Deploying promtail with following variables:"
Write-Host "Public ip of this machine: $PUBLIC_IP"
Write-Host "INSTANCE: $INSTANCE"
Write-Host "ENVIRONMENT: $ENVIRONMENT"
Write-Host "PHOTON_SERVER_DIR: $PHOTON_SERVER_DIR"
Write-Host "PROMTAIL_EXECUTABLE: $PROMTAIL_EXECUTABLE"
Read-Host -Prompt "Press any key to continue or CTRL+C to quit" 

"Installing promtail as windows service..."
.\nssm.exe install promtail-service $PROMTAIL_EXECUTABLE --config.file="promtail.yaml" --config.expand-env=true
.\nssm.exe set promtail-service Application $PROMTAIL_EXECUTABLE
.\nssm.exe set promtail-service AppDirectory $PSScriptRoot
.\nssm.exe set promtail-service AppParameters --config.file="promtail.yaml" --config.expand-env=true
.\nssm.exe set promtail-service Start SERVICE_DELAYED_AUTO_START
.\nssm.exe set promtail-service AppExit Default Restart
.\nssm.exe set promtail-service AppRestartDelay 30000
.\nssm.exe set promtail-service AppEnvironmentExtra INSTANCE=$INSTANCE ENVIRONMENT=$ENVIRONMENT PHOTON_SERVER_DIR=$PHOTON_SERVER_DIR
.\nssm.exe start promtail-service
.\nssm.exe status promtail-service
.\nssm.exe edit promtail-service

Read-Host -Prompt "Press any key to continue or CTRL+C to quit" 
