MassAlth::Admin.controllers :deliver_signs do
  get :index do
    @title = "Deliver_signs"
    @deliver_signs = DeliverSign.all
    render 'deliver_signs/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'deliver_sign')
    @deliver_sign = DeliverSign.new
    render 'deliver_signs/new'
  end

  post :create do
    @deliver_sign = DeliverSign.new(params[:deliver_sign])
    if @deliver_sign.save
      @title = pat(:create_title, :model => "deliver_sign #{@deliver_sign.id}")
      flash[:success] = pat(:create_success, :model => 'DeliverSign')
      params[:save_and_continue] ? redirect(url(:deliver_signs, :index)) : redirect(url(:deliver_signs, :edit, :id => @deliver_sign.id))
    else
      @title = pat(:create_title, :model => 'deliver_sign')
      flash.now[:error] = pat(:create_error, :model => 'deliver_sign')
      render 'deliver_signs/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "deliver_sign #{params[:id]}")
    @deliver_sign = DeliverSign.find(params[:id])
    if @deliver_sign
      render 'deliver_signs/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'deliver_sign', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "deliver_sign #{params[:id]}")
    @deliver_sign = DeliverSign.find(params[:id])
    if @deliver_sign
      if @deliver_sign.update_attributes(params[:deliver_sign])
        flash[:success] = pat(:update_success, :model => 'Deliver_sign', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:deliver_signs, :index)) :
          redirect(url(:deliver_signs, :edit, :id => @deliver_sign.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'deliver_sign')
        render 'deliver_signs/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'deliver_sign', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Deliver_signs"
    deliver_sign = DeliverSign.find(params[:id])
    if deliver_sign
      if deliver_sign.destroy
        flash[:success] = pat(:delete_success, :model => 'Deliver_sign', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'deliver_sign')
      end
      redirect url(:deliver_signs, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'deliver_sign', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Deliver_signs"
    unless params[:deliver_sign_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'deliver_sign')
      redirect(url(:deliver_signs, :index))
    end
    ids = params[:deliver_sign_ids].split(',').map(&:strip)
    deliver_signs = DeliverSign.find(ids)
    
    if deliver_signs.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Deliver_signs', :ids => "#{ids.to_sentence}")
    end
    redirect url(:deliver_signs, :index)
  end
end
