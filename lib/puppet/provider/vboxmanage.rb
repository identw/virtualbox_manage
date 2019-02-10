# Puppet provider for mysql
class Puppet::Provider::Vboxmanage < Puppet::Provider
  # Without initvars commands won't work.
  initvars

  # rubocop:disable Style/HashSyntax
  commands :vboxmanage_cmd  => 'vboxmanage'
  commands :su  => 'su'

  confine :operatingsystem => [:debian, :ubuntu]

  defaultfor :operatingsystem => :ubuntu
  # rubocop:enable Style/HashSyntax
  #


  def self.vboxmanage(args)
    vboxmanage_cmd(args)
  end

  def self.vboxmanage_for_user(user, args)
    Puppet::Util::Execution.execute(['vboxmanage'] + args, {uid: user})
  end
end
