Param(
    [switch]$t,       # Hora
    [switch]$d,       # Fecha
    [switch]$u,       # Ubicación automática
    [string]$c,       # Especificar ciudad
    [switch]$h,       # MEJORA 1: Menú de ayuda detallado
    [string]$s,       # MEJORA 2: Guardar resultado en un archivo de texto (.txt)
    [switch]$cl       # MEJORA 3: Limpiar la pantalla antes de iniciar
)

# MEJORA 3: Limpiar pantalla si el usuario lo pide
if ($cl) { Clear-Host }

# MEJORA 1: Si el usuario pide ayuda (-h), muestra el manual y detiene el script
if ($h) {
    Write-Host "`n=== MANUAL DE USO DE CONSULTA.PS1 ===" -ForegroundColor Yellow
    Write-Host "-t        : Muestra la hora actual."
    Write-Host "-d        : Muestra la fecha actual."
    Write-Host "-u        : Muestra tu ubicación aproximada por IP."
    Write-Host "-c `"City`"` : Registra y muestra una ciudad específica en la Tierra."
    Write-Host "-s `"file`"` : Guarda todo el resultado en el archivo de texto indicado."
    Write-Host "-cl       : Limpia la terminal antes de mostrar los datos."
    Write-Host "-h        : Muestra esta pantalla de ayuda.`n"
    Exit
}

# Variable para acumular todo el texto si el usuario quiere guardarlo (-s)
$salida = @()

# Bloques de ejecución principales
if ($t) {
    $hora = Get-Date -Format "HH:mm:ss"
    $msg = "La hora actual es: $hora"
    Write-Host $msg -ForegroundColor Green
    $salida += $msg
}

if ($d) {
    $fecha = Get-Date -Format "dd/MM/yyyy"
    $msg = "La fecha actual es: $fecha"
    Write-Host $msg -ForegroundColor Green
    $salida += $msg
}

if ($u) {
    try {
        $info = Invoke-RestMethod -Uri "ipinfo.io/json" -TimeoutSec 3
        $msg = "Te encuentras en: $($info.city), $($info.country)"
    } catch {
        $msg = "No se pudo conectar a la API de ubicación."
    }
    Write-Host $msg -ForegroundColor Magenta
    $salida += $msg
}

if ($c) {
    $msg = "Lugar registrado en el planeta Tierra: $c"
    Write-Host $msg -ForegroundColor Cyan
    $salida += $msg
}

# Si lo ejecutan sin opciones normales (y tampoco pidieron ayuda)
if (-not ($t -or $d -or $u -or $c -or $h)) {
    $fechaHora = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    $msg = "Fecha y hora locales: $fechaHora"
    Write-Host $msg -ForegroundColor Cyan
    $salida += $msg
}

# MEJORA 2: Si el usuario especificó un archivo, guarda los resultados ahí
if ($s) {
    # Agrega una estampa de tiempo al archivo para saber cuándo se guardó
    $timestamp = Get-Date -Format "[dd/MM/yyyy HH:mm:ss]"
    $contenidoArchivo = @("$timestamp --- REPORTE GENERADO ---") + $salida + @("")
    
    $contenidoArchivo | Out-File -FilePath $s -Append -Encoding utf8
    Write-Host "`n[OK] Resultados guardados exitosamente en: $s" -ForegroundColor Yellow
}
