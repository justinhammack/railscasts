class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :episodes, ["published_at <= ?", Time.zone.now] do |episode|
      episode.published_at <= Time.now.utc
    end
    can :access, :info
    can :create, :feedback_messages
    can [:read, :create, :login], :users

    if user
      can :logout, :users
      can :update, :users, :id => user.id
      can :create, :comments
      can [:update, :destroy], :comments do |comment|
        comment.created_at >= 15.minutes.ago && comment.user_id == user.id
      end

      if user.admin?
        can :access, :all
      end
    end
  end
end