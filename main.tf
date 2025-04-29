terraform {
  required_providers {
    aws ={
        source = "aws"
        version = "5.96"
    }
  }
}
resource "aws_security_group" "default" {
    for_each    = var.sgs
    name        = each.value.name
    description = each.value.description
    tags        = each.value.tags
    vpc_id      = each.value.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "default" {
  for_each          = local.egress_association
  cidr_ipv4         = var.sg_rules[split("/", each.key)[0]].cidr_ipv4
  cidr_ipv6         = var.sg_rules[split("/", each.key)[0]].cidr_ipv6
  description       = var.sg_rules[split("/", each.key)[0]].description
  from_port         = var.sg_rules[split("/", each.key)[0]].from_port
  to_port           = var.sg_rules[split("/", each.key)[0]].to_port
  ip_protocol       = var.sg_rules[split("/", each.key)[0]].ip_protocol
  security_group_id = aws_security_group.default[each.value].id
}

resource "aws_vpc_security_group_ingress_rule" "default" {
  for_each          = local.ingress_association
  cidr_ipv4         = var.sg_rules[split("/", each.key)[0]].cidr_ipv4
  cidr_ipv6         = var.sg_rules[split("/", each.key)[0]].cidr_ipv6
  description       = var.sg_rules[split("/", each.key)[0]].description
  from_port         = var.sg_rules[split("/", each.key)[0]].from_port
  to_port           = var.sg_rules[split("/", each.key)[0]].to_port
  ip_protocol       = var.sg_rules[split("/", each.key)[0]].ip_protocol
  security_group_id = aws_security_group.default[each.value].id
}


locals {
  possible_directions = ["ingress", "egress", "both"]
  #List of rules that are either egress or both
  egress_rules = {for name, rule in var.sg_rules : name => rule if rule.direction == "egress" || rule.direction == "both"}
  #List of rules that are either ingress or both
  ingress_rules = {for name, rule in var.sg_rules : name => rule if rule.direction == "ingress" || rule.direction == "both"}
  #Associates sg name with rule description for ingress and egress

#Creates a map of {(key of the rule/name of sg) = name of security group to attach to} for each attach needed
#The formatting with a slash is used as terraform expects keys to be unique
egress_association  = merge([for name, rule in local.egress_rules : {for sg in rule.sgs : format("%s/%s", name, sg) => sg}]...)
ingress_association = merge([for name, rule in local.ingress_rules : {for sg in rule.sgs : format("%s/%s", name, sg) => sg}]...)
}
