# == Class: mit_krb5::loggin
#
# Add logging section to krb5.conf
#
# === Parameters
#
# [*admin_server*]
#   These entries specify how the administrative server is to perform its
#   logging. (Default: FILE:/var/log/kadmind.log)
#
# [*default*]
#   These entries specify how to perform logging in the absence of explicit
#   specifications otherwise.  (Default: FILE:/var/log/krb5libs.log)
#
# [*kdc*]
#   These entries specify how the KDC is to perform its logging.
#   (Default: FILE:/var/log/krb5kdc.log)
#
# === Examples
#
#  class { 'mit_krb5::logging':
#    default      => 'FILE:/custom/krb5libs.log',
#    admin_server => 'FILE:/custom/kadmind.log',
#    kdc          => 'FILE:/custom/krb5kdc.log'
#  }
#
# === Authors
#
# Patrick Mooney <patrick.f.mooney@gmail.com>
#
# === Copyright
#
# Copyright 2013 Patrick Mooney.
#

class mit_krb5::logging(
  $default      = 'FILE:/var/log/krb5libs.log',
  $admin_server = 'FILE:/var/log/kadmind.log',
  $kdc          = 'FILE:/var/log/krb5kdc.log'
) {
  include mit_krb5
  concat::fragment { 'mit_krb5::logging':
    target  => $krb5_conf_path,
    order   => '00logging',
    content => template('mit_krb5/logging.erb'),
  }
}
