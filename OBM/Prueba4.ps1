$directorioBin = "D:\HPBSM\bin"
$archivoBat = "opr-archive-events.bat"
$fechaArchivo = "14052026"
$horaArchivo = "0800"
$fechaUntil = "2026.05.14-08:00"
$directorioLog = "D:\HPBSM\log"
$fechaHoy = Get-Date -Format "yyyyMMdd-HHmmss"
$archivoLog = "$directorioLog\archivado-eventos-$fechaHoy.log"

if (!(Test-Path $directorioLog)) {
    New-Item -ItemType Directory -Path $directorioLog | Out-Null
}

function Registrar-Log ($mensaje, $color = "White") {
    $fechaHoraLog = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $lineaLog = "[$fechaHoraLog] $mensaje"
    Write-Host $mensaje -ForegroundColor $color
    Add-Content -Path $archivoLog -Value $lineaLog
}
=============================

$outputFile = "$env:OvDataDir\shared\server\datafiles\archive\event-archive-BCS-$fechaArchivo-$horaArchivo.xml"
$zipFile = "$env:OvDataDir\shared\server\datafiles\archive\event-archive-BCS-$fechaArchivo-$horaArchivo.zip"

Registrar-Log "=========================================="
Registrar-Log "=== PREPARANDO PROCESO DE ARCHIVADO ===" "Yellow"
Registrar-Log "Límite (-until)  : $fechaUntil"
Registrar-Log "Archivo de salida: event-archive-BCS-$fechaArchivo-$horaArchivo.xml"
Registrar-Log "Archivo de Log   : $archivoLog"
Registrar-Log "=========================================="

if (Test-Path $directorioBin) {
    cd $directorioBin
    
    Registrar-Log "Iniciando proceso de archivado de eventos..." "Cyan"
    cmd.exe /c "$archivoBat -force --outputFile `"$outputFile`" --state CLOSED -until $fechaUntil"
    
    Registrar-Log "[OK] Comando .bat ejecutado internamente." "Green"
    if (Test-Path $outputFile) {
        Registrar-Log "Iniciando compresión del archivo XML..." "Cyan"
        
        try {
            
            Compress-Archive -Path $outputFile -DestinationPath $zipFile -Force
            Registrar-Log "[OK] Archivo comprimido con éxito en: $zipFile" "Green"
            
            
            Remove-Item -Path $outputFile -Force
            Registrar-Log "[OK] Archivo XML original eliminado correctamente." "Yellow"
        }
        catch {
            Registrar-Log "[ERROR] Falló el proceso de compresión o borrado: $_" "Red"
        }
    } else {
        Registrar-Log "[ERROR] El archivo XML no se encontró en la ruta. El .bat falló o no había eventos cerrados." "Red"
    }

} else {
    Registrar-Log "[ERROR] No se encontró el directorio: $directorioBin" "Red"
}

Registrar-Log "=== PROCESO FINALIZADO ===`n"
