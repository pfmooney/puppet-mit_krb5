# == Define: mit_krb5::realm
#
# Add a Kerberos realm to krb5.conf
#
# === Parameters
#
# [*kdc*]
#   The value of this relation is the name of a host running a KDC for that
#   realm.  An optional port number (preceded by a colon) may be appended to
#   the hostname.  This tag should generally be used only if the realm
#   administrator has not made the information available through DNS.
#
# [*admin_server*]
#   This relation identifies the host where the administration server is
#   running.  Typically this is the Master Kerberos server.
#
# [*database_module*]
#   This relation indicates the name of the configuration section under
#   dbmodules for database specific parameters used by the loadable database
#   library.
#
# [*default_domain*]
#   This relation identifies the default domain for which hosts in this realm
#   are assumed to be in.  This is needed for translating V4 principal names
#   (which do not contain a domain name) to V5 principal names (which do).
#
# [*v4_instance_convert*]
#   This subsection allows the administrator to configure exceptions to the
#   default_domain mapping rule.  It contains V4 instances (the tag name) which
#   should be translated to some specific hostname (the tag value) as the
#   second component in a Kerberos V5 principal name.
#
# [*v4_realm*]
#   This relation is used by the krb524 library routines when converting a V5
#   principal name to a V4 principal name.  It is used when V4 realm name and
#   the V5 realm are not the same, but still share the same principal names and
#   passwords. The tag value is the Kerberos V4 realm name.
#
# [*auth_to_local_names*]
#   This subsection allows you to set explicit mappings from principal names to
#   local user names.  The tag is the mapping name, and the value is the
#   corresponding local user name.
#
# [*auth_to_local*]
#   This tag allows you to set a general rule for mapping principal names to
#   local user names.  It will be used if there is not an explicit mapping for
#   the principal name that is being translated.  The possible values are:
#
# [*pkinit_anchors*]
#   This relation allows you set the path of a certificate authority file. 
#
#   DB:<filename>
#       The principal will be looked up in the database <filename>.  Support
#       for this is not currently compiled in by default.
#   RULE:<exp>
#       The local name will be formulated from <exp>.
#   DEFAULT
#       The principal name will be used as the local name.  If the principal
#       has more than one component or is not in the default realm, this rule
#       is not applicable and the conversion will fail.
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
# Copyright 2015 Patrick Mooney.
#
define mit_krb5::realm(
  $kdc                 = '',
  $admin_server        = '',
  $database_module     = '',
  $default_domain      = '',
  $v4_instance_convert = '',
  $v4_realm            = '',
  $auth_to_local_names = '',
  $auth_to_local       = '',
  $pkinit_anchors      = '',
) {
  include mit_krb5
  ensure_resource('concat::fragment', 'mit_krb5::realm_header', {
    target  => $mit_krb5::krb5_conf_path,
    order   => '10realm_header',
    content => "[realms]\n",
  })
  concat::fragment { "mit_krb5::realm::${title}":
    target  => $mit_krb5::krb5_conf_path,
    order   => "11realm_${title}",
    content => template('mit_krb5/realm.erb'),
  }
}
