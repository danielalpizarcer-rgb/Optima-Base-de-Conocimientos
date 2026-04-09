# Gestión de Servicios en Vertica

## 📌 Descripción
Comandos básicos para revisar, iniciar, detener y reiniciar los servicios de Vertica.

---

## 🔍 Revisar estado del clúster

Permite verificar si la base de datos y los nodos están activos.

```bash
/opt/vertica/bin/admintools -t view_cluster
```

Listar los servicios
```bash
/opt/vertica/bin/admintools -t list_allnodes
```

## 🛜 Levantar servicios
Inicia la base de datos de Vertica: 

```bash
/opt/vertica/bin/admintools -t start_db -d nomdb
```

## Otras formas
```bash
./admintools -t start_db -d itomdb -p <password> -U
```

```bash
./admintools -t start_db -d itomdb -p <password> -c start
```


## Detener servicios
Para detener los servicios es necesario ubicarse en la siguiente ruta

```bash
cd /opt/vertica/bin
```
Despues se debe ejecutar
```bash
./admintools -t stop_db -d nomdb -p <password>
```

validar que el servicio se haya detenido:
```bash
/opt/vertica/bin/admintools -t view_cluster
```

## Reiniciar nodo especifico
```bash 
admintools -t restart_node \
--hosts <host> \
--database itomdb \
--password <password>
```

### Ejemplo
```bash
admintools -t restart_node \
--hosts mxtlpdmver01.mx.att.com \
--database itomdb \
--password <password>
```

## ✅ Validar servicios activos
Despues de iniciar o reiniciar, validar estado: 
```bash
/opt/vertica/bin/admintools -t view_cluster
```
El resultado esperado debe mostrarse en **UP**
