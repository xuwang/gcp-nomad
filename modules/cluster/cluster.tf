resource "google_compute_instance" "node" {
    depends_on = ["google_compute_disk.data"]    

    count = "${var.cluster_size}"
    name = "${var.cluster_name}-${count.index+1}"
    machine_type = "${var.machine_type}"
    // servers in different zones
    zone = "${lookup(var.zones, concat("zone", count.index % lookup(var.zones, "size")))}"
    
    tags = [
        "${var.cluster_name}",
        "${var.region}",
        "${lookup(var.zones, concat("zone", count.index % lookup(var.zones, "size")))}",
        "${var.machine_type}",
        "${var.disk_type}",
        "${split(",", var.instance_tags)}"
     ]

    // boot disk
    disk {
        image = "${var.image}"
    }

    // external disk for data
    disk {
        device_name = "data"
        disk = "${var.cluster_name}-data-${count.index+1}"
        auto_delete = false
    }

    network_interface {
        network = "default"
        access_config {
            // Ephemeral IP
        }
    }

    metadata {
        "cluster-name" = "${var.cluster_name}"
        "cluster-size" = "${var.cluster_size}"
        "user-data" = "${var.user_data}"
    }

    service_account {
        scopes = ["${split(",", var.service_account_scopes)}"]
    }
}

resource "google_compute_disk" "data" {
    count = "${var.cluster_size}"
    name = "${var.cluster_name}-data-${count.index+1}"
    type = "${var.disk_type}"
    zone = "${lookup(var.zones, concat("zone", count.index % lookup(var.zones, "size")))}"
    size = "${var.disk_size}"
}

output "node_names" {
    value = "${join(",", google_compute_instance.node.*.name)}"
}

output "private_ips" {
    value = "${join(",", google_compute_instance.node.*.network_interface.0.address)}"
}

output "public_ips" {
    value = "${join(",", google_compute_instance.node.*.network_interface.0.access_config.0.assigned_nat_ip)}"
}