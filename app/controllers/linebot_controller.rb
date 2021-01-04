class LinebotController < ApplicationController
  require 'line/bot'

  protect_from_forgery :expect => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    @post = Post.offset( rand(Post.count) ).first
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body,signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each{|event|
    
    if event.message['text'].include?("おはよう")
      response = "おはよう"
    elsif event.message["text"].include("こんにちは")
      response = "こんにちは"
    elsif event.message["text"].include("こんばんは")
      response = "こんばんは"
    else
      response = @post.name
    end
  
    case event
    when Line::Bot::Event::message
      case event.type
      when Line::Bot::Event::MessageType::text
        message ={
          type: 'text',
          text: response
        }
        client.reply_message(event['replyToken'],message)
      end
    end
  }

  head :ok
end
end
