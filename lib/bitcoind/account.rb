require "memoist"

module Bitcoind
  class Account
    extend Memoist
    attr_accessor :name, :balance

    def initialize(client, name)
      @client = client
      self.name = name
    end

    def inspect
      "#<Bitcoind::Account #{self.name.inspect} >"
    end

    def send_to(destination, amount)
      txn_id = @client.request 'sendfrom', self.name, destination, amount
      Transaction.new @clientm, self, txn_id
    end

    def balance
      @client.request 'getbalance', self.name
    end
    memoize :balance

    def address
      @client.request 'getaccountaddress', self.name
    end
    memoize :address

    def transactions
      txn_array = @client.request 'listtransactions', self.name

      txn_array.map do |h|
        Transaction.new @client, self, h['txid']
      end
    end
  end
end
