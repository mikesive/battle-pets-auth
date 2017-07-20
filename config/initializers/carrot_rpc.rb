CarrotRpc.configure do |config|
  config.logger = CarrotRpc::TaggedLog.new(logger: Rails.logger, tags: ["Carrot RPC Client"])
end
