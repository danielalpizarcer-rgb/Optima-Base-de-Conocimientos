# 🛠️ Herramienta de diagnóstico avanzado
Es fundamental para cuando las cosas se ponen difíciles y es neesario levantar un ticket con soporte para un diagnóstico avanzado. Esta es la herramienta que te pide el soporte de OpenText para entende mejor lo que sucede con Vertica y darte la mejor resolución al problema. 

### 🖥️ Uso Básico (Recolección Total)
Para generar un reporte completo del estado actual:

```bash
/opt/vertica/bin/scrutinize -U dbadmin -P '[PASSWORD]'
```
**Usa el código con precaución.**

### 🛡️ Recolección Filtrada (Más rápido)
Si conoces el momento exacto del error, usa filtros de tiempo para que el archivo no sea tan pesado:
```bash
/opt/vertica/bin/scrutinize --by-minute yes -m 'Error permissions pods obm' -U dbadmin -P '[PASSWORD]' --tmpdir=/var/tmp
```
**Usa el código con precaución.**
--by-minute: Ajusta el rango de búsqueda.
-m: Agrega una descripción al reporte.
--tmpdir: Define dónde guardar el paquete (útil si /opt tiene poco espacio).

### 📊 Qué incluye el reporte
Logs del sistema operativo.
Logs de la base de datos (vertica.log).
Configuraciones del clúster (admintools.conf).
Estadísticas de uso de CPU, RAM y Disco.

#### ⚙️ Tips de Troubleshooting
Permisos: Si lo corres como root, asegúrate de que tenga acceso a las rutas de dbadmin.
Limpieza: Estos paquetes pueden pesar Gigabytes. Una vez enviado a soporte o analizado, bórralo de /var/tmp para no saturar el servidor.
Análisis manual: El resultado es un .tar.gz. Puedes descomprimirlo para ver los archivos vertica.log históricos sin entrar a la base.