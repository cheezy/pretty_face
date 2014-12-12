require 'spec_helper'

module PrettyFace::Formatter
  class Html
    def customization_directory
      nil
    end
  end
end

describe PrettyFace::Formatter::Html do
  let(:formatter) { Html.new(nil, nil, nil) }

  context "when not customizing the report" do
    it "indicates that there are no custom components" do
      expect(formatter.custom_suite_header?).to be false
      expect(formatter.custom_feature_header?).to be false
      expect(formatter.send(:logo_file)).to be nil
    end

  end

end
