class Order
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :deliver

  # field <name>, :type => <type>, :default => <value>
  field :node1, :type => String
  field :node2, :type => String
  field :node3, :type => String
  field :status, :type =>Integer

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
