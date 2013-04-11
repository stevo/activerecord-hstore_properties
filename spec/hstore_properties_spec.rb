require 'spec_helper'
describe ActiveRecord::HstoreProperties do
  with_model :Comment do
    table do |t|
      t.string :text
      t.hstore :properties
    end

    model do
      include ActiveRecord::HstoreProperties

      #We need to do that, as sqlite does not support hstore
      self.class_eval do
        def properties
          self[:properties].is_a?(Hash) ? self[:properties] : ActiveRecord::Coders::Hstore.load(self[:properties])
        end
      end
    end
  end

  it "it should respond to properties call" do
    Comment.respond_to?(:properties).should be_true
  end

  it "it should be possible to define properties" do
    Comment.properties 'property_one', 'property_two'
    Comment.properties.should be_an_instance_of(Array)
    Comment.properties.map(&:name).should include('property_one', 'property_two')
  end

  it "by default properties should be of String type" do
    Comment.properties 'property_one'
    Comment.properties.first.should be_a_kind_of(ActiveRecord::Properties::StringProperty)
  end

  it "it should be possible to define property types other than string" do
    Comment.properties 'property_one', 'property_two' => :boolean
    Comment.properties.find { |p| p.name == 'property_two' }.should be_a_kind_of(ActiveRecord::Properties::BooleanProperty)
  end

  it "_property accessor should return raw property value" do
    Comment.properties 'property_two' => :boolean
    comment = Comment.new
    comment.properties = {:property_two => true}
    comment.save
    comment.property_two_property.should == 'true'
  end

  it "properties_set should not return underscored properties" do
    Comment.properties '_property_one', 'property_two'
    Comment.properties_set.find{|p| p.name == '_property_one'}.should be_nil
    Comment.properties_set.find{|p| p.name == 'property_two'}.should_not be_nil
  end

  context "boolean properties" do
    before(:each) do
      Comment.properties 'property_two' => :boolean
      @comment = Comment.new
      @comment.properties = {:property_two => true}
      @comment.save
    end

    it "should be possible to be queried for state" do
      @comment.property_two?.should == true
      @comment.property_two_enabled?.should == true
    end

    it "should be possible to be toggled" do
      @comment.property_two_lower!
      @comment.property_two?.should == false
      @comment.property_two_raise!
      @comment.property_two?.should == true
      @comment.property_two_disable!
      @comment.property_two?.should == false
      @comment.property_two_enable!
      @comment.property_two?.should == true
    end
  end

  context "counter properties" do
    before(:each) do
      Comment.properties 'property_two' => :counter
      @comment = Comment.new
      @comment.save
    end

    it "should be possible to bump counter" do
      @comment.property_two_bump!
      @comment.properties['property_two'].should == '1'
    end

    it "should be possible to query for current count" do
      @comment.property_two_count.should == 0
      @comment.property_two_bump!

      @comment.property_two_count.should == 1
    end

    end

end