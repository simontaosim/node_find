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
    @deliver_num = nil
    $i = 0
    @delivers = {}
    if params[:deliver_num]
      @deliver_num = params[:deliver_num].to_i
      while @deliver_num>0 do
        $i+=1
        deliver = Deliver.new
        deliver.deliver_id = Company.where(_id:params[:company_id]).first.name+'公司快递员'+$i.to_s
        deliver.save
        @delivers[$i] = deliver
        @deliver_num-=1
      end
    else
    end
    render 'index/deliver_name'
  end

  

end
