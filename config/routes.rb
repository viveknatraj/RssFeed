Rails.application.routes.draw do
  resources :blog_articles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'fetch_articles' => 'blog_articles#populate_articles'
end
