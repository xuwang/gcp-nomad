variable "region" {
    default = "us-central1"
}

/* Available zones
"asia-east1-a"
"asia-east1-b"
"asia-east1-c"
"europe-west1-b"
"europe-west1-c"
"europe-west1-d"
"us-east1-b"
"us-east1-c"
"us-east1-d"
"us-central1-a"
"us-central1-b"
"us-central1-c"
"us-central1-f"
*/
variable "zones" {
    default = {
        zone0 = "us-central1-a"
        zone1 = "us-central1-b"
        zone2 = "us-central1-c"
        zone3 = "us-central1-f"
        size = "4"
    }
}

variable "zones" {
    default = {
        zone0 = "us-central1-a"
        zone1 = "us-central1-b"
        zone2 = "us-central1-c"
        zone3 = "us-central1-f"
        size = "4"
    }
}

variable "cluster_name" {
    default = "node"
}

variable "user_data" { }

variable "image" { }

variable "machine_type" {
    default = "n1-standard-1"
}

variable "cluster_size" {
    default = 1
}

variable "disk_size" {
    default = 50
}

variable "disk_type" {
    default = "pd-ssd"
}

variable "instance_tags" {
    default = "node"
}

variable "service_account_scopes" {
    default = "userinfo-email,compute-ro,storage-ro"
}
