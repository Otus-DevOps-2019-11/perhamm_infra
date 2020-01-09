variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west3-c"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable disk_image {
  description = "Disk image"
}
variable private_key_path {
  description = "Path to the private key"
}

variable public_key_path1 {
  description = "Path to the public key used for ssh access"
}
variable public_key_path2 {
  description = "Path to the public key used for ssh access"
}
variable public_key_path3 {
  description = "Path to the public key used for ssh access"
}
variable node_count {
  description = "Number of running instances"
  default     = "1"
}
