# == Define: mit_krb5::realm
#
# Add a Kerberos realm to krb5.conf
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  mit_krb5::realm { 'TEST.COM':
#    kdc            => [ 'kdc1.test.com', 'kdc2.test.com' ],
#    kpasswd_server => 'kpasswd.test.com',
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
define mit_krb5::realm() {
  include mit_krb5
  concat::fragment { "mit_krb5::realm::${title}":
    target  => $mit_krb5::krb5_conf_path,
    order   => "10realm::${title}",
    content => template('mit_krb5/realm.erb'),
  }
}
