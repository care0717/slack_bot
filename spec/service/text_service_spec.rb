require 'rspec'
require 'rspec/mocks'
require_relative '../../src/service/text_service'
require_relative '../../src/dao/text_dao'

describe TextService do
  before(:each) do
    test_dao_mock = double('TextService')
    allow(test_dao_mock).to receive(:uranai).and_return('test')
    allow(TextDao).to receive(:new).and_return(test_dao_mock)
  end

  describe '#uranai' do
    it 'uranaiメソッドはfileのHashを返す' do
      test_service = TextService.new 
      res = {
        token: ENV['PGRP_LEGACY_TOKEN'],
        channels: 'aa',
        file: 'test',
        initial_comment: '占い結果です',
      }
      expect( test_service.uranai('aa')).to eq(res)
    end
  end
  describe '#analyze_receipt_from_history' do
    it 'トーク履歴から商品名のデータを取り出す' do
      test_service = TextService.new 
      histories = [{"username"=>"ruby_bot",
        "text"=>"receipt 2018-01-12\n スープヌードル=&gt;117\n バンホーテンチョコレート =&gt;74"}]
      text = 'バンホーテン レシートから'
      res = [" 2018-01-12", " バンホーテンチョコレート =&gt;74"]
      expect( test_service.analyze_receipt_from_history(histories, text)).to eq(res)
    end
  end
  
end
