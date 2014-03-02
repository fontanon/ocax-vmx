Generador de entornos OCA(x):
============================

¿Qué es esto?
-------------

El Generador de entornos OCA(x) comprende una serie de automatizaciones
para el despliegue de [OCA(x)](http://ocax.net/doku.php?id=es:index) en entornos 
tanto de desarrollo como de producción.

[OCAx](http://ocax.net/doku.php?id=es:index) (Observatorio Ciudadano del 
Ayuntamiento x) es una aplicación web de apoyo a los **Observatorios Ciudadanos 
Municipales (OCM)**, para ayudar a la fiscalización colectiva y abierta de las 
cuentas de los ayuntamientos.

Este generador ha sido pensado con dos fines diferenciados: 

-   **Para personas detrás de OCMs**, que deseen contar con su propio OCA(x) 
    sin tener que realizar tediosos procesos de instalación.
-   **Para desarrolladores de OCA(x)**: contar con un entorno de desarrollo 
    para pruebas.

Conceptos generales.
--------------------

En líneas generales, el generador de entornos OCA(x) realiza tres operaciones:

-   Construir una **vmx VirtualBox** basada en Ubuntu 13.04
-   **Instalar OCA(x)** y sus dependencias.
-   Opcionalmente, realizar un **despliegue en la nube**. Actualmente sólo 
    [DigitalOcean](http://digitalocean.com) es soportado (próximamente AWS).

El generador de entornos OCA(x) está basado en
[Vagrant](http://www.vagrantup.com) +
[CHEF-solo](http://www.getchef.com/chef) :

-   [Vagrant](http://www.vagrantup.com) es una herramienta para la
    creación y configuración de entornos de desarrollo virtualizados. Lo
    utilizaremos para generar máquinas virtuales para el entornos OCA(x).
    
-   [CHEF-solo](http://www.getchef.com/chef) es parte de la suite
    CHEF, una herramienta de gestión de la configuración. CHEF-solo está
    indicado para provisionar entornos en los que solo hace falta
    desplegar software, y no realizar una gestión de la configuración
    completa. Lo utilizamos para programar la receta de despliegue de
    [OCA(x)](http://ocax.net/doku.php?id=es:index) y sus dependencias
    
*Nota*: Existen en internet diversos tutoriales introductorios muy
útiles para aprender las *basics* de Vagrant y Chef. A continuación
presentamos algunos de ellos. Para más información consulte la
documentación oficial.
    
**Vagrant**
-   [Cómo instalar y configurar
    Vagrant](http://codehero.co/como-instalar-y-configurar-vagrant)

**CHEF-solo**
-   [First Steps with
    CHEF](http://gettingstartedwithchef.com/first-steps-with-chef.html)
-   [Chef-solo quick and easy
    cookig](http://horewi.cz/chef-solo-quick-and-easy-cooking-for-one.html)

Requisitos previos
------------------

Para poder usar el generador de entornos OCA(x) es necesario:

-   **Tener instalado VirtualBox** (se recomienda [versión Oracle
    1.4.3](https://www.virtualbox.org/wiki/Downloads))
-   **Tener instalado Vagrant** (se recomienda [versión
    4.3](http://www.vagrantup.com/downloads.html)). 

OCA(x) en dos sabores: Maquina virtual y en la Nube 
---------------------------------------------------

### Opción 1: OCA(x) en una Máquina Virtual (con VirtualBox)

Si tenemos instalado VirtualBox y Vagrant lanzar la construcción del
entorno OCA(x) sería tan sencillo como ejecutar:

    user@host:~/ocax-vmx$ vagrant up

Tras unos 15 minutos, si no hay errores ya podremos acceder por ssh a
nuestro recién-construido-entorno con

    user@host:/ocax-vmx$ vagrant ssh

Y desde nuestra máquina host podemos acceder a OCA(x):

-   http://192.168.56.101

### Opción 2: OCA(x) en la nube con DigitalOcean

[DigitalOcean](http://digitalocean.com) es un proveedor de servicios *cloud-computing* 
que cuenta con una serie de características muy especiales para hacer despliegues
rápidos. DigitalOcean dispone de un **plugin para Vagrant**, haciendo muy sencillo contar
con nuestro OCA(x) desplegado en la red de forma muy sencilla.

**Advertencia: [DigitalOcean](http://digitalocean.com) es un proveedor de pago**. 
Este generador de entornos OCA(x) realiza una instalación básica en Digitalocean (1CPU, 
512MB RAM, 20GB SSD, 1TB Transfer), que tiene un coste máximo de $5/mes. Véase el 
[plan de precios](https://www.digitalocean.com/pricing) para más información.

Lo primero que necesitamos es una cuenta de usuario en [DigitalOcean](http://digitalocean.com).
Una vez tengamos nuestra cuenta de usuario, sería necesario configurar:

-    **Datos de cobro**: ¡lo siento! Es la parte fea de este asunto :)
-    **SSH Key**: seguir las instrucciones desde el menú SSH Key.
-    **API Key**: seguir las instrucciones desde el menu API Key.

Una vez generada la cuenta, deberemos sustituir en el fichero *Vagrantfile* la 
dirección a la private ssh key (ssh.private_key_path), client_id y api_key:

    # Setting for deploying on digitalocean
    config.vm.provider :digital_ocean do |provider, override|
      config.omnibus.chef_version = :latest
      override.ssh.private_key_path = '~/.ssh/id_rsa' <--- aqui
      override.vm.box = 'digital_ocean'
      override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
      provider.client_id = 'pon-tu-client_id' <--- aqui
      provider.api_key = 'pon-tu-api_key' <--- y aqui
  end

Procedemos a **instalar los *plugins* de digitalocean y omnibus** para Vagrant. 
*Nota*: estas instrucciones son para sistemas GNU/Linux. Si está intentando 
generar un entorno OCA(x) desde Mac/Windows, por favor lea la nota 
en la [documentación de vagrant-digitalocean](https://github.com/smdahlen/vagrant-digitalocean).

    user@host:~/ocax-vmx$ vagrant plugin install vagrant-digitalocean
    user@host:~/ocax-vmx$ vagrant plugin install vagrant-omnibus

**Lanzamos construcción** del entorno OCA(x) en DigitalOcean. ¡Estate atento! En el proceso **se te
informará de la dirección IP** para tu entorno OCA(x) en DigitalOcean.

    user@host:~/ocax-vmx$ vagrant up

Tras unos 15 minutos, si no hay errores ya podremos acceder por ssh a
nuestro recién-construido-entorno

    user@host:~/ocax-vmx$ vagrant ssh

Y desde nuestra máquina host podemos acceder a los distintos servicios:

-   http://IP-en-digital-ocean

Conozcamos ocax-vmx a fondo
---------------------------------

### El entorno de generación con Vagrant

El generador de entornos OCA(x) son una serie de ficheros, este
es el árbol:

    ocax-vmx
    ├── cookbooks
    │   ├── apache2
    │   ├── apt
    │   ├── aws
    │   ├── build-essential
    │   ├── database
    │   ├── mysql
    │   ├── ocax
    │   ├── openssl
    │   ├── postgresql
    │   └── xfs
    └── Vagrantfile

El entorno de generación OCA(x) es completamente configurable. 
El ficheros clave a modificar para adaptar los entornos
de desarrollo a nuestras necesidades es *Vagrantfile* que contiene las 
instrucciones de configuración para:

-   **Sistema operativo** a usar como máquina virtual base. Se
    recomienda escoger un sistema operativo pre-empaquetado para
    Vagrant/VirtualBox como los disponibles en
    [Vagrantbox](http://vagrantbox.es)
-   Opciones de **configuración de red** entre la máquina virtual y el
    sistema host. Por defecto una private network con IP
    192.168.56.101
-   **Capacidades** de la máquina virtual, memoria RAM, etc.
-   **Credenciales MySQL** para usuario root.

### La receta de provisionamiento con CHEF-solo

El arbol de ficheros de la receta maestra, opendatajdavmx, es el
siguiente:

    ocax-vmx/cookbooks/ocax
    ├── attributes
    │   └── default.rb
    ├── metadata.rb
    ├── recipes
    │   └── default.rb
    └── templates
        ├── default
        │   ├── etc_hosts
        │   ├── ocax_main.php
        │   └── site.conf.erb
        └── ubuntu -> default/

Los ficheros más importantes son:

-   **attributes/default.rb**: Contiene variables de configuración tales
    como, la IP y nombre de dominio para los servicios en nuestra
    máquina virtual, etc. Es un fichero comentado con
    instrucciones útiles para personalizar nuestro entorno.
-   **recipes/default.rb**: Contiene las instrucciones de
    provisionamiento del sistema. Este sería el fichero a editar si
    queremos provisionar nuestro entorno con más componentes
-   **templates/default/**\*: Plantillas de ficheros de configuración.
    Desde *recipes/default.rb* se pueden incluir directivas para 
    aplicar las plantillas con variables definidas
    *attributes/default.rb* en nuestro sistema virtual.
