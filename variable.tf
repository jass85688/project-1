variable "aws_usernames" {
  type = list(string)
  default = ["Jaspal","Harsimran","Jaldeep","Afsah"]
}
variable "s3_bucket_names" {
  type = list
  default = ["bucket1.app", "bucket2.app"]
}

variable "prefix" {
  default = "jass1234"
}

variable "storage_acc_name" {
  type = string
  default = "jaspalstorageacc1"
}
