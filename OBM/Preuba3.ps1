$directorioBin = "D:\HPBSM\bin"
$archivoBat = "opr-archive-events.bat"
$fechaArchivo = "14052026"
$fechaUntil = "2026.05.14-06:00"

$outputFile = "$env:OvDataDir\shared\server\datafiles\archive\event-archive-BCS-$fechaArchivo-0000.xml"
$zipFile = "$env:OvDataDir\shared\server\datafiles\archive\event-archive-BCS-$fechaArchivo-0000.zip"

if (Test-Path $directorioBin) {
    cd $directorioBin
    
    Write-Host "=== PREPARANDO ARCHIVADO ===" -ForegroundColor Yellow
    Write-Host "Límite (-until)  : $fechaUntil"
    Write-Host "Archivo de salida: event-archive-BCS-$fechaArchivo-0000.xml" ## Cambiar esta parte para que tome la hora
    Write-Host "============================`n"
    
    Write-Host "Iniciando proceso de archivado de eventos..." -ForegroundColor Cyan
    
    cmd.exe /c "$archivoBat -force --outputFile `"$outputFile`" --state CLOSED -until $fechaUntil"
    
    Write-Host "`n[OK] Comando ejecutado." -ForegroundColor Green
    if (Test-Path $outputFile) {
        Write-Host "Iniciando compresión del archivo XML..." -ForegroundColor Cyan
        
        try {
            
            Compress-Archive -Path $outputFile -DestinationPath $zipFile -Force
            Write-Host "[OK] Archivo comprimido con éxito en: $zipFile" -ForegroundColor Green
            Remove-Item -Path $outputFile -Force
            Write-Host "[OK] Archivo XML original eliminado correctamente." -ForegroundColor Yellow
        }
        catch {
            Write-Host "[ERROR] Falló el proceso de compresión o borrado: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "[ERROR] El archivo XML no se encontró en la ruta especificada. Es posible que el .bat haya fallado o no generara datos." -ForegroundColor Red
    }

} else {
    Write-Host "[ERROR] No se encontró el directorio: $directorioBin" -ForegroundColor Red
}
