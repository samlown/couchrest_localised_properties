# encoding: utf-8

require File.expand_path('../../spec_helper', __FILE__)

class BasicLP < CouchRest::Model::Base
  use_database DB
  localised_property :title, String
  localised_property :popularity, Float
  property :posted_at, DateTime
end

I18n.default_locale = :en

describe "CouchRest LocalisedProperties" do

  describe "instance" do

    before :each do
      @obj = BasicLP.new
    end

    describe "#read_localised_attribute" do
      before :each do
        @obj['title'] = { 'en' => "Sample Title", 'es' => "Título de muestra" }
      end

      it "should read title appropriately" do
        I18n.locale = :en
        @obj.read_localised_attribute('title').should eql("Sample Title")
        I18n.locale = 'es'
        @obj.read_localised_attribute('title').should eql("Título de muestra")
      end

      it "should use default locale if no match available" do
        I18n.locale = :de
        @obj.read_localised_attribute('title').should eql('Sample Title')
      end

      it "should not cause any problems if data not set" do
        @obj['title'] = nil
        lambda { @obj.read_localised_attribute('title') }.should_not raise_error
      end
    end

    describe "#write_localised_attribute" do
      it "should write basic property" do
        I18n.locale = 'en'
        @obj.write_localised_attribute('title', "Sample Title")
        @obj['title']['en'].should eql("Sample Title")
        I18n.locale = 'es'
        @obj.write_localised_attribute('title', "Ejemplo de un título")
        @obj['title']['es'].should eql("Ejemplo de un título")
      end

      it "should allow mass-assignment with Hash" do
        @obj.write_localised_attribute('title', {'en' => "Sample Title"})
        @obj['title']['en'].should eql('Sample Title')
      end

      it "should call dirty tracking to register the change" do
        @obj.should_receive(:couchrest_attribute_will_change!).with('title')
        @obj.write_localised_attribute('title', "Sample Title")
      end

      it "should mark record as changed when translation set" do
        @obj.changed?.should be_false
        @obj.title = 'New Title'
        @obj.title_changed?.should be_true
        @obj.changed?.should be_true
      end

      describe "with casting" do
        it "should perform type casting on normal write" do
          I18n.locale = 'en'
          amount = '32'
          @obj.write_localised_attribute('popularity', amount)
          @obj['popularity']['en'].should eql(32.0)
        end
        it "should perform casting on each key when hash sent" do
          @obj.write_localised_attribute('popularity', {'en' => '23', 'es' => '32'})
          @obj['popularity']['es'].should eql(32.0)
        end
      end
    end

  end

  describe "class methods" do

    describe ".localised_property" do
      it "should be added to class" do
        BasicLP.respond_to?(:localised_property).should be_true
      end

      it "should call property method" do
        prop = mock('Property')
        prop.should_receive(:type).and_return(String)
        BasicLP.should_receive(:property).with(:body).and_return(prop)
        BasicLP.should_receive(:create_localised_property_getter)
        BasicLP.should_receive(:create_localised_property_setter)
        BasicLP.localised_property :body
      end

      it "should fail if type provided is a Hash" do
        lambda { BasicLP.localised_property(:body, Hash) }.should raise_error
      end

      it "should create getters and setters" do
        BasicLP.localised_property :active, TrueClass
        @obj = BasicLP.new
        @obj.respond_to?(:active).should be_true
        @obj.respond_to?(:active?).should be_true
        @obj.respond_to?(:active=).should be_true
      end

      it "getters and setters should pass on requests" do
        BasicLP.localised_property :content, String
        @obj = BasicLP.new
        @obj.should_receive(:read_localised_attribute).with('content')
        @obj.content
        @obj.should_receive(:write_localised_attribute).with('content', 'foo')
        @obj.content = 'foo'
      end

    end

  end

end
