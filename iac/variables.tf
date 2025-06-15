variable "docker_host" {
  type        = string
  description = "unix format uri for the docker endpoint on local machine. Find this by running docker context ls."
  default     = "unix:///var/run/docker.sock"
}

variable "owner" {
  type        = string
  description = "Ensures appropriate sandbox tagging, this should be your name. There is no default"
}

variable "ecr_repository" {
  type        = string
  description = "The repository name for your docker image, within the account registry. e.g. cloud101. how do we make this unique?"
}

variable "app_port" {
  default     = 3000
  description = "Node compatible application port"
}

variable "external_port" {
  default     = 80
  description = "Externally expected port"
}
