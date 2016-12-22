rails_root_dir = File.expand_path(::Rails.root.to_s)

require "#{rails_root_dir}/lib/caldav/caldav.rb"
# require "#{rails_root_dir}/lib/rgb.rb"
require 'nokogiri'
require 'uri'

class Calendar < ActiveRecord::Base
  has_many :events, dependent: :destroy
  belongs_to :user
  belongs_to :calendar_provider
  has_one :auth_info, as: :parent,
  class_name: "CalendarAuthInfo", dependent: :destroy

  def self.already_impored_url?(url)
    !AuthInfo.where(["url = ? AND parent_type = ? AND parent_id = ?", url, "Calendar", User.current.id]).empty?
  end

  def self.create_from_params(params)
    calendars     = params["calendars"]
    displaynames  = params["displayname"]
    urls          = params["url"]
    colors        = params["color"]
    descriptions  = params["description"]
    sync_channels = []

    success_cals  = []

    calendars.each do |num, url|
      url =~ /\/([^\/]+%40.+?)\//
      ab_name = $1

      calendar = Calendar.new({
        :displayname => displaynames["#{num}"],
        :color       => colors["#{num}"],
        :description => descriptions["#{num}"],
        :user_id     => User.current.id
      })

      auth_info = CalendarAuthInfo.new(
        :login_name => params["username"],
        :url => url
      )
      auth_info.decrypted_pass = params["userpass"]
      auth_info = KeyVault.lock(auth_info, User.current)
      calendar.auth_info = auth_info

      ei = EventImpoter.new(calendar.auth_info.url,
                            calendar.auth_info.login_name,
                            KeyVault.unlock(auth_info, User.current).decrypted_pass)
      events = ei.import
      events.each do |e|
        e.calendar = calendar
        e.save
      end

      success_cals << calendar if calendar.save
    end
    return success_cals
  end



  def self.all_calendar_list(username, userpass)

    url = "https://calendar.google.com/calendar/dav/" + username
    if username.index("@")
      url += "/"
    else
      url += "%40gmail.com/"
    end

    my_calendar_list = fetch_my_calendar_list(url, username, userpass)

    url = "https://www.google.com/calendar/dav/" + username
    if username.index("@")
      url += "/"
    else
      url += "%40gmail.com/"
    end
    url += "user/"
    commissioned_calendar_list =
      fetch_commissioned_calendar_list(url, username, userpass)
    return [my_calendar_list, commissioned_calendar_list]

  end



  def self.fetch_my_calendar_list(url, username, userpass)
    origin_dav = CalDAV.new(url)
    origin_dav.set_basic_auth(username, userpass)

    depth = 1
    split_url = URI.split(url)
    host_url = split_url[0] + "://" + split_url[2]

    body = <<-EOF_BODY
<?xml version="1.0" encoding="UTF-8"?>
 <A:propfind xmlns:A="DAV:">
  <A:prop>
   <A:add-member/>
   <C:allowed-sharing-modes xmlns:C="http://calendarserver.org/ns/"/>
   <D:autoprovisioned xmlns:D="http://apple.com/ns/ical/"/>
   <E:bulk-requests xmlns:E="http://me.com/_namespace/"/>
   <D:calendar-color xmlns:D="http://apple.com/ns/ical/"/>
   <B:calendar-description xmlns:B="urn:ietf:params:xml:ns:caldav"/>
   <B:calendar-free-busy-set xmlns:B="urn:ietf:params:xml:ns:caldav"/>
   <D:calendar-order xmlns:D="http://apple.com/ns/ical/"/>
   <B:calendar-timezone xmlns:B="urn:ietf:params:xml:ns:caldav"/>
   <A:current-user-privilege-set/>
   <B:default-alarm-vevent-date xmlns:B="urn:ietf:params:xml:ns:caldav"/>
   <B:default-alarm-vevent-datetime xmlns:B="urn:ietf:params:xml:ns:caldav"/>
   <A:displayname/>
   <C:getctag xmlns:C="http://calendarserver.org/ns/"/>
   <D:language-code xmlns:D="http://apple.com/ns/ical/"/>
   <D:location-code xmlns:D="http://apple.com/ns/ical/"/>
   <A:owner/>
   <C:pre-publish-url xmlns:C="http://calendarserver.org/ns/"/>
   <C:publish-url xmlns:C="http://calendarserver.org/ns/"/>
   <C:push-transports xmlns:C="http://calendarserver.org/ns/"/>
   <C:pushkey xmlns:C="http://calendarserver.org/ns/"/>
   <A:quota-available-bytes/>
   <A:quota-used-bytes/>
   <D:refreshrate xmlns:D="http://apple.com/ns/ical/"/>
   <A:resource-id/>
   <A:resourcetype/>
   <B:schedule-calendar-transp xmlns:B="urn:ietf:params:xml:ns:caldav"/>
   <B:schedule-default-calendar-URL xmlns:B="urn:ietf:params:xml:ns:caldav"/>
   <C:source xmlns:C="http://calendarserver.org/ns/"/>
   <C:subscribed-strip-alarms xmlns:C="http://calendarserver.org/ns/"/>
   <C:subscribed-strip-attachments xmlns:C="http://calendarserver.org/ns/"/>
   <C:subscribed-strip-todos xmlns:C="http://calendarserver.org/ns/"/>
   <B:supported-calendar-component-set xmlns:B="urn:ietf:params:xml:ns:caldav"/>
   <B:supported-calendar-component-sets xmlns:B="urn:ietf:params:xml:ns:caldav"/>
   <A:supported-report-set/>
   <A:sync-token/>
  </A:prop>
 </A:propfind>
EOF_BODY
    res = origin_dav.propfind(url, depth, body)
    return [] if (res.code.to_i / 200) != 1

    xml = Nokogiri::XML(res.body).remove_namespaces!
    blocks = xml.xpath('//multistatus/response')

    calendars = []
    blocks.each do |block|
      if block.xpath('propstat/prop/calendar-color')[0].content != ""
        href = block.xpath('href')[0].content
        displayname = block.xpath('propstat/prop/displayname')[0].content
        color = block.xpath('propstat/prop/calendar-color')[0].content
        if color =~ /\A#(..)(..)(..)/
          color = "#" + $1 + $2 + $3
          # color = double_lightness_of_hexrgb(color)
        end
        description = block.xpath('propstat/prop/calendar-description')[0].content
        calendars << {"url" => host_url + href.to_s, "displayname" => displayname.to_s,
          "color" => color.to_s, "description" => description.to_s }
      end
    end

    return calendars
  end
  private_class_method :fetch_my_calendar_list


  def self.fetch_commissioned_calendar_list(url, username, userpass)
    origin_dav = CalDAV.new(url)
    origin_dav.set_basic_auth(username, userpass)

    split_url = URI.split(url)
    host_url = split_url[0] + "://" + split_url[2]
    body = <<-EOF_BODY
<?xml version="1.0" encoding="UTF-8"?>
<A:expand-property xmlns:A="DAV:">
  <A:property name="calendar-proxy-read-for" namespace="http://calendarserver.org/ns/">
    <A:property name="displayname" namespace="DAV:"/>
    <A:property name="calendar-user-address-set" namespace="urn:ietf:params:xml:ns:caldav"/>
    <A:property name="email-address-set" namespace="http://calendarserver.org/ns/"/>
  </A:property>
  <A:property name="calendar-proxy-write-for" namespace="http://calendarserver.org/ns/">
    <A:property name="displayname" namespace="DAV:"/>
    <A:property name="calendar-user-address-set" namespace="urn:ietf:params:xml:ns:caldav"/>
    <A:property name="email-address-set" namespace="http://calendarserver.org/ns/"/>
  </A:property>
</A:expand-property>
EOF_BODY
    res = origin_dav.report(body, url)
    return [] if (res.code.to_i / 200) != 1
    xml = Nokogiri::XML(res.body).remove_namespaces!
    blocks = xml.xpath('//multistatus/response/propstat/prop')
    calendars = []

    blocks.each do |block|
      read_for_calendars = block.xpath('calendar-proxy-read-for/response')
      write_for_calendars = block.xpath('calendar-proxy-write-for/response')

      body = <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<A:propfind xmlns:A="DAV:">
  <A:prop>
    <B:calendar-home-set xmlns:B="urn:ietf:params:xml:ns:caldav"/>
    <B:calendar-user-address-set xmlns:B="urn:ietf:params:xml:ns:caldav"/>
    <A:current-user-principal/>
    <A:displayname/>
    <C:dropbox-home-URL xmlns:C="http://calendarserver.org/ns/"/>
    <C:email-address-set xmlns:C="http://calendarserver.org/ns/"/>
    <C:notification-URL xmlns:C="http://calendarserver.org/ns/"/>
    <A:principal-collection-set/>
    <A:principal-URL/>
    <A:resource-id/>
    <B:schedule-inbox-URL xmlns:B="urn:ietf:params:xml:ns:caldav"/>
    <B:schedule-outbox-URL xmlns:B="urn:ietf:params:xml:ns:caldav"/>
    <A:supported-report-set/>
  </A:prop>
</A:propfind>
EOF

      read_for_calendars.each do |rfc|
        if rfc.xpath('propstat/status')[0].content.index("200")
          href = host_url + rfc.xpath('href')[0].content

          res = origin_dav.propfind(href, 0, body)
          xml = Nokogiri::XML(res.body).remove_namespaces!
          calendar_home = xml.xpath('//multistatus/response/propstat/prop/calendar-home-set/href')[0].content
          commissioned_calendar_url = host_url + calendar_home
          calendars << fetch_my_calendar_list(commissioned_calendar_url,
                                              username, userpass)
        end
      end

      write_for_calendars.each do |wfc|
        if wfc.xpath('propstat/status')[0].content.index("200")
          href = host_url + wfc.xpath('href')[0].content

          res = origin_dav.propfind(href, 0, body)
          xml = Nokogiri::XML(res.body).remove_namespaces!
          calendar_home = xml.xpath('//multistatus/response/propstat/prop/calendar-home-set/href')[0].content

          commissioned_calendar_url = host_url + calendar_home
          calendars << fetch_my_calendar_list(commissioned_calendar_url,
                                              username, userpass)
        end
      end
    end
    return calendars.flatten
  end
  private_class_method :fetch_commissioned_calendar_list


end
