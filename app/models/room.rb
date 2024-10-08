class Room < ApplicationRecord
  ROOMS_PERMITTED = %i(room_number status description room_type_id).freeze
  enum status: {active: 0, inactive: 1}
  belongs_to :room_type
  has_many :requests, dependent: :destroy
  validates :room_number, presence: true
  validates :status, presence: true

  scope :excluding_ids, ->(ids){where.not(id: ids)}
  scope :by_ids, ->(ids){where(id: ids)}
  scope :by_room_type_price_range, lambda {|min_price, max_price|
    room_type_ids = RoomType.within_price_range(min_price, max_price).pluck(:id)
    where(room_type_id: room_type_ids)
  }
  scope :ordered_by_room_number, ->{order(room_number: :asc)}
  scope :by_type_and_ids, lambda {|room_type_id, available_room_ids|
    where(id: available_room_ids, room_type_id:)
  }

  def self.ransackable_attributes _auth_object = nil
    %w(room_number)
  end
end
