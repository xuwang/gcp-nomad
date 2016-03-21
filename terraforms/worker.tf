# Create worker worker cluster
module "worker" {
    source = "../modules/cluster"
    cluster_name = "worker"
    user_data = "${template_file.worker_cloud_config.rendered}"
    instance_tags = "green"

    # defaults in variables.tf
    cluster_size = "${var.worker_count}"
    region = "${var.region}"
    zones = "${var.zones}"
    image = "${var.image}"
    machine_type = "${var.worker_machine_type}"
    disk_size="${var.worker_disk_size}"
}

resource "template_file" "worker_cloud_config" {

    template = "${file("artifacts/worker_cloud_config.yaml")}"
    vars {
        "region" = "${var.region}"
        "nomad_servers" = "${join(",", formatlist("%s:4647", split(",", module.nomad.private_ips)))}"
        "nomad_meta" = "key=value"
        "consul_address" = "${module.consul_load_balancer.service_ip}"
        "consul_token" = "${var.consul_master_token}"
    }
}

output "worker_public_ips" {
    value = "${module.worker.public_ips}"
}

output "worker_private_ips" {
    value = "${module.worker.private_ips}"
}

/*
# GCP free trial account allows only ONE static IP address

module "worker_load_balancer" {
    source = "../modules/balancer"
    name = "worker"
    check_port = "80"
    check_path = "/_ping"
    instances ="${module.worker.instance_names}"
}

output "worker_service_ip" {
    value = "${module.worker_load_balancer.service_ip}"
}
*/

