# Firewalls for etcd2
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

    allow {
        protocol = "udp"
        #rpc, serf
        ports = ["4647", "4848"]  
    }

    source_ranges = ["10.0.0.0/24"]
    target_tags = ["nomad"]
}

# Firewalls for nomad HTTP Api
resource "google_compute_firewall" "nomad_api" {
    name = "allow-nomad-api"
    description = "Allow nomad_api from everywhere."
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["4646"]
    } 

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["namad"]
}

/*
Consul ports:
Server RPC (Default 8300). This is used by servers to handle incoming requests from other agents. TCP only.
Serf LAN (Default 8301). This is used to handle gossip in the LAN. Required by all agents. TCP and UDP.
Serf WAN (Default 8302). This is used by servers to gossip over the WAN to other servers. TCP and UDP.
CLI RPC (Default 8400). This is used by all agents to handle RPC from the CLI. TCP only.
HTTP API 80 (Default 8500). This is used by clients to talk to the HTTP API. TCP only.
DNS Interface 53 (Default 8600). Used to resolve DNS queries. TCP and UDP.
 */
resource "google_compute_firewall" "consul" {
    name = "allow-consul"
    description = "Allow consul from internal."
    network = "default"

    allow {
        protocol = "tcp"      
        ports = ["8300", "8301", "8302", "8400", "53", "80", "443"]  
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
    description = "Allow consul from everywhere."
    network = "default"

    allow {
        protocol = "tcp"      
        ports = ["80", "443"]  
    } 

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["consul"]
}
