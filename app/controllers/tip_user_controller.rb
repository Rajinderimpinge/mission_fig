class TipUserController < ApplicationController
  before_filter :current_user
  require 'rest_client'
  require 'uri'
  require 'net/http'
  
  respond_to :js, :html,:json
  def send_notification
  # url="https://www.facebook.com/dialog/apprequests?app_id=641206265895621&message=Take%20control%20of%20your%20financial%20future%2EMissionFIG%20is%20the%20new%2Cfun%20and%20risk%2Dfree%20way%20to%20learn%20how%20to%20invest&filters=['all']&content=this%20is%20content&title=this%20is%20title&data=this%20is%20data&redirect_uri=http://202.164.36.12:3000/fb-oauth&to=['100002340314497','100000762962084']"
 # #url="https://www.facebook.com/dialog/apprequests?app_id=641206265895621&message=Take%20control%20of%20your%20financial%20future%2EMissionFIG%20is%20the%20new%2Cfun%20and%20risk%2Dfree%20way%20to%20learn%20how%20to%invest&filters=['all']&title=this%20is%20title&data=this%20is%20data&redirect_uri=http://202.164.36.12:3000/fb-oauth&to=['100000973512268','100000762962084']"
#     
    # @receivers=["675771396","100000080158727","100000590727241","100000973512268","100001239671137","100001575698095"]
   # redirect_to url
  end

  def send_message
    
    parsed_json = ActiveSupport::JSON.decode(params[:data])
      # message= parsed_json["userMessageData"]['message']
     # messageType= parsed_json["userMessageData"]['messageType']
      # receivers=["675771396","100000080158727","100000590727241","100000973512268","100001239671137","100001575698095"]
     receiverIds=parsed_json["userMessageData"]['receiver_ids']
     $admins = Array(YAML::load(File.open("#{RAILS_ROOT}/config/fb_admin_ids.yml"))[Rails.env]["fb_admin_ids"])
     request_url = "https://graph.facebook.com/100000762962084/apprequests"
        @message="Jordan Keffer sent you a tip in MissionFIG."
        if current_user.fb_id=="675771396"
          @message="Jordan Keffer sent you a tip in MissionFIG."
        else if $admins.include?(current_user.fb_id)
          @message="Mission sent you a tip in MissionFIG."
        # else if $admins.include?(current_user.fb_id) && messageType=="inbox"
          # @message="You have a new message from Mission in MissionFIG."
         # end
          end
         end
    request_params={
      'message'=>@message      
    } 
    notification_params={
      'href'=>'http://0.0.0.0:3000/fb-oauth/',
      'template'=>@message
    }
     
    # receivers.each do |receiver|
      # user=User.find_by_id(receiver)
      # unless user.nil?
        # fb_id=user.fb_id
        # request_url = "https://graph.facebook.com/#{receiver}/apprequests"
         notification_url="https://graph.facebook.com/100000762962084/notifications"
        send_notify_request(notification_url,notification_params) 
        send_notify_request(request_url,request_params) 
      # end
      # end
    # response= RestClient.post 'https://graph.facebook.com/100000080158727/notifications?access_token=CAAJHLHe02sUBAG0uKTxfqBmZCmx5YDw3GI9rfTBEST6M7fNsTXY2dYJQGMPVwPZBVN8dApqk6ppDiu9bcFJOtpF5JaMYbARpi2lao8dm2qVH2MiqUEZBAvGUS4eqCFTZBbq3z4uSWtSOQhBFjVVjSOpnIbNE3VV14cr3nWzMeQZDZD&href=http://google.com&template=You have people waiting to play with you, play now!'
    # response =  RestClient.post 'https://graph.facebook.com/100002340314497/notifications?access_token=641206265895621|9250pmdIBdwJnsUykTUnoL5Xm9E&href=http://google.com&template=You have people waiting to play with you, play now!',:content_type => 'application/json'
       respond_to do |format|
     format.json {render :json => {:status => "success"}}
    end
   end
  
  
  
  
  
  def send_notify_request(url,attach)
    access_token="641206265895621|9250pmdIBdwJnsUykTUnoL5Xm9E"
    uri = URI.parse(url) 
    req = Net::HTTP::Post.new(uri.path)
     req.set_form_data(attach.merge('access_token' => access_token))
     res = Net::HTTP.new(uri.host, uri.port)
  res.verify_mode = OpenSSL::SSL::VERIFY_NONE
  res.use_ssl = true
  response = nil
  res.start do |http|
    response = http.request(req)
  end
  puts JSON.parse(response.read_body)
  return JSON.parse(response.read_body)
  end
  
  
  def callback_method
    puts "i am in call back method with params#{params}"
  end
end
