# R Language Cookbook

A Chef cookbook that installs and configures R programming language. R is a system for statistical computation and graphics.

## Supported Platforms

- Amazon Linux 2.x, 2023
- Debian 10.x, 11.x
- FreeBSD 13.x
- macOS 12.x, 13.x, 14.x
- Oracle Enterprise Linux 7.x, 8.x
- Red Hat Enterprise Linux (RHEL) 7.x, 8.x, 9.x
- Rocky Linux 8.x, 9.x
- SUSE Linux Enterprise Server (SLES) 12.x, 15.x
- Ubuntu (LTS releases) 18.04, 20.04, 22.04
- Windows 10, 11, Server 2016, 2019, 2022

## Supported Chef Versions

- Chef Infra Client 18+

## Dependencies

Chef 18+ includes built-in package management resources, so no external cookbook dependencies are required.

## Attributes

| Key                                             | Type    | Description                                    | Default                         |
| ----------------------------------------------- | ------- | ---------------------------------------------- | ------------------------------- |
| `['r-language']['version']`                     | String  | R version to install (nil uses distro default) | `nil`                           |
| `['r-language']['install_method']`              | String  | Installation method ('package' or 'source')    | `'package'`                     |
| `['r-language']['source_url']`                  | String  | URL for source tarball                         | `nil` (auto-generated)          |
| `['r-language']['source_checksum']`             | String  | Checksum for source tarball                    | `nil`                           |
| `['r-language']['cran_mirror']`                 | String  | CRAN mirror URL                                | `'https://cloud.r-project.org'` |
| `['r-language']['install_dev']`                 | Boolean | Whether to install development packages        | `true`                          |
| `['r-language']['install_recommended']`         | Boolean | Whether to install recommended packages        | `true`                          |
| `['r-language']['enable_repo']`                 | Boolean | Whether to enable the R repository             | `true`                          |
| `['r-language']['packages']`                    | Array   | R packages to install                          | `[]`                            |
| `['r-language']['source']['configure_options']` | Array   | Configure options for source install           | See attributes file             |

For additional attributes related to repository configuration, please refer to the `attributes/default.rb` file.

## Recipes

### default

Includes either the `package` or `source` recipe based on the `node['r-language']['install_method']` attribute, and then the `packages` recipe if any packages are specified.

### package

Installs R using the system package manager (apt or yum). If `node['r-language']['enable_repo']` is true, it will also configure the official R repositories.

### source

Installs R from source. This is useful when you need a specific version or custom compile options.

### packages

Installs the R packages specified in the `node['r-language']['packages']` attribute.

## Custom Resources

### r_package

A custom resource for installing R packages.

#### Properties

- `package_name` - Name of the R package to install (name property)
- `version` - Specific version to install (optional)
- `repo` - Repository URL to use (default: https://cloud.r-project.org)
- `bioc` - Whether to use Bioconductor for installation (default: false)

#### Actions

- `:install` - Install the specified R package
- `:remove` - Remove the specified R package

#### Examples

```ruby
# Install dplyr package
r_package 'dplyr' do
  action :install
end

# Install specific version
r_package 'ggplot2' do
  version '3.3.0'
  action :install
end

# Install from Bioconductor
r_package 'DESeq2' do
  bioc true
  action :install
end

# Remove a package
r_package 'dplyr' do
  action :remove
end
```

## Usage

### Basic Installation

Include `r-language` in your node's `run_list`:

```json
{
  "run_list": ["recipe[r-language::default]"]
}
```

This will install R using packages from your distribution's standard repositories.

### Using CRAN Repositories

To install from the official CRAN repositories with development packages:

```ruby
node.default['r-language']['enable_repo'] = true
node.default['r-language']['install_dev'] = true
include_recipe 'r-language::default'
```

### Installing from Source

To compile and install R from source:

```ruby
node.default['r-language']['install_method'] = 'source'
node.default['r-language']['version'] = '4.3.1'
include_recipe 'r-language::default'
```

### Installing R Packages

To install R packages:

```ruby
# Using the packages attribute
node.default['r-language']['packages'] = ['dplyr', 'ggplot2', 'shiny']

# Or using the r_package resource directly
r_package 'tidyverse' do
  action :install
end
```

## License

MIT (see LICENSE file)

## Authors

- Thomas Vincent
