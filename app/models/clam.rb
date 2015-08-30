class Clam < ActiveRecord::Base
  belongs_to :mission
  has_one :resource
  serialize :options
  has_many :clam_events
  has_many :events, through: :clam_events

  def self.serialized_attr_accessor(*args)
    args.each do |method_name|
      eval "
        def #{method_name}
          (self.options || {})[:#{method_name}]
        end
        def #{method_name}=(value)
          self.options ||= {}
          self.options[:#{method_name}] = value
        end
      "
    end
  end

  def self.search(search)
    if search
      Clam.where(['options LIKE ? or summary LIKE ?', "%#{search}%", "%#{search}%"])
    else
      Clam.all
    end
  end

  serialized_attr_accessor :description, :originator, :recipients
end
