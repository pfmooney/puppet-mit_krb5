# puppet-mit\_krb5

#### Table of Contents

1. [Overview](#overview)
2. [Dependencies](#dependencies)
3. [Examples](#examples)
4. [Classes and Resources](#classes-and-resources)
    - [mit\_krb5](#mit_krb5)
    - [mit\_krb5::install](#mit_krb5install)
    - [mit\_krb5::realm](#mit_krb5realm)
    - [mit\_krb5::logging](#mit_krb5logging)
    - [mit\_krb5::domain\_realm](#mit_krb5domain_realm)
    - [mit\_krb5::appdefaults](#mit_krb5appdefaults)
5. [Limitations](#limitations)
6. [License](#license)
7. [Development](#development)


# Overview

This Puppet module is designed to facilitate the installation and configuration of [MIT Kerberos](http://web.mit.edu/kerberos/).  The primary scope includes installing the user utilities (kinit, etc) on the system and populating krb5.conf with the appropriate sections.

Other tasks such as setting up KDC services are **not covered**.


## Dependencies

- [puppetlabs/stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)
- [puppetlabs/concat](https://github.com/puppetlabs/puppetlabs-concat)


# Examples

```puppet
class { 'mit_krb5':
  default_realm      => 'INSECURE.LOCAL',
  permitted_enctypes => ['des-cbc-crc', 'des-cbc-md5'],
  allow_weak_crypto  => true
}
class { 'mit_krb5::logging':
  default => ['FILE:/var/log/krb5libs.log', 'SYSLOG']
}
mit_krb5::realm { 'INSECURE.LOCAL':
  kdc          => ['kdc1.insecure.local', 'kdc2.insecure.local'],
  admin_server => 'kpasswd.insecure.local',
}
mit_krb5::domain_realm { 'INSECURE.LOCAL':
  domains => ['insecure.local', '.insecure.local']
}
```

Yields the following krb5.conf:
```
[logging]
    default = FILE:/var/log/krb5libs.log
    default = SYSLOG

[libdefaults]
    default_realm = INSECURE.LOCAL
    permitted_enctypes = des-cbc-crc des-cbc-md5
    allow_weak_crypto = true

[realms]
    INSECURE.LOCAL = {
        kdc = kdc1.insecure.local
        kdc = kdc2.insecure.local
        admin_server = kpasswd.insecure.local
    }

[domain_realm]
    insecure.local = INSECURE.LOCAL
    .insecure.local = INSECURE.LOCAL
```

Code such at this would mimic the example file shipped with CentOS/RHEL:
```puppet
class { 'mit_krb5::install': }
class { 'mit_krb5':
  default_realm    => 'EXAMPLE.COM',
  dns_lookup_realm => false,
  dns_lookup_kdc   => false,
  ticket_lifetime  => '24h',
  renew_lifetime   => '7d',
  forwardable      => true,
}
class { 'mit_krb5::logging':
  default      => 'FILE:/var/log/krb5libs.log',
  kdc          => 'FILE:/var/log/krb5kdc.log',
  admin_server => 'FILE:/var/log/kadmind.log'
}
mit_krb5::realm { 'EXAMPLE.COM':
  kdc          => 'kerberos.example.com',
  admin_server => 'kerberos.example.com'
}
mit_krb5::domain_realm { 'INSECURE.LOCAL':
  domains => ['.example.com', 'example.com']
}
```

# Classes and Resources

The module was structured into resources/classes that resemble the sections of krb5.conf.

## mit\_krb5

Top-level class that installs MIT Kerberos and controls krb5.conf file.  Class parameters are used to define contents of \[libdefaults\] section.

### Parameters from libdefaults section

- `default_realm` - **Must be set to non-empty**
- `default_keytab_name`
- `default_tgs_enctypes`
- `default_tkt_enctypes`
- `permitted_enctypes`
- `allow_weak_crypto`
- `clockskew`
- `ignore_acceptor_hostname`
- `k5login_authoritative`
- `k5login_directory`
- `kdc_timesync`
- `kdc_req_checksum_type`
- `ap_req_checksum_type`
- `safe_checksum_type`
- `preferred_preauth_types`
- `ccache_type`
- `dns_lookup_kdc`
- `dns_lookup_realm`
- `dns_fallback`
- `realm_try_domains`
- `extra_addresses`
- `udp_preference_limit`
- `verify_ap_req_nofail`
- `ticket_lifetime`
- `renew_lifetime`
- `noaddresses`
- `forwardable`
- `proxiable`
- `rdns`
- `plugin_base_dir`

### File parameters

- `krb5_conf_path` - Path to krb5.conf (default: /etc/krb5.conf)
- `krb5_conf_owner` - Owner of krb5.conf (default: root)
- `krb5_conf_group` - Group of krb5.conf (default: root)
- `krb5_conf_mode` - Mode of krb5.conf (default: 0444) 

## System parameters

- `alter_etc_services` - Should _kerberos_ udp and tcp entries be managed in `/etc/services` (default: `false`)

## mit\_krb5::install

Class to install Kerberos client package(s).
This class is included from mit\_krb5.  If you wish to set the packages
parameter, do so before declaring/including mit\_krb5 or use hiera.

### Parameters

- `packages` - Override facter-derived defaults for Kerberos packages (default: undef) 

## mit\_krb5::realm

Resource to add entries to the `[realms]` section.

Realm name is specified by resource title

### Parameters from realm section

- `kdc` - (arrays allowed)
- `admin_server` - (arrays allowed)
- `database_module`
- `default_domain`
- `v4_instance_convert`
- `v4_name converts`
- `v4_realm`
- `auth_to_local_names`
- `auth_to_local`

## mit\_krb5::logging

Class to configure `[logging]` section 

### Parameters from logging section

- `default` - (arrays allowed)
- `defaults` - Replaces `default` parameter (for use in Puppet 2.7)
- `admin_server` - (arrays allowed)
- `kdc` - (arrays allowed)

## mit\_krb5::domain\_realm

Resource to add entries to `[domain_realm]` section.

### Parameters

 - `domains` - Domains to be mapped into realm - (arrays allowed)
 - `realm` - Realm to map into - (default: resource title)

## mit\_krb5::appdefaults

Resource to add entries to `[appdefaults]` section.

Currently, this module only supports this format of _appdefaults_:

```
application = {
    option1 = value
    option2 = value
}
```

or 

```
realm = {
    option = value
}
```

### Parameters

 - `debug`
 - `ticket_lifetime`
 - `renew_lifetime`
 - `forwardable`
 - `krb4_convert`
 - `ignore_afs`

### Example

The following `appdefaults` section

```
[appdefaults]
    EXAMPLE.ORG = {
        forwardable = false
    }
```

could be obtained with

```puppet
::mit_krb5::appdefaults { 'EXAMPLE.ORG':
    forwardable => false
}
```

# Limitations

Configuration sections other than those listed above are not yet supported.
This includes:

- `capaths`
- `dbdefaults`
- `dbmodules`
- `login`
- `plugins`

Stub classes for those sections exist but will throw an error.


# License

Apache License, Version 2.0

# Contributors

This module was initially created by Patrick Mooney (@pfmooney) and forked by CC-IN2P3 in Oct. 2014.

# Development

Please [report issues](https://github.com/ccin2p3/puppet-mit_krb5/issues) or [submit a pull request](https://github.com/ccin2p3/puppet-mit_krb5/pulls).
