sgs = { 
  my_sg = {
  name = "my_sg"
  description = "An sg with rules allowing ssh and http access for specific ipv4 addresses"
  tags = {
    name = "my_sg"
    test_tag = 1
  }
}
my_second_sg = {
    name = "my_second_sg"
    description = "An sg with a MySQL ingress rule, and http both directions"
}
}
sg_rules = {
    "my_ssh_rule" = {
    cidr_ipv4 = "10.0.0.0/16"
    description = "ipv4 ssh both directions"
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    sgs = [ "my_sg" ]
    direction = "both"
},
"my_http_rule" = {
    cidr_ipv4 = "10.0.0.0/16"
    description = "ipv4 http both directions"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    sgs = [ "my_sg", "my_second_sg" ]
    direction = "both"
},
"my_sql_rule" = {
    cidr_ipv4 = "0.0.0.0/0"
    description = "sql ingress"
    from_port = 3306
    to_port = 3306
    ip_protocol = "tcp"
    sgs = [ "my_second_sg" ]
    direction = "ingress"
}
}