module Bitcoind
  class Client
    def initialize(user, pass, host, port)
      @endpoint = "https://#{user}:#{pass}@#{host}:#{port}"
    end

    def balance
      request 'getbalance'
    end

    def accounts
      balance_hash = request 'listaccounts'
      AccountHash.new self, balance_hash
    end

    def request(method, *args)
      body = { 'id'=>'jsonrpc', 'method'=>method}
      body['params'] = args unless args.empty?
      response_json = RestClient.post @endpoint, body.to_json
      response = JSON.parse response_json
      return response['result']
    end

    def inspect
      "#<Bitcoind::Client #{@endpoint.inspect} >"
    end
  end
end
