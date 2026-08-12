$directorioBin     = "D:\HPBSM\bin"
$archivoBat        = "opr-archive-events.bat"
$directorioLog     = "D:\HPBSM\log"
$directorioArchive = "$env:OvDataDir\shared\server\datafiles\archive"

$fechaHoy   = Get-Date -Format "yyyyMMdd-HHmmss"
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

Registrar-Log "=========================================="
Registrar-Log "=== INICIANDO PROCESO DE ARCHIVADO ===" "Yellow"
Registrar-Log "Directorio búsqueda: $directorioArchive"
Registrar-Log "Archivo de Log       : $archivoLog"
Registrar-Log "=========================================="

if (Test-Path $directorioBin) {
    Push-Location $directorioBin
    
    # 1. Buscar primero si existen archivos XML pendientes
    $archivosProcesar = Get-ChildItem -Path $directorioArchive -Filter "event-archive-BCS-*.xml"

    # 2. Si NO hay archivos XML, buscar los archivos ZIP y tomar únicamente el ÚLTIMO (más reciente)
    if ($archivosProcesar.Count -eq 0) {
        Registrar-Log "[INFO] No se encontraron archivos XML. Buscando el último archivo ZIP..." "Cyan"
        
        $ultimoZip = Get-ChildItem -Path $directorioArchive -Filter "event-archive-BCS-*.zip" | 
                     Sort-Object LastWriteTime -Descending | 
                     Select-Object -First 1

        if ($ultimoZip) {
            $archivosProcesar = @($ultimoZip)
            Registrar-Log "[OK] Se encontró el ZIP más reciente: $($ultimoZip.Name)" "Green"
        } else {
            Registrar-Log "[WARN] No se encontraron archivos XML ni ZIP con el patrón especificado." "Yellow"
        }
    }

    # 3. Procesar los archivos encontrados (XML o el último ZIP)
    foreach ($archivo in $archivosProcesar) {
        Registrar-Log "------------------------------------------"
        Registrar-Log "Procesando: $($archivo.Name)" "Cyan"
        
        # Expresión regular ajustada para aceptar extensiones .xml o .zip
        if ($archivo.Name -match "event-archive-BCS-(\d{2})(\d{2})(\d{4})-(\d{2})(\d{2})\.(xml|zip)") {
            $dia  = $Matches[1]
            $mes  = $Matches[2]
            $anio = $Matches[3]
            $hora = $Matches[4]
            $min  = $Matches[5]
            $ext  = $Matches[6]

            # Formato exigido por el parámetro -until (yyyy.MM.dd-HH:mm)
            $fechaUntil = "$anio.$mes.$dia-${hora}:${min}"
            
            # Definir nombres según la extensión
            if ($ext -eq "xml") {
                $outputFile = $archivo.FullName
                $zipFile    = $archivo.FullName -replace "\.xml$", ".zip"
            } else {
                # Si es ZIP, la salida del XML será la misma base pero cambiando a .xml
                $outputFile = $archivo.FullName -replace "\.zip$", ".xml"
                $zipFile    = $archivo.FullName
            }

            Registrar-Log "Fecha/Hora extraída: Día:$dia Mes:$mes Año:$anio Hora:${hora}:${min}"
            Registrar-Log "Límite (-until)     : $fechaUntil"
            Registrar-Log "Ejecutando script .bat..."

            # 4. Ejecutar el comando .bat
            cmd.exe /c "$archivoBat -force --outputFile `"$outputFile`" --state CLOSED -until $fechaUntil"
            
            if ($LASTEXITCODE -ne 0) {
                Registrar-Log "[WARN] El .bat devolvió un código de salida: $LASTEXITCODE" "Yellow"
            } else {
                Registrar-Log "[OK] Comando .bat ejecutado exitosamente." "Green"
            }

            # 5. Si el archivo procesado era un XML, lo comprimimos y borramos
            if ($ext -eq "xml") {
                if (Test-Path $outputFile) {
                    Registrar-Log "Iniciando compresión del XML a ZIP..." "Cyan"
                    try {
                        Compress-Archive -Path $outputFile -DestinationPath $zipFile -Force
                        Registrar-Log "[OK] Archivo comprimido en: $zipFile" "Green"

                        Remove-Item -Path $outputFile -Force
                        Registrar-Log "[OK] Archivo XML original eliminado correctamente." "Yellow"
                    }
                    catch {
                        Registrar-Log "[ERROR] Falló la compresión o eliminación: $_" "Red"
                    }
                } else {
                    Registrar-Log "[ERROR] El archivo XML no se encontró tras la ejecución del .bat." "Red"
                }
            } else {
                # Si ya era un ZIP, solo ejecutamos el bat y la información queda actualizada.
                Registrar-Log "[OK] Proceso completado utilizando la fecha del ZIP más reciente." "Green"
            }

        } else {
            Registrar-Log "[ERROR] El formato de nombre del archivo '$($archivo.Name)' no es válido." "Red"
        }
    }

    Pop-Location

} else {
    Registrar-Log "[ERROR] No existe el directorio de binarios: $directorioBin" "Red"
}

Registrar-Log "=========================================="
Registrar-Log "=== PROCESO FINALIZADO ===" "Green"