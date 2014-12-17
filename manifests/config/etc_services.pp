#
class mit_krb5::config::etc_services {

	$port = 88
	$comment = 'Kerberos v5'

	augeas { 'kerberos_etc_services_tcp':
		context => '/files/etc/services',
		changes => [
			'defnode kerberostcp service-name[.="kerberos"][protocol = "tcp"] kerberos',
			"set \$kerberostcp/port ${port}",
			'set $kerberostcp/protocol tcp',
			'remove $kerberostcp/alias',
			'remove $kerberostcp/#comment',
			'set $kerberostcp/alias[1] kerberos5',
			'set $kerberostcp/alias[2] krb5',
			'set $kerberostcp/alias[3] kerberos-sec',
			"set \$kerberostcp/#comment '${comment}'",
		]
	}

	augeas { 'kerberos_etc_services_udp':
		context => '/files/etc/services',
		changes => [
			'defnode kerberosudp service-name[.="kerberos"][protocol = "udp"] kerberos',
			"set \$kerberosudp/port ${port}",
			'set $kerberosudp/protocol udp',
			'remove $kerberosudp/alias',
			'remove $kerberosudp/#comment',
			'set $kerberosudp/alias[1] kerberos5',
			'set $kerberosudp/alias[2] krb5',
			'set $kerberosudp/alias[3] kerberos-sec',
			"set \$kerberosudp/#comment '${comment}'",
		]
	}

}

# vim: tabstop=4 shiftwidth=4 softtabstop=4
