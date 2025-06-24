# Запускать от имени администратора

Write-Host "Проверка прав доступа..." -ForegroundColor Yellow
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin){
    Write-Warning "Для выполнения этого скрипта требуется запуск от имени администратора."
    exit
}

Write-Host "Шаг 1: Включение WinRM..." -ForegroundColor Green
winrm quickconfig -force

Write-Host "Шаг 2: Настройка WinRM сервиса..." -ForegroundColor Green
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config @{MaxTimeoutms="7200000"}
winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
winrm set winrm/config/service @{AllowRemoteAccess="true"}

Write-Host "Шаг 3: Настройка фаервола..." -ForegroundColor Green
netsh advfirewall firewall add rule name="Windows Remote Management (HTTP-In)" dir=in action=allow protocol=TCP localport=5985

Write-Host "Шаг 4: Перезапуск службы WinRM..." -ForegroundColor Green
Restart-Service WinRM -Force

Write-Host "Шаг 5: Проверка статуса службы WinRM..." -ForegroundColor Green
Get-Service -Name WinRM

Write-Host "Шаг 6: Проверка прослушивания порта 5985..." -ForegroundColor Green
Test-NetConnection localhost -Port 5985

Write-Host "Настройка WinRM завершена!" -ForegroundColor Green