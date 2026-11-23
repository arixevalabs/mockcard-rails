# frozen_string_literal: true

# `bin/rails generate mockcard:install` — adds config/initializers/mockcard.rb.
#
# Author: Arixeva Labs <hello@arixevalabs.com>
require "rails/generators"

module Mockcard
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      desc "Creates the MockCard initializer."

      # Copies the initializer template.
      # @return [void]
      def create_initializer
        template "mockcard.rb", "config/initializers/mockcard.rb"
      end
    end
  end
end
