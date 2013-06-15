Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "479108305511384", "c5a8b1ba3552bdc25f01a58b113bb286", {:scope => "read_stream"}
end