
variable "sgs" {
    type          = map(object({
      name        = string
      description = optional(string)
      tags        = optional(map(string))
      vpc_id      = optional(string)
    }))
    default = {}
}

variable "sg_rules" {
  type = map(object({
    cidr_ipv4   = optional(string)
    cidr_ipv6   = optional(string)
    description = string
    from_port   = optional(number)
    to_port     = optional(number)
    ip_protocol =   optional(string)
    sgs         = list(string)
    direction   = string
  }))
  default = {}
  validation {
    condition = alltrue([for rule in var.sg_rules : contains(["ingress", "egress", "both"], rule.direction)])
    error_message = "All sg_rules must have a direction of ingress, egress, or both."
  }
  validation {
    condition = alltrue([for rule in var.sg_rules : rule.cidr_ipv4 != null || rule.cidr_ipv6 != null])
    error_message = "All sg_rules must have either an ipv4 or ipv6 cidr block."
  }
  validation {
    condition = alltrue([for rule in var.sg_rules : alltrue([for sg in rule.sgs : contains(keys(var.sgs), sg)])])
    error_message = "All security groups referenced in the sg_rules.sgs arguments must be a security group defined in the sgs variable."
  }
}
