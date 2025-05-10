# tcp_wrappers Cookbook CHANGELOG

This file is used to list changes made in each version of the tcp_wrappers cookbook.

## 0.3.0 (UNRELEASED)

- Complete modernization for Chef 16-18
- Resources:
  - Added unified_mode true to resources
  - Updated resource properties with proper descriptions and coercions
  - Added property validation with proper data types
  - Improved resource structure with action_class
  - Removed unnecessary usage of new_resource
  - Used template_path variables for improved readability
  - Enhanced idempotency with correct resource guards
  
- Testing and Quality:
  - Added enforce_idempotency and multiple converge to kitchen
  - Added Chef 16 compatibility mode
  - Added chef_license acceptance to Test Kitchen
  - Updated ChefSpec to SoloRunner for better speed
  - Added explicit platform testing for multiple OS versions
  
- Modern Ruby Practices:
  - Replaced gsub with tr for string manipulation
  - Used string interpolation consistently
  - Extracted repeated directory paths to variables
  - Used idiomatic Ruby throughout the codebase
  
- Attributes and Platform Detection:
  - Added platform-specific package detection via attributes
  - Used value_for_platform helper instead of if/else conditions
  - Enhanced attribute organization with clear sections
  
- Security Improvements:
  - Made template resources sensitive for security
  - Used standard file permissions for configuration files
  
- Supported Platforms:
  - Restricted support to currently maintained OS versions:
    - Ubuntu 20.04+
    - Debian 11+
    - RHEL 8+
    - AlmaLinux 8+
    - Rocky Linux 8+
    - Amazon Linux 2+
    - Fedora 36+
  - Added support for tcpd package on newer Ubuntu (22.04+)
  - Removed support for deprecated platforms

## 0.2.0 (UNRELEASED)

- Initial modernization
- Updated testing structure
- Added Docker-based testing
- Reorganized and simplified code structure
- Expanded test coverage

## 0.1.0

- Initial release
- Basic tcp_wrappers cookbook functionality