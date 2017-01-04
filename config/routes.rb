Blah::Application.routes.draw do

  #Overide the feedback controller of Blacklight to our Contact view
  match 'feedback' => 'contact#new'

  Blacklight.add_routes(self, :except => [:catalog, :solr_document])
  # We don't add the Blacklight catalog/solr_document routes so that...
  # ... we can override url route with 'catalogue'...
  match 'catalogue/opensearch', :to => 'catalog#opensearch',  :as => 'opensearch_catalog'
  match 'catalogue/citation', :to => 'catalog#citation', :as => 'citation_catalog'
  match 'catalogue/sms', :to => 'catalog#sms',  :as => 'sms_catalog'
  match 'catalogue/endnote', :to => 'catalog#endnote', :as => 'endnote_catalog'
  match 'catalogue/send_email_record', :to => 'catalog#send_email_record',  :as => 'send_email_record_catalog'
  match 'catalogue/facet/:id', :to => 'catalog#facet', :as => 'catalog_facet'
  match 'catalogue/range_limit', :to => 'catalog#range_limit', :as => 'catalog_range_limit'
  match 'catalogue', :to => 'catalog#index', :as => 'catalog_index'
  match 'catalogue/:id/librarian_view', :to => 'catalog#librarian_view', :as => 'librarian_view_catalog'

  resources :solr_document,  :path => 'catalogue', :controller => 'catalog', :only => [:show, :update] 
  resources :catalog, :path => 'catalogue', :controller => 'catalog', :only => [:show, :update]
  # End of catalog/solr_document overides 

  root :to => 'home#show'

  # Use to retrieve library item and its holdings
  match 'items/:bib_no' => 'library_items#show'

  match 'contact' => 'contact#new', :as => 'contact', :via => :get
  match 'contact' => 'contact#create', :as => 'contact', :via => :post
 
  match 'faq', :to => 'home#faq', :as => 'faq'
  match 'cookies', :to => 'home#cookies', :as => 'cookies'
  match 'home', :to => 'home#show', :as => 'home'

  devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with 'root'
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with 'rake routes'

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
