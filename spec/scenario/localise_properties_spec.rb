# encoding: utf-8

require File.expand_path('../../spec_helper', __FILE__)

class Article < CouchRest::Model::Base
  use_database DB
  localised_property :title, String
  localised_property :content, String
  localised_property :active, TrueClass
  property :posted_at, DateTime
  timestamps!
end

I18n.default_locale = :en

describe "Basic Usage" do

  before :each do
    @a = Article.new
  end

  after :each do
    @a.destroy
  end

  it "should be possible to set and receive basic attributes" do
    @a.title = "This is a test title"
    @a.content = "This is the body of the article."
    @a.active = true
    @a.posted_at = now = DateTime.current

    @a.save

    @a = Article.first
    @a.title.should eql("This is a test title")
    @a.active.should be_true
    @a.posted_at.to_s.should eql(now.to_s)
  end

  it "should be possible to use default values" do
    @a.title = "This is a test title"
    @a.save
    @a = Article.first
    I18n.locale = :es
    @a.title.should eql("This is a test title")
  end

  it "should be possible to set value for other language" do
    I18n.locale = :en
    @a.title = "This is a test title"
    I18n.locale = :es
    @a.title = "Una prueba en castellano de un título"
    @a.save

    @a = Article.first
    @a.title.should eql("Una prueba en castellano de un título")
    I18n.locale = :en
    @a.title.should eql("This is a test title")
  end

  it "should allow mass-asignment" do
    I18n.locale = :en

    @a.attributes = {:title => "TITLE TEST", :content => 'The body', :posted_at => DateTime.current}

    @a.title.should eql("TITLE TEST")
    @a.save

    @a = Article.first
    I18n.locale = :es
    @a.title.should eql("TITLE TEST")
    @a.attributes = {:title => "PRUEBA DE TITULO"}
    @a.save

    @a = Article.first
    @a.title.should eql('PRUEBA DE TITULO')
    @a.content.should eql('The body')

    I18n.locale = :en
    @a.title.should eql('TITLE TEST')
  end

end

