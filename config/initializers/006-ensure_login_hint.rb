
# frozen_string_literal: true

return if GlobalSetting.skip_db?

# Some sanity checking so we don't count on an unindexed column on boot
begin
  if ActiveRecord::Base.connection.table_exists?(:users) &&
     User.limit(20).count < 20 &&
     User.where(admin: true).human_users.count == 0

    notice =
      if GlobalSetting.developer_emails.blank?
        "مبارکه، شما دیسکورس را نصب کردید! متاسفانه هیچ ایمیل ادمینی در طول نصب تعریف نشده است،‌ بنابراین تکمیل<a href='https://meta.discourse.org/t/create-admin-account-from-console/17274'> پیکربندی</a>  کمی سخت خواهد بود."
      else
        emails = GlobalSetting.developer_emails.split(",")
        if emails.length > 1
          emails = emails[0..-2].join(', ') << " or #{emails[-1]} "
        else
          emails = emails[0]
        end
        "Congratulations, you installed Discourse! Register a new admin account with #{emails} to finalize configuration."
      end
      "مبارکه، شما دیسکورس را نصب کردید! یک حساب کاربری با ایمیل بسازید و تنظیمات را تکمیل کنید."
    end

    if notice != SiteSetting.global_notice
      SiteSetting.global_notice = notice
      SiteSetting.has_login_hint = true
    end
  end
rescue ActiveRecord::NoDatabaseError
  # Database might not have been created
end
