# frozen_string_literal: true

module FixtureHelpers
  def self.as_file_storage(fixture_name, filename = nil)
    {
      io: File.open(Rails.root.join('spec', 'fixtures', fixture_name)),
      filename: filename || File.basename(fixture_name)
    }
  end

  def self.fixture_as_upload(fixture_name, content_type = 'image/png')
    path = Rails.root.join('spec', 'fixtures', fixture_name)
    Rack::Test::UploadedFile.new(path, content_type)
  end
end
