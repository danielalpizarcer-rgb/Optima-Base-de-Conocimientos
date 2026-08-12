
<###################################################################################################
Script perteneciente a la Base de Conocimientos de OptimaLATAM                                     #
                                                                                                   #
Este Script esta diseñado para archivar eventos de OBM usando su script nativo                     #
opr-archive-events.bat , es importante mencionar que el script debe estar instalado en el servidor #
de OBM y si la solución esta implementada en un cluster con GW y DTP                               #
este script debe ejecutarse en el DTP.                                                             #
                                                                                                   #
- En este escript hay que modificar unicamente las rutas señaladas en las primeras 23 lineas       #
- Se requieren permisos de adminitrador                                                            #
- Recomendaciones :                                                                                #
    -En la documentación de OBM se sugiere que la aplicación debe estas abajo, sin embargo con     #
    este script se peude ejecutar ocn lso servicios arriba siempre y cuando                        #
     el tiempo sea minimo 1min maximo 2hrs que es el tiempo en el que ha sido probado.             #
                                                                                                   #
    -El tiempo puede modificarse en la linea 87                                                    #
                                                                                                   #
    -Para realizar pruebas se adjunta segundo script que se puede ejecutar de manera               #
     local y este creara los .XML de prueba                                                        #
                                                                                                   #
    -Para mayor nformación consultar el repositorio de Optima en GitHub :                          #
            https://github.com/eortegaotlatam/Optima-Base-de-Conocimientos.git                     #
                                                                                                   #
    -Repositorio secundario :                                                                      #
            https://github.com/danielalpizarcer-rgb/Optima-Base-de-Conocimientos.git               #
                                                                                                   #
    AUTHOR : DANIEL ALPIZAR                                 EMAIL : DALPIZAR@OPTIMALATAM.COM       #
#####################################################################################################>
if ($env:TOPAZ_HOME -and (Test-Path "$env:TOPAZ_HOME\bin\opr-archive-events.bat")) {
    $directorioBin = "$env:TOPAZ_HOME\bin"
} elseif (Test-Path "D:\HPBSM\bin\opr-archive-events.bat") {
    $directorioBin = "D:\HPBSM\bin"
} elseif (Test-Path "C:\HPBSM\bin\opr-archive-events.bat") {
    $directorioBin = "C:\HPBSM\bin"
} else {
    $directorioBin = "D:\HPBSM\bin"
}

$archivoBat        = "opr-archive-events.bat"
$directorioLog     = "D:\HPBSM\log"
$directorioArchive = "C:\HPBSM_Data\shared\server\datafiles\archive"
if (!(Test-Path "D:\")) {
    $directorioLog = "C:\HPBSM\log"
}
$archivoLog = "$directorioLog\archivado-eventos.log"

if (!(Test-Path $directorioLog)) {
    New-Item -ItemType Directory -Path $directorioLog -Force | Out-Null
}
function Registrar-Log ($mensaje, $color = "White") {
    $fechaHoraLog = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $lineaLog = "[$fechaHoraLog] $mensaje"
    Write-Host $mensaje -ForegroundColor $color
    Add-Content -Path $archivoLog -Value $lineaLog -Encoding UTF8
}
Registrar-Log "================================================================================"
Registrar-Log "===================== INICIANDO NUEVO PROCESO DE ARCHIVADO =====================" "Yellow"
Registrar-Log "================================================================================"
Registrar-Log "Directorio busqueda: $directorioArchive"
Registrar-Log "Archivo de Log       : $archivoLog"
Registrar-Log "--------------------------------------------------------------------------------"

$rutaBatCompleta = Join-Path $directorioBin $archivoBat
if (!(Test-Path $rutaBatCompleta)) {
    Registrar-Log "[ERROR] No se encontro el ejecutable .bat en: $rutaBatCompleta" "Red"
    Registrar-Log "Por favor confirma la ruta exacta donde esta instalado 'opr-archive-events.bat' en el servidor." "Yellow"
    exit 1
}

Registrar-Log "[OK] Ejecutable localizado en: $rutaBatCompleta" "Green"

Push-Location $directorioBin
$archivosProcesar = Get-ChildItem -Path $directorioArchive -Filter "event-archive-BCS-*.xml" -ErrorAction SilentlyContinue
if (!$archivosProcesar -or $archivosProcesar.Count -eq 0) {
    Registrar-Log "[INFO] No se encontraron archivos XML. Buscando el ultimo archivo ZIP..." "Cyan"
    
    $ultimoZip = Get-ChildItem -Path $directorioArchive -Filter "event-archive-BCS-*.zip" -ErrorAction SilentlyContinue | 
                 Sort-Object LastWriteTime -Descending | 
                 Select-Object -First 1

    if ($ultimoZip) {
        $archivosProcesar = @($ultimoZip)
        Registrar-Log "[OK] Se encontro el ZIP mas reciente: $($ultimoZip.Name)" "Green"
    } else {
        Registrar-Log "[WARN] No se encontraron archivos XML ni ZIP con el patron especificado." "Yellow"
    }
}

foreach ($archivo in $archivosProcesar) {
    Registrar-Log "------------------------------------------"
    Registrar-Log "Procesando origen: $($archivo.Name)" "Cyan"
    
    if ($archivo.Name -match "event-archive-BCS-(\d{2})(\d{2})(\d{4})-(\d{2})(\d{2})\.(xml|zip)") {
        $dia  = $Matches[1]
        $mes  = $Matches[2]
        $anio = $Matches[3]
        $hora = $Matches[4]
        $min  = $Matches[5]
        $ext  = $Matches[6]

        $fechaTextoOriginal = "$anio-$mes-$dia ${hora}:${min}:00"
        $objetoFecha = [DateTime]::ParseExact($fechaTextoOriginal, "yyyy-MM-dd HH:mm:ss", $null)
        $objetoFechaNueva = $objetoFecha.AddHours(2)

        $fechaUntil              = $objetoFechaNueva.ToString("yyyy.MM.dd-HH:mm")
        $stringNuevaNomenclatura = $objetoFechaNueva.ToString("ddMMyyyy-HHmm")

        $nuevoNombreBase = "event-archive-BCS-$stringNuevaNomenclatura"
        $outputFile      = Join-Path $directorioArchive "$nuevoNombreBase.xml"
        $zipFile         = Join-Path $directorioArchive "$nuevoNombreBase.zip"

        Registrar-Log "Fecha/Hora original archivo: $($objetoFecha.ToString('dd/MM/yyyy HH:mm'))"
        Registrar-Log "Nueva Fecha/Hora (+2 Horas): $($objetoFechaNueva.ToString('dd/MM/yyyy HH:mm'))" "Yellow"
        Registrar-Log "Limite (-until)            : $fechaUntil"
        Registrar-Log "Nuevo nombre de salida     : $nuevoNombreBase.xml"

        Registrar-Log "Ejecutando script .bat..."
        
        $argumentos = "-force --outputFile `"$outputFile`" --state CLOSED -until `"$fechaUntil`""
        Registrar-Log "Comando exacto: & `"$rutaBatCompleta`" $argumentos" "Cyan"
        
            $salidaBat = & cmd.exe /c "`"$rutaBatCompleta`" $argumentos 2>&1"
        
        if ($salidaBat) {
            Registrar-Log "--- [INICIO SALIDA .BAT] ---" "DarkGray"
            foreach ($linea in $salidaBat) {
                Registrar-Log "  [BAT] $linea" "Gray"
            }
            Registrar-Log "--- [FIN SALIDA .BAT] ---" "DarkGray"
        }

        if ($LASTEXITCODE -ne 0) {
            Registrar-Log "[WARN] El .bat devolvio un codigo de salida: $LASTEXITCODE" "Yellow"
        } else {
            Registrar-Log "[OK] Comando .bat ejecutado exitosamente." "Green"
        }

        if (Test-Path $outputFile) {
            Registrar-Log "Iniciando compresion a ZIP ($nuevoNombreBase.zip)..." "Cyan"
            try {
                Compress-Archive -Path $outputFile -DestinationPath $zipFile -Force
                Registrar-Log "[OK] Archivo comprimido generado: $zipFile" "Green"

                Remove-Item -Path $outputFile -Force
                Registrar-Log "[OK] Archivo XML temporal ($nuevoNombreBase.xml) eliminado." "Yellow"
                
                if ($ext -eq "xml" -and $archivo.FullName -ne $outputFile) {
                    Remove-Item -Path $archivo.FullName -Force
                    Registrar-Log "[OK] Archivo XML original viejo eliminado." "Yellow"
                }
            }
            catch {
                Registrar-Log "[ERROR] Fallo la compresion o eliminacion: $_" "Red"
            }
        } else {
            Registrar-Log "[ERROR] El archivo XML de salida no se encontro tras la ejecucion del .bat." "Red"
        }

    } else {
        Registrar-Log "[ERROR] El formato de nombre del archivo '$($archivo.Name)' no es valido." "Red"
    }
}

Pop-Location

Registrar-Log "================================================================================"
Registrar-Log "========================== PROCESO FINALIZADO ==========================" "Green"
Registrar-Log "================================================================================"