require_relative "./spec_helper"
require 'rspec'
require_relative '../slack_class'
require 'timecop'

test_today = Date.new(2017, 11, 17)
test_yesterday = test_today - 1

describe SlackText do
  describe "#analyze" do
    context "今日を入れる" do
      data = {'text' => '             今日'}
      slack_text = SlackText.new(data)
      it '今日の予定があればそれを返す' do
        Timecop.travel(test_today) do
          allow(slack_text).to receive(:fetch_html).and_return(get_test_nokogiri_obj)
          #allow(slack_text).to receive(:html_to_text)
          analyzed_text = slack_text.analyze
          expect(analyzed_text).to eq "11-17 15:00 ゼミ（tokamaks:第16回-山本，加藤）"
          expect(analyzed_text.class).to eq String
        end
      end
      it "今日に予定がなければ「予定はありません」を返す" do
        Timecop.travel(test_yesterday) do
          allow(slack_text).to receive(:fetch_html).and_return(get_test_nokogiri_obj)
          #allow(slack_text).to receive(:html_to_text)
          analyzed_text = slack_text.analyze
          expect(analyzed_text).to eq "予定はありません．"
          expect(analyzed_text.class).to eq String
        end
      end
    end
    context "muraを入れる" do
      data = {'text' => '             mura'}
      slack_text = SlackText.new(data)
      it '今日の予定があればそれを返す' do
        Timecop.travel(test_today) do
          allow(slack_text).to receive(:fetch_html).and_return(get_test_nokogiri_obj)
          #allow(slack_text).to receive(:html_to_text)
          analyzed_text = slack_text.analyze
          expect(analyzed_text).to eq "11-17 13:00-2:30 村上：桂（講義：核融合プラズマ工学）"
          expect(analyzed_text.class).to eq String
        end
      end
      it "今日に予定がなければ「予定はありません」を返す" do
        Timecop.travel(test_yesterday) do
          allow(slack_text).to receive(:fetch_html).and_return(get_test_nokogiri_obj)
          #allow(slack_text).to receive(:html_to_text)
          analyzed_text = slack_text.analyze
          expect(analyzed_text).to eq "予定はありません．"
          expect(analyzed_text.class).to eq String
        end
      end
    end
    context "ゼミを入れる" do
      data = {'text' => '             ゼミ'}
      slack_text = SlackText.new(data)
      it '最新のゼミの予定を返す' do
        Timecop.travel(test_today) do
          allow(slack_text).to receive(:fetch_html).and_return(get_test_nokogiri_obj)
          #allow(slack_text).to receive(:html_to_text)
          analyzed_text = slack_text.analyze
          expect(analyzed_text).to eq "11-17 15:00 ゼミ（tokamaks:第16回-山本，加藤）"
          expect(analyzed_text.class).to eq String
        end
      end
    end
    context "それ以外" do
      data = {'text' => '             あああ'}
      slack_text = SlackText.new(data)
      it '何の用だを返す' do
        expect(slack_text.analyze).to eq "なんの用だ"
      end
    end
  end
end
