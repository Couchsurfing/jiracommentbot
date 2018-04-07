Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/servers/reservations', to: 'reservations#show'
  post '/servers/reserve', to: 'reservations#reserve'
  post '/servers/unreserve', to: 'reservations#unreserve'

  post '/servers/setup', to: 'reservations#setup'
  post '/servers/cleanup', to: 'reservations#cleanup'
end
