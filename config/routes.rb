Rails.application.routes.draw do
  root 'application#hello'

  post '/servers/reservations', to: 'reservations#show'
  post '/servers/reserve', to: 'reservations#reserve'
  post '/servers/unreserve', to: 'reservations#unreserve'

  post '/servers/setup', to: 'reservations#setup'
  post '/servers/cleanup', to: 'reservations#cleanup'
  post '/servers/tweak', to: 'reservations#tweak'
end
