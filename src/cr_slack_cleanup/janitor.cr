require "http/client"
require "json"

module CrSlackCleanup
  class Janitor
    def initialize(@domain : String, @token : String, files_response : CrSlackCleanup::FilesResponse)
      @files = ( files_response.try &.files ) as Array(FilesItemResponse)
    end

    def cleanup!
      channel = Channel(Tuple(Symbol, String)).new

      counter = 0
      @files.each do |item|
        counter += 1
        spawn delete( item.id, item.permalink, channel )
      end

      counter.times do
        result = channel.receive
        case result[0]
        when :ok
          puts "Successfully deleted file #{result[1]}"
        else
          puts "Error deleting file #{result[1]}"
        end
      end
    end

    private def open_client
      HTTP::Client.new("#{@domain}.slack.com", ssl: true).tap do |c|
        c.connect_timeout = 15.seconds
        c.dns_timeout = 5.seconds
        c.read_timeout = 3.minutes
      end
    end

    private def delete(item_id, item_permalink, channel)
      http_client = open_client
      response = http_client.post("/api/files.delete?token=#{@token}&file=#{item_id}")
      if response.status_code == 200
        body = response.body || ""
        if body =~ /\"ok\"\:true/
          channel.send({:ok, item_permalink})
          return
        end
      end
      channel.send({:error, item_permalink})
    rescue IO::Timeout
      sleep 1
      delete item_id, item_permalink, channel
    ensure
      http_client.try &.close
    end
  end
end
