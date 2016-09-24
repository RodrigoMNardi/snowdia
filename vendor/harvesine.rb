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

#
# The haversine formula is an equation important in navigation, giving great-circle
# distances between two points on a sphere from their longitudes and latitudes.
#
class HaversineFormula
  EARTH_RADIUS = 6371e3
  RAD_TO_DEG  = Math::PI / 180

  def initialize(latlong_a, latlong_b)
    @latitude_a  = latlong_a[:latitude]
    @longitude_a = latlong_a[:longitude]

    @latitude_b  = latlong_b[:latitude]
    @longitude_b = latlong_b[:longitude]
  end

  #
  # Calculates distance between two points in kilometers.
  #
  def distance
    diff_longitude = @longitude_b - @longitude_a
    diff_latitude  = @latitude_b  - @latitude_a

    angle_a = (Math.sin(radius_to_degree(diff_latitude)/2.0)) ** 2 +
        Math.cos(radius_to_degree(@latitude_a)) *
            Math.cos(radius_to_degree(@latitude_b)) *
            (Math.sin(radius_to_degree(diff_longitude)/2.0)) ** 2
    angle_c = 2 * Math.atan2(Math.sqrt(angle_a), Math.sqrt(1-angle_a))

    (EARTH_RADIUS * angle_c) / 1000 # Returns the distance in kilometers
  end

  private

  def radius_to_degree(number)
    number * RAD_TO_DEG
  end
end