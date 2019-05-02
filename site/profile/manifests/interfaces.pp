class profile::interfaces(
  Hash $interfaces,
) {
    $interfaces.each | $interface, $params | {
    cisco_interface {  $interface:
      * => $params,
    }
  }
}