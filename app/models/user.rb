class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy, class_name:"Noticed::Notification"
  has_many :notification_mentions, as: :record, dependent: :destroy, class_name:"Noticed::Event"
  has_one :address, dependent: :destroy, inverse_of: :user, autosave: true

  has_one_attached :avatar

  pay_customer stripe_attributes: :stripe_attributes

  enum role: %i[user admin]
  after_initialize :set_default_role, if: :new_record?

  # Class level accessor http://apidock.com/rails/Class/cattr_accessor
  cattr_accessor :form_steps do
    %w[sign_up set_name set_address find_users]
  end

  # Instance level accessor http://apidock.com/ruby/Module/attr_accessor
  attr_accessor :form_step

  def form_step
    @form_step ||= 'sign_up'
  end

  with_options if: -> { required_for_step?('set_name') } do |step|
    step.validates :first_name, presence: true
    step.validates :last_name, presence: true
  end

  validates_associated :address, if: -> { required_for_step?('set_address') }

  def full_name
    "#{first_name.capitalize unless first_name.nil?} #{last_name.capitalize unless last_name.nil?}"
  end

  accepts_nested_attributes_for :address, allow_destroy: true

  def required_for_step?(step)
    # All fields are required if no form step is present
    form_step.nil?

    # All fields from previous steps are required if the
    # step parameter appears before or we are on the current step
    form_steps.index(step.to_s) <= form_steps.index(form_step.to_s)
  end

  def stripe_attributes(pay_customer)
    {
      address: {
        city: pay_customer.owner.city,
        country: pay_customer.owner.country
      },
      metadata: {
        pay_customer_id: pay_customer.id,
        user_id: id # or pay_customer.owner_id
      }
    }
  end


  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "encrypted_password", "id", "id_value", "first_name", "last_name", "remember_created_at", "reset_password_sent_at", "reset_password_token", "role", "updated_at", "views"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["address", "avatar_attachment", "avatar_blob", "comments", "notification_mentions", "notifications", "posts"]
    end
  private

  def set_default_role
    self.role ||= :user
  end
end
