#!/bin/bash
#Entrypoint script that sets up Vault config required for Goldfish
#API calls were converted from:
#- https://github.com/Caiyeon/goldfish/blob/master/vagrant/policies/goldfish.hcl
#- https://github.com/Caiyeon/goldfish/wiki/Production-Deployment#1-prepare-vault-only-needs-to-be-done-once
#
#Based of https://github.com/Caiyeon/goldfish/blob/master/docker/entrypoint.sh

/usr/local/sbin/goldfish -config=/config.hcl -token=`cat /secrets/wrapped_token`
