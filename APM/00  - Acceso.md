# 🔐 APM - Acceso y ubicación básica

## 📌 ¿Qué es APM?

APM (Application Performance Management) es una plataforma utilizada para monitorear aplicaciones, servicios, transacciones y componentes de infraestructura relacionados, con el fin de identificar problemas de desempeño, disponibilidad e integración.

En ambientes OpenText / Micro Focus, APM también participa en integraciones con otros componentes como:

- SiteScope
- OMi
- RTSM / UCMDB
- Reportes
- Gateways y Data Processing Servers

---

## 🎯 ¿Para qué sirve este apartado?

Este documento sirve como punto de entrada rápido para:

- Ubicar rutas importantes
- Identificar componentes base
- Saber dónde revisar primero
- Tener a la mano accesos comunes para soporte y validación

---

## 🧱 Componentes que normalmente intervienen

Dependiendo de la arquitectura, en APM puedes encontrar componentes como:

- **Gateway Server**
- Recibe accesos de usuarios y administra parte de la lógica de aplicación

- **Data Processing Server (DPS)**
- Procesa información interna de la plataforma

- **RTSM / UCMDB**
- Maneja topología y relaciones de configuración

- **SiteScope**
- Herramienta de monitoreo que puede integrarse con APM

- **OMi**
- Plataforma relacionada con eventos, monitoreo e integración

---

## 📂 Ubicaciones comunes

### Ruta raíz de APM

```bash
<APM root directory>
```

## Desde aquí normalmente se derivan rutas importantes como:

```bash 
<APM root directory>\log
<APM root directory>\conf
<APM root directory>\conf\core\Tools\log4j
<APM root directory>\log\jboss
```