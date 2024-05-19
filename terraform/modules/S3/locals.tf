locals {
  lab_role = "arn:aws:iam::${var.account_id}:role/LabRole"
  files = [
    {
      source       = "../resources/frontend/index.html"
      dest         = "index.html"
      content_type = "text/html"
    },
    {
      source       = "../resources/frontend/script.js"
      dest         = "script.js"
      content_type = "application/javascript"
    },
    {
      source       = "../resources/frontend/styles.css"
      dest         = "styles.css"
      content_type = "text/css"
    }
  ]
}