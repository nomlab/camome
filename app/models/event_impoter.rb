require 'rubygems'
require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/file_storage'

class EventImpoter < ActiveRecord::Base
  def initialize
    @client = Google::APIClient.new(:application_name => '')
    authfile = Google::APIClient::FileStorage.new(".authfile")
    unless authfile.authorization.nil?
      @client.authorization = authfile.authorization
    else
      client_secrets = Google::APIClient::ClientSecrets.load("#{Rails.root}/app/models/client_secrets.json")

      flow = Google::APIClient::InstalledAppFlow.new(
                                                     :client_id => client_secrets.client_id,
                                                     :client_secret => client_secrets.client_secret,
                                                     :scope => ['https://www.googleapis.com/auth/calendar']
                                                     )
      @client.authorization = flow.authorize(authfile)
    end
    @client.authorization.fetch_access_token! if @client.authorization.refresh_token && @client.authorization.expired?
    @service = @client.discovered_api('calendar', 'v3')
  end

  def get_event_list
    page_token = nil
    result = @client.execute( :api_method => @service.events.list,
                              :parameters =>
                              {
                                'calendarId' => 'example@gmail.com',
                              }
                              )
    return result.data.items
  end
end
