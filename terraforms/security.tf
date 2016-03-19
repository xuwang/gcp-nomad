# Firewalls for nomad server
resource "google_compute_firewall" "nomad" {
    name = "allow-nomad"
    description = "Allow nomad from internal."
    network = "default"

    allow {
        protocol = "tcp"
        
        # http, rpc, serf
        ports = ["4646", "4647", "4848"]  
    }

    source_ranges = ["10.0.0.0/16"]
    target_tags = ["nomad-server"]
}

resource "google_compute_firewall" "etcd" {
    name = "allow-etcd"
    description = "Allow etcd from internal."
    network = "default"

    allow {
        protocol = "tcp"
        
        # http, rpc, serf
        ports = ["2379", "2380"]  
    }

    source_ranges = ["10.0.0.0/16"]
    target_tags = ["etcd-server"]
}

resource "google_compute_firewall" "www" {
    name = "allow-www"
    description = "Allow nomad from anywhere."
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["80"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["nomad-server"]
}
