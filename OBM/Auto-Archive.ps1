$directorioBin = "D:\HPBSM\bin"
$archivoBat = "opr-archive-events.bat"
$fechaArchivo = Get-Date -Format "14052026"
$fechaUntil = Get-Date -Format "2026.05.14-02:00"
$outputFile = "%OvDataDir%\shared\server\datafiles\archive\event-archive-BCS-$fechaArchivo-0000.xml"
if (Test-Path $directorioBin) {
    cd $directorioBin
    
    Write-Host "=== PREPARANDO ARCHIVADO ===" -ForegroundColor Yellow
    Write-Host "Límite (-until)  : $fechaUntil"
    Write-Host "Archivo de salida: event-archive-BCS-$fechaArchivo-0000.xml"
    Write-Host "============================`n"
    
    Write-Host "Iniciando proceso de archivado de eventos..." -ForegroundColor Cyan
    
    cmd.exe /c "$archivoBat -force --outputFile `"$outputFile`" --state CLOSED -until $fechaUntil"
    
    Write-Host "`n[OK] Comando ejecutado con éxito." -ForegroundColor Green
} else {
    Write-Host "[ERROR] No se encontró el directorio: $directorioBin" -ForegroundColor Red
}