class Vote < ApplicationRecord
  belongs_to :question
  belongs_to :answer
end
