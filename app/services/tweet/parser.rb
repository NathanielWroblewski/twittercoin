class Tweet::Parser

  attr_accessor :tweet, :sender, :info, :mentions, :amounts

  BOT = "@tippercoin"

  def initialize(tweet, sender)
    @tweet = tweet
    @sender = sender
    @mentions = Tweet::Extractor::Mentions.parse(@tweet)
    @amounts = Tweet::Extractor::Amounts.parse(@tweet)

    @info = {
      recipient: @mentions.first,
      amount: @amounts.first,
      sender: @sender
    }
  end

  def valid?
    return false if direct_tweet?
    return false if !(@info.values & [nil, 0]).empty?
    return false if @sender == BOT

    return true
  end

  def direct_tweet?
    @mentions.first == BOT
  end

  def multiple_recipients?
    @mentions.count > 2 # actual recipient + BOT
  end


end