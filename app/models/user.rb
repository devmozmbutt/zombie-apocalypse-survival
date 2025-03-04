# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, :age, :gender, presence: true
  validates_associated :locations
  validates_associated :inventories

  after_commit :welcome_email, on: :create

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { survivor: 0, admin: 1 }

  has_many :inventories, dependent: :destroy
  has_many :items, through: :inventories
  has_many :locations, dependent: :destroy
  has_many :trade_histories, dependent: :destroy

  has_many :reporters, class_name: 'Infection',
                       dependent: :destroy,
                       foreign_key: :reporter_id,
                       inverse_of: :reporter
  has_many :reports, class_name: 'Infection',
                     dependent: :destroy,
                     foreign_key: :reported_id,
                     inverse_of: :report

  has_many :base_traders, class_name: 'Trade',
                          dependent: :destroy,
                          foreign_key: :base_trader_id,
                          inverse_of: :base_trader
  has_many :traders, class_name: 'Trade',
                     dependent: :destroy,
                     foreign_key: :trader_id,
                     inverse_of: :trader

  has_one_attached :photo

  accepts_nested_attributes_for :inventories
  accepts_nested_attributes_for :locations

  scope :infected, ->(status) { where(infected: status) }
  scope :except_survivor, ->(user) { where.not(id: user.id) }

  def self.total_survivors
    survivor.count
  end

  def self.infected_percentage
    if !total_survivors.zero?
      infected_survivors = survivor.infected(true).count
      (infected_survivors * 100) / total_survivors
    else
      0
    end
  end

  def self.non_infected_percentage
    if !total_survivors.zero?
      non_infected_survivors = survivor.infected(false).count
      (non_infected_survivors * 100) / total_survivors
    else
      0
    end
  end

  def welcome_email
    UserMailer.with(user: self).welcome_email.deliver_later
  end
end
