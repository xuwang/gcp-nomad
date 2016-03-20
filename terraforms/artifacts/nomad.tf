# Crate Nomad server cluster
module "nomad" {
    source = "../modules/cluster"
    cluster_name="nomad"
    user_data = "${template_file.nomad_cloud_config.rendered}"
    instance_tags ="nomad-server"

    # defaults in variables.tf
    cluster_size = "${var.server_count}"
    region = "${var.region}"
    zones = "${var.zones}"
    image = "${var.image}"
    machine_type = "${var.machine_type}"
    disk_size="${var.server_disk_size}"
}

resource "template_file" "nomad_cloud_config" {

    template = "${file("artifacts/nomad_cloud_config.yaml")}"
    vars {
        "etcd_initial_cluster" =  "${join(",", formatlist("%s=http://%s:2380", split(",", module.etcd.node_names), split(",", module.etcd.private_ips)))}"
        "region" = "${var.region}"
        "cluster_size" = "${var.server_count}"
        "fleet_tags" = "nomad,${var.region},${var.machine_type}"
    }
}

output "nomad_public_ips" {
    value = "${module.nomad.public_ips}"
}

output "nomad_private_ips" {
    value = "${module.nomad.private_ips}"
}

