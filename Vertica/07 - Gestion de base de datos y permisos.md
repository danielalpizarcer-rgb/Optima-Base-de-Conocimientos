# 🗄️ Gestion de Base de datos y privilegios (OBM)

Este documento cubre la creación de bases de datos desde cero y la asignación de permisos necesarios para los esquemas de OBM.
Es importante mencionar que cada herramienta de OpenText que use Vertica , puede tener una configuración diferente en la base de datos de Vertica. 


### 🖥️ Creación de la Base de Datos
Este comando se ejecuta usualmente desde el host principal con admintools:
```bash
/opt/vertica/bin/admintools -t create_db -s [LISTA_HOSTS] -d [NOMBRE_BD] -p [PASSWORD]
```
**Usa el código con precaución.**

### 🔒 Gestión de Privilegios (vsql)
Una vez dentro de la base (vsql), se deben asignar permisos para que las capacidades de OBM (como Optic DL) funcionen:
Asignar dueño a la BD:
```sql
ALTER DATABASE [NOMBRE_BD] OWNER TO [USUARIO_ADMIN];
```

**Usa el código con precaución.**

#### 🔑 Dar todos los privilegios:
```sql 
GRANT ALL PRIVILEGES ON DATABASE [NOMBRE_BD] TO [USUARIO_ADMIN];
```
**Usa el código con precaución.**

### 🛠️ Configuración de Esquemas (Schemas)
Para herramientas como Monitoring Admin, se requiere mover y renombrar esquemas:

Renombrar esquema público:
```sql
ALTER SCHEMA public RENAME TO [NUEVO_ESQUEMA];
```
**Usa el código con precaución.**

Definir ruta de búsqueda (Search Path):
```sql
ALTER USER [USUARIO] SET search_path TO [ESQUEMA];
```
**Usa el código con precaución.**

### ⚙️ Tips de Troubleshooting
Revocar accesos: Por seguridad, revoca el acceso a public antes de asignar el esquema privado:
```sql
REVOKE ALL ON SCHEMA [ESQUEMA] FROM public;
```

Validación de usuarios: Si no estás seguro de quién tiene qué permiso, usa **(dentro del prompt de vsql)**:
```bash
\du
```
 para usuarios o \dn para ver los esquemas.