class NodeWay
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  # field <name>, :type => <type>, :default => <value>
  field :node1, :type => String
  field :node2, :type => String
  field :fee, :type => Float
  field :speed, :type => FLoat
  field :miles, :type => Float
  field :longlast, :type => Float

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
