# frozen_string_literal: true

#
# Cookbook:: net-snmp
# Attributes:: default
#
# Copyright:: 2025, Thomas Vincent
#
# Licensed under the Apache License, Version 2.0 (the "License");

# SNMPv3 Configuration
default['net-snmp']['snmpv3']['enabled'] = false
default['net-snmp']['snmpv3']['users'] = []

# Example user configuration (do not use in production - use encrypted data bags):
# default['net-snmp']['snmpv3']['users'] = [
#   {
#     'username' => 'monitoring_user',
#     'auth_protocol' => 'SHA',
#     'auth_password' => 'authpass123456',
#     'priv_protocol' => 'AES',
#     'priv_password' => 'privpass123456',
#   },
# ]
