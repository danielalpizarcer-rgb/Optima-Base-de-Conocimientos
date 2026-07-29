$directorioBin = "D:\HPBSM\bin"
$archivoBat = "opr-archive-events.bat"
$fechaArchivo = Get-Date -Format "14052026"
$fechaUntil = Get-Date -Format "2026.05.14-02:00"

$rutaOvDataDir = "C:\ProgramData\HP\HPBSM"  
$outputFile = "$rutaOvDataDir\shared\server\datafiles\archive\event-archive-BCS-$fechaArchivo-0000.xml"
$zipFile = "$rutaOvDataDir\shared\server\datafiles\archive\event-archive-BCS-$fechaArchivo-0000.zip"

$directorioLog = "$rutaOvDataDir\shared\server\datafiles\archive\logs"
$archivoLog = "$directorioLog\archivado-eventos-$fechaArchivo.log"

function Registrar-Log ($mensaje, $color = "White") {
    $fechaHora = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $lineaLog = "[$fechaHora] $mensaje"
    

    Write-Host $mensaje -ForegroundColor $color
    

    Add-Content -Path $archivoLog -Value $lineaLog
}

if (!(Test-Path $directorioLog)) {
    New-Item -ItemType Directory -Path $directorioLog | Out-Null
}

Registrar-Log "=========================================="
Registrar-Log "=== INICIANDO PROCESO DE ARCHIVADO ===" "Yellow"
Registrar-Log "Límite (-until)  : $fechaUntil"
Registrar-Log "Archivo salida   : $outputFile"
Registrar-Log "=========================================="

if (Test-Path $directorioBin) {
    cd $directorioBin
    Registrar-Log "Ejecutando comando de archivado de eventos..." "Cyan"   
    cmd.exe /c "$archivoBat -force --outputFile `"$outputFile`" --state CLOSED -until $fechaUntil"
    Registrar-Log "Comando de archivado ejecutado de forma interna." "Green"
    if (Test-Path $outputFile) {
        Registrar-Log "Iniciando compresión del archivo XML..." "Cyan"
        
        try {
            Compress-Archive -Path $outputFile -DestinationPath $zipFile -Force
            Registrar-Log "Archivo comprimido con éxito en: $zipFile" "Green"   
            Remove-Item -Path $outputFile -Force
            Registrar-Log "Archivo XML original eliminado correctamente." "Yellow"
        }
        catch {
            Registrar-Log "[ERROR] Falló el proceso de compresión o borrado: $_" "Red"
        }
    } else {
        Registrar-Log "[ERROR] El archivo XML no fue creado por el comando .bat." "Red"
    }
} else {
    Registrar-Log "[ERROR] No se encontró el directorio binario: $directorioBin" "Red"
}
Registrar-Log "=== PROCESO FINALIZADO ===`n"



D:\HPBSM\bin>opr-archive-events.bat -force --outputFile "%OvDataDir%\shared\server\datafiles\archive \event-archive-BCS-14052026-0000.xml" --state CLOSED -until 2026.05.14-02:00
Get-Content C:\Logs\app.log -Wait