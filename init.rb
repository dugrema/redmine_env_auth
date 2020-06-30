require "redmine"

Redmine::Plugin.register :redmine_env_auth do
  name "request environment authentication"
  author "Intera GmbH"
  url "http://github.com/intera/redmine_env_auth" if respond_to?(:url)
  description "a plugin for authentication based on variables in the request environment"
  version "1.1"

  Redmine::MenuManager.map :account_menu do |menu|
    # Note : link /signout est capture par NGINX pour rediriger

    # hide the logout link if an automatic login is active
    # menu.delete :logout
    # menu.push :logout, :signout_path, :html => {:method => "post"}, :if => Proc.new {
    #   env_auth_disabled = Setting.plugin_redmine_env_auth["enabled"] != "true"
    #   User.current.logged? and env_auth_disabled
    # }, :after => :my_account
  end

  settings :partial => "settings/redmine_env_auth_settings",
    :default => {
      "allow_other_login" => "admins",
      "allow_other_login_users" => "",
      "enabled" => "true",
      "env_variable_name" => "HTTP_USER_PRIVE",
      "ldap_checked_auto_registration" => "true",
      "redmine_user_property" => "login",
      "remove_suffix" => ""
    }
end

Rails.configuration.to_prepare do
  RedmineEnvAuth::EnvAuthPatch.install
end
