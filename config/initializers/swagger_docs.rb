module Swagger::Docs
  class Config
    def self.transform_path(path, api_version)
      "api-docs/#{path}"
    end
  end
end

Swagger::Docs::Config.register_apis(
  '1.0' => {
    # base path
    base_path: BASE_URL,
    # the extension used for the API
    api_extension_type: :json,
    # the output location where your .json files are written to
    api_file_path: 'public/api-docs',
    # if you want to delete all .json files at each generation
    clean_directory: true,
    # ability to setup base controller for each api version. Api::V1::SomeController for example.
    parent_controller: Api::V1::BaseController,
    # add custom attributes to api-docs
    attributes: {
      info: {
        'title' => 'Gym Test Project'
      }
    }
  }
)
