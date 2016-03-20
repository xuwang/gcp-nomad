variable "name" {
    default = "www"
}

# server instances in format:
# "${join(",", formatlist("%s/%s", google_compute_instance.www.*.zone, google_compute_instance.www.*.name))}"
variable "instances" {}

variable "check_port" {
    default = "80"
}

variable "check_path" {
    default = "/"
}

variable "check_interval_sec" {
    default = 5
}

variable "timeout_sec" {
    default = 5
}