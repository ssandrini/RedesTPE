# Infrastructure as Code
## Terraform
Para el desarrollo de infraestructura cloud en AWS, utilizamos la herramienta Terraform.

Como prerrequisito debemos tener instalado [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) y [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

Una vez instalados, notemos que dentro de la carpeta terraform tenemos diferentes modulos dentro de la carpeta modules, y los archivos principales en la carpeta organization.
Para levantar la infraestructura, es necesario configurar las credenciales de AWS en el archivo `~/.aws/credentials` y luego dentro del directorio terraform ejecutar los comandos:

`terraform init` para inicializar el directorio de trabajo, descargar e instalar proveedores, etc.
`terraform plan -out plan.tfplan` generar un plan de ejecución y describir los recursos que se van a levantar.
`terraform apply plan.tfplan` para que se aplique el plan y se levanten los recursos.
`terraform destroy` para destruir todos los recursos generados con terraform.

**Importante**: En el proyecto se asume que se han creado dos recursos previamente en AWS. Estos son una hosted zone, la cual se creó anteriormente para reservar nameservers y registrar un dominio propio en nic.ar, y un secret con el nombre db_creds en AWS Secret Manager, el cual contiene credenciales de acceso para una base de datos, que se pensó así para mostrar las buenas prácticas del manejo de credenciales en Terraform.

## Vagrant
Para el desarrollo on-premise utilizamos [Vagrant](https://developer.hashicorp.com/vagrant/intro), una herramienta de código abierto para la creación y manejo de ambientes con máquinas virtuales.

Una vez instalado Vagrant, únicamente hay que correr `vagrant up` desde el directorio `./vagrant`. Esto levantará las cuatro máquinas virtuales estipuladas en [Vagrantfile](./vagrant/Vagrantfile). Una vez terminado el despliegue de estas máquinas virtuales, se las puede parar con `vagrant halt` o destruir con `vagrant destroy`.

> **Importante**: Vagrant únicamente orquestra la virtualización del ambiente,  pero en sí no virtualiza. Para poder correrlo se necesita tener un [proveedor de virtualización](https://developer.hashicorp.com/vagrant/docs/providers). Para este ejemplo, utilizamos [VirtualBox](https://www.virtualbox.org/) de Oracle, dado que es de de código abierto y funciona en la mayoría de las plataformas. Esto implica que es necesario descargarlo previamente para que funcione el ambiente virtual creado por Vagrant.
