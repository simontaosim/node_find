MassAlth::App.controllers :index do
#==========================
#Author Simon
#mobile: 18820965455
#QQ: 626754503
#==========================
  get :index, :with => :error do
    if params[:error]
      @error = params[:error]
    else
      @error = nil
    end
    @company = Company.new
    render 'index/index'
  end

  post :create do
    @company = Company.new(params[:company])
    if @company.save
      @success = '创建公司成功'
      render 'index/set_deliver_number'
    else
      @error = '此公司名已经存在'
      redirect(url(:index, :index,error: @error))
    end
  end

  post :create_delivers do
    @company = Company.where(_id:params[:company_id]).first
    @deliver_num = nil
    $i = 0
    @delivers = {}
    if params[:deliver_num]
      @deliver_num = params[:deliver_num].to_i
      while @deliver_num>0 do
        $i+=1
        deliver = Deliver.new
        deliver.deliver_id = @company.name+'公司快递员'+$i.to_s
        deliver.save
        @delivers[$i] = deliver
        @deliver_num-=1
      end
    else
    end
    @node = Node.new
    #创建公司区域
    @company_node =  Node.new
    @company_node.name = @company.name + "公司所在区域"
    @company_node.company_id = params[:company_id]
    @company_node.save
    #公司区域创建完成
    @nodes = Node.where(company_id: params[:company_id])
    @node_ways = Node.where(:node1 => @company_node._id.to_s)
    render 'index/manager_ment'
  end#create_delivers

  post :create_node do
    #建立新的属于该公司管理节点
    @node = Node.new
    @node.name = params[:node_name]
    @node.company_id = params[:company_id]
    if Node.nodeInCompanyExist(@node.name, @node.company_id)
       @error = '此区域已经存在'
       @company_node = Node.find(params[:company_node_id])
       @company = Company.where(_id:params[:company_id]).first
       @nodes = Node.where(company_id: params[:company_id])
       @node_ways = NodeWay.where(:company_id => params[:company_id])
       @new_settle = '新的快递点：'+'建立失败'
       render 'index/manager_ment'
    else
      @node.save
      @success = '创建区域成功'
       #建立完毕，输出页面对象
      @company_node = Node.find(params[:company_node_id])
      @company = Company.where(_id:params[:company_id]).first
      @nodes = Node.where(company_id: params[:company_id])
      @nodes.each_with_index do |f,index|
      #logger.info params['time_cost'+f._id].to_s+'分钟'
        @node_way = NodeWay.new
        @node_way.node_one = @node._id
        @node_way.node_two = f._id
        @node_way.company_id = params[:company_id]
        @node_way.longlast = params['time_cost'+f._id].to_i
        @node_way.save
        logger.info @node_way.node1.to_json
      end
      
      @node_ways = NodeWay.where(company_id: params[:company_id])
      logger.info @node_ways.to_json
      @new_settle = '新的快递点：'+'［'+@node.name+'］'+'已经建立'
      render 'index/manager_ment'
    end
   

  end

  post :delete_node_way do
      @node = Node.new
      @company_node = Node.find(params[:company_node_id])
      @company = Company.where(_id:params[:company_id]).first
      @nodes = Node.where(company_id: params[:company_id])
      @node_ways = NodeWay.where(company_id: params[:company_id])
      logger.info @node_ways.to_json
      @new_settle = '删除成功！'
      render 'index/manager_ment'

  end

end
