#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with otrs](#setup)
    * [What otrs affects](#what-otrs-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with otrs](#beginning-with-otrs)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module allows you to install and manage an OTRS installation starting from OTRS 5.

## Module Description

The module allows different kinds of installations.

Currently:
* web
* package

## Setup

### What otrs affects

OTRS expects the installation to be performed in **/opt/otrs**

Be sure to make a backup **BEFORE** applying changes.

The module allows to selectively manage certain things like:

* The otrs user
* Apache
* MySQL

Those will be managed out of convenience, but you can choose to manage those yourself.

### Setup Requirements **OPTIONAL**

Depending on which components you want to use, the optional modules are:

* Apache https://github.com/puppetlabs/puppetlabs-apache.git
* MySQL https://github.com/puppetlabs/puppetlabs-mysql.git

### Beginning with otrs

Simple setup

```
include ::otrs
```

## Usage

Web installation using Mysql as a connector

```
class {'otrs':
  installation_type  => 'web',
  database_connector => 'mysql',
}
```

Connecting to a remove Mysql Server

```
class {'otrs':
  database_connector => 'mysql',
  db_host            => 'db.example.com',
  db_name            => 'otrsprod',
  db_user            => 'otrs',
  db_password        => 'plzCr3at3Atick3t',
}
```
Customize options

```
class {'otrs':
  config_hash        => {
    'SystemID'         => '66',
    'FQDN'             => $::fqdn,
    'CustomerHeadline' => 'Frequently asked questions',
    'DefaultLanguage'  => 'en',
    'SecureMode'       => '1',
  }
}
```

## Limitations

* Currently tested on Debian Jessie
* Only web installation tested
