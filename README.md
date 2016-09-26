# snowdia
Small urban GPS tracking system

=== Install ===

Ruby 2.0.0 or above

gem install bundler

cd snowdia/

bundle install

=== Setup Database ===

rake db:create
rake db:migrate

=== Start Webserver ===
rackup -o 0.0.0.0 -p 9292 rackup.ru

=== Start spawner ===
cd spawner/

ruby spawner.rb <number of entities> <server>

=== Acceptable Message ===
<server>/save_position?position[lat]=<value>&position[lng]=<value>&id=<value>&type=<value>&direction=<value>&date=<value>

=== Troubleshoot ===

If your server does not response a vehicle request, it will return a timeout error, server and vehicle class will log
this timeout.
Our integration test, we hold around 1200 entities sending current location.

=== Next steps ===

Improve Haversine formula, it's still a little simple.
