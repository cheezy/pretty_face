require 'spec_helper'

describe PrettyFace::Formatter::Html do
  let(:formatter) { Html.new(nil, nil, nil) }

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
      formatter.before_feature_element(nil)
      formatter.after_feature_element(nil)
      formatter.after_feature_element(nil)
      formatter.after_feature_element(nil)
      
      formatter.scenario_count.should eq 3
    end

    it "should track average scenario durations" do
      formatter.before_feature_element(nil)
      formatter.after_feature_element(nil)
      formatter.before_feature_element(nil)
      formatter.after_feature_element(nil)
      
      formatter.scenario_average_duration.should include '0.0'
    end
  end

  context "when building the report for steps" do
    it "should track number of steps" do
      formatter.before_step(nil)
      formatter.after_step(nil)
      formatter.after_step(nil)
      
      formatter.step_count.should eq 2
    end
    
    it "should track average step durations" do
      formatter.before_step(nil)
      formatter.after_step(nil)

      formatter.before_step(nil)
      formatter.after_step(nil)
      
      formatter.step_average_duration.should include '0.0'
    end
  end
end
