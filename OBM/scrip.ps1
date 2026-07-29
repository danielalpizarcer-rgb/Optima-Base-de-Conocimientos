# 1. DATOS DE CONEXIÓN (Servidor de Pruebas)
$User   = ".\Administrador" 
$Server = "WIN-4JCIU73LK6G"

# 2. RUTAS LOCALES DE TUS ARCHIVOS DE ACCESO (En tu PC)
$PasswordFile = "C:\Users\danie\Downloads\Optima\Prueba\MiContrasena.txt"
$KeyFile      = "C:\Users\danie\Downloads\Optima\Prueba\SecretKey.key"
 
# 3. LEER LA LLAVE CRIPTOGRÁFICA
$RawKey    = Get-Content $KeyFile -Raw
$Plain_Key = $RawKey -split ' ' | ForEach-Object { [byte]$_ }

# 4. DESENCRIPTAR CONTRASEÑA Y CREAR CREDENCIAL EN MEMORIA RAM
$EncryptedPassword = Get-Content $PasswordFile
$SecurePassword    = ConvertTo-SecureString $EncryptedPassword -Key $Plain_Key
$Credentials       = New-Object System.Management.Automation.PSCredential($User, $SecurePassword)
 
# 5. INICIAR CONEXIÓN REMOTA SILENCIOSA
Write-Output "Conectando de forma automática y segura a $Server..."
$Session = New-PSSession -ComputerName $Server -Credential $Credentials
 
# 6. EJECUTAR LOS SCRIPTS `.PS1` DISPONIBLES EN EL SERVIDOR REMOTO
Write-Output "--- Ejecutando script de diagnóstico en el servidor ---"
Invoke-Command -Session $Session -ScriptBlock { 
    # Entra a la carpeta remota, busca los scripts de la carpeta y les da play
    Get-ChildItem "C:\Users\Administrator\Downloads\script\*" -Include *.ps1 | ForEach-Object { 
        & $_.FullName 
    }
}
 
# 7. CIERRE Y LIMPIEZA DE SESIÓN
Remove-PSSession $Session
Write-Output "Sesión remota cerrada correctamente."