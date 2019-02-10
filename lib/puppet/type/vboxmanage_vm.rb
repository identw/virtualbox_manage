Puppet::Type.newtype(:vboxmanage_vm) do
  @doc = 'vboxmanage_vm'

  ipv4_regex = /\A([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])){3}\z/
  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    desc 'Virtual machine name'
    defaultto 'vm_default'
  end

  newparam(:user) do
    desc 'Virtuablbox host user'
    defaultto 'vbox'
  end

end