CocoaOfficeHours::Application.routes.draw do
  
  root 'application#index'
  get '/ping_me' => 'application#ping_me'
  get '/next_event' => 'application#next_event'
  get '/attendings' => 'application#attendings'
  get '/auth/github' => 'application#github_auth'
  get '/auth/github/callback' => 'application#github_callback'
  
end
