require 'spec_helper'

describe PrettyFace::Formatter::Html do
  let(:formatter) { Html.new(nil, nil, nil) }
  let(:parameter) { double('parameter') }

  context "when building the header for the main page" do
    it "should know the start time" do
      formatter.before_features(nil)
      formatter.start_time.should eq Time.now.strftime("%a %B %-d, %Y at %H:%M:%S")
    end
    
    it "should know how long it takes" do
      formatter.should_receive(:generate_report)
      formatter.should_receive(:copy_images_directory)
      formatter.before_features(nil)

      formatter.after_features(nil)
      formatter.total_duration.should include '0.0'
    end
  end

  context "when building the report for scenarios" do
    it "should track number of scenarios" do
      parameter.stub(:status).and_return(:passed)
      formatter.before_feature_element(nil)
      formatter.before_feature_element(nil)
      formatter.before_feature_element(nil)
      
      formatter.scenario_count.should eq 3
    end

    it "should track average scenario durations" do
      parameter.stub(:status).and_return(:passed)
      formatter.before_feature_element(nil)
      formatter.after_feature_element(parameter)
      formatter.before_feature_element(nil)
      formatter.after_feature_element(parameter)
      
      formatter.scenario_average_duration.should include '0.0'
    end

    it "should keep track of passing scenarios" do
      parameter.stub(:status).and_return(:passed)
      formatter.before_feature_element(nil)
      formatter.after_feature_element(parameter)
      formatter.after_feature_element(parameter)
      formatter.instance_variable_get(:@passed_scenarios).should == 2
    end

    it "should keep track of failing scenarios" do
      parameter.stub(:status).and_return(:failed)
      formatter.before_feature_element(nil)
      formatter.after_feature_element(parameter)
      formatter.after_feature_element(parameter)
      formatter.instance_variable_get(:@failed_scenarios).should == 2
    end

    it "should keep track of pending scenarios" do
      parameter.stub(:status).and_return(:pending)
      formatter.before_feature_element(nil)
      formatter.after_feature_element(parameter)
      formatter.after_feature_element(parameter)
      formatter.instance_variable_get(:@pending_scenarios).should == 2
    end

    it "should keep track of undefined scenarios" do
      parameter.stub(:status).and_return(:undefined)
      formatter.before_feature_element(nil)
      formatter.after_feature_element(parameter)
      formatter.after_feature_element(parameter)
      formatter.instance_variable_get(:@undefined_scenarios).should == 2
    end

    it "should keep track of skipped scenarios" do
      parameter.stub(:status).and_return(:skipped)
      formatter.before_feature_element(nil)
      formatter.after_feature_element(parameter)
      formatter.after_feature_element(parameter)
      formatter.instance_variable_get(:@skipped_scenarios).should == 2
    end
  end

  context "when building the report for steps" do
    it "should track number of steps" do
      parameter.stub(:status).and_return(:passed)
      formatter.before_step(nil)
      formatter.after_step(parameter)
      formatter.after_step(parameter)
      formatter.step_count.should eq 2
    end
    
    it "should track average step durations" do
      parameter.stub(:status).and_return(:passed)
      formatter.before_step(nil)
      formatter.after_step(parameter)
      formatter.before_step(nil)
      formatter.after_step(parameter)
      formatter.step_average_duration.should include '0.0'
    end

    it "should keep track of passing steps" do
      parameter.stub(:status).and_return(:passed)
      formatter.before_step(nil)
      formatter.after_step(parameter)
      formatter.after_step(parameter)
      formatter.instance_variable_get(:@passed_steps).should == 2
    end

    it "should keep track of failing steps" do
      parameter.stub(:status).and_return(:failed)
      formatter.before_step(nil)
      formatter.after_step(parameter)
      formatter.after_step(parameter)
      formatter.instance_variable_get(:@failed_steps).should == 2
    end

    it "should keep track of skipped steps" do
      parameter.stub(:status).and_return(:skipped)
      formatter.before_step(nil)
      formatter.after_step(parameter)
      formatter.after_step(parameter)
      formatter.instance_variable_get(:@skipped_steps).should == 2
    end

    it "should keep track of pending steps" do
      parameter.stub(:status).and_return(:pending)
      formatter.before_step(nil)
      formatter.after_step(parameter)
      formatter.after_step(parameter)
      formatter.instance_variable_get(:@pending_steps).should == 2 
    end

    it "should keep track of undefined steps" do
      parameter.stub(:status).and_return(:undefined)
      formatter.before_step(nil)
      formatter.after_step(parameter)
      formatter.after_step(parameter)
      formatter.instance_variable_get(:@undefined_steps).should == 2 
    end
end
end
