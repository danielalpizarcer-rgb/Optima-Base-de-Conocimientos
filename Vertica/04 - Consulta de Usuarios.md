# Usuarios en Vertica

## Descripción
Permite visualizar los usuarios existentes en Vertica y su nivel de privilegios.

---

## 👀 Ver usuarios

Ingresar a la consola:

```bash
vsql
```

Dentro de vsql:
```sql
\du
```

### Ejemplo de salida
```sql
User name        | Is Superuser
-----------------+--------------
dbadmin          | t
vertica_rouser   | f
vertica_rwuser   | f
```
