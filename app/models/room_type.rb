class RoomType < ApplicationRecord
  has_many :utilities_in_room_types, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :requests, dependent: :destroy

  has_many :utilities, through: :utilities_in_room_types, source: :utility

  ATTRIBUTE_PERMITTED = %i(start_date end_date min_price max_price).freeze

  scope :ordered_by_name, ->{order(name: :asc)}
  scope :by_ids, ->(ids){where(id: ids)}
  scope :within_price_range, lambda {|min_price, max_price|
    where("(? IS NULL OR price_weekday >= ?)
          AND (? IS NULL OR price_weekend <= ?)",
          min_price.presence,
          min_price.presence || Float::INFINITY,
          max_price.presence,
          max_price.presence || -Float::INFINITY)
  }
  scope :with_utilities, lambda {|selected_utility_ids|
    joins(:utilities_in_room_types)
      .where(utilities_in_room_types: {utility_id: selected_utility_ids})
      .group("room_types.id")
      .having("COUNT(utilities_in_room_types.utility_id) = ?",
              selected_utility_ids.size)
  }

  def self.ransackable_attributes _auth_object = nil
    %w(name)
  end
end
