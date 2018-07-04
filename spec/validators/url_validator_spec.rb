require 'spec_helper'
require 'active_model'
require 'yaml'
require 'valid_url'

class Validatable
  include ActiveModel::Validations
  attr_accessor :url
  validates :url, url: true
end

class ValidatableWithProtocol
  include ActiveModel::Validations
  attr_accessor :url
  validates :url, url: {ensure_protocol: true}
end

def load_yml path
  YAML.load File.read(File.expand_path(path))
end

valid_urls = load_yml('spec/config/valid_urls.yml')
invalid_urls = load_yml('spec/config/invalid_urls.yml')

describe "UrlValidator" do
  subject { Validatable.new }

  valid_urls.each do |section, urls|
    context section do
      urls.each do |valid_url|
        it valid_url do
          subject.url = valid_url
          expect(subject).to be_valid
        end
      end
    end
  end

  invalid_urls.each do |section, urls|
    context section do
      urls.each do |invalid_url|
        it invalid_url do
          subject.url = invalid_url
          expect(subject).not_to be_valid
        end
      end
    end
  end

  context 'special' do
    it 'nil' do
      subject.url = nil
      expect(subject).not_to be_valid
    end
  end

  context "when 'ensure_protocol' option is set to true" do
    subject { ValidatableWithProtocol.new }

    it "leaves the url as-is when a protocol is specified" do
      url = 'http://blog.example.com'

      subject.url = url
      expect(subject).to be_valid
      expect(subject.url).to eq(url)
    end

    it "updates the url with the default protocol when not specified" do
      url = 'blog.example.com'

      subject.url = url
      expect(subject).to be_valid
      expect(subject.url).to eq("http://#{url}")
    end
  end
end