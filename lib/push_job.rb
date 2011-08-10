class PushJob
  @queue = :unfuddle_commits
  
  def self.perform(changeset_xml)
    changeset = Unfuddle::Changeset.new(changeset_xml)
    begin
      commit = Unfuddle.client.commit(changeset.repo, changeset.commit)
      config = UnfuddleServices.load_config(changeset.repo)
      unless config.empty?
        config.each_pair do |service_name, options|
          service = Services.get(service_name, options.symbolize_keys)
          if service.valid?
            service.push(changeset)
          else
            UnfuddleServices.logger.error("[error] Invalid section '#{service_name}' in #{changeset.repo}.yml")
          end  
        end
      end
    rescue UnfuddleServices::ConfigNotFoundError => e
      UnfuddleServices.logger.error("[error] #{e.message}")
    rescue Services::InvalidServiceError => e
      UnfuddleServices.logger.error("[error] Invalid service: #{e.message}")    
    rescue Exception => e
      UnfuddleServices.logger.error("[error] Exception: #{e.inspect}")
    end
  end
end