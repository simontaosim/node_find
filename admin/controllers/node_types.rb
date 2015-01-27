MassAlth::Admin.controllers :node_types do
  get :index do
    @title = "Node_types"
    @node_types = NodeType.all
    render 'node_types/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'node_type')
    @node_type = NodeType.new
    render 'node_types/new'
  end

  post :create do
    @node_type = NodeType.new(params[:node_type])
    if @node_type.save
      @title = pat(:create_title, :model => "node_type #{@node_type.id}")
      flash[:success] = pat(:create_success, :model => 'NodeType')
      params[:save_and_continue] ? redirect(url(:node_types, :index)) : redirect(url(:node_types, :edit, :id => @node_type.id))
    else
      @title = pat(:create_title, :model => 'node_type')
      flash.now[:error] = pat(:create_error, :model => 'node_type')
      render 'node_types/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "node_type #{params[:id]}")
    @node_type = NodeType.find(params[:id])
    if @node_type
      render 'node_types/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'node_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "node_type #{params[:id]}")
    @node_type = NodeType.find(params[:id])
    if @node_type
      if @node_type.update_attributes(params[:node_type])
        flash[:success] = pat(:update_success, :model => 'Node_type', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:node_types, :index)) :
          redirect(url(:node_types, :edit, :id => @node_type.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'node_type')
        render 'node_types/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'node_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Node_types"
    node_type = NodeType.find(params[:id])
    if node_type
      if node_type.destroy
        flash[:success] = pat(:delete_success, :model => 'Node_type', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'node_type')
      end
      redirect url(:node_types, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'node_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Node_types"
    unless params[:node_type_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'node_type')
      redirect(url(:node_types, :index))
    end
    ids = params[:node_type_ids].split(',').map(&:strip)
    node_types = NodeType.find(ids)
    
    if node_types.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Node_types', :ids => "#{ids.to_sentence}")
    end
    redirect url(:node_types, :index)
  end
end
