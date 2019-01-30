require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vboxmanage'))
Puppet::Type.type(:vboxmanage_hostonlyif).provide(:vboxmanage, parent: Puppet::Provider::Vboxmanage) do
  desc 'Manage virtualbox hostonly networks'
  mk_resource_methods

  def self.instances
    hostonly_networks = vboxmanage(['list', 'hostonlyifs']).split("\n\n").map do |hostonly_network|
      name        = hostonly_network.split("\n").grep(/^Name:/)[0].split(/:\s+/)[1]
      dhcp        = hostonly_network.split("\n").grep(/^DHCP:/)[0].split(/:\s+/)[1]
      ip          = hostonly_network.split("\n").grep(/^IPAddress:/)[0].split(/:\s+/)[1]
      netmask     = hostonly_network.split("\n").grep(/^NetworkMask:/)[0].split(/:\s+/)[1]
      status      = hostonly_network.split("\n").grep(/^Status:/)[0].split(/:\s+/)[1]
      mac_address = hostonly_network.split("\n").grep(/^HardwareAddress:/)[0].split(/:\s+/)[1]
      new(name: name,
          ensure: :present,
          ip: ip,
          netmask: netmask)
    end
  end

  def self.prefetch(resources)
    # Стандартный метод провайдера puppet. Puppet его вызывает всегда при apply (puppet agent -t).
    # В resources - попадают все ресурсы созданные на сервере с помощью типа, для которого создан этот провадейр
    # На этам этапе puppet автоматически заполняет @property_hash, для текущего ресурса
    instances = self.instances
    a = {}
    instances.map do |prov|
      if a[prov.ip]
        a[prov.ip][:count] += 1
      else
        a[prov.ip] = {}
        a[prov.ip][:name] = prov.name
        a[prov.ip][:count] = 1
      end
    end
    a.each do |ip, ip_props|
      if ip_props[:count] > 1
        puts "#{ip} - wrong"
      end
    end
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present || false
  end

  def create
    Puppet.notice('create')
  end

  def destroy
    Puppet.notice('desroy')
  end

end