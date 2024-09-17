class CustomUnlocksController < Devise::UnlocksController
  skip_load_and_authorize_resource
  layout "application"
end
