# R Language Cookbook

A Chef cookbook that installs and configures R programming language. R is a system for statistical computation and graphics.

## Supported Platforms

- Ubuntu 18.04+
- Debian 10+
- CentOS 7+
- Red Hat Enterprise Linux 7+
- Amazon Linux 2+
- Fedora 30+

## Supported Chef Versions

- Chef 15+

## Dependencies

- `apt` cookbook (>= 7.0)
- `yum` cookbook (>= 5.0)
- `build-essential` cookbook (>= 8.0)

## Attributes

| Key | Type | Description | Default |
| --- | ---- | ----------- | ------- |
| `['r-language']['version']` | String | R version to install (nil uses distro default) | `nil` |
| `['r-language']['install_method']` | String | Installation method ('package' or 'source') | `'package'` |
| `['r-language']['source_url']` | String | URL for source tarball | `nil` (auto-generated) |
| `['r-language']['source_checksum']` | String | Checksum for source tarball | `nil` |
| `['r-language']['cran_mirror']` | String | CRAN mirror URL | `'https://cloud.r-project.org'` |
| `['r-language']['install_dev']` | Boolean | Whether to install development packages | `true` |
| `['r-language']['install_recommended']` | Boolean | Whether to install recommended packages | `true` |
| `['r-language']['enable_repo']` | Boolean | Whether to enable the R repository | `true` |
| `['r-language']['packages']` | Array | R packages to install | `[]` |
| `['r-language']['source']['configure_options']` | Array | Configure options for source install | See attributes file |

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
  "run_list": [
    "recipe[r-language::default]"
  ]
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