data "aws_secretsmanager_secret" "dbcreds" {
 name = "db_creds"
}

data "aws_secretsmanager_secret_version" "secret_credentials" {
 secret_id = data.aws_secretsmanager_secret.dbcreds.id
}

resource "aws_db_instance" "mydb" {
 allocated_storage    = 10
 db_name              = "mydb"
 engine               = "mysql"
 engine_version       = "5.7"
 instance_class       = "db.t3.micro"
 username             = jsondecode(data.aws_secretsmanager_secret_version.secret_credentials.secret_string)["db_username"]
 password             = jsondecode(data.aws_secretsmanager_secret_version.secret_credentials.secret_string)["db_password"]
 # otra forma es crear TF_VAR_db_username, TF_VAR_db_password como variables de entorno
 skip_final_snapshot  = true
}