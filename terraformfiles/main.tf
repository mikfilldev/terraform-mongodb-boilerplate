terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
  }
  required_version = ">= 0.13"
}


provider "mongodbatlas" {
  public_key  = var.MONGODB_ATLAS_PUBLIC_KEY
  private_key = var.MONGODB_ATLAS_PRIVATE_KEY
}


resource "mongodbatlas_project" "mikproject" {
  name        = var.MONGODB_ATLAS_PROJECT_NAME
  org_id      = var.MONGODB_ATLAS_ORGANIZATION_ID
}


data "mongodbatlas_project" "mikproject" {
  project_id = "${mongodbatlas_project.mikproject.id}"
}


resource "mongodbatlas_cluster" "test" {
  project_id                  = "${mongodbatlas_project.mikproject.id}"
  name                        = var.MONGODB_ATLAS_CLUSTER_NAME
  provider_name               = var.MONGODB_ATLAS_PROVIDER_NAME
  backing_provider_name       = var.MONGODB_ATLAS_BACKING_PROVIDER_NAME
  provider_region_name        = var.MONGODB_ATLAS_PROVIDER_REGION_NAME
  provider_instance_size_name = var.MONGODB_ATLAS_PROVIDER_INSTANCE_SIZE_NAME
}


resource "mongodbatlas_database_user" "bob" {
  project_id         = "${mongodbatlas_project.mikproject.id}"
  username           = var.MONGODB_ATLAS_USER_NAME
  auth_database_name = "admin"
  password           = var.MONGODB_ATLAS_USER_PASSWORD
  roles {
    role_name     =  "readWrite"
    database_name = var.MONGODB_ATLAS_DATABASE_NAME
  }
  depends_on         = [mongodbatlas_cluster.test]
}


resource "mongodbatlas_project_ip_access_list" "cidr1" {
  project_id  = "${mongodbatlas_project.mikproject.id}"
  depends_on  = [mongodbatlas_cluster.test]
  cidr_block = var.cidr_block_allow_all_1
}


resource "mongodbatlas_project_ip_access_list" "cidr2" {
  project_id  = "${mongodbatlas_project.mikproject.id}"
  depends_on  = [mongodbatlas_cluster.test]
  cidr_block = var.cidr_block_allow_all_2
}