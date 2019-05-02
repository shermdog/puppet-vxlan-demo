class role::vxlan {
  include profile::interfaces
  include profile::vxlan

  Class['profile::interfaces'] -> Class['profile::vxlan']
}
