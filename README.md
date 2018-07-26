# aws-proxy-pattern

## Description

https://github.com/nearform/pathfinders/issues/260

A fairly common security best practice is to send outbound internet traffic through a proxy to facilitate monitoring and filtering. Transparent proxies make this easier by not requiring any specific configuration on the hosts.

Making a terraform module to reproduce this architectural 'pattern' easily within an AWS VPC would allow people to bring up the required infrastructure and inspect the configuration to see how it works, or adapt it to their cloud provider. Accompanying it with an article about how to use the module and the benefits of a web proxy would encourage adoption and raise awareness of NearForm's expertise in security.

AWS PrivateLink is an interesting way to develop this further by offering an endpoint in a customers private network for outbound traffic, so an outbound proxy could be run as a service and customers need only route outbound traffic towards the service.