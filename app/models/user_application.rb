class UserApplication < ActiveRecord::Base
  # attr_accessible :title, :body
   extend UserApplicationsHelper
  # attr_accessor :name,:current
  # cattr_accessor :current_user
  # attr_accessible :name,:current
  
   
  
  def self.current
  event=  Event.find_by_event("session_start");
    
    unless event.nil?
   @user=User.find_by_id(event.user_id)
    end
  end
  def self.cron_demo
   current_session= ActiveRecord::SessionStore::Session.find(:last)
   current_user=nil
   user_session=nil
   unless current_session.nil?
     current_user=current_session.data['user_id']
     # user_session=current_session.data['session']
   end
   
  unless current_user.nil?
     puts "i am in cron check nill#{current_user}"
    require 'xmpp4r_facebook'
   # token=UserApplication.current.facebook_token
   # sender_fb_id=UserApplication.current.fb_id
   sender_fb_id=User.find(current_user).fb_id
   sender_chat_id = "-#{sender_fb_id}@chat.facebook.com"
    message_subject = "message subject"
     # receiverss=["675771396","100000080158727","100000590727241","100000973512268","100001239671137","100001575698095"]
   receivers=SendMessage.find(:all)
  unless receivers.empty?
    receivers.each_with_index do |receiver,index|
       user = User.find_by_id(receiver.sender_id)
       unless user.nil?
       receiver_chat_id = "-#{user.fb_id}@chat.facebook.com"
       jabber_message = Jabber::Message.new(receiver_chat_id, receiver.message)
        jabber_message.subject = message_subject
        client = Jabber::Client.new(Jabber::JID.new(sender_chat_id))
        client.connect
        # puts jabber_message
        client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client,'641206265895621', 'CAAJHLHe02sUBAMyGTkDZBv4lgwDpfZBJ24etoa1G2UmiyTtif1zXRhZBErfajwQCW5GPqJZBsMFTxTvU4MmU1fcvEukCdcZAx9HeZBN1GKDqyZCYxn3MtZBQUbzzaSATIT5ZCtYZAUuZBLJAsJoknI61eaW3y49CZAxqop4ZD','e81cd8aa1272a4b3a17e3ac0824b07dc'), nil)
        client.send(jabber_message) 
        client.close
        puts client
        receiver.destroy
         end
       end
     end
   end
  end
end
