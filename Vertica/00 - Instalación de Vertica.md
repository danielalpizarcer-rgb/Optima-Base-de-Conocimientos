# Instalación de Vertica

## Descripción
Procedimiento para instalar Vertica en Linux, incluyendo pre-requisitos del sistema, instalación y configuración inicial.

---

## ⚙️ Pre-requisitos

### 📦 Instalación de paquetes necesarios

```bash
sudo yum install -y dialog gdb mcelog sysstat
```

## 🔥 Deshabilitar firewall
```bash 
systemctl mask firewalld
systemctl disable firewalld
systemctl stop firewalld
```

## 🧠 Configurar swappiness
```bash
echo 0 > /proc/sys/vm/swappiness
```

## 🔐 Configurar SELinux en modo permissive

Editar archivo:

```bash
sudo vi /etc/selinux/config
```

Cambiar:
SELINUX=permissive


## ⚙️ Deshabilitar Transparent HugePages (recomendado)
Para este paso será necesario subir a permisos de super usuario o adminitración sobre el sistema.
```bash 
echo never > /sys/kernel/mm/transparent_hugepage/enabled
```

## 🚀 Instalación de Vertica

Ejecutar instalación:

```bash
sudo /opt/vertica/sbin/install_vertica \
--hosts <host1,host2,host3> \
--rpm /ruta/vertica-<version>.rpm \
--dba-user dbadmin
```

## 📌 Ejemplo:
```bash
sudo /opt/vertica/sbin/install_vertica \
--hosts 192.168.3.61,192.168.3.62,192.168.3.63 \
--rpm /home/daniel/vertica-11.1.1-0.x86_64.RHEL6.rpm \
--dba-user dbadmin
```

## 👤 Configuración del usuario dbadmin

Editar archivo:

```bash 
sudo vi /home/dbadmin/.bashrc
```

Agregar zona horaria:
```bash
export TZ="America/Mexico_City"
```

## 🔑 Acceso a Vertica

Ingresar con usuario:

```bash 
bash su - dbadmin 
```
## ⚙️ Administración inicial

Ejecutar herramienta de administración:

```bash
admintools
```