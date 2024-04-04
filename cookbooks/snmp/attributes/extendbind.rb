# Cookbook Name:: snmp
# Attributes:: extendbind
#
# Copyright 2012, Eric G. Wolfe
# Copyright 2023, Thomas Vincent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# SNMP Cookbook Attributes - extendbind
# Configures SNMP extended bind statistics script based on RHEL version

# Default script for non-RHEL platforms and RHEL 6 or newer
default['snmp']['rndc_stats_script'] = 'snmp_rndc_stats_v97.pl'

# Specific script for RHEL 5
default['snmp']['rndc_stats_script'] = 'snmp_rndc_stats.pl' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 5
