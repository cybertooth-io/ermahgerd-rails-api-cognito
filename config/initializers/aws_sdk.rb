# frozen_string_literal: true

# @see https://github.com/aws/aws-sdk-rails
# Assuming an encrypted credentials file with decrypted contents like:
#
#     aws:
#       access_key_id: YOUR_KEY_ID
#       secret_access_key: YOUR_ACCESS_KEY
#

aws_keys = Rails.application.credentials[:aws]

credentials = Aws::Credentials.new(aws_keys[:access_key_id], aws_keys[:secret_access_key])

# AWS Credentials Configuration
# --------------------------------------------------------------------------------------------------------------------

Aws.config.update(
  credentials: credentials,
  region: aws_keys[:region]
)

# Aws::Rails.add_action_mailer_delivery_method(:aws_sdk, credentials: credentials, region: "us-east-1")
