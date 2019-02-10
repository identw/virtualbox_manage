require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vboxmanage'))
Puppet::Type.type(:vboxmanage_vm).provide(:vboxmanage, parent: Puppet::Provider::Vboxmanage) do
  desc 'Manage virtualbox vm '
  mk_resource_methods

  def self.instances
    vboxmanage_for_user('vbox', ['list', 'vms']).split("\n").map{|el| el.split(' ')[0].tr('"', '')}.each do |vm|

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
        # Puppet.notice("vboxmanage_vm: remove not manage hostonlyif: #{prov.get('ifname')}")
        # prov.destroy
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
    Puppet.notice('destroy')
  end


  def flush
    # Puppet.notice('flush')
  end

  def self.flush
    Puppet.notice('self flush')
  end

  # Методы которые используются только внутри этого провайдера
end