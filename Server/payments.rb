require "sinatra"
require 'braintree'

class Payments < Sinatra::Base

  Braintree::Configuration.environment = :sandbox
  Braintree::Configuration.merchant_id = 'xc4p5dwp2bdcqqqq'
  Braintree::Configuration.public_key = 'y8w3wsj8zgzhxgcn'
  Braintree::Configuration.private_key = 'a2e5245602fa4ab8578f38988b75aeba'


  get '/client_token' do
    content_type :json
    @client_token = Braintree::ClientToken.generate(
        :customer_id => params["customer_id"]
    )
    JSON.pretty_generate({ :client_token => @client_token})
  end

  post '/simple_transaction' do
    content_type :json
    result = Braintree::Transaction.sale(
      :amount => params["price"],
      :payment_method_nonce => params["payment_method_nonce"],
      :customer_id => params["customer_id"],
      :options => {
          :store_in_vault_on_success => true
      }
    )
    if result.success?
      puts JSON.pretty_generate(self.to_json(result.transaction))
      JSON.pretty_generate(self.to_json(result.transaction))
    else
      puts JSON.pretty_generate ({ :message => result.message})
      JSON.pretty_generate ({ :message => result.message})
    end

  end

  def to_json(convertObject)
    hash = {}
    convertObject.instance_variables.each do |var|
        hash[var] = convertObject.instance_variable_get var
    end
    hash
  end

end

run Payments.run!