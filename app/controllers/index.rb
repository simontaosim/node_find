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
       @company_node = Node.where(_id:params[:company_node_id]).first
       @company = Company.where(_id:params[:company_id]).first
       @nodes = Node.where(company_id: params[:company_id])
       @node_ways = NodeWay.where(:company_id => params[:company_id])
       @new_settle = '新的快递点：'+'建立失败'
       render 'index/manager_ment'
    else
      @node.save
      @success = '创建区域成功'
       #建立完毕，输出页面对象
      @company_node = Node.where(_id:params[:company_node_id]).first
      @company = Company.where(_id:params[:company_id]).first
      @nodes = Node.where(company_id: params[:company_id])
      logger.info @company_node.to_json

      @nodes.each_with_index do |f,index|
      #logger.info params['time_cost'+f._id].to_s+'分钟'
        @node_way = NodeWay.new
        @node_way.node_one = @node._id
        @node_way.node_two = f._id
        @node_way.company_id = params[:company_id]
        time_cost = params['time_cost'+f._id]
        if params['time_cost'+f._id]
          #同一区域或者没有填写距离默认
          time_cost = 10
        end
        @node_way.longlast = time_cost.to_i
        @node_way.save
      end
      
      @node_ways = NodeWay.where(company_id: params[:company_id])
      @new_settle = '新的快递点：'+'［'+@node.name+'］'+'已经建立'
      render 'index/manager_ment'
    end
   

  end

  post :delete_node_way do
      logger.info params[:node_way_id]
      node_way = NodeWay.where(_id: params[:node_way_id]).first
      if node_way
        @new_settle = '［'+Node.find(node_way.node_one).name+'
      ］到［'+Node.find(node_way.node_two).name+'］的距离删除成功!'
        node_way.destroy
      end
      
      #============================
    #页面数据维持
      @node = Node.new
      @company_node = Node.where(_id:params[:company_node_id]).first
      @company = Company.where(_id:params[:company_id]).first
      @nodes = Node.where(company_id: params[:company_id])
      @node_ways = NodeWay.where(company_id: params[:company_id])
    #=============================
      render 'index/manager_ment'

  end

end
