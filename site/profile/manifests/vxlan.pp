class profile::vxlan(
  Hash $ospf,
  Hash $vxlan,
) {
  cisco_ospf { $ospf['instance']:
    ensure => present,
  }

  cisco_interface_ospf { "${ospf['interconnect']} ${ospf['instance']}":
    ensure                         => present,
    area                           => $ospf['area']
  }

  cisco_interface_ospf { "loopback0 ${ospf['instance']}":
    ensure                         => present,
    area                           => $ospf['area']
  }

  cisco_interface_ospf { "loopback1 ${ospf['instance']}":
    ensure                         => present,
    area                           => $ospf['area']
  }

  cisco_vlan { $vxlan['access_vlan']:
    ensure         => present,
    mapped_vni     => $vxlan['vni'],
    shutdown       => false,
    state          => 'active',
  }

  cisco_pim { 'ipv4' :
    ensure    => present,
    vrf       => 'default',
    ssm_range => '232.0.0.0/8',
    bfd       => true
  }

  cisco_pim_grouplist { 'ipv4' :
    ensure  => present,
    rp_addr => '3.3.3.3',
    group   => '224.0.0.0/4',
  }

  cisco_command_config { 'pim-anycast':
    command => "
      ip pim anycast-rp 3.3.3.3 1.1.1.1
      ip pim anycast-rp 3.3.3.3 2.2.2.2
    "
  }

  cisco_vxlan_vtep { $vxlan['nve']:
    ensure                          => present,
    description                     => 'Configured By Puppet',
    shutdown                        => false,
    source_interface                => $vxlan['lo'],
  }

  cisco_vxlan_vtep_vni {"${vxlan['nve']} ${vxlan['vni']}":
    ensure              => present,
    multicast_group     => '230.1.1.1',
  }

}