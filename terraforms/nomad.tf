# Crate nomad server cluster
module "nomad" {
    source = "../modules/cluster"
    cluster_name = "nomad"
    user_data = "${template_file.nomad_cloud_config.rendered}"
    instance_tags = "green"

    # defaults in variables.tf
    cluster_size = "${var.nomad_count}"
    region = "${var.region}"
    zones = "${var.zones}"
    image = "${var.image}"
    machine_type = "${var.nomad_machine_type}"
    disk_size="${var.server_disk_size}"
}

resource "template_file" "nomad_cloud_config" {

    template = "${file("artifacts/nomad_cloud_config.yaml")}"
    vars {
        "etcd_initial_cluster" = "${join(",", formatlist("%s=http://%s:2380", split(",", module.etcd.node_names), split(",", module.etcd.private_ips)))}"
        "region" = "${var.region}"
        "cluster_size" = "${var.nomad_count}"
        "fleet_tags" = "nomad,${var.region},${var.nomad_machine_type}"
    }
}

output "nomad_public_ips" {
    value = "${module.nomad.public_ips}"
}

output "nomad_private_ips" {
    value = "${module.nomad.private_ips}"
}

/*
# GCP free trial account allows only ONE static IP address

module "nomad_load_balancer" {
    source = "../modules/balancer"
    name = "nomad"
    check_port = "4646"
    check_path = "/v1/status/peers"
    instances ="${module.nomad.instance_names}"
}

output "nomad_service_ip" {
    value = "${module.nomad_load_balancer.service_ip}"
}
*/

