class Tweet < ActiveRecord::Base
  # validates :content, presence:true, length: {maximum: 140}
  
  validate :add_error

  def add_error
    # 空のときにエラーメッセージを追加する
    if content.empty?
      # errors.add(:content, "に関係するエラーを追加")
      # errors[:base] << "モデル全体に関係するエラーを追加"
      errors[:base] << "なにかつぶやいてね"
    end
    
    if content.length > 140
      errors[:base] << "140文字以内でつぶやいてね！"
    end
    
  end
  
end
