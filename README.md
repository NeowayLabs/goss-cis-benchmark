goss-cis-benchmark
===

[![Build Status](https://travis-ci.org/NeowayLabs/goss-cis-benchmark.svg?branch=master)](https://travis-ci.org/NeowayLabs/goss-cis-benchmark)

This project validate level 1 for the sections 1, 2, 3, 5 and 6 of Ubuntu CIS Controls Benchmarks with [Goss](https://github.com/aelsabbahy/goss).

Currently supports version 20.04 of Ubuntu Server.

## Items not implemented

### Section 1

  * 1.2.1 Ensure package manager repositories are configured (Manual): not implemented
  * 1.2.2 Ensure GPG keys are configured (Manual): not implemented
  * 1.4.1 Ensure AIDE is installed (Automated) : not implemented
  * 1.4.2 Ensure filesystem integrity is regularly checked (Automated): not implemented
  * 1.5.1 Ensure bootloader password is set (Automated): not implemented
  * 1.5.2 Ensure permissions on bootloader config are configured (Automated): not implemented
  * 1.5.3 Ensure authentication required for single user mode (Automated): not implemented

### Section 2

  * 2.2.1.2 Ensure systemd-timesyncd is configured (Manual): not implemented
  * 2.2.1.4 Ensure ntp is configured (Automated): not implemented
  * 2.4 Ensure nonessential services are removed or masked (Manual): not implemented

### Section 3

  * 3.5.1.1 Ensure Uncomplicated Firewall is installed (Automated): not implemented
  * 3.5.1.2 Ensure iptables-persistent is not installed (Automated): not implemented
  * 3.5.1.3 Ensure ufw service is enabled (Automated): not implemented
  * 3.5.1.4 Ensure loopback traffic is configured (Automated): not implemented
  * 3.5.1.5 Ensure outbound connections are configured (Manual): not implemented
  * 3.5.1.6 Ensure firewall rules exist for all open ports (Manual): not implemented
  * 3.5.1.7 Ensure default deny firewall policy (Automated): not implemented
  * 3.5.2.1 Ensure nftables is installed (Automated): not implemented
  * 3.5.2.2 Ensure Uncomplicated Firewall is not installed or disabled (Automated): not implemented
  * 3.5.2.3 Ensure iptables are flushed (Manual): not implemented
  * 3.5.2.4 Ensure a table exists (Automated): not implemented
  * 3.5.2.5 Ensure base chains exist (Automated): not implemented
  * 3.5.2.6 Ensure loopback traffic is configured (Automated): not implemented
  * 3.5.2.7 Ensure outbound and established connections are configured (Manual): not implemented
  * 3.5.2.8 Ensure default deny firewall policy (Automated): not implemented
  * 3.5.2.9 Ensure nftables service is enabled (Automated): not implemented
  * 3.5.2.10 Ensure nftables rules are permanent (Automated): not implemented
  * 3.5.3.1.1 Ensure iptables packages are installed (Automated): not implemented
  * 3.5.3.1.2 Ensure nftables is not installed (Automated): not implemented
  * 3.5.3.1.3 Ensure Uncomplicated Firewall is not installed or disabled (Automated): not implemented
  * 3.5.3.2.1 Ensure default deny firewall policy (Automated): not implemented
  * 3.5.3.2.2 Ensure loopback traffic is configured (Automated): not implemented
  * 3.5.3.2.4 Ensure firewall rules exist for all open ports (Automated): not implemented
  * 3.5.3.3.1 Ensure IPv6 default deny firewall policy (Automated): not implemented
  * 3.5.3.3.2 Ensure IPv6 loopback traffic is configured (Automated): not implemented
  * 3.5.3.3.3 Ensure IPv6 outbound and established connections are configured (Manual): not implemented
  * 3.5.3.3.4 Ensure IPv6 firewall rules exist for all open ports (Manual): not implemented

### Section 5

  * 5.3.2 Ensure lockout for failed password attempts is configured (Automated) : not implemented
  * 5.3.3 Ensure password reuse is limited (Automated): not implemented
  * 5.3.4 Ensure password hashing algorithm is SHA-512 (Automated): not implemented
  * 5.4.1.4 Ensure inactive password lock is 30 days or less (Automated): not implemented
  * 5.4.1.1 Ensure password expiration is 365 days or less (Automated): not implemented
  * 5.4.1.5 Ensure all users last password change date is in the past (Automated): not implemented
  * 5.4.2 Ensure system accounts are secured (Automated): not implemented
  * 5.4.5 Ensure default user shell timeout is 900 seconds or less (Automated): not implemented
  * 5.6 Ensure access to the su command is restricted (Automated): not implemented
  * 5.5 Ensure root login is restricted to system console (Manual): not implemented
  * 5.6 Ensure access to the su command is restricted (Automated): not implemented

## Requirements

* [Goss](https://github.com/aelsabbahy/goss#installation)
* Bash

## Usage

### Clone this repository

```shell
git clone https://github.com/NeowayLabs/goss-cis-benchmark
```

```shell
cd goss-cis-benchmark
cp -r ./scripts/* /tmp
goss --gossfile test_section_01_level1.yml validate
goss --gossfile test_section_02_level1.yml validate
goss --gossfile test_section_03_level1.yml validate
goss --gossfile test_section_05_level1.yml validate
goss --gossfile test_section_06_level1.yml validate
```
