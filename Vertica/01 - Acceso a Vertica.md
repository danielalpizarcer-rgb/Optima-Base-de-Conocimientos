# Acceso a Vertica

## 📌 Descripción
Comandos básicos para acceder a la base de datos Vertica y gestionar sesiones.

---

## 🔌 Puerto
Vertica utiliza el puerto:

**5433**

---

## 👤 Acceso al usuario
Para trabajar con Vertica se utiliza el usuario `dbadmin` dentro del sistema operativo por ello hay que realizar el cambio:

```bash
su - dbadmin 
```

## 🔌 Conexion a la base

### Conexión local
``` bash
vsql 
```  

### Conexión remota 
``` bash 
vsql -h <host> -U dbadmin -d <database>
```

#### Ejemplo
```bash 
vsql -h vertica.base.local -U dbadmin -d nomdb
```

### Autenticación 
En la autenticación se solicitará el password de la base de datos
```bash
pwd:
```
### Salir
Para salir solo hay que ejecutar : 
```bash 
\q
```

            