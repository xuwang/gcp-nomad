# Crate consul server cluster
module "consul" {
    source = "../modules/cluster"
    cluster_name = "consul"
    user_data = "${template_file.consul_cloud_config.rendered}"
    instance_tags = "green"

    # defaults in variables.tf
    cluster_size = "${var.consul_count}"
    region = "${var.region}"
    zones = "${var.zones}"
    image = "${var.image}"
    machine_type = "${var.consul_machine_type}"
    disk_size="${var.server_disk_size}"
}

resource "template_file" "consul_cloud_config" {

    template = "${file("artifacts/consul_cloud_config.yaml")}"
    vars {
        "etcd_initial_cluster" = "${join(",", formatlist("%s=http://%s:2380", split(",", module.etcd.node_names), split(",", module.etcd.private_ips)))}"
        "region" = "${var.region}"
        "cluster_size" = "${var.consul_count}"
        "fleet_tags" = "consul,${var.region},${var.consul_machine_type}"
        "consul_master_token" = "${var.consul_master_token}"
    }
}

module "consul_load_balancer" {
    source = "../modules/balancer"
    name = "consul"
    check_port = "80"
    check_path = "/v1/status/leader"
    instances ="${module.consul.instance_names}"
}

output "consul_public_ips" {
    value = "${module.consul.public_ips}"
}

output "consul_private_ips" {
    value = "${module.consul.private_ips}"
}

