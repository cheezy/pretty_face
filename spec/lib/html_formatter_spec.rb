require 'spec_helper'
require 'cucumber/core/ast/step'

describe PrettyFace::Formatter::Html do
  let(:step_mother) { double('step_mother') }
  let(:formatter) { Html.new(step_mother, nil, nil) }
  let(:parameter) { double('parameter') }
  let(:step) { Cucumber::Ast::Step.new(1, 'Given', 'A cucumber Step') }

  context "when building the header for the main page" do
    it "should know the start time" do
      allow(formatter).to receive(:make_output_directories)
      formatter.before_features(nil)
      expect(formatter.start_time).to eql Time.now.strftime("%a %B %-d, %Y at %H:%M:%S")
    end

    it "should know how long it takes" do
      expect(formatter).to receive(:generate_report)
      expect(formatter).to receive(:copy_images)
      expect(formatter).to receive(:copy_stylesheets)
      allow(formatter).to receive(:make_output_directories)
      formatter.before_features(nil)

      formatter.after_features(nil)
      expect(formatter.total_duration).to include '0.0'
    end
  end

  context "when building the report for scenarios" do
    it "should track number of scenarios" do
      expect(step_mother).to receive(:scenarios).and_return([1,2,3])
      expect(formatter.scenario_count).to eql 3
    end

    it "should keep track of passing scenarios" do
      expect(step_mother).to receive(:scenarios).with(:passed).and_return([1,2])
      expect(step_mother).to receive(:scenarios).and_return([1,2])
      expect(formatter.scenarios_summary_for(:passed)).to eql "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it "should keep track of failing scenarios" do
      expect(step_mother).to receive(:scenarios).with(:failed).and_return([1,2])
      expect(step_mother).to receive(:scenarios).and_return([1,2])
      expect(formatter.scenarios_summary_for(:failed)).to eql "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it "should keep track of pending scenarios" do
      expect(step_mother).to receive(:scenarios).with(:pending).and_return([1,2])
      expect(step_mother).to receive(:scenarios).and_return([1,2])
      expect(formatter.scenarios_summary_for(:pending)).to eql "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it "should keep track of undefined scenarios" do
      expect(step_mother).to receive(:scenarios).with(:undefined).and_return([1,2])
      expect(step_mother).to receive(:scenarios).and_return([1,2])
      expect(formatter.scenarios_summary_for(:undefined)).to eql "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it "should keep track of skipped scenarios" do
      expect(step_mother).to receive(:scenarios).with(:skipped).and_return([1,2])
      expect(step_mother).to receive(:scenarios).and_return([1,2])
      expect(formatter.scenarios_summary_for(:skipped)).to eql "2 <span class=\"percentage\">(100.0%)</span>"
    end
  end

  context "when building the report for steps" do
    it "should track number of steps" do
      expect(step_mother).to receive(:steps).and_return([1,2])
      expect(formatter.step_count).to eql 2
    end

    it "should keep track of passing steps" do
      expect(step_mother).to receive(:steps).with(:passed).and_return([1,2])
      expect(step_mother).to receive(:steps).and_return([1,2])
      expect(formatter.steps_summary_for(:passed)).to eql "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it "should keep track of failing steps" do
      expect(step_mother).to receive(:steps).with(:failed).and_return([1,2])
      expect(step_mother).to receive(:steps).and_return([1,2])
      expect(formatter.steps_summary_for(:failed)).to eql "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it "should keep track of skipped steps" do
      expect(step_mother).to receive(:steps).with(:skipped).and_return([1,2])
      expect(step_mother).to receive(:steps).and_return([1,2])
      expect(formatter.steps_summary_for(:skipped)).to eql "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it "should keep track of pending steps" do
      expect(step_mother).to receive(:steps).with(:pending).and_return([1,2])
      expect(step_mother).to receive(:steps).and_return([1,2])
      expect(formatter.steps_summary_for(:pending)).to eql "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it "should keep track of undefined steps" do
      expect(step_mother).to receive(:steps).with(:undefined).and_return([1,2])
      expect(step_mother).to receive(:steps).and_return([1,2])
      expect(formatter.steps_summary_for(:undefined)).to eql "2 <span class=\"percentage\">(100.0%)</span>"
    end
  end

  context "when embedding an image" do
    before(:each) do
      cuke_feature = double('cuke_feature')
      expect(cuke_feature).to receive(:description)
      report_feature = ReportFeature.new(cuke_feature, 'foo')
      formatter.report.features << report_feature
      @scenario = ReportScenario.new(nil)
      formatter.report.current_feature.scenarios << @scenario
      allow(File).to receive(:dirname).and_return('')
      allow(FileUtils).to receive(:cp)
    end

    it "should generate an id" do
      formatter.embed('image.png', 'image/png', 'the label')
      expect(@scenario.image_id).to include 'img_0'
    end

    it "should get the filename from the src" do
      formatter.embed('directory/image.png', 'image/png', 'the label')
      expect(@scenario.image).to include 'image.png'
    end

    it "should get the image label" do
      formatter.embed('directory/image.png', 'image/png', 'the label')
      expect(@scenario.image_label).to include 'the label'
    end

    it "scenario should know if it has an image" do
      formatter.embed('directory/image.png', 'image/png', 'the label')
      expect(@scenario).to have_image
    end

    it "should copy the image to the output directory" do
      expect(FileUtils).to receive(:cp).with('directory/image.png', '/images')
      formatter.embed('directory/image.png', 'image/png', 'the label')
    end
  end
end
