require 'spec_helper'

describe PrettyFace::Formatter::Html do
  it "should track number of scenarios" do

    formatter = Html.new nil, nil, nil
    
    formatter.before_feature_element(nil)
    formatter.after_feature_element(nil)
    formatter.after_feature_element(nil)
    formatter.after_feature_element(nil)
	
  	formatter.scenario_count.should eq 3
  end
  it "should track number of steps" do

    formatter = Html.new nil, nil, nil
    
    formatter.before_step(nil)
    formatter.after_step(nil)
    formatter.after_step(nil)
	
  	formatter.step_count.should eq 2
  end
  it "should track average scenario durations" do

    formatter = Html.new nil, nil, nil
    
    formatter.before_feature_element(nil)
    formatter.after_feature_element(nil)

    formatter.before_feature_element(nil)
    formatter.after_feature_element(nil)
	
  	formatter.scenario_average_duration.should include '0.0'
  end
  it "should track average step durations" do

    formatter = Html.new nil, nil, nil
    
    formatter.before_step(nil)
    formatter.after_step(nil)

    formatter.before_step(nil)
    formatter.after_step(nil)
	
  	formatter.step_average_duration.should include '0.0'
  end
  it "should know the start time" do
    formatter = Html.new nil, nil, nil
    formatter.before_features(nil)
    formatter.start_time.should eq Time.now.strftime("%a %B %-d, %Y at %H:%M:%S")
  end
  it "should know how long it takes" do
    formatter = Html.new nil, nil, nil

    formatter.before_features(nil)

    formatter.after_features(nil)
    formatter.total_duration.should include '0.0'
  end


end