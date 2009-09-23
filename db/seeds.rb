# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Section.create([ 
  { :name => 'Breve', :description => 'RESERVED. This is the default section used for posts.' }
])

## dummy users 
users = User.create([ 
  { :nickname => 'Juris',    :password => 'password' },  
  { :nickname => 'Kreek\'t', :password => 'password' },
  { :nickname => 'Libat',    :password => 'password' },
  { :nickname => 'Vicky',    :password => 'password' },
  { :nickname => 'Marj',     :password => 'password' },
  { :nickname => 'Justin',   :password => 'password' },
  { :nickname => 'Jared',    :password => 'password' },
  { :nickname => 'Jace',     :password => 'password' },
  { :nickname => 'Jaden',    :password => 'password' },
  { :nickname => 'Myrhon',   :password => 'password' }
])

# dummy articles
10.times do |i|
  users.each do |user|
    Post.create(
      :user_id => user.id,
      :points  => rand(10) + 1,
      :url     => "http://www.post#{i}.com", 
      :title   => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
    )
  end
end
