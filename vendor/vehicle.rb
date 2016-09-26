#
#  Copyright (c) 2016, Rodrigo Mello Nardi
#  All rights reserved.
#  
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#  
#  1. Redistributions of source code must retain the above copyright notice, this
#     list of conditions and the following disclaimer. 
#  2. Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#  
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
#  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#  
#  The views and conclusions contained in the software and documentation are those
#  of the authors and should not be interpreted as representing official policies, 
#  either expressed or implied, of the FreeBSD Project.
#

require 'rest-client'
require 'uuidtools'

#
# Simulates a vehicle using SNOWDIA GPS tracking system.
#
class Vehicle
  #
  # Direction - 0 North, 90 West, 180 South, 270 East
  #
  def initialize(type, speed)
    raise "Invalid speed set. (#{speed})" if !(speed.is_a? Integer or speed.is_a? Float) and speed <= 0
    @id        = UUIDTools::UUID.random_create    # Unique IDENTIFY
    @speed     = speed                            #
    @direction = 0
    @type      = type
    lat        = 33.129099 + rand(25)  / 1000
    lng        = -96.768673 + rand(25) / 1000
    @position  = {lat: lat, lng: lng}
  end

  def walk
    change_direction
    update
    send_position
  end

  private

  def change_direction
    return if rand(10)%2 == 0
    @direction = rand(359)
  end

  #
  # Update vehicle position when routing NORTH increase longitude, East increase latitude,
  # South decrease longitude and West decrease latitude.
  #
  def update
    case @direction
      when 0  # NORTH
        @position[:lng] += @speed
      when 90 # WEST
        @position[:lat] -= @speed
      when 180 # SOUTH
        @position[:lng] -= @speed
      when 270 # EAST
        @position[:lat] += @speed
      else
        if (1..89).include? @direction   # NORTH - WEST
          @position[:lng] += @speed
          @position[:lat] -= @speed
        end

        if (91..179).include? @direction   # SOUTH - WEST
          @position[:lng] -= @speed
          @position[:lat] -= @speed
        end

        if (181..268).include? @direction   # SOUTH - EAST
          @position[:lng] -= @speed
          @position[:lat] += @speed
        end

        if (271..359).include? @direction   # NORTH - EAST
          @position[:lng] += @speed
          @position[:lat] += @speed
        end
    end
  end

  def send_position
    msg = {position: @position, id: @id.to_s,
           direction: @direction, type: @type,
           date: Time.now.strftime('%m/%d/%Y %I:%M%p')}
    puts msg.inspect
    RestClient.post 'http://euqueroreciclar.eco.br:9090/save_position', msg, {content_type: :json, accept: :json}
  end
end
