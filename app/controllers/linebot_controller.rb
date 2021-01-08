class LinebotController < ApplicationController
  require 'line/bot'

  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)

    events.each { |event|
      if event.message['text'] != nil
        keyword = event.message['text']
        result = `curl -X GET https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706?format=json&keyword=#{keyword}&applicationId=ENV['RAKUTEN_APP_ID']`
      end

      hash_result = JSON.parse result
      items = hash_result["rest"]
      item = items.name

      url = item['itemUrl']
      item_name = item['itemName']
      item_price = item['itemPrice']

      response = "【商品名】" + item_name + "\n" + "【価格】" + item_price + url
        case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: response
          }
          client.reply_message(event['replayToken'], message)
        end
      end
    }
    head :ok
  end
end

  