# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthServices::Tweeter do
  let(:access_token) { 'access_token' }
  let(:title) { 'title' }
  let(:url) { 'url' }
  let(:service) { described_class.new(access_token, title, url) }
  let(:response) { double('response') }

  describe '#call' do
    context '例外が発生する場合' do
      let(:standard_error) { 'standard error' }

      before do
        expect(Net::HTTP).to receive(:new).and_raise(StandardError, standard_error)
        expect(Net::HTTP::Post).not_to receive(:new)
      end

      it do
        result = service.call
        expect(result.success?).to be false
        expect(result.error).to eq(standard_error)
      end
    end

    context '投稿が出来ない場合' do
      let(:error_msg) { 'failed in tweeting' }

      before do
        expect_any_instance_of(Net::HTTP).to receive(:request).and_return(response)
        expect(response).to receive(:is_a?).with(Net::HTTPCreated).and_return(false)
      end

      it do
        result = service.call
        expect(result.success?).to be false
        expect(result.error).to eq(error_msg)
      end
    end

    it 'is successful' do
      expect_any_instance_of(Net::HTTP).to receive(:request).and_return(response)
      expect(response).to receive(:is_a?).with(Net::HTTPCreated).and_return(true)
      result = service.call
      expect(result.success?).to be true
    end
  end
end
