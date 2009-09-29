namespace :db do
  task :fakes => :environment do 
    users = User.create([ 
      { :email => 'juris@breve.com',   :password => 'password', :lastname => 'galang', :firstname => 'juris'   },  
      { :email => 'kreek`t@breve.com', :password => 'password', :lastname => 'rebaño', :firstname => 'kreek`t' },  
      { :email => 'myrhon@breve.com',  :password => 'password', :lastname => 'galang', :firstname => 'myrhon'  },  
      { :email => 'jared@breve.com',   :password => 'password', :lastname => 'galang', :firstname => 'jared'   },  
      { :email => 'jace@breve.com',    :password => 'password', :lastname => 'galang', :firstname => 'jace'    },  
      { :email => 'justin@breve.com',  :password => 'password', :lastname => 'galang', :firstname => 'justin'  },  
      { :email => 'jaden@breve.com',   :password => 'password', :lastname => 'galang', :firstname => 'jaden'   }  
      ])

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

    `rake db:rank:all`
  end
end

