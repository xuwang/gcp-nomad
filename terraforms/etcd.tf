# Crate etcd server cluster
module "etcd" {
    source = "../modules/cluster"
    cluster_name="etcd"
    user_data = "${template_file.etcd_cloud_config.rendered}"
    instance_tags ="nomad-etcd"

    # defaults in variables.tf
    cluster_size = "${var.etcd_count}"
    region = "${var.region}"
    zones = "${var.zones}"
    image = "${var.image}"
    machine_type = "${var.etcd_machine_type}"
    disk_size="${var.server_disk_size}"
}

resource "template_file" "etcd_cloud_config" {

    depends_on = ["null_resource.etcd_discovery_url"]
    template = "${file("artifacts/etcd_cloud_config.yaml")}"
    vars {
        "etcd_discovery_url" = "${file(var.discovery_url_file)}"
    }
}

resource "null_resource" "etcd_discovery_url" {

    provisioner "local-exec" {
        command = "curl -s https://discovery.etcd.io/new?size=${var.etcd_count} > ${var.discovery_url_file}"
    }
}

output "etcd_public_ips" {
    value = "${module.etcd.public_ips}"
}

output "etcd_private_ips" {
    value = "${module.etcd.private_ips}"
}

output "etcd_initial_cluster" {
    value =  "${join(",", formatlist("%s=http://%s:2380", split(",", module.etcd.node_names), split(",", module.etcd.private_ips)))}"
}
