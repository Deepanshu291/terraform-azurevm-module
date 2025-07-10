
variable "rg_name" {
  default = "RG_codeserver"
  description = "Resource Group Name"
  type = string
}

variable "location" {
  description = "resouce group location"
  type = string
}

variable "source_image_name" {
 default = "codexdev"
  description = "source Vm image Name"
  type = string
}


variable "source_image_url" {
 default = "/subscriptions/d77e2983-68f3-474f-b7d1-460f5038891f/resourceGroups/Coderserver-RG/providers/Microsoft.Compute/galleries/codeserverdevx/images/codexdev"
  description = "source Vm image URL"
  type = string
}

variable "subscription_id" {
  type = string
  default = "d77e2983-68f3-474f-b7d1-460f5038891f"
}

