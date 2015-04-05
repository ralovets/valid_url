require 'spec_helper'
require 'active_model'
require 'yaml'
require 'valid_url'

class Validatable
  include ActiveModel::Validations
  attr_accessor :url
end

def load_yml path
  YAML.load File.read(File.expand_path(path))
end

valid_urls = load_yml('spec/config/valid_urls.yml')
invalid_urls = load_yml('spec/config/invalid_urls.yml')

describe "UrlValidator" do
  subject { Validatable.new }

  context 'default' do
    before :all do
      Validatable.class_eval{ validates :url, url: true }
    end

    valid_urls.each do |section, urls|
      urls.each do |valid_url|
        it valid_url do
          subject.url = valid_url
          is_expected.to be_valid
        end
      end
    end

    invalid_urls.each do |section, urls|
      urls.each do |invalid_url|
        it invalid_url do
          subject.url = invalid_url
          is_expected.not_to be_valid
        end
      end
    end

    context 'special' do
      it 'nil' do
        subject.url = nil
        is_expected.not_to be_valid
      end
    end
  end

  context 'schemes' do
    before :all do
      Validatable.class_eval do
        validates :url, url: {schemes: [:http, :ftp, :sftp]}
      end
    end

    # it 'wrong scheme' do
    #   subject.url = "https://www.ruby-lang.org"
    #   expect(subject).not_to be_valid
    # end
  end

  context 'default scheme' do
    before :all do
      Validatable.class_eval do
        validates :url, url: {default_scheme: :https}
      end
    end
  end

  context 'schemeless' do
    before :all do
      Validatable.class_eval do
        validates :url, url: {allow_schemeless: false}
      end
    end
  end

  context 'iana domains root zone' do
    before :all do
      Validatable.class_eval do
        validates :url, url: {iana_domains: false}
      end
    end
  end

  context 'ip hosts' do
    before :all do
      Validatable.class_eval do
        validates :url, url: {iana_domains: false}
      end
    end
  end
end