class Apply < ApplicationRecord
  belongs_to :user, optional: true
  
  validates :one_month, presence:true
  
  
  enum application_content: { なし: 0, 申請中: 1, 承認: 2, 否認: 3 }, _prefix: true
  
end
