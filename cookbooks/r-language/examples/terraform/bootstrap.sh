#!/bin/bash
# Bootstrap script for R Analytics Server with Chef

set -e

# Variables from Terraform
ENVIRONMENT="${environment}"
R_PACKAGES='${r_packages}'
CHEF_VERSION="${chef_version}"

# Logging
exec > >(tee /var/log/bootstrap.log)
exec 2>&1

echo "Starting bootstrap process for R Analytics Server"
echo "Environment: $ENVIRONMENT"
echo "Chef Version: $CHEF_VERSION"
echo "R Packages: $R_PACKAGES"

# Update system
apt-get update
apt-get upgrade -y

# Install Chef Infra Client
curl -L https://omnitruck.chef.io/install.sh | bash -s -- -v $CHEF_VERSION

# Accept Chef license
export CHEF_LICENSE=accept-silent

# Create Chef directories
mkdir -p /etc/chef
mkdir -p /var/chef/cache
mkdir -p /var/log/chef

# Create Policyfile
cat > /etc/chef/Policyfile.rb << EOF
name 'r-analytics-server'
default_source :supermarket

run_list 'r-language::default'

cookbook 'r-language', github: 'thomasvincent/chef-r-language-cookbook', tag: 'v1.0.0'

# Configure R installation
default['r-language']['install_method'] = 'package'
default['r-language']['install_dev'] = true
default['r-language']['install_recommended'] = true
default['r-language']['packages'] = $R_PACKAGES

# Environment-specific settings
default['r-language']['environment'] = '$ENVIRONMENT'
EOF

# Install and compile Policyfile
cd /etc/chef
chef install Policyfile.rb

# Create Chef client configuration
cat > /etc/chef/client.rb << EOF
log_level        :info
log_location     STDOUT
chef_server_url  'http://localhost:8889'
validation_key   false
local_mode       true
cookbook_path    ['/var/chef/cache/cookbooks']
lockfile         '/var/chef/cache/chef-client-running.pid'
file_cache_path  '/var/chef/cache'
file_backup_path '/var/chef/backup'
node_name        '$(hostname -f)'
json_attribs     '/etc/chef/node.json'
policy_document_native_api false
use_policyfile true
policy_name 'r-analytics-server'
EOF

# Create node attributes
cat > /etc/chef/node.json << EOF
{
  "r-language": {
    "packages": $R_PACKAGES
  },
  "run_list": ["r-language::default"]
}
EOF

# Run Chef client
echo "Running Chef client..."
chef-client --local-mode --config /etc/chef/client.rb

# Install additional R packages for analytics
echo "Installing additional R packages for analytics platform..."
Rscript -e "
packages <- c('shiny', 'shinydashboard', 'DT', 'plotly', 'rmarkdown', 'knitr')
install.packages(packages, repos='https://cloud.r-project.org', quiet=TRUE)
cat('Additional packages installed successfully\n')
"

# Setup systemd service for automatic Chef runs
cat > /etc/systemd/system/chef-client.service << EOF
[Unit]
Description=Chef Client Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/chef-client --local-mode --config /etc/chef/client.rb
User=root
Environment=CHEF_LICENSE=accept-silent

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/chef-client.timer << EOF
[Unit]
Description=Chef Client Timer
Requires=chef-client.service

[Timer]
OnCalendar=*:0/30
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Enable and start Chef client timer
systemctl daemon-reload
systemctl enable chef-client.timer
systemctl start chef-client.timer

# Create status endpoint
cat > /var/www/html/status.json << EOF
{
  "status": "healthy",
  "environment": "$ENVIRONMENT",
  "chef_version": "$CHEF_VERSION",
  "r_version": "$(R --version | head -1)",
  "bootstrap_time": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "packages": $R_PACKAGES
}
EOF

echo "Bootstrap completed successfully!"
echo "R Analytics Server is ready for use"
echo "Check /var/log/bootstrap.log for detailed logs"
