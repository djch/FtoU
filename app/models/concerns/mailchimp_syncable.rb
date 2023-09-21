module MailchimpSyncable
  extend ActiveSupport::Concern

  included do
    after_create :add_to_mailchimp
    after_update :update_in_mailchimp
    after_destroy :remove_from_mailchimp
  end

  def mailchimp_email_hash
    Digest::MD5.hexdigest(self.email.downcase)
  end

  private

    def mailchimp_list_id
      Rails.configuration.mailchimp_list_id
    end

    def handle_mailchimp_errors
      yield
    rescue Gibbon::MailChimpError => e
      Rails.logger.error("Mailchimp error: #{e.message}")
    end

    def add_to_mailchimp
      handle_mailchimp_errors do
        Gibbon::Request.new.lists(mailchimp_list_id).members.create(
          body: {
            email_address: self.email,
            status: "subscribed",
            merge_fields: mailchimp_merge_fields
          }
        )
      end
    end

    def update_in_mailchimp
      handle_mailchimp_errors do
        Gibbon::Request.new.lists(mailchimp_list_id).members(self.mailchimp_email_hash).update(
          body: { merge_fields: mailchimp_merge_fields }
        )
      end
    end

    def remove_from_mailchimp
      handle_mailchimp_errors do
        Gibbon::Request.new.lists(mailchimp_list_id).members(self.mailchimp_email_hash).delete
      end
    end

    def mailchimp_merge_fields
      {
        FNAME: self.first_name,
        LNAME: self.last_name,
        PHONE: self.phone,
        ADDRESS: format_address_for_mailchimp
      }
    end

    def format_address_for_mailchimp
      {
        addr1: self.street_address,
        city: self.town,
        state: self.state,
        zip: self.postcode,
        country: self.country
      }
    end
end
