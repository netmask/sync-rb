require "paybook/version"
require "httparty"

module Paybook
  class Api
    include HTTParty

    base_uri 'https://sync.paybook.com/v1'

    format :json

    def initialize(api_key)
      @api_key = api_key
    end

    def connect(method, endpoint, params = {})
      params[:api_key] = @api_key

      ap params

      response = if method == :get
                   self.class.get(endpoint, :query => params)
                 elsif method == :post
                   self.class.post(endpoint, :query => params)
                 elsif method == :delete
                   self.class.delete(endpoint, :query => params)
                 else
                   raise StandardError.new('No method found')
                 end

      JSON.parse(response.body)
    end

    def get_sites
      self.connect(:get, '/catalogues/sites')
    end

    def get_countries
      self.connect(:get, '/catalogues/countries')
    end

    def get_site_organizations
      self.connect(:get, 'catalogues/site_organizations')
    end

    def user_list
      self.connect(:get, '/users')
    end

    def create_user(username)
      self.connect(:post, '/users', name: username)
    end

    def delete_user(id_user)
      self.connect(:delete, "/users/#{id_user}")
    end

    def create_session(id_user)
      self.connect(:post, '/sessions', id_user: id_user)
    end

    def validate_session(token)
      self.connect(:get, "/sessions/#{token}/verify")
    end

    def delete_session(token)
      self.connect(:delete, "/sessions/#{token}")
    end

    def register_credentials(id_user, id_site, token, credentials)
      data = {
          id_site: id_site,
          id_user: id_user,
          token: token,
          credentials: credentials
      }

      self.connect(:get, '/credentials', data)
    end

    def get_accounts(id_user, token)
      self.connect(:get, '/accounts', :token => token, id_user: id_user)
    end

    def get_transactions(id_user)
      self.connect(:get, '/transactions', id_user: id_user)
    end

    def get_attachments(token)
      self.connect(:get, '/attachments', token: token)
    end
  end
end
