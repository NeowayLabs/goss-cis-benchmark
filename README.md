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
cp -r ./scripts/test_section_06_level1 /tmp
goss --gossfile test_section_01_level1.yml validate
goss --gossfile test_section_02_level1.yml validate
goss --gossfile test_section_03_level1.yml validate
goss --gossfile test_section_05_level1.yml validate
goss --gossfile test_section_06_level1.yml validate
```
