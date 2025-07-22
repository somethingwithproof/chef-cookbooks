# Chef Cookbook Docker Testing Guide

All Chef cookbooks have been configured for **isolated Docker testing** using **Dokken** driver for optimal laptop development experience.

## 🐳 Docker Testing Setup

### Prerequisites
```bash
# Install Docker Desktop (macOS)
brew install --cask docker

# Install required gems
gem install test-kitchen kitchen-dokken kitchen-inspec
```

### Quick Test Commands

For any cookbook:
```bash
# Test all platforms and suites
kitchen test

# Test specific platform
kitchen test default-ubuntu-2204

# List available instances  
kitchen list

# Converge without destroying (faster iteration)
kitchen converge
kitchen verify
kitchen destroy
```

## 📋 Docker Configuration Status

### All Cookbooks Use Dokken Driver

| Cookbook | Primary Config | Driver | Chef Version | Platforms |
|----------|----------------|--------|--------------|-----------|
| chef-zabbix-cookbook | .kitchen.yml | dokken | 19 (latest) | Ubuntu, Debian, Rocky, Alma, Amazon |
| chef-hbase-cookbook | .kitchen.yml | dokken | 19 (latest) | Ubuntu, Debian, Alma, Amazon |  
| chef-cookbook-template | .kitchen.yml | dokken | 19 (latest) | Ubuntu, Debian, Rocky, Amazon |
| chef-net-snmp-cookbook | .kitchen.yml | dokken | 19 (latest) | Ubuntu, Debian, Rocky |
| chef-httpd-cookbook | .kitchen.yml | dokken | 19 (latest) | Ubuntu, Debian, Rocky, Amazon |
| chef-nginx-cookbook | .kitchen.yml | dokken | 19 (latest) | Ubuntu, Debian, Rocky, Amazon |
| chef-snmp-cookbook | .kitchen.yml | dokken | 19 (latest) | Ubuntu, Debian, CentOS, Alma |

### Benefits of Dokken

✅ **Fast**: No VM overhead, uses Docker containers  
✅ **Lightweight**: Minimal resource usage on laptops  
✅ **Isolated**: Each test runs in clean container environment  
✅ **Consistent**: Same environment locally and in CI  
✅ **Chef-Optimized**: Built specifically for Chef cookbook testing  

## 🚀 Usage Examples

### Test Single Cookbook
```bash
cd chef-zabbix-cookbook
kitchen test default-ubuntu-2204
```

### Test All Suites
```bash
cd chef-zabbix-cookbook  
kitchen test
# Tests: agent, server-mysql, server-postgresql
```

### Development Workflow
```bash
# Fast iteration cycle
kitchen converge default-ubuntu-2204
# Make code changes...
kitchen converge default-ubuntu-2204  # Re-run Chef
kitchen verify default-ubuntu-2204    # Run tests
kitchen destroy default-ubuntu-2204   # Clean up
```

### Parallel Testing
```bash
# Test multiple platforms simultaneously
kitchen test -c 3  # Run 3 instances in parallel
```

## 🔧 Configuration Details

All cookbooks use this standardized Dokken configuration:

```yaml
driver:
  name: dokken
  privileged: true
  chef_version: latest # Chef 19
  chef_license: accept-no-persist

transport:
  name: dokken

provisioner:
  name: dokken
  chef_license: accept-no-persist
  multiple_converge: 2
  enforce_idempotency: true
  deprecations_as_errors: true

verifier:
  name: inspec
```

## 🐛 Troubleshooting

### Docker Issues
```bash
# Ensure Docker is running
docker ps

# Clean up stopped containers
kitchen destroy
docker system prune -f
```

### Common Commands
```bash
# See what's happening
kitchen diagnose

# Get detailed logs
kitchen verify default-ubuntu-2204 -l debug

# Manual container inspection
docker exec -it kitchen-container-id bash
```

## 🎯 Testing Best Practices

1. **Always test locally** before pushing changes
2. **Use multiple platforms** to catch OS-specific issues  
3. **Run idempotency tests** (multiple converges)
4. **Check InSpec tests** pass consistently
5. **Clean up containers** to avoid conflicts

---

**All cookbooks are now ready for fast, isolated Docker testing on your laptop! 🚀**
