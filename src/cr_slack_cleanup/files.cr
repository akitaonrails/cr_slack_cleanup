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

    def initialize(@token : String)
      @body = ""
    end

    def fetch! : FilesResponse
      client = HTTP::Client.new("slack.com", ssl: true)
      client.connect_timeout = 30.seconds
      client.dns_timeout = 2.seconds
      client.read_timeout = 5.minutes

      begin
        response = client.get("/api/files.list?token=#{@token}")
        @body = response.body || "{}"
        FilesResponse.from_json(@body)
      ensure
        client.close
      end
    end
  end
end


