Puppet::Type.newtype(:vboxmanage_hostonlyif) do
  @doc = 'vboxmanage_hostonlyif'

  ipv4_regex = /\A([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])){3}\z/
  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    desc 'bridge ip address'
    validate do |value|
      unless value =~ ipv4_regex
        raise ArgumentError, "%s is not ipv4 address" % value
      end
    end
    defaultto '192.168.56.1'
  end

  newproperty(:netmask) do
    desc 'netmask'
    validate do |value|
      unless value =~ ipv4_regex
        raise ArgumentError, "%s is not ipv4 address" % value
      end
    end
    defaultto '255.255.255.0'
  end
end