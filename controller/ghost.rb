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

require 'sinatra/base'
require 'coffee-script'
require "#{File.dirname(__FILE__)}/../database/database"
require "#{File.dirname(__FILE__)}/../vendor/harvesine"

DOWNTOWN = {lat: 32.7472844, lng: -97.0987854}

class Ghost < Sinatra::Base
  set :views, Proc.new { File.join(root, '../views') }
  set :public_folder, "#{File.dirname(__FILE__)}/../public"

  post '/save_position' do
    pos = {lat: params[:position][:lat].to_f, lng: params[:position][:lng].to_f}

    if HaversineFormula.new(DOWNTOWN, pos).distance >= 50
      puts 'Leave city'
    else
      vehicle = Vehicle.where(vehicle_id: params['id']).first
      if vehicle.nil? # Create a new entry
        vehicle = Vehicle.new(vehicle_id: params['id'], vehicle_type: params['type'])
      end

      Thread.new do
        position = Position.new(direction: params['direction'].to_i,
                                latitude: params[:position][:lat].to_f,
                                longitude: params[:position][:lng].to_f)
        position.save!

        vehicle.positions << position
        vehicle.save!
      end
    end

    ActiveRecord::Base.connection.close

  end

  get '/' do
    erb :map, locals: {downtown: DOWNTOWN, vehicles: Vehicle.all}
  end

  get '/update' do
    vehicles = []
    Vehicle.all.each do |vehicle|
      vehicles << vehicle.display
    end

    content_type :json
    vehicles.to_json
  end
end