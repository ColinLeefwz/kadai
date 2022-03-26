require 'rails_helper'

RSpec.describe Image, type: :model do
  describe 'validates' do
    let(:blank_title_msg) { 'タイトルタイトルを入力してください' }
    let(:too_long_title_msg) { 'タイトルは30文字以内で入力してください' }
    let(:blank_avatar_msg) { '画像ファイル画像ファイルを入力してください' }

    it 'is invalid without a title' do
      image = described_class.new
      image.valid?
      expect(image.errors.full_messages).to match_array([blank_title_msg, blank_avatar_msg])
    end

    it 'is invalid without a avatar' do
      image = described_class.new(title: 'title')
      image.valid?
      expect(image.errors.full_messages).to match_array([blank_avatar_msg])
    end

    it 'is invalid with a too long title' do
      image = described_class.new(title: 'title' * 20, avatar: fixture_file_upload(file_fixture('test.jpg'), 'image/jpg'))
      image.valid?
      expect(image.errors.full_messages).to match_array([too_long_title_msg])
    end
  end
end
