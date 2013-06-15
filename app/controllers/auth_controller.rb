class AuthController < ApplicationController
  def index
  end

  def home
    @start_date = Date.strptime(session[:date], "%Y-%m-%d")
    graph = Koala::Facebook::API.new(session[:user_token])
    @query = "home?since=#{@start_date}&until=#{@start_date + 1.day}"
    @display_objects = []
    feeds = graph.get_connections("me", "home?since=#{@start_date}&until=#{@start_date + 1.day}")
    feeds.each do |feed|
      obj = {}
      obj["id"] = feed["from"]["id"]
      obj["name"] = feed["from"]["name"]
      obj["message"] = feed["message"]
      obj["type"] = feed["type"]
      obj["action_type"] = feed["status_type"]
      obj["link"] = feed["link"]
      obj["picture"] = feed["picture"]
      obj["likesCount"] = feed["likes"]["count"] if feed["likes"]
      obj["commentsCount"] = feed["comments"]["data"].count if feed["comments"] and feed["comments"]["data"]
      @display_objects.push obj
    end
  end

  def callback
    user = request.env['omniauth.auth']
    session[:user_token] = user["credentials"].token
    redirect_to :action => "home"
  end
  
  def logout
  end

  def login
    session[:date] = params[:dp1]
    redirect_to "/auth/facebook/"
  end
end
