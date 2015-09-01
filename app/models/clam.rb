class Clam < ActiveRecord::Base
  belongs_to :mission
  has_one :resource
  serialize :options
  has_many :clam_events
  has_many :events, through: :clam_events
  # for reuse info
  has_one :parent_relation, foreign_key: 'child_id', class_name: 'ReuseInfo'
  has_many :child_relations, foreign_key: 'parent_id', class_name: 'ReuseInfo'
  has_one :reuse_parent, through: :parent_relation, source: :parent
  has_many :reuse_children, through: :child_relations, source: :child

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
