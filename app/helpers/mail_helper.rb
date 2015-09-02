require 'digest/sha1'

module MailHelper
  def create_uid(seed)
    "<#{Digest::SHA1.hexdigest(Time.now.to_i.to_s + seed)}@camome.com>"
  end
end
