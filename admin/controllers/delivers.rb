MassAlth::Admin.controllers :delivers do
  get :index do
    @title = "Delivers"
    @delivers = Deliver.all
    render 'delivers/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'deliver')
    @deliver = Deliver.new
    render 'delivers/new'
  end

  post :create do
    @deliver = Deliver.new(params[:deliver])
    if @deliver.save
      @title = pat(:create_title, :model => "deliver #{@deliver.id}")
      flash[:success] = pat(:create_success, :model => 'Deliver')
      params[:save_and_continue] ? redirect(url(:delivers, :index)) : redirect(url(:delivers, :edit, :id => @deliver.id))
    else
      @title = pat(:create_title, :model => 'deliver')
      flash.now[:error] = pat(:create_error, :model => 'deliver')
      render 'delivers/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "deliver #{params[:id]}")
    @deliver = Deliver.find(params[:id])
    if @deliver
      render 'delivers/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'deliver', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "deliver #{params[:id]}")
    @deliver = Deliver.find(params[:id])
    if @deliver
      if @deliver.update_attributes(params[:deliver])
        flash[:success] = pat(:update_success, :model => 'Deliver', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:delivers, :index)) :
          redirect(url(:delivers, :edit, :id => @deliver.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'deliver')
        render 'delivers/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'deliver', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Delivers"
    deliver = Deliver.find(params[:id])
    if deliver
      if deliver.destroy
        flash[:success] = pat(:delete_success, :model => 'Deliver', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'deliver')
      end
      redirect url(:delivers, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'deliver', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Delivers"
    unless params[:deliver_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'deliver')
      redirect(url(:delivers, :index))
    end
    ids = params[:deliver_ids].split(',').map(&:strip)
    delivers = Deliver.find(ids)
    
    if delivers.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Delivers', :ids => "#{ids.to_sentence}")
    end
    redirect url(:delivers, :index)
  end
end
