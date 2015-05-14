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
5. [Limitations](#limitations)
6. [License](#license)
7. [Development](#development)


# Overview

This Puppet module is designed to facilitate the installation and configuration
of [MIT Kerberos](http://web.mit.edu/kerberos/).  The primary scope includes
installing the user utilities (kinit, etc) on the system and populating
krb5.conf with the appropriate sections.

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
mit_krb5::domain_realm { 'EXAMPLE.COM':
  domains => ['.example.com', 'example.com']
}
```

# Classes and Resources

The module was structured into resources/classes that resemble the sections of
krb5.conf.

## mit\_krb5

Top-level class that installs MIT Kerberos and controls krb5.conf file.  Class
parameters are used to define contents of \[libdefaults\] section.

### Parameters from libdefaults section

- default\_realm - **Must be set to non-empty**
- default\_keytab\_name
- default\_tgs\_enctypes
- default\_tkt\_enctypes
- permitted\_enctypes
- allow\_weak\_crypto
- clockskew
- ignore\_acceptor\_hostname
- k5login\_authoritative
- k5login\_directory
- kdc\_timesync
- kdc\_req\_checksum\_type
- ap\_req\_checksum\_type
- safe\_checksum\_type
- preferred\_preauth\_types
- ccache\_type
- dns\_lookup\_kdc
- dns\_lookup\_realm
- dns\_fallback
- realm\_try\_domains
- extra\_addresses
- udp\_preference\_limit
- verify\_ap\_req\_nofail
- ticket\_lifetime
- renew\_lifetime
- noaddresses
- forwardable
- proxiable
- rdns
- plugin\_base\_dir

### File parameters

- krb5\_conf\_path - Path to krb5.conf (default: /etc/krb5.conf)
- krb5\_conf\_owner - Owner of krb5.conf (default: root)
- krb5\_conf\_group - Group of krb5.conf (default: root)
- krb5\_conf\_mode - Mode of krb5.conf (default: 0444)

## mit\_krb5::install

Class to install Kerberos client package(s).
This class is included from mit\_krb5.  If you wish to set the packages
parameter, do so before declaring/including mit\_krb5 or use hiera.

### Parameters

- packages - Override facter-derived defaults for Kerberos packages (default: undef)

## mit\_krb5::realm

Resource to add entries to the \[realms\] section.

Realm name is specified by resource title

### Parameters from realm section

- kdc - (arrays allowed)
- admin\_server - (arrays allowed)
- database\_module
- default\_domain
- v4\_instance\_convert
- v4\_realm
- auth\_to\_local\_names
- auth\_to\_local

## mit\_krb5::logging

Class to configure \[logging\] section

### Parameters from logging section

- default - (arrays allowed)
- defaults - Replaces 'default' parameter (for use in Puppet 2.7)
- admin\_server - (arrays allowed)
- kdc - (arrays allowed)

## mit\_krb5::domain\_realm

Resource to add entries to \[domain\_realm\] section.

### Parameters

 - domains - Domains to be mapped into realm - (arrays allowed)
 - realm - Realm to map into - (default: resource title)


# Limitations

Configuration sections other than those listed above are not yet supported.
This includes:

- appdefaults
- capaths
- dbdefaults
- dbmodules
- login
- plugins

Stub classes for those sections exist but will throw an error.


# License

Apache License, Version 2.0


# Development

Please [report issues](https://github.com/pfmooney/puppet-mit_krb5) or
[submit a pull request](https://github.com/pfmooney/puppet-mit_krb5/pulls).
