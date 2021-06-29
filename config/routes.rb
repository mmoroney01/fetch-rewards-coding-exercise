Rails.application.routes.draw do
  resources :transactions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end


        # Prefix Verb   URI Pattern                                                                                       Controller#Action
        #                     transactions GET    /transactions(.:format)                                                                           transactions#index
        #                                  POST   /transactions(.:format)                                                                           transactions#create
        #                  new_transaction GET    /transactions/new(.:format)                                                                       transactions#new
        #                 edit_transaction GET    /transactions/:id/edit(.:format)                                                                  transactions#edit
        #                      transaction GET    /transactions/:id(.:format)                                                                       transactions#show
        #                                  PATCH  /transactions/:id(.:format)                                                                       transactions#update
        #                                  PUT    /transactions/:id(.:format)                                                                       transactions#update
        #                                  DELETE /transactions/:id(.:format)     