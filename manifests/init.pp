# @summary Interface class to manage k3s installation
#
# This class is reponsible to call the install or uninstall classes
#
# @param ensure
#     Ensure if present or absent.
# @param installation_mode
#     Specify if installation should be done via script or if the binary should be used.
# @param binary_version
#     Version of binary to use. (Only required for $installation_mode = 'binary'.)
# @param binary_path
#     Destination path of the binary. (Only required for $installation_mode = 'binary'.)
# @param operation_mode
#     Specify if k3s should be installed as server or agent.
#     (Only for installation_mode = 'script'.)
# @param token
#     Token to use as shared secret to join the cluster. Will be autogenerated if not provided.
#     (Only for installation_mode = 'script'.)
# @param server
#     Server URL of the master node. (Only required for $type = 'agent'.)
#     Format: https://192.168.1.11:6443 or https://k3s-master:6443
#     (Only for installation_mode = 'script'.)
# @param custom_server_args
#     Custom server arguments to use
#     (Only for installation_mode = 'script' and operation_mode = 'server'.)
# @param custom_agent_args
#     Custom agent arguments to use
#     (Only for installation_mode = 'script' and operation_mode = 'agent'.)
#
# @example Standalone server
#   include k3s
#
# @example Server (in server + agent setup)
#   class { 'k3s':
#     token => 's3cret',
#   }
#
# @example Agent (in server + agent setup)
#   class { 'k3s':
#     type   => 'agent',
#     token  => 's3cret',
#     server => 'https://k3s-master:6443'
#   }
#
# @example Binary
#   class { 'k3s':
#     installation_mode => 'binary',
#     binary_path       => '/home/john-doe/bin/k3s',
#   }
class k3s (
  Enum['present', 'absent'] $ensure             = present,
  Enum['script', 'binary']  $installation_mode  = 'script',
  Optional[String]          $binary_version     = 'v1.19.4+k3s1',
  Optional[String]          $binary_path        = '/usr/bin/k3s',
  Enum['server', 'agent']   $operation_mode     = 'server',
  Optional[String]          $token              = undef,
  Optional[String]          $server             = undef,
  String                    $custom_server_args = '',
  String                    $custom_agent_args  = '',
) {
  if $installation_mode == 'binary' and (!$binary_path or !$binary_version) {
    fail('The vars $binary_version and $binary_path must be set when using the \
      binary installation mode.')
  }

  if $ensure == 'present' {
    include k3s::install
  } else {
    include k3s::uninstall
  }
}
