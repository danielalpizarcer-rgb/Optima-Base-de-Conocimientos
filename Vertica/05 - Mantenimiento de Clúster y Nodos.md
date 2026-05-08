# Mantenimiento de Clúster y Nodos

### 📝 Descripción
Este documento detalla los comandos para monitorear el estado de salud del clúster de Vertica y las acciones de recuperación de nodos. 

### 🔍 Verificación del clúster

Antes de cualquier cambio es importante validar el estado actual del cluster. 

### 📊 Estado de los nodos 
Permite verificar el estado actual de los nodos pertenecientes al cluster de vertica. 

```bash
/opt/vertica/bin/admintools -t list_allnodes
```
Permite una vista rápida del clúster

```bash
/opt/vertica/bin/admintools -t view_cluster
```

### 📟 Reinicio de un nodo especifico 

Si un nodo aparece en un estado de **DOWN** es recomendable ejecutar : 

```bash 
admintools -t restart_node --hosts [HOST_DEL_NODO] --database [NOMBRE_BD] --password [PASSWORD_DBA]

```
Ejemplo

```bash
admintools -t restart_node --hosts ://tienda.com --database itomdb --password 12345678
```

### 📂 Binarios criticos
Los binarios criticos de Vertica se instalan por default en : 

```bash 
/opt/vertica/bin
```

### ⚙️ Troubleshouting
**Sincronización**
Si el nodo no sube, revisa que no haya diferencias de tiempo entre los HOST

**Espacio**
Valida que la ruta del catálogo no esté al 100% antes de intentar el reinicio

**Procesos**
Si el nodo se queda "pegado", busca procesos huerfanos con: 

```bash
ps -ef | grep vertica
```


