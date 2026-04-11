# R Language Cookbook

[![Chef Version](https://img.shields.io/badge/chef-18.7.10%2B-blue.svg)](https://www.chef.io)
[![Test Kitchen](https://img.shields.io/badge/test--kitchen-docker-green.svg)](https://kitchen.ci)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)

A modern Chef cookbook that installs and configures the R programming language. This cookbook follows Chef 18.7.10+ best practices with Policyfile-driven configuration and Docker-based testing.

## 🚀 Quick Start

```bash
# Clone the cookbook
git clone https://github.com/thomasvincent/chef-r-language-cookbook.git
cd chef-r-language-cookbook

# Install dependencies
bundle install

# Run all tests
bundle exec kitchen test

# Run specific platform
bundle exec kitchen test default-ubuntu-2204
```

## 📋 Requirements

- Chef Infra Client 18.7.10 or higher
- Ruby 3.1+
- Docker (for testing)

## 🖥️ Supported Platforms

| Platform     | Versions     | Status |
| ------------ | ------------ | ------ |
| Ubuntu       | 22.04, 24.04 | ✅     |
| Debian       | 12           | ✅     |
| CentOS       | Stream 9     | ✅     |
| Rocky Linux  | 9            | ✅     |
| Amazon Linux | 2023         | ✅     |
| RHEL         | 9            | ✅     |
| Windows      | 2019, 2022   | ✅     |
| macOS        | 12+          | ✅     |

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

## 🔧 Usage

### Policyfile Workflow (Recommended)

1. Create a `Policyfile.rb` in your repository:

```ruby
name 'my-app'
default_source :supermarket

run_list 'r-language::default'

cookbook 'r-language', github: 'thomasvincent/chef-r-language-cookbook', tag: 'v1.0.0'

# Set attributes
default['r-language']['packages'] = ['dplyr', 'ggplot2', 'shiny']
```

2. Install and compile the policy:

```bash
chef install Policyfile.rb
chef export Policyfile.rb ./export
```

3. Deploy with Chef:

```bash
# Using chef-client
chef-client -z -j export/Policyfile.lock.json

# Or push to Chef Server
chef push production Policyfile.rb
```

### Basic Installation Examples

#### Package Installation (Default)

```ruby
# In a recipe or Policyfile
include_recipe 'r-language::default'
```

#### Source Compilation

```ruby
# Policyfile.rb
default['r-language']['install_method'] = 'source'
default['r-language']['version'] = '4.4.1'
```

#### Installing R Packages

```ruby
# Via attributes
default['r-language']['packages'] = ['tidyverse', 'data.table', 'rmarkdown']

# Via resource in a recipe
r_package 'shiny' do
  version '1.7.4'
  action :install
end

# Bioconductor packages
r_package 'DESeq2' do
  bioc true
  action :install
end
```

## 🧪 Testing

### Unit Tests

```bash
# Run ChefSpec unit tests
bundle exec rspec

# Run with coverage
CHEF_LICENSE=accept bundle exec rspec --format doc
```

### Integration Tests

```bash
# List available test suites
bundle exec kitchen list

# Run all tests
bundle exec kitchen test

# Run specific platform
bundle exec kitchen test default-ubuntu-2204

# Run tests in parallel
bundle exec kitchen test -c 2
```

### Linting

```bash
# Cookstyle (Chef-specific RuboCop)
bundle exec cookstyle

# Auto-correct issues
bundle exec cookstyle -a
```

## 📦 Development

### Setup Development Environment

```bash
# Install dependencies
bundle install

# Install git hooks
precommit install
```

### Policyfile Commands

```bash
# Update cookbook dependencies
chef update Policyfile.rb

# Show policy info
chef show-policy

# Clean policy cache
chef clean-policy-cookbooks
```

### Docker Testing Tips

```bash
# Keep container running for debugging
bundle exec kitchen create default-ubuntu-2204
bundle exec kitchen converge default-ubuntu-2204
bundle exec kitchen login default-ubuntu-2204

# Clean up all test instances
bundle exec kitchen destroy
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Run tests (`bundle exec kitchen test`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## 📋 License

MIT License - see [LICENSE](LICENSE) file for details

## 👥 Authors

- **Thomas Vincent** - _Initial work_ - [thomasvincent](https://github.com/thomasvincent)

## 🙏 Acknowledgments

- Chef Software for the amazing Chef Infra
- The R Project for Statistical Computing
- All contributors to this cookbook
