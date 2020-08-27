require 'textacular/searchable'

class Sit < ActiveRecord::Base

  attr_accessor :tag_list

  TYPES = %w[diary meditation].freeze

  enum visibility: {
    private: 'private',
    followers: 'followers',
    # groups: 'groups',   # TODO: make it available when groups will be implemented
    public: 'public'
  }, _suffix: :visibility

  belongs_to :user, counter_cache: true
  has_many :comments, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :favourites, as: :favourable
  has_many :likes, as: :likeable
  has_many :reports, as: :reportable

  validates :duration, presence: true, numericality: { greater_than: 0, only_integer: true }, if: Proc.new { |record| record.is_meditation? }
  validates :s_type, presence: true, inclusion: { in: TYPES }
  validates :title, presence: true, unless: Proc.new { |record| record.is_meditation? }
  validates :user_id, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # Scopes
  scope :communal, -> { where(visibility: 'public') }
  scope :viewable_for, -> (user) do
    where(user_id: user.id).or(where(visibility: 'public'))
      .or(followed_for(user))
  end
  scope :followed_for, -> (user) do
    where("visibility IN ('public', 'followers') AND user_id IN (?)", user.followed_user_ids)
  end
  scope :private_for, -> (user) { where(user_id: user.id) }
  scope :most_popular_for, -> (user) do
    select('sits.*, COUNT(comments.id) AS comments_count').joins('LEFT JOIN comments ON comments.sit_id = sits.id')
      .where(
        "sits.user_id = ? OR sits.visibility = 'public' OR (sits.visibility IN ('public', 'followers') AND sits.user_id IN (?))",
        user.id,
        user.followed_user_ids
      )
      .group('sits.id').order('comments_count DESC').limit(10)
  end
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
    when "meditation" then I18n.t('sit.meditation', count: self.duration)
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
    followed_user_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
    public_visibility = "visibility IN ('public', 'followers')"
    where("(user_id IN (#{followed_user_ids}) AND #{public_visibility}) OR user_id = :user_id", user_id: user.id)
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
#  body             :text
#  disable_comments :boolean          default(FALSE), not null
#  duration         :integer
#  s_type           :string           default("meditation"), not null
#  title            :string
#  views            :integer          default(0)
#  visibility       :enum             default("public")
#  user_id          :integer
#
