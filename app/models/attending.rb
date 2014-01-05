class Attending
  
  class << self
    # Adds the user to the next meeting based on the passed in params
    def add(user_info)
      new user_info
    end

    # Removes a user from the next meeting
    def cancel(username)
      REDIS.hdel "Attending:#{Event.current}", username
    end
  
    # Lists who is coming to the next meeting
    def list
      REDIS.hgetall("Attending:#{Event.current}").values.map {|x|JSON.parse(x)}
    end

    # Deletes a meeting for a given date
    def delete_list_with(date)
      REDIS.del "Attending:#{date}"
    end

    # Checks if a user is signed up to attend the next meeting
    def exists?(username)
      REDIS.hexists("Attending:#{Event.current}", username)
    end
  end

  private
    # Creates variables based on the passed in hash
    def initialize user_info
      @username = user_info["login"]
      @avatar = user_info["avatar_url"]
      @url = user_info["html_url"]
      save
    end

    # Saves the user data to the next meeting
    def save
      REDIS.hset "Attending:#{Event.current}", @username, {username: @username, avatar: @avatar, url: @url}.to_json
    end
    
end
