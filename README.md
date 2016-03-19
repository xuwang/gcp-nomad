# Create A Nomad Cluster On GCP with Terraform

This is a demo project that will create a [Nomad Cluster][nomad] on **[Google Clould Platform][gCloud]** with **[Terraform][terraform]**.

**Google Cloud Platform** enables developers to build, test and deploy applications on Google’s highly-scalable and reliable infrastructure.

**Terraform** is a tool for creating, combining, and managing infrastructure resources across multiple providers. Manage resources on cloud providers such as Amazon Web Services, Google Cloud, Microsoft Azure, DNS records on DNSSimple, Dyn, and CloudFlare, email services on Mailgun, and more.

**Nomad** is a cluster manager and scheduler designed for microservices and batch workloads. Nomad is distributed, highly available, and scales to thousands of nodes spanning multiple datacenters and regions.

## Install Terraform

If terraform is not installed on the workstation, following the instructions on [Installing Terraform][installing-terraform] to install Terraform.

**Tip:** for MacOS users, just `brew install terraform`

## Setup A Google Cloud Project

The start point for working on Google Clould Platform is **Project** (very engineering oriented).

The first thing we need to do is to login and create a new project at [Google Project Console][gProject], for example:

Project Name | Project ID
------------ | ----------
NomadCluster | nomadcluster


**Note:** you'll be asked to setup billing infomation for this new project. If you are new user, Google gives you a `$300.00` GCP credit for 60 days. 

### Enable Google Cloud APIs for NomadCluster

To use and control google cloud with command line tools, we need to enable Google Cloud APIs.

Go to [Google Cloud API Manager][gAPI]
and enable Google Cloud APIs for NomadCluster:

* Compute Engine API
* Cloud Storage Service
* Cloud Deployment Manager API
* Cloud DNS API
* Cloud Monitoring API
* Cloud Storage JSON API
* Compute Engine Instance Group Manager API
* Compute Engine Instance Groups API
* Prediction API

**Note:** Make sure the project is *NomadCluster* and click through the APIs to enable them.

### Get Authentication JSON File

Authenticating with Google Cloud services requires a JSON file which is called the _account file_ in Terraform.

This file is downloaded directly from the [Google Project Console][gProject]:

1. Click the menu button in the top left corner, and navigate to "Permissions", then "Service accounts", and finally "Create service account".

1. Provide **nomadcluster** as the name and ID in the corresponding fields, select "Furnish a new private key", and select "JSON" as the key type.

1. Clicking "Create" will download your credentials.

1. Rename the downloaded json file to **account.json**

## Provision NomadCluster on Google Cloud
```shell
$ git clone https://github.com/xuwang/gcp-nomad.git
$ cp account.json gcp-nomad/tf/
$ cd gcp-nomad/tf
```
**Note:** You should check default values defined in **tf/variables.tf** and make modification to match your own case, e.g. use your own **`google_project_id`** instead of the default _`nomadcluster`_.

### Plan and apply the Terraform managed resources

Run Terraform plan to preview what resources will be created:

```
$ terraform plan
...
+ google_compute_target_pool.www
    description:     "" => "www server pool"
    health_checks.#: "" => "1"
    health_checks.0: "" => "www-check"
    instances.#:     "" => "3"
    instances.0:     "" => "us-central1-a/www-1"
    instances.1:     "" => "us-central1-b/www-2"
    instances.2:     "" => "us-central1-c/www-3"
    name:            "" => "www-pool"
    self_link:       "" => "<computed>"
Plan: 8 to add, 0 to change, 0 to destroy.
```

If everything looks good, apply the terraform:

```shell
$ terraform apply
...
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.
...
Outputs:
   nomad_service_ip = 146.148.104.177
```
Give a few minutes, the NomadCluster should be up and running on google cloud.


## Cleanup: Destroy the NomadCluster

If you want to **stop paying google for NomadCluster**, remember to clean it up:

```shell
$ terraform destroy
...
google_compute_instance.www.1: Destruction complete
google_compute_instance.www.0: Destruction complete
google_compute_instance.www.2: Destruction complete

Apply complete! Resources: 0 added, 0 changed, 8 destroyed.
```

[virtualbox]: https://www.virtualbox.org/
[vagrant]: https://www.vagrantup.com/downloads.html
[CoreOS]: https://coreos.com/
[using-coreos]: http://coreos.com/docs/using-coreos/
[Etcd]: https://coreos.com/etcd/
[Docker-Nodeapp]: https://github.com/xueshanf/Docker-Nodeapp
[terraform]: https://www.terraform.io/
[installing-terraform]: https://www.terraform.io/intro/getting-started/install.html
[gCloud]: https://cloud.google.com/
[gProject]: https://console.cloud.google.com/project
[gSDK]: https://cloud.google.com/sdk/
[gAPI]: https://console.cloud.google.com/apis
[gcloud-lb]: https://cloud.google.com/compute/docs/load-balancing/network/example
[gInstance]: https://console.cloud.google.com/compute/instances
[nomad]: https://www.hashicorp.com/blog/nomad.html
