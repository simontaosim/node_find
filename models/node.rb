class Node
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :node_type
  belongs_to :company
  
  field :name, :type => String
  field :node_type, :type => String

  def self.nodeInCompanyExist(name,company_id)
  #判断一个区域在一个公司是否有
   logger.info "调试："+name
  	node = where(:company_id => company_id, :name => name).first
  end
end
