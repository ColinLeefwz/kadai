# frozen_string_literal: true

class BaseService
  def initialize
    raise NotImplementedError
  end

  # クラスメソッドから呼び出す
  def self.call(*args, &block)
    new(*args, &block).call
  end

  private

  # Private: 失敗した結果
  #
  # @params error[String] エラーメッセージ
  #
  # @return [OpenStruct] 失敗した結果
  def failed_result(error)
    OpenStruct.new(success?: false, error: error)
  end

  # Private: 成功した結果
  #
  # @params payload[Hash] データの中身
  #
  # @return [OpenStruct] 成功した結果
  def succeed_result(payload = {})
    OpenStruct.new(success?: true, payload: payload)
  end
end
