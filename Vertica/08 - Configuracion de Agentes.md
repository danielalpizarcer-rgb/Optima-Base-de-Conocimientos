# Configuración del Agente
Este documento cubre los servicios de fondo (daemons) que permiten la comunicación entre nodos y la administración remota del clúster.

### Servicios del Sistema (systemd)
Vertica depende de dos servicios principales que deben estar siempre en ejecución:
Vertica Agent: Permite que admintools se comunique con otros nodos.
```bash
systemctl status vertica_agent.service
```
**Usa el código con precaución.**

Verticad: El demonio principal del motor de la base de datos.
```bash
systemctl status verticad.service
```
**Usa el código con precaución.**

### Gestión de Estados
Si los servicios están detenidos o presentan fallas tras un reinicio del servidor:
Arrancar servicios:
```bash
systemctl start vertica_agent.service

systemctl start verticad.service
```

**Usa el código con precaución.**

### Habilitar al arranque: (Para que suban solos si se reinicia el servidor)
```bash
systemctl enable vertica_agent.service
systemctl enable verticad.service
```
**Usa el código con precaución.**

### El Agente de Monitoreo
El agente es el que reporta el estado al clúster. Si view_cluster muestra un nodo como "Unknown" pero el servidor está prendido, el problema suele ser este servicio.
Reinicio rápido del agente:
```bash
systemctl restart vertica_agent.service
```
**Usa el código con precaución.**

### Tips de Troubleshooting
Firewall: Si el servicio está running pero no hay conexión, revisa que los puertos de comunicación del agente (normalmente 5444) no estén bloqueados.
Logs del Sistema: Si el servicio falla al iniciar, revisa el journal de Linux:
journalctl -u vertica_agent.service
Zombies: A veces el agente cree que ya hay una instancia corriendo; revisa procesos huérfanos con ps -ef | grep vertica.