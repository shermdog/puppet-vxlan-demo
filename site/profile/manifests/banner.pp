class profile::banner (
  String $motd = 'Default from manifest',
) {

  banner { 'default':
    motd => $motd,
  }

}