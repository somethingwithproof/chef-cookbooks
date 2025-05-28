# SNMP Cookbook CHANGELOG

This file is used to list changes made in each version of the snmp cookbook.

## 5.0.0 (2025-05-16)

### Breaking Changes
- Removed legacy attribute file `extendbind.rb` 
- Removed support for EOL platforms (RHEL 5, CentOS 7, etc.)
- Updated minimum Chef version to 18.0
- Set Chef compatibility to Chef 18.x and 19.x only
- Drop support for non-LTS or EOL operating systems 
- Replaced kitchen-docker with kitchen-dokken for testing

### Enhancements
- Added support for modern platforms (Ubuntu 22.04, CentOS Stream 9, AlmaLinux 9)
- Added property descriptions to resources
- Added property validation using Chef 18+ property validation features
- Consolidated platform-specific logic in a helper method
- Updated SNMP default configurations
- Improved templates for better readability and consistency
- Added pre-commit hooks for automated linting
- Updated dependencies to use only supported versions
- Migrated from unmaintained kitchen-docker to kitchen-dokken
- Improved GitHub Actions workflow for testing

## 4.0.0

*BREAKING CHANGE*
* Allow multiple sources and groups
  - Deprecate sources & sources6 keys
  - Added sec_name, sec_name6, groups['v1'], groups['v2c'] keys.

* Added sysName to System contact information section
* snmpd.conf should only be readable to root
* Update various build files 

## 3.0.1

* Missing newline in template, issue #28 reported by @indigo423

## 3.0.0

@atomic-penguin
* Update build files, and rubocopped.

@jhmartin
* removed fqdn fron template.

@CBeerta
* Added `sources` and `sources6` attributes.
* Added ipv6 listener.

Breaking changes:

@glensc
* Change `load_average` from Array of Hashes, to Hash #27

## 2.0.0

@MrMMorris
* Add load average checks.

Breaking changes:

@themoore
* Remove hardcoded extend scripts and is_dnsserver boolean.
* Remove perl dependency.
* Added extend_scripts hash for greater flexibility. #21

## 1.1.0

@slashterix
* Use default level over set #9

@odyssey4me contributed:
* Array `snmp['snmpd']['mibs']` to specify list of MIBs to load #12
* Arrays `snmp['process_monitory']['proc']` and `snmp['process_monitoring']['procfix']
  for monitoring process table and corrective procfix commands. #13
* Attributes `snmp['disman_events']` for SNMP Distributed Management #14

@sfiggins contributed:
* Attributes `snmp['include_all_disks']` (bool),
  `snmp['all_disk_min']` (String for minimum kilobytes/percent free),
  and `snmp['disks']` (Hash of mount points and/or minimum thresholds). #17

* Corrected rubocop warnings.
* Add chefspec/Remove minitest
* Add basic BATS tests
* Add erubis check for templates

## 1.0.0
  
Add snmptrapd recipe, and add RHEL support.
Template debian files.
Add test-kitchen skeleton.
Typos in platform_family case switches.
Check for existence of dmi OHAI attribute, before checking in a condition.
Correct minitest-spec file for Chef 11.x  

## 0.4.0

Add necessary setup for the HP System Management Homepage to be able to poll via @tas50
Add Suse support via @jackl0phty
FC043: Prefer new notification syntax: ./recipes/default.rb:38

## 0.3.1

Fix Gemfile for Travis.

Foodcritic warnings resolved

* FC007: Ensure recipe dependencies are reflected in cookbook metadata

## 0.3.0

Merge pull request #1 from gustavowt/master

* Ubuntu package name fixes

Add [test-kitchen](https://github.com/opscode/test-kitchen) scaffolding

* Simple snmp::default test

Add TravisCI attribute sanity tests, and foodcritic linting.

Foodcritic warnings resolved

* FC001: Use strings in preference to symbols to access node attributes
* FC024: Consider adding platform equivalents

## 0.2.0

Refactor SNMP cookbook

## 0.1.0

* Add Getopt::Declare dependency
* Update metadata
* Update documentation

## 0.0.1

Add snmp cookbook.