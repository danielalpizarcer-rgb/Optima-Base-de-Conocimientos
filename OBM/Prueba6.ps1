Registrar-Log "Ejecutando script .bat..."
        
        # Construimos los argumentos exactamente como los necesitas
        $argumentos = "-force --outputFile `"$outputFile`" --state CLOSED -until `"$fechaUntil`""
        
        Registrar-Log "Comando exacto: & `"$rutaBatCompleta`" $argumentos" "Cyan"
        
        # Ejecutamos redirigiendo la salida normal y los errores
        $salidaBat = & cmd.exe /c "`"$rutaBatCompleta`" $argumentos 2>&1"
        
        # Registramos cada linea emitida por el archivo .bat en nuestro log
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