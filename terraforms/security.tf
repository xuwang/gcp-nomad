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

    source_ranges = ["10.0.0.0/24"]
    target_tags = ["nomad"]
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

    source_ranges = ["10.0.0.0/24"]
    target_tags = ["etcd"]
}

resource "google_compute_firewall" "consul" {
    name = "allow-consul"
    description = "Allow consul from internal."
    network = "default"

    allow {
        protocol = "tcp"      
        ports = ["8301", "8302", "8400", "80", "443"]  
    } 

    allow {
        protocol = "udp"      
        ports = ["8301", "8302", "53"]  
    }

    source_ranges = ["10.0.0.0/24"]
    target_tags = ["consul"]
}

resource "google_compute_firewall" "consul-ui" {
    name = "allow-consul-ui"
    description = "Allow consul from internal."
    network = "default"

    allow {
        protocol = "tcp"      
        ports = ["80", "443"]  
    } 

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["consul"]
}
