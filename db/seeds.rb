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
  { :email => 'juris@breve.com',    :password => 'password', :lastname => 'galang', :firstname => 'juris'   },  
  { :email => 'kreek`t@breve.com',  :password => 'password', :lastname => 'rebaño', :firstname => 'kreek`t' },  
  { :email => 'myrhon@breve.com',   :password => 'password', :lastname => 'galang', :firstname => 'myrhon'  },  
  { :email => 'jared@breve.com',    :password => 'password', :lastname => 'galang', :firstname => 'jared'   },  
  { :email => 'jace@breve.com',     :password => 'password', :lastname => 'galang', :firstname => 'jace'    },  
  { :email => 'justin@breve.com',   :password => 'password', :lastname => 'galang', :firstname => 'justin'  },  
  { :email => 'jaden@breve.com',    :password => 'password', :lastname => 'galang', :firstname => 'jaden'   }  
])

# dummy articles
(rand(10) + 5).times do |i|
  users.each do |user|
    post = Post.new(
      :author  => user,
      :points  => rand(10) + 1,
      :url     => "http://www.post#{i}.com", 
      :title   => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
    )
    post.save!
  end
end

Post.find(:all).each do |post|
  Post.destroy(post) if post.author.nil?
end

