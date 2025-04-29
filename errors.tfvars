#Examples of invalid variables that trigger the custom validation error messages

sg_rules = {
    #Sg rule with an invalid direction
    "my_ssh_rule" = {
    cidr_ipv4 = "10.0.0.0/16"
    description = "ipv4 ssh both directions"
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    sgs = [ "my_sg" ]
    direction = "fake_direction"
},
#Sg rule with no cidr block
"my_http_rule" = {
    description = "ipv4 http both directions"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    sgs = [ "my_sg", "my_second_sg" ]
    direction = "both"
},
#Sg rule with a fake associated sg
"my_sql_rule" = {
    cidr_ipv4 = "0.0.0.0/0"
    description = "sql ingress"
    sgs = [ "fake_sg" ]
    direction = "ingress"
}
}
sgs = { 
  my_sg = {
  name = "my_sg"
  description = "An sg with rules allowing ssh and http access for specific ipv4 addresses"
  tags = {
    name = "my_sg"
    test_tag = 1
  }
}
}