# DustBuster - Windows Cleanup Script 🧹
# Löscht unnötige Dateien und optimiert das System

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Bitte starte das Skript als Administrator!" -ForegroundColor Red
    Exit
}

function Cleanup-Files {
    param (
        [string]$Path,
        [string]$Description
    )
    
    if (Test-Path $Path) {
        Write-Host "Lösche $Description..." -ForegroundColor Yellow
        Remove-Item "$Path\*" -Force -Recurse -ErrorAction SilentlyContinue
    } else {
        Write-Host "$Description nicht gefunden, überspringe..." -ForegroundColor Green
    }
}

function Cleanup-Disk {
    Write-Host "Starte die Windows Datenträgerbereinigung..." -ForegroundColor Yellow
    Start-Process cleanmgr -ArgumentList "/sagerun:1" -NoNewWindow -Wait
}

Write-Host "Papierkorb wird geleert..." -ForegroundColor Yellow
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

Cleanup-Files "C:\Windows\Temp" "Windows Temp"
Cleanup-Files "$env:TEMP" "Benutzer Temp"
Cleanup-Files "C:\Windows\Prefetch" "Prefetch Dateien"

Write-Host "Lösche Windows Update Cache..." -ForegroundColor Yellow
net stop wuauserv
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Force -Recurse -ErrorAction SilentlyContinue
net start wuauserv

Write-Host "Optimierung der Prefetch-Daten wird durchgeführt..." -ForegroundColor Yellow
rundll32.exe advapi32.dll,ProcessIdleTasks

Write-Host "Bereinigung abgeschlossen! Ein Neustart wird empfohlen." -ForegroundColor Green
