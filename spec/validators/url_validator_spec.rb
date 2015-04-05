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
        is_expected.to be_valid
      end
    end
  end

  context 'gets possible schemes' do
    before :all do
      Validatable.class_eval do
        validates :url, url: {schemes: [:https, :udp]}
      end
    end

    it 'wrong' do
      subject.url = "http://www.ruby-lang.org"
      is_expected.not_to be_valid
    end

    it 'uncommon' do
      subject.url = "udp://1.2.3.4:5000"
      is_expected.to be_valid
    end
  end

  context 'denies schemeless domains' do
    before :all do
      Validatable.class_eval do
        validates :url, url: {allow_schemeless: false}
      end
    end

    it 'with scheme' do
      subject.url = "http://www.ruby-lang.org"
      is_expected.to be_valid
    end

    it 'without scheme' do
      subject.url = "www.ruby-lang.org"
      is_expected.not_to be_valid
    end
  end

  context 'disables checking iana domains root zone' do
    before :all do
      Validatable.class_eval do
        validates :url, url: {iana_domains: false}
      end
    end

    it 'iana domain' do
      subject.url = "http://example.com"
      is_expected.to be_valid
    end

    it 'random domain' do
      subject.url = "http://www.example.ruby"
      is_expected.to be_valid
    end
  end

  context 'denies ip hosts' do
    before :all do
      Validatable.class_eval do
        validates :url, url: {ip: false}
      end
    end

    it 'common domain' do
      subject.url = 'https://ruby-lang.org'
      is_expected.to be_valid
    end

    it 'ip host' do
      subject.url = "212.188.10.227"
      is_expected.not_to be_valid
    end
  end
end