$directorioBin = "D:\HPBSM\bin"
$archivoBat = "opr-archive-events.bat"

# === CONFIGURACIÓN DEL ARCHIVO ORIGEN DE LA FECHA ===
$rutaArchivoOrigen = "C:\Users\danie\Downloads\Prueba.txt" 
# ====================================================

# Rutas de datos y archivos de salida
$rutaOvDataDir = "C:\Users\danie\Downloads\"   # Cambia si tu %OvDataDir% es diferente
$directorioLog = "C:\Users\danie\Downloads\Logs"  # Carpeta donde se guardarán los logs del proceso

# Crear la carpeta de logs si no existe
if (!(Test-Path $directorioLog)) {
    New-Item -ItemType Directory -Path $directorioLog | Out-Null
}

# Variable temporal para el nombre del log mientras obtenemos la fecha real
$archivoLog = "$directorioLog\archivado-eventos-temporal.log"

function Registrar-Log ($mensaje, $color = "White") {
    $fechaHoraLog = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $lineaLog = "[$fechaHoraLog] $mensaje"
    Write-Host $mensaje -ForegroundColor $color
    Add-Content -Path $archivoLog -Value $lineaLog
}

Registrar-Log "=========================================="
Registrar-Log "=== INICIANDO CONTROL DE FECHA Y HORA ===" "Yellow"

# Validar si el archivo de origen existe
if (Test-Path $rutaArchivoOrigen) {
    # Obtiene los metadatos del archivo
    $infoArchivo = Get-Item $rutaArchivoOrigen
    
    # Extrae la fecha y hora de última modificación del archivo
    $fechaBase = $infoArchivo.LastWriteTime

    # FORMATOS DE FECHA Y HORA AUTOMÁTICOS:
    # Para el nombre del archivo (Ej: 14052026-143022) -> No usa ":" porque Windows lo prohíbe
    $fechaArchivo = $fechaBase.ToString("ddMMyyyy-HHmmss")
    
    # Para el parámetro -until (Ej: 2026.05.14-14:30) -> Formato requerido por el .bat
    $fechaUntil   = $fechaBase.ToString("yyyy.MM.dd-HH:mm")

    # Renombrar el archivo log con la fecha y hora correctas del proceso
    $archivoLogReal = "$directorioLog\archivado-eventos-$fechaArchivo.log"
    if (Test-Path $archivoLog) {
        Move-Item -Path $archivoLog -Destination $archivoLogReal -Force
        $archivoLog = $archivoLogReal
    }

    Registrar-Log "[OK] Archivo detectado: $rutaArchivoOrigen" "Green"
    Registrar-Log "[INFO] Fecha/Hora original del archivo: $fechaBase" "Cyan"
} else {
    Registrar-Log "[ERROR] No se encontró el archivo origen en: $rutaArchivoOrigen" "Red"
    Registrar-Log "=== PROCESO ABORTADO ===`n"
    Exit
}

# Definición de archivos con las fechas y horas dinámicas
$outputFile = "$rutaOvDataDir\shared\server\datafiles\archive\event-archive-BCS-$fechaArchivo-0000.xml"
$zipFile = "$rutaOvDataDir\shared\server\datafiles\archive\event-archive-BCS-$fechaArchivo-0000.zip"

Registrar-Log "Límite (-until)  : $fechaUntil"
Registrar-Log "Archivo salida   : event-archive-BCS-$fechaArchivo-0000.xml"
Registrar-Log "=========================================="

if (Test-Path $directorioBin) {
    cd $directorioBin
    
    Registrar-Log "Ejecutando comando de archivado de eventos..." "Cyan"
    
    # Ejecución del comando .bat pasándole la hora exacta en el formato correcto
    cmd.exe /c "$archivoBat -force --outputFile `"$outputFile`" --state CLOSED -until $fechaUntil"
    
    Registrar-Log "Comando de archivado ejecutado de forma interna." "Green"

    # Verificación, compresión y limpieza
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
