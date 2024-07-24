variable "project"{
    description = "the name project"
    default = "otd"
}

variable "environment"{
    description = "the enviroment to release"
    default = "dev"
}

variable "location"{
    description = "Azure region"
    default = "East Us 2"
}

variable "tags"{
    description = "all tags used"
    default = {
        environment = "dev"
        project = "otd"
        created_by = "terraform"
    }
}

variable "password"{
    description = "sqlserver password"
    type = string
    sensitive = true
}

variable "postgres_admin_password"{
    description = "postgres password"
    type = string
    sensitive = true
}

variable "postgres_admin_username"{
    description = "postgres username"
    type = string
    default = "postgres"
}
