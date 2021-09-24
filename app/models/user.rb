class EmailValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
            record.errors.add attribute, (options[:message] || "is not an email")
        end
    end
end

class User < ApplicationRecord
    # has_secure_password(validations: false)
    has_secure_password

    validates :name, presence: true, on: :create
    validates :username, uniqueness: true, on: :create
    validates :email, presence: true, uniqueness: true, email: true, on: :create
    validates :role, presence: true, on: :create
    validates :password, confirmation: true, on: :create
    validates :password_confirmation, presence: true, on: :create

    before_save :downcase_email
    before_create :generate_confirmation_instructions

    def downcase_email
        self.email = self.email.delete(' ').downcase
    end
    
    def generate_confirmation_instructions
        self.confirmation_token = generate_token
        self.confirmation_sent_at = Time.now
    end

    def confirmation_token_valid?
        (self.confirmation_sent_at + 3.days) > Time.now
    end
    
    def mark_as_confirmed!
        self.confirmation_token = nil
        self.confirmed_at = Time.now
        save!
    end
        
    private

    def generate_token
        SecureRandom.hex(10)
    end
end
