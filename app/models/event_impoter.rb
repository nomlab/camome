# -*- coding: utf-8 -*-
require "./lib/caldav/caldav.rb"
require "./lib/caldav/webdav.rb"
require 'yaml'
require 'icalendar'

class EventImpoter < ActiveRecord::Base

  def initialize(url, user, pass, start_date=nil, end_date=nil)
    @url = url
    @user = user
    @pass = pass
    @calenar = nil
    @start_date = start_date
    @end_date = end_date
  end

  def import
    events = convert_icalendar_into_camome(get_calendar_data)
  end

  private

  def convert_icalendar_into_camome(icalendar)
    events = []
    icalendar.events.each do |e|
      if Event.where("uid IS ?","#{e.uid}").blank?
        ev = Event.new
        ev.uid = e.uid.to_s
        ev.summary = e.summary.to_s
        ev.dtstart = e.dtstart
        ev.dtend = e.dtend
        ev.recurrence_id = Recurrence.inbox.id
        events << ev
      end
    end
    return events
  end

  def get_calendar_data
    events_data = get_schedule(@url, @user, @pass, @start_date, @end_date)
  end

  def get_schedule(url, user, pass, start_date = nil, end_date = nil)
    initialize_caldav_connection(url, user, pass)
    uri_xml = get_uri(url, start_date, end_date)
    raise "PROPFIND ERROR (uri_xml is nil)" unless uri_xml
    list_of_uri = get_list_of_uri(uri_xml.body)
    p list_of_uri
  # camomeと比較してとってくるEventを選ぶ機能を付け加える
    events_xml = get_events(url, list_of_uri)
    get_list_of_events(events_xml.body.force_encoding("utf-8"))
  end

  def initialize_caldav_connection(url, user, pass)
    @dav = CalDAV.new(url)
    @dav.set_basic_auth(user, pass)
  end

  def get_uri(url,start_date, end_date)
    xml = <<"EOS"
<D:propfind xmlns:D="DAV:">
<D:prop>
</D:prop>
</D:propfind>
EOS
    @dav.propfind(url, 1, xml)
  end

  # xmlを解析し，uriをリストで返す．
  def get_list_of_uri(xml)
    xml.scan(/<D:href>(.*?)<\/D:href>/m).flatten
  end

  def get_events(url, list_of_uri)
    xml = make_xml_for_report(list_of_uri)
    @dav.report(xml, url, 1)
  end

  def make_xml_for_report(list_of_uri)
    xml = <<"EOS"
<?xml version="1.0" encoding="utf-8" ?>
<C:calendar-multiget xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">
<D:prop>
<D:getetag/>
<C:calendar-data/>
</D:prop>
EOS
    list_of_uri.each do |uri|
      xml += "<D:href>" + uri + "</D:href>\n"
    end if list_of_uri
    xml += "</C:calendar-multiget>"
  end

  def get_list_of_events(xml)
    # VEVENT毎に切り分け
    events = ""
    vcalendar_heads = xml.scan(/BEGIN:VCALENDAR(.*?)BEGIN:VEVENT/m).flatten
    vcalendar_head = "BEGIN:VCALENDAR" +  vcalendar_heads[0]
    vevents = xml.scan(/BEGIN:VEVENT(.*?)END:VEVENT/m).flatten
     vevents.map do |vevent|
       events << "\nBEGIN:VEVENT" + vevent + "END:VEVENT"
    end
    event_ics = vcalendar_head + events + "\nEND:VCALENDAR"
    return Icalendar.parse(event_ics,true)
  end
end
