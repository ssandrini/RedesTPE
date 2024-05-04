# Plumbi & Google Cloud

## Steps

Para crear un proyecto nuevo se pueden seguir estos comandos, 
```bash
mkdir <NEW_PROJECT_DIR> && cd <NEW_PROJECT_DIR> && pulumi new <TEMPLATE_NAME>
```

This project was created with
```bash
mkdir pulumi-with-gcp-python && cd pulumi-with-gcp-python && pulumi new gcp-python
```
- Pulumi requires you to have an account to create a project this way. 
- The command `pulumi new <>` requires it to be run in an empty directory. 
- This project runs on the `gcp-python` template.
- Running the creation command will ask for some details about the project. Feel free to leave them default for a demo. 
  - It will prompt for a valid GCP project where it will deploy the GCP services. 

Deploy the project with this command:
```bash
pulumi up
```