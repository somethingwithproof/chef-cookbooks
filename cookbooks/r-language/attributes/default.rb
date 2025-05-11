# R version and configuration
default['r-language']['version'] = nil # Use distro package version by default
default['r-language']['install_method'] = 'package' # 'package' or 'source'
default['r-language']['source_url'] = nil # Will be set automatically based on version if nil
default['r-language']['source_checksum'] = nil

# CRAN mirror URL
default['r-language']['cran_mirror'] = 'https://cloud.r-project.org'

# Package options
default['r-language']['install_dev'] = true # Install r-base-dev package
default['r-language']['install_recommended'] = true # Install recommended packages
default['r-language']['enable_repo'] = true # Enable the R repository on supported platforms

# Repository configuration 
default['r-language']['ubuntu']['keyserver'] = 'keyserver.ubuntu.com'
default['r-language']['ubuntu']['key'] = 'E298A3A825C0D65DFD57CBB651716619E084DAB9'
default['r-language']['ubuntu']['repo'] = 'https://cloud.r-project.org/bin/linux/ubuntu'

default['r-language']['debian']['keyserver'] = 'keyserver.ubuntu.com'
default['r-language']['debian']['key'] = 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'
default['r-language']['debian']['repo'] = 'https://cloud.r-project.org/bin/linux/debian'

default['r-language']['rhel']['repo_url'] = 'https://cloud.r-project.org/bin/linux/centos/#{node["platform_version"].to_i}'
default['r-language']['rhel']['key_url'] = 'https://cloud.r-project.org/bin/linux/centos/RPM-GPG-KEY-EPEL-#{node["platform_version"].to_i}'

# Default packages to install
default['r-language']['packages'] = []

# Source installation options
default['r-language']['source']['configure_options'] = %w(
  --enable-R-shlib
  --with-blas
  --with-lapack
)