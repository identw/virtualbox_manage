require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vboxmanage'))
Puppet::Type.type(:vboxmanage_hostonlyif).provide(:vboxmanage, parent: Puppet::Provider::Vboxmanage) do
  desc 'Manage virtualbox hostonly networks'
  mk_resource_methods

  def self.instances
    hostonly_networks = vboxmanage(['list', 'hostonlyifs']).split("\n\n").map do |hostonly_network|
      ifname      = hostonly_network.split("\n").grep(/^Name:/)[0].split(/:\s+/)[1]
      dhcp        = hostonly_network.split("\n").grep(/^DHCP:/)[0].split(/:\s+/)[1]
      ip          = hostonly_network.split("\n").grep(/^IPAddress:/)[0].split(/:\s+/)[1]
      netmask     = hostonly_network.split("\n").grep(/^NetworkMask:/)[0].split(/:\s+/)[1]
      status      = hostonly_network.split("\n").grep(/^Status:/)[0].split(/:\s+/)[1]
      mac_address = hostonly_network.split("\n").grep(/^HardwareAddress:/)[0].split(/:\s+/)[1]
      new(name: ip,
          ifname: ifname,
          ensure: :present,
          netmask: netmask)
    end

  end

  def self.prefetch(resources)
    # Стандартный метод провайдера puppet. Puppet его вызывает всегда при apply (puppet agent -t).
    # В resources - попадают все ресурсы созданные на сервере с помощью типа, для которого создан этот провадейр
    # На этам этапе puppet автоматически заполняет @property_hash, для текущего ресурса
    instances = self.instances
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      else
        Puppet.notice("Vboxmanage_hostonlyif: remove not manage hostonlyif: #{prov.get('ifname')}")
        prov.destroy
      end
    end
  end


  def exists?
    @property_hash[:ensure] == :present || false
  end

  def create
    netmask   = @resource[:netmask]
    ip        = @resource[:name]
    ifname = self.class.vboxmanage(['hostonlyif', 'create']).split("\n").last.split(' ')[1].tr("'", '')
    self.class.vboxmanage(['hostonlyif', 'ipconfig', ifname, '--ip', ip, '--netmask', netmask])

    @property_hash[:ensure]  = :present
    @property_hash[:netmask] = netmask
    @property_hash[:name]    = ip
    @property_hash[:ifname]  = ifname
  end

  def destroy
    ifname = @property_hash[:ifname]
    self.class.vboxmanage(['hostonlyif', 'remove', ifname])
    @property_hash[:ensure] = :absent
    @property_hash.clear
    exists? ? (return false) : (return true)
  end

  def netmask=(value)
    ifname    = @property_hash[:ifname]
    ip        = @resource[:name]
    self.class.vboxmanage(['hostonlyif', 'ipconfig', ifname, '--ip', ip, '--netmask', value])
    @property_hash[:netmask] = value
    (netmask == value) ? (return true) : (return false)
  end


  def flush
    # Puppet.notice('flush')
  end

  def self.flush
    Puppet.notice('self flush')
  end

  # Методы которые используются только внутри этого провайдера
end