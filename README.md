# Infrastructure as Code

## Vagrant
Para el desarrollo on-premise utilizamos [Vagrant](https://developer.hashicorp.com/vagrant/intro), una herramienta de código abierto para la creación y manejo de ambientes con máquinas virtuales.

Una vez instalado Vagrant, únicamente hay que correr `vagrant up` desde el directorio `./vagrant`. Esto levantará las cuatro máquinas virtuales estipuladas en [Vagrantfile](./vagrant/Vagrantfile). Una vez terminado el despliegue de estas máquinas virtuales, se las puede parar con `vagrant halt` o destruir con `vagrant destroy`.

> **Importante**: Vagrant únicamente orquestra la virtualización del ambiente,  pero en sí no virtualiza. Para poder correrlo se necesita tener un [proveedor de virtualización](https://developer.hashicorp.com/vagrant/docs/providers). Para este ejemplo, utilizamos [VirtualBox](https://www.virtualbox.org/) de Oracle, dado que es de de código abierto y funciona en la mayoría de las plataformas. Esto implica que es necesario descargarlo previamente para que funcione el ambiente virtual creado por Vagrant.
