#service ip
resource "google_compute_address" "service" {
    name = "${var.name}"
}

output "service_ip" {
    value = "${google_compute_address.service.address}"
}

# service server pool
resource "google_compute_target_pool" "service" {
    name = "${var.name}"
    description = "${var.name} server pool"
    # servers in a same zone
    instances = ["${split(",", var.instances)}"]

    # Not supported on google API: https://github.com/hashicorp/terraform/issues/4282
    # health_checks = [ "${google_compute_https_health_check.service.name}" ]
    health_checks = [ "${google_compute_http_health_check.service.name}" ]
}

# bind the web service ip to target pool
resource "google_compute_forwarding_rule" "service" {
    name = "${var.name}"
    description = "bind the service service ip to target pool"
    target = "${google_compute_target_pool.service.self_link}"
    ip_address = "${google_compute_address.service.address}"
    # trust firewall rules
    // ip_protocol = "TCP"
    // port_range = "${var.port}"
}

resource "google_compute_http_health_check" "service" {
    name = "${var.name}"
    port = "${var.check_port}"
    request_path = "${var.check_path}"
    check_interval_sec =  "${var.check_interval_sec}"
    timeout_sec = "${var.timeout_sec}"
}


