require "memoist"

module Bitcoind
  class Transaction
    extend Memoist
    attr_accessor :id, :account
    def initialize(client, account, id)
      @client = client
      self.account = account
      self.id = id
    end

    def detail_hash
      @client.request 'gettransaction', self.id
    end
    memoize :detail_hash

    def inspect
      "#<Bitcoind::Transaction #{id} #{amount} to #{account.name} at #{time}>"
    rescue RestClient::InternalServerError
      "#<Bitcoind::Transaction #{id} UNCONFIRMED>"
    end

    def amount
      detail_hash['amount']
    end

    def confirmations
      detail_hash['confirmations'] rescue 0
    end

    def time
      Time.at detail_hash['time']
    end
    memoize :time

    def confirmed?
      confirmations > 6
    end
  end
end
