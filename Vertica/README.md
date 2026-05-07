# VERTICA

Este repositorio contiene la documentación técnica y guías de referencia rápida para la administración, mantenimiento y solución de problemas de los clústeres de Vertica , contine comandos sugeridos y que han sido probados anteriormente por expertos en la herramienta.

# 📂 Estructura de Documentación
Archivo	Descripción
* 00 - Instalación de Vertica.
* 01 - Acceso	a Vertica.
* 02 - Servicios de Vertica.
* 03 - Logs.
* 04 - Consulta de Usuarios.
* 05 - Mantenimiento	Salud del clúster y nodos.
* 06 - Herramienta de diagnostico.
* 07 - Gestion de base de datos y permisos.
* 08 - Configuracion de Agentes.

# 🛠️ Herramientas Principales
vsql: Cliente de línea de comandos para interacción con la base de datos.
admintools: Interfaz de administración de clúster y tareas de base de datos.
scrutinize: Herramienta de recolección de diagnósticos para soporte técnico.

# 🤝 Contribuciones
Si deseas agregar nuevas notas, actualizar comandos o documentar un troubleshooting específico, sigue estos pasos:

**Formato: Utiliza Markdown (.md) para mantener la legibilidad.**
**Nomenclatura: Sigue el orden numérico existente (ej. 06 - Nuevo Tema.md) y agrega el nombre del documento a este README.md**

**Estandarización:**
Incluye siempre el comando completo.
Indica el usuario necesario (root, dbadmin, etc.).
Agrega una breve descripción del "por qué" se usa ese comando.
Versionado: Asegúrate de hacer un commit claro indicando qué tema estás agregando o corrigiendo.

## Nota 

Si notas que el tema del que buscas contribuir ya existe , agrega dentro de la nota la parte con la que deseas contribuir y el adminitrador descidira si e simportante o no o busca agregar el contenido de una forma especifica. 

**Ejemplo**

05 - Mantenimiento	Salud del clúster, gestión de nodos y recuperación de caídas. (Existente)

Un tema nuevo suponiendo que buscas hablar del mismo tema: 

XX - Mantenimiento de las tablas internas de Vertica. 

**IMPORTANTE:** Recuerda que el propocito del repositorio es que sean notas rapidas de consultar y de manera eficiente, por tanto agrega notas cortas pero lo suficientemente definidas. 
