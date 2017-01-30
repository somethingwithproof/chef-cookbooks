# tcp_wrappers cookbook - WIP - Supermarket by Feb. 1, 2017

[![Build Status](https://travis-ci.org/thomasvincent/tcp_wrappers-cookbook.svg?branch=master)](http://travis-ci.org/thomasvincent/tcp_wrappers-cookbook) [![Chef cookbook](https://img.shields.io/cookbook/v/chef-sugar.svg)](https://github.com/thomasvincent/tcp_wrappers-cookbook)

### TODO

- Input validation
- integration tests
- unit tests
- Validating daemon is linked to wrappers.so

The Chef `tcp_wrappers` cookbook installs the `tcp_wrappers` package and configures the `/etc/hosts.deny or /etc/hosts.allow` file.

It also exposes an LWRP for adding and managing tcp_wrappers.

## Requirements

### Platforms

- Debian/Ubuntu
- RHEL/CentOS/Scientific/Amazon/Oracle
- FreeBSD
- Mac OS X
- openSUSE / Suse

### Chef

- Chef 12.1+

### Cookbooks

- None

## Attributes
- `node['tcp_wrappers']['hosts']` - hosts to enable tcp_wrappers access (default: `[]`)
- `node['tcp_wrappers']['daemons']` - daemons to control via tcp_wrappers by default (default: `[]`)
- `node['tcp_wrappers']['options']` - default options to pass via tcp_wrappers by default (default: `[]`)

## Usage
### Attributes
To use attributes for defining tcp_wrappers, set the attributes above on the node (or role) itself:

```json
{
  "default_attributes": {
    "authorization": {
      "tcp_wrappers": {
        "hosts": ["192.168.1.1"],
        "daemons": ["sshd"],
        "options": "spawn /bin/echo `/bin/date` access denied>>/var/log/sshd.log \"
      }
    }
  }
}
```

### tcp_wrappers Defaults
Configure a node attribute, `node['tcp_wrappers']['hosts_allow_defaults']` as an array of `Defaults` entries to configure in `/etc/hosts.allow`. A list of examples for common platforms is listed below:

_Debian_

```ruby
node.default['tcp_wrappers']['hosts_allow_defaults'] = ['allow_options']
```

_Ubuntu 10.04_

```ruby
node.default['tcp_wrappers']['hosts_allow_defaults'] = ['allow_options']
```

_Ubuntu 12.04_

```ruby
node.default['tcp_wrappers']['hosts_allow_defaults'] = []
```

_FreeBSD_

```ruby
node.default['tcp_wrappers']['hosts_allow_defaults'] = []
```

### LWRP

There are two ways for rendering a tcp_wrappers-fragment using this LWRP:
1. Using the built-in template
2. Using a custom, cookbook-level template

Example using the built-in template:

```ruby
tcp_wrappers 'sshd' do
  hosts      "192.168.1.1"
  commands  ['spawn /bin/echo `/bin/date` access denied>>/var/log/sshd.log \']
end
```

```ruby
tcp_wrappers 'tomcat' do
  template    'my_hosts.allow.erb' # local cookbook template
  variables   :cmds => ['spawn /bin/echo `/bin/date` access denied>>/var/log/sshd.log \']
end
```

In either case, the following file would be generated in `/etc/hosts.allow'

```bash
# This file is managed by Chef for node.example.com
# Do NOT modify this file directly.

sshd : ALL : allow : 'spawn /bin/echo `/bin/date` access denied>>/var/log/sshd.log \'
```

#### LWRP Attributes
<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Example</th>
      <th>Default</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>name</td>
      <td>name of the `hosts.allow` file</td>
      <td><tt>hosts.allow</tt></td>
      <td>current resource name</td>
    </tr>
    <tr>
      <td>commands</td>
      <td>array of commands this tcp_wrappers can execute</td>
      <td><tt>[''spawn /bin/echo `/bin/date` access denied>>/var/log/sshd.log \'']</tt></td>
      <td><tt>['ALL']</tt></td>
    </tr>
    <tr>
      <td>daemons</td>
      <td>list of daemons</td>
      <td><tt>daemons</tt></td>
      <td></td>
    </tr>
  </tbody>
</table>

**If you use the template attribute, all other attributes will be ignored except for the variables attribute.**

## Development
This section details "quick development" steps. For a detailed explanation, see [[Contributing.md]].
- Clone this repository from GitHub:

  ```
   $ git clone git@github.com:thomasvincent/tcp_wrappers.git
  ```

- Create a git branch

  ```
   $ git checkout -b my_bug_fix
  ```

- Install dependencies:

  ```
   $ bundle install
  ```

- Make your changes/patches/fixes, committing appropiately
- **Write tests**
- Run the tests:
  - `bundle exec foodcritic -f any .`
  - `bundle exec rspec`
  - `bundle exec rubocop`
  - `bundle exec kitchen test`

    In detail:

  - Foodcritic will catch any Chef-specific style errors
  - RSpec will run the unit tests
  - Rubocop will check for Ruby-specific style errors
  - Test Kitchen will run and converge the recipes

## License & Authors
**Author:** Thomas Vincent (thomasvincent@gmail.com)

**Copyright:** 2017, Thomas Vincent

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
