goss-cis-benchmark
===

[![Build Status](https://travis-ci.org/NeowayLabs/goss-cis-benchmark.svg?branch=master)](https://travis-ci.org/NeowayLabs/goss-cis-benchmark)

This project validate the sections 1, 2, 3, 5 and 6 of Ubuntu CIS Controls Benchmarks with [Goss](https://github.com/aelsabbahy/goss).

Currently supports version 20.04 of Ubuntu Server.

## Requirements

* [Goss](https://github.com/aelsabbahy/goss#installation).
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
