# Logs de Vertica

## Descripción
Ubicación de los principales logs de Vertica para revisar errores, eventos del clúster y problemas de operación.

**Revisar estos logs cuando ocurra alguno de estos escenarios:**

- La base no levanta
- Un nodo no reinicia correctamente
- Hay errores de permisos
- Se sospecha que Vertica no está poblando información
- Se requiere evidencia para soporte

## Rutas principales
Este archivo puede contener eventos generales relacionados con la base de datos y su operación.

**Log general de la base**
```bash
/catalog/itomdb/dblog
```
## Log del nodo
```bash
/catalog/itomdb/v_itomdb_node0001_catalog/vertica.log
```

## Comandos útiles

### Ver últimas líneas
```bash
tail -n 50 /catalog/itomdb/dblog
tail -n 50 /catalog/itomdb/v_itomdb_node0001_catalog/vertica.log
```

### Monitorear en tiempo real
```bash 
tail -f /catalog/itomdb/dblog
tail -f /catalog/itomdb/v_itomdb_node0001_catalog/vertica.log
```

### Buscar errores
```bash 
grep -i error /catalog/itomdb/dblog
grep -i error /catalog/itomdb/v_itomdb_node0001_catalog/vertica.log
```
### Recolección avanzada de información

Desde la ruta de binarios de Vertica:

```bash 
cd /opt/vertica/bin/
```

Este comando ayuda a recopilar información más detallada para análisis o soporte.
```bash
./scrutinize --by-minute yes -U dbadmin -P '<password>' --tmpdir=/var/tmp -m 'Error permissions pods obm'
```

```markdown
---

## Nota

- Reemplazar `<password>`, `<host>` y nombres reales antes de subir a GitHub
- Validar rutas según entorno (pueden variar por instalación)