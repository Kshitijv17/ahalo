# namespace :send_promotions do
#     desc "Send promotional emails to all users"
#     task :email => :environment do
#       # Here, you can call methods or classes to send emails
#       User.find_each do |user|
#         UserMailer.promotion_email(user).deliver_now
#       end
#       puts "Promotional emails sent!"
#     end
#   end