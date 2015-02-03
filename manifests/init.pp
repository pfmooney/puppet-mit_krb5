# == Class: mit_krb5
#
# Install and configure MIT Kerberos v5 client via krb5.conf.  Parameters
# (except the required default_realm) only will appear in the config if
# specified.  Otherwise they will be omitted, falling upon the defaults of the
# local system.
#
# === Parameters
#
# [*default_realm*]
#   This relation identifies the default realm to be used in a client host's
#   Kerberos activity. (REQUIRED)
#
# [*default_keytab_name*]
#   This relation specifies the default keytab name to be used by application
#   severs such as telnetd and rlogind.
#
# [*default_tgs_enctypes*]
#   This relation identifies the supported list of session key encryption types
#   that should be returned by the KDC. (Required type: array)
#
# [*default_tkt_enctypes*]
#   This relation identifies the supported list of session key encryption types
#   that should be requested by the client. (Required type: array)
#
# [*permitted_enctypes*]
#   This relation identifies the permitted list of session key encryption
#   types. (Required type: array)
#
# [*allow_weak_crypto*]
#   If this is set to 0 (for false), then weak encryption types will be
#   filtered out of the previous three lists.  The default value for this tag
#   is false, which may cause authentication failures in existing Kerberos
#   infrastructures that do not support strong crypto.  Users in affected
#   environments should set this tag to true until their infrastructure adopts
#   stronger ciphers.
#
# [*clockskew*]
#   This relation sets the maximum allowable amount of clockskew in seconds
#   that the library will tolerate before assuming that a Kerberos message is
#   invalid.
#
# [*ignore_acceptor_hostname*]
#   When accepting GSSAPI or krb5 security contexts for host-based service
#   principals, ignore any hostname passed by the calling application and allow
#   any service principal present in the keytab which matches the service name
#   and realm name (if given).  This option can improve the administrative
#   flexibility of server applications on multi- homed hosts, but can
#   compromise the security of virtual hosting environments.
#
# [*k5login_authoritative*]
#   If the value of this relation is true (the default), principals must be
#   listed in a local user's k5login file to be granted login access, if a
#   k5login file exists.  If the value of this relation is false, a principal
#   may still be granted login access through other mechanisms even if a
#   k5login file exists but does not list the principal.
#
# [*k5login_directory*]
#   If set, the library will look for a local user's k5login file within the
#   named directory, with a filename corresponding to the local username.  If
#   not set, the library will look for k5login files in the user's home
#   directory, with the filename .k5login.  For security reasons, k5login files
#   must be owned by the local user or by root.
#
# [*kdc_timesync*]
#   If the value of this relation is non-zero, the library will compute the
#   difference between the system clock and the time returned by the KDC and in
#   order to correct for an inaccurate system clock.  This corrective factor is
#   only used by the Kerberos library.
#
# [*kdc_req_checksum_type*]
#   For compatibility with DCE security servers which do not support the
#   default CKSUMTYPE_RSA_MD5 used by this version of Kerberos.  Use a value of
#   2 to use the CKSUMTYPE_RSA_MD4 instead. This applies to DCE 1.1 and
#   earlier.  This value is only used for DES keys; other keys use the
#   preferred checksum type for those keys.
#
# [*ap_req_checksum_type*]
#   If set this variable controls what ap-req checksum will be used in
#   authenticators.  This variable should be unset so the appropriate checksum
#   for the encryption key in use will be used.  This can be set if backward
#   compatibility requires a specific checksum type.
#
# [*safe_checksum_type*]
#   This allows you to set the preferred keyed-checksum type for use in
#   KRB_SAFE messages.  The default value for this type is
#   CKSUMTYPE_RSA_MD5_DES.  For compatibility with applications linked against
#   DCE version 1.1 or earlier Kerberos libraries, use a value of 3 to use the
#   CKSUMTYPE_RSA_MD4_DES instead.  This field is ignored when its value is
#   incompatible with the session key type.
#
# [*preferred_preauth_types*]
#   This allows you to set the preferred preauthentication types which the
#   client will attempt before others which may be advertised by a KDC.  The
#   default value for this setting is "17, 16, 15, 14", which forces libkrb5 to
#   attempt to use PKINIT if it is supported.
#
# [*ccache_type*]
#   User this parameter on systems which are DCE clients, to specify the type
#   of cache to be created by kinit, or hen forwarded tickets are received. DCE
#   and Kerberos can share the cache, but some versions of DCE do not suport
#   the default cache as created by this version of Kerberos. Use a value of 1
#   on DCE 1.0.3a systems, and a alue of 2 on DCE 1.1 systems.
#
# [*dns_lookup_kdc*]
#   Indicate whether DNS SRV records should be used to locate the KDCs and
#   other servers for a realm, if they are not listed in the information for
#   the realm.
#
# [*dns_lookup_realm*]
#   Indicate whether DNS TXT records should be used to determine the Kerberos
#   realm of a host.
#
# [*dns_fallback*]
#   General flag controlling the use of DNS for Kerberos information.  If both
#   of the preceding options are specified, this option has no effect.
#
# [*realm_try_domains*]
#   Indicate whether a host's domain components should be used to determine the
#   Kerberos realm of the host.  The value of this variable is an integer: -1
#   means not to search, 0 means to try the host's domain itself, 1 means to
#   also try the domain's immediate parent, and so forth.  The library's usual
#   mechanism for locating Kerberos realms is used to determine whether a
#   domain is a valid realm -- which may involve consulting DNS if
#   dns_lookup_kdc is set.
#
# [*extra_addresses*]
#   This allows a computer to use multiple local addresses, in order to allow
#   Kerberos to work in a network that uses NATs. (Required type: array)
#
# [*udp_preference_limit*]
#   When sending a message to the KDC, the library will try using TCP before
#   UDP if the size of the message is above "udp_preference_limit".  If the
#   message is smaller than "udp_preference_limit", then UDP will be tried
#   before TCP.  Regardless of the size, both protocols will be tried if the
#   first attempt fails.
#
# [*verify_ap_req_nofail*]
#   If this flag is set, then an attempt to get initial credentials will fail
#   if the client machine does not have a keytab.
#
# [*ticket_lifetime*]
#   The value of this tag is the default lifetime for initial tickets.
#
# [*renew_lifetime*]
#   The value of this tag is the default renewable lifetime for initial
#   tickets.
#
# [*noaddresses*]
#   Setting this flag causes the initial Kerberos ticket to be addressless.
#
# [*forwardable*]
#   If this flag is set, initial tickets by default will be forwardable.
#
# [*proxiable*]
#   If this flag is set, initial tickets by default will be proxiable.
#
# [*rdns*]
#   If set to false, prevent the use of reverse DNS resolution when translating
#   hostnames into service principal names.  Defaults to true.  Setting this
#   flag to false is more secure, but may force users to exclusively use fully
#   qualified domain names when authenticating to services.
#
# [*plugin_base_dir*]
#   If set, determines the base directory where krb5 plugins are located.  The
#   default value is the "krb5/plugins" subdirectory of the krb5 library
#   directory.
#
# [*krb5_conf_path*]
#   Path to krb5.conf file.  (Default: /etc/krb5.conf)
#
# [*krb5_conf_owner*]
#   File owner for krb5.conf.  (Default: root)
#
# [*krb5_conf_group*]
#   File group for krb5.conf.  (Default: root)
#
# [*krb5_conf_mode*]
#   File mode for krb5.conf.  (Default: 0444)
#
# === Examples
#
#  class { 'mit_krb5':
#    default_realm => 'TEST.COM',
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
class mit_krb5(
  $default_realm            = '',
  $default_keytab_name      = '',
  $default_tgs_enctypes     = [],
  $default_tkt_enctypes     = [],
  $permitted_enctypes       = [],
  $allow_weak_crypto        = '',
  $clockskew                = '',
  $ignore_acceptor_hostname = '',
  $k5login_authoritative    = '',
  $k5login_directory        = '',
  $kdc_timesync             = '',
  $kdc_req_checksum_type    = '',
  $ap_req_checksum_type     = '',
  $safe_checksum_type       = '',
  $preferred_preauth_types  = '',
  $ccache_type              = '',
  $dns_lookup_kdc           = '',
  $dns_lookup_realm         = '',
  $dns_fallback             = '',
  $realm_try_domains        = '',
  $extra_addresses          = [],
  $udp_preference_limit     = '',
  $verify_ap_req_nofail     = '',
  $ticket_lifetime          = '',
  $renew_lifetime           = '',
  $noaddresses              = '',
  $forwardable              = '',
  $proxiable                = '',
  $rdns                     = '',
  $plugin_base_dir          = '',
  $krb5_conf_path           = '/etc/krb5.conf',
  $krb5_conf_owner          = 'root',
  $krb5_conf_group          = 'root',
  $krb5_conf_mode           = '0444',
) {
  # SECTION: Parameter validation {
  validate_string(
    $default_realm,
    $default_keytab_name,
    $clockskew,
    $k5login_directory,
    $kdc_timesync,
    $kdc_req_checksum_type,
    $ap_req_checksum_type,
    $safe_checksum_type,
    $preferred_preauth_types,
    $ccache_type,
    $realm_try_domains,
    $udp_preference_limit,
    $ticket_lifetime,
    $renew_lifetime,
    $plugin_base_dir,
    $krb5_conf_path,
    $krb5_conf_owner,
    $krb5_conf_group,
    $krb5_conf_mode
  )
  # Boolean-type parameters are not type-validated at this time.
  # This allows true/false/'yes'/'no'/'1'/0' to be used.
  #
  # Array-type fields are not validated to allow single items via strings or
  # multiple items via arrays
  if $default_realm == '' {
    fail('default_realm must be set manually or via Hiera')
  }
  # END Parameter validation }

  # SECTION: Resource creation {
  anchor { 'mit_krb5::begin': }
  include mit_krb5::install
  concat { $krb5_conf_path:
    owner  => $krb5_conf_owner,
    group  => $krb5_conf_group,
    mode   => $krb5_conf_mode,
  }
  concat::fragment { 'mit_krb5::libdefaults':
    target  => $krb5_conf_path,
    order   => '01libdefaults',
    content => template('mit_krb5/libdefaults.erb'),
  }
  anchor { 'mit_krb5::end': }
  # END Resource creation }

  # SECTION: Resource ordering {
  Anchor['mit_krb5::begin'] -> Class['mit_krb5::install'] ->
    Concat[$krb5_conf_path] -> Anchor['mit_krb5::end']
  # END Resource ordering }
}
