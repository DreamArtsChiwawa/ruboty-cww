require 'json'
require 'net/http'
require 'uri'
require 'pp'

module Ruboty
  module Adapters
    class Chiwawa < Base
      env :CHIWAWA_COMPANY_ID, "知話輪から発行されたINSUITEの企業別ID"
      env :CHIWAWA_API_TOKEN, "知話輪管理画面から発行したBOTのAPI利用トークン"
      env :CHIWAWA_VERIFY_TOKEN, "知話輪管理画面から発行したBOTのWebhook検証トークン"
      env :CHIWAWA_BOT_USER_ID, "知話輪管理画面から発行したBOTのユーザID"
      env :CHIWAWA_BOT_USER_NAME, "知話輪管理画面から発行したBOTのユーザ名"
      env :CHIWAWA_GROUP_ID, "BOTが所属するグループID"
      env :CHIWAWA_GROUP_NAME, "BOTが所属するグループ名"

      def run
        init
        listen
      end

      def say(message)
        url = URI.parse(message_endpoint_path)
        req = Net::HTTP::Post.new(url.path, headers)
        req.body = JSON.generate(post_message_data(message))
        https = Net::HTTP.new(url.host, access_port)
        https.use_ssl = true
        res = https.start { |https| https.request(req) }
      end

      private

      def init
        ENV["RUBOTY_NAME"] ||= bot_user_name
        @last_created_at_from = "0"
        @last_fetch_message_ids = []
        set_last_fetch_message_ids(get_messages)
      end

      def listen
        loop do
          listen_group
          sleep(3)
        end
      end

      def get_messages
        url = URI.parse(message_get_path)
        req = Net::HTTP::Get.new(url.request_uri, headers)
        https = Net::HTTP.new(url.host, access_port)
        https.use_ssl = true
        res = https.start { |https| https.request(req) }
        messages = JSON.parse(res.body)["messages"] 
        messages = messages.sort_by { |hash| hash['createdAt'].to_i }
        unless messages.last.nil?
          @last_created_at_from = messages.last["createdAt"]
        end

        return messages
      rescue => e
        puts "Ruboty::Cww::Adapters::Cww.get_messages error[#{e.message}]."
        return []
      end

      def listen_group
        messages = get_messages
        messages.each do |m|
          if m["createdBy"] === bot_user_id
            next
          end
          if @last_fetch_message_ids.include?(m["messageId"])
            next
          end

          # botに送りたい情報を設定
          robot.receive(
            body: m["text"]
          )
        end
        set_last_fetch_message_ids(messages)
      end

      def set_last_fetch_message_ids(messages)
        @last_fetch_message_ids = []
        messages.each do |m|
          @last_fetch_message_ids << m["messageId"]
        end
      end

      def post_message_data(message)
        # メッセージ投稿APIに送りたいJSONを設定
        {
          "text": message[:body]
        }
      end

      def company_id
        ENV["CHIWAWA_COMPANY_ID"]
      end

      def api_token
        ENV["CHIWAWA_API_TOKEN"]
      end

      def verify_token
        ENV["CHIWAWA_VERIFY_TOKEN"]
      end

      def bot_user_id
        ENV["CHIWAWA_BOT_USER_ID"]
      end

      def bot_user_name
        ENV["CHIWAWA_BOT_USER_NAME"]
      end

      def group_id
        ENV["CHIWAWA_GROUP_ID"]
      end

      def group_name
        ENV["CHIWAWA_GROUP_NAME"]
      end

      def message_endpoint_path
        "#{protcol}://#{chiwawa_host}#{public_api_path}/groups/#{group_id}/messages"
      end

      def protcol
        "https"
      end

      def access_port
        "443"
      end

      def chiwawa_host
        "#{company_id}.#{chiwawa_root_domain}"
      end

      def chiwawa_root_domain
        "chiwawa.one"
      end

      def headers
        {
          "X-Chiwawa-API-Token" => api_token,
          "Content-Type" => "application/json"
        }
      end

      def public_api_path
        "/api/public/v1"
      end

      def message_get_path
        "#{message_endpoint_path}?createdAtFrom=#{@last_created_at_from}"
      end
    end
  end
end
