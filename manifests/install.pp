# == Class: mit_krb5::install
#
# Install MIT Kerberos v5 client.
#
# === Authors
#
# Patrick Mooney <patrick.f.mooney@gmail.com>
#
# === Copyright
#
# Copyright 2013 Patrick Mooney.
#


class mit_krb5::install {
  # FIXME: Write conditional for non-redhat OSes
  $packages = ['krb5-workstation']
  ensure_packages($packages)
}
