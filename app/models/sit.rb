require 'textacular/searchable'

class Sit < ActiveRecord::Base

  # attr_accessible :tag_list

  belongs_to :user, counter_cache: true
  has_many :comments, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :favourites, as: :favourable
  has_many :likes, as: :likeable
  has_many :reports, as: :reportable

  validates :s_type, presence: true, inclusion: { in: ["diary", "meditation"] }
  validates :title, presence: true, if: "s_type == 'diary'"
  validates :duration, presence: true, numericality: { greater_than: 0, only_integer: true }, if: "s_type == 'meditation'"

  # Scopes
  scope :communal, -> { where(private: false) }
  scope :newest_first, -> { order(created_at: :desc) }
  scope :today, -> { where("DATE(created_at) = ?", Date.today) }
  scope :yesterday, -> { where("DATE(created_at) = ?", Date.yesterday) }
  scope :with_body, -> { where.not(body: '')}
  scope :without_diaries, -> { where.not(s_type: "diary") }

  self.per_page = 20 # Pagination: sits per page

  extend Searchable(:title, :body) # Textacular: search these columns only

  # Nice date: 11 July 2012
  def date
    created_at.strftime("%d %B %Y")
  end

  # For use on show sit pages
  def full_title
    case s_type
    when "meditation" then "#{self.duration} minute meditation journal"
    when "diary" then self.title # Diary
    else "Article: #{self.title}" # Article
    end
  end

  ##
  # METHODS
  ##

  def is_meditation?
    s_type == "meditation"
  end

  def stub?
    body.empty?
  end

  # Remove <br>'s and &nbsp's
  def custom_strip
    no_brs = self.body.gsub(/<br>/, ' ')
    no_brs.gsub('&nbsp;', ' ')
  end

  def mine?(current)
    return true if self.user_id == current.id
  end

  def next(current_user)
    next_sit = user.sits.with_body.where("created_at > ?", self.created_at).order(created_at: :asc)
    return next_sit.first if current_user && (self.user_id == current_user.id)
    return next_sit.communal.first
  end

  def prev(current_user)
    prev_sit = user.sits.with_body.where("created_at < ?", self.created_at).order(created_at: :asc)
    return prev_sit.last if current_user && (self.user_id == current_user.id)
    return prev_sit.communal.last
  end

  # Returns sits from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("(user_id IN (#{followed_user_ids}) AND private = false) OR user_id = :user_id", user_id: user.id)
  end

  def commenters
    ids = self.comments.map {|c| c.user.id}.uniq # uniq removes dupe ids if someone's posted multiple times
    ids.delete(self.user.id) # remove owners id
    return ids
  end

  ##
  # TAGS
  ##

  class << self

    def tagged_with(name)
      Tag.find_by_name!(name).sits.communal
    end

    def tag_counts
      Tag.select("tags.*, count(taggings.tag_id) as count").joins(:taggings).group("taggings.tag_id, tags.id, tags.name, tags.created_at")
    end

  end


  def tag_list
    tags.pluck(:name).join(', ')
  end

  ##
  # LIKES
  ##

  def likers
    Like.likers_for(self)
  end

  def liked?
    self.likes.any?
  end

end

# == Schema Information
#
# Table name: sits
#
#  id               :integer          not null, primary key
#  title            :string
#  body             :text
#  user_id          :integer
#  disable_comments :boolean          default(FALSE), not null
#  created_at       :datetime
#  updated_at       :datetime
#  duration         :integer
#  s_type           :string           default("meditation"), not null
#  private          :boolean          default(FALSE)
#  views            :integer          default(0)
#
