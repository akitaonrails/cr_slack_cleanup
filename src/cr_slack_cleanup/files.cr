require "http/client"
require "json"

module CrSlackCleanup
  class FilesResponse
    JSON.mapping({
      ok: {type: Bool},
      files: {type: Array(FilesItemResponse)}
    })
  end

  class FilesItemResponse
    JSON.mapping({
      id: {type: String},
      name: {type: String},
      filetype: {type: String},
      created: {type: Time, converter: Time::EpochConverter}
      timestamp: {type: Time, converter: Time::EpochConverter}
      permalink: {type: String}
    })
  end

  class Files
    getter body

    @http_client : HTTP::Client
    def initialize(@token : String)
      @body = ""
      @http_client = HTTP::Client.new("slack.com", ssl: true).tap do |c|
                       c.connect_timeout = 30.seconds
                       c.dns_timeout = 2.seconds
                       c.read_timeout = 5.minutes
                     end
    end

    def finalize
      @http_client.close
    end

    def fetch! : FilesResponse
      response = @http_client.get("/api/files.list?token=#{@token}")
      @body = response.body || "{}"
      FilesResponse.from_json(@body)
    end
  end
end


