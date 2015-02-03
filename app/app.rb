module MassAlth
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions
#========================
#Author Simon
#mobile: 18820965455
#QQ: 626754503
#========================
    get '/' do
        redirect(url( :index,:index, error: '注册您的公司'))
    end

    



  end
end
