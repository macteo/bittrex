module Bittrex
  class Limit
    include Helpers
    attr_reader :uuid

    def initialize(attrs = {})
      @uuid = attrs['uuid']
    end

    # Bittrex::Limit.buy('BTC-BCC', 0.0001, 0.0001)
    def self.buy(market, quantity, rate)
      d = client.get('market/buylimit', market: market.downcase, quantity: quantity, rate: rate)
      return new(d) if d
      nil
    end

    # Bittrex::Limit.sell('BTC-BCC', 0.0001, 0.0001)
    def self.sell(market, quantity, rate)
      d = client.get('market/selllimit', market: market.downcase, quantity: quantity, rate: rate)
      return new(d) if d
      nil
    end

    def self.cancel(_uuid)
      client.get('market/cancel').map { |data| new(data) }
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end
