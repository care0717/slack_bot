require_relative "./spec_helper"
require 'rspec'
require_relative '../slack_class'

describe SlackFile do

  it "imageファイルであればscoreを返す" do
    data = {'file'=> {'mimetype' => 'images', 'id' => 1}}
    slack_file = SlackFile.new(data)
    scores = {"cat" => 0.9, "dog" => 0.1}
    allow(slack_file).to receive(:calc_scores_of_image).and_return(scores)
    expect(slack_file.analyze_by_watson).to eq "\"cat\"=>0.9\n \"dog\"=>0.1"
  end
  it "imageファイルで無ければ何も返さない" do
    data = {'file'=> {'mimetype' => 'file', 'id' => 1}}
    slack_file = SlackFile.new(data)
    allow(slack_file).to receive(:calc_scores_of_image)
    analyzed_text = slack_file.analyze_by_watson
    expect(slack_file).not_to have_received(:calc_scores_of_image)
    expect(analyzed_text).to eq nil
  end
end
