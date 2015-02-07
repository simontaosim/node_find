class Order
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :deliver

  # field <name>, :type => <type>, :default => <value>
  field :company_node, :type => String
  field :get_goods_node, :type => String
  field :delvier_node, :type => String
  field :status, :type =>Integer
  field :receive_time, :type => DateTime
  field :end_time, :type => DateTime

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
