# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /' do
    let(:url) { '/' }
    let(:subject) { get url }

    before(:each) do
      subject
    end

    context 'access top page' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include 'TopPage' }
    end
  end
end
