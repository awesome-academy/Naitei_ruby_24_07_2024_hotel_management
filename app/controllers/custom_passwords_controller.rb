class CustomPasswordsController < Devise::PasswordsController
  skip_load_and_authorize_resource
  layout "application"
end
