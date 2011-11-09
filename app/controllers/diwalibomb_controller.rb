class DiwalibombController < ApplicationController

  APP_ID = "XXX"
  APP_SECRET = "XXX"

  def index
    if (session[:fb_user_id].blank?)
    session[:oauth] = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, oauth_redirect_url)
    end
    @app_id = APP_ID
    if params[:signed_request]
      user_data = session[:oauth].parse_signed_request(params[:signed_request])
      session[:fb_user_id] = user_data["user_id"]
      session[:access_token] = user_data["oauth_token"]
    end
    if session[:access_token]
      graph = Koala::Facebook::API.new(session[:access_token])
      @name = graph.get_object("me")["first_name"]
      @friends = graph.get_connections("me", "friends")
    end
    crackers = get_firecracker(true)
    @crackers = crackers.each_with_index.map {|c, i| ["#{c[:name]}", i]}
  end

  def redirect
    session[:access_token] = session[:oauth].get_access_token(params[:code]) if params[:code]
    if session[:access_token].blank?
      flash[:error] = "You didn't authorize the application. Please authorize the application to throw a firecracker on your friend's wall!"
      redirect_to :action => "authorize_app" and return
    end
    redirect_to "http://apps.facebook.com/diwalibomb"
  end

  def get_friend_and_cracker
    if session[:access_token]
      graph = Koala::Facebook::API.new(session[:access_token])
      @name = graph.get_object("me")["first_name"]
      if request.post?
        if params[:userid].blank?
          friends = graph.get_connections("me", "friends")
          @selected_friend = friends[rand(friends.size)]
        else
          @selected_friend = {"name" => params[:name], "id" => params[:userid]}
        end
        @selected_cracker = get_firecracker(true)[params[:cracker].to_i]
      else
        friends = graph.get_connections("me", "friends")
        @selected_friend = friends[rand(friends.size)]  # {"name"=>"Bill Baba", "id"=>"100001497688538"}
        @selected_cracker = get_firecracker
      end
    end
    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.js
    end
  end

  def get_firecracker(all = false)
    cracker = [ {:name => "MIRCHI BOMB", :description => "just threw a MIRCHI BOMB on your wall. Fight back...!!!", :picture => "http://www.railsify.in/images/mirchi_bomb.jpg"},
                {:name => "BULLET BOMB", :description => "just threw a BULLET BOMB on your wall. Fight back...!!!", :picture => "http://www.railsify.in/images/bullet.jpg"},
                {:name => "OON BOMB", :description => "just threw an OON BOMB on your wall. It was nasty, fight back...!!!", :picture => "http://www.railsify.in/images/oon.jpg"},
                {:name => "SUTLI BOMB", :description => "just destroyed your wall with a desi SUTLI BOMB. Fight back...!!!", :picture => "http://www.railsify.in/images/sutli.jpg"},
                {:name => "HYDRO BOMB", :description => "just destroyed your wall with a HYDRO BOMB. Fight back...!!!", :picture => "http://www.railsify.in/images/hydro.jpg"},
                {:name => "PHUSS BOMB", :description => "just threw a bomb on your wall, but luckily it was a PHUSS BOMB. Enjoyyy...!!!", :picture => "http://www.railsify.in/images/phuss.jpg"},
                {:name => "PHULJARI", :description => "just burnt your wall with a PHULJARI. Fight back...!!!", :picture => "http://www.railsify.in/images/phuljhari.jpg"},
                {:name => "MEHATAB", :description => "just burnt your wall with a MEHATAB. Fight back...!!!", :picture => "http://www.railsify.in/images/rassi.jpg"},
                {:name => "RASSI", :description => "just burnt your wall with a RASSI. Fight back...!!!", :picture => "http://www.railsify.in/images/rassi.jpg"},
                {:name => "CHAKARGHINNI", :description => "just adorned you wall with a CHAKARGHINNI. Dance around...!!!", :picture => "http://www.railsify.in/images/chakhri.jpg"},
                {:name => "ANAR", :description => "just adorned you wall with an ANAR. Celebration time...!!!", :picture => "http://www.railsify.in/images/anar.jpg"},
                {:name => "ANAR BOMB", :description => "just placed an ANAR BOMB on your wall. Beware of the blast in the end...!!!", :picture => "http://www.railsify.in/images/anarbomb.jpg"},
                {:name => "ROCKET", :description => "just fired a ROCKET on your wall. Dodge...!!!", :picture => "http://www.railsify.in/images/rocket.jpg"},
                {:name => "WHISTLING ROCKET", :description => "just fired a WHISTLING ROCKET on your wall. Dodge and whistle... ;)", :picture => "http://www.railsify.in/images/w_rocket.jpg"},
                {:name => "CHUTPUTIA", :description => "just tried to destroy your wall with a CHUTPUTIA. Hilarious...!!!", :picture => "http://www.railsify.in/images/chutputi.png"},
                {:name => "CHUTPUTIA GUN", :description => "is after your life and fired at you with the CHUTPUTIA GUN. Fight back...!!!", :picture => "http://www.railsify.in/images/chutputi.png"},
                {:name => "CHATAAI", :description => "just planted a CHATAI on your wall. This is gonna do some serious damage...!!!", :picture => "http://www.railsify.in/images/chatai.jpg"},
                {:name => "DOUBLE SOUND BOMB", :description => "just planted a DOUBLE SOUND BOMB on your wall. Fight back...!!!", :picture => "http://www.railsify.in/images/sound2.jpg"},
                {:name => "7 SOUND BOMB", :description => "just planted a 7 SOUND BOMB on your wall. Stay indoors, it is gonna take long...;)", :picture => "http://www.railsify.in/images/sound7.jpg"},
                {:name => "SNAKE TABLET", :description => "just spoiled your wall by burning a SNAKE TABLET on it. Pathetic...!!!", :picture => "http://www.railsify.in/images/snake.JPG"},
                {:name => "TRAIN", :description => "tied a thread between the two walls, and launched a TRAIN. Impressive firecraker...!!!", :picture => "http://www.railsify.in/images/train.jpg"}
              ]
    all ? cracker : cracker[rand(cracker.size)]
  end
  
end
