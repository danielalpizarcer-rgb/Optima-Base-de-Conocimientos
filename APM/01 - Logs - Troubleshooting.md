# Logs y Troubleshooting

### 📌 Gestión de Logs
Cuando algo falla en la integración o en el desempeño, estos son los archivos clave para identificar la causa raíz.

### 📁 Rutas de Logs por Categoría

Conexión: \log\connection.log (Errores de login y comunicación SiS-APM).
Monitoreo: \log\monitoring.log (Métricas y tiempos de respuesta).
Seguridad: \log\security.log (Auditoría y accesos fallidos).
Reportes: \log\jboss\reports.log (Errores al generar informes).

### 🛠️ Activación de Modo Debug

Si los logs estándar no muestran suficiente información, se debe elevar el nivel de detalle.

* Configuración de Integración (SiS y APM)

Edita el archivo: <APM root>\conf\core\Tools\log4j\log4j.properties
Cambia las categorías de com.hp.ucmdb a nivel DEBUG.
Esto generará trazabilidad detallada en discovery.log y probeGW-taskResults.log.

* Debug de Base de Datos y Reportes

Para problemas de datos no disponibles o errores de SQL, edita:
Reportes: \conf\core\Tools\log4j\EJB\topaz.properties
bac.core.reports=DEBUG
Consultas SQL: \conf\core\Tools\log4j\EJB\GDE.properties
loglevel=DEBUG

### 🚦 Niveles de Log4j
Es importante entender la jerarquía para no saturar el disco del servidor:

* Nivel	Uso Sugerido
* ERROR	Fallos críticos del sistema.
* WARN	Comportamientos inesperados pero no fatales.
* INFO	Registro de operaciones diarias (Default).
* DEBUG	Solo para solución de problemas puntuales.

### 🔍 Herramientas de Validación
Logs de Proba: Revisar \log\topology_queue_consumer.log para ver si la topología de SiteScope está entrando a APM.
URL de Validación: https://<URL_SITESCOPE>:8443/SiteScope (Prueba de conectividad SSL).