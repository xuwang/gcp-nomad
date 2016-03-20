
# Use your own PROJECT ID
variable "google_project_id" { 
    default = "nomadcluster"
}

variable "account_file" {
    default = "account.json"
}

/* Availabe region
"asia-east1"
"europe-west1"
"us-east1"
"us-central1"
*/
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

/*
To get the latest CoreOS stable image id:
    gcloud compute images list | grep coreos-stable | awk '{print $1;}'
*/
variable "image" {
    default = "coreos-stable-835-13-0-v20160218"
}

variable "machine_type" {
    default = "n1-standard-1"
}

variable "etcd_count" {
    default = 1
}

variable "server_count" {
    default = 3
}

variable "worker_account" {
    default = 1
}

variable "server_disk_size" {
    default = 50
}

variable "worker_disk_size" {
    default = 50
}

variable "discovery_url_file" {
    default = "artifacts/discovery_url.txt"
}
