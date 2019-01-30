# Puppet provider for mysql
class Puppet::Provider::Vboxmanage < Puppet::Provider
  # Without initvars commands won't work.
  initvars

  # rubocop:disable Style/HashSyntax
  commands :vboxmanage_cmd  => 'vboxmanage'

  confine :operatingsystem => [:debian, :ubuntu]

  defaultfor :operatingsystem => :ubuntu
  # rubocop:enable Style/HashSyntax

  def self.vboxmanage(args)
    vboxmanage_cmd(args)
  end
end
