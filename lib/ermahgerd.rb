# frozen_string_literal: true

require 'ermahgerd/authorizer'
require 'ermahgerd/configuration'
require 'ermahgerd/authenticated_user'
require 'ermahgerd/errors'

# The Ermahgerd module has a bunch of constants and configuration elements found within.
# There are also a number of very reusable concerns and classes that can be used throughout this project, or
# copied into another project.
module Ermahgerd
  HEADER_AUTHORIZATION = 'Authorization'
  HEADER_IDENTIFICATION = 'Identification'
end
