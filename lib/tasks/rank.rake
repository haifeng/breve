namespace :db do
  namespace :rank do
    desc "compute rank for posts"
    task :posts => :environment  do
      Post.update_all "rank = (points - 1) / (EXTRACT(epoch from AGE(NOW() at time zone 'UTC', created_at)) / 60 / 60 + 2) ^ 1.5"
    end

    desc "compute rank for comments"
    task :comments => :environment do
      Comment.update_all "rank = (points - 1) / (EXTRACT(epoch from AGE(NOW() at time zone 'UTC', created_at)) / 60 / 60 + 2) ^ 1.5"
    end
    
    desc "show rankings"
    task :list => :environment do 
      puts "Posts"
      puts "--------"
      Post.find(:all, :order => 'rank DESC').each do |a|
        puts "#{a.user.nickname}\t#{a.created_at}\t#{a.points}\t#{a.rank}"
      end
      puts
      
      puts "Comments"
      puts "--------"
      Comment.find(:all, :order => 'rank DESC').each do |a|
        puts "#{a.user.nickname}\t#{a.created_at}\t#{a.points}\t#{a.rank}"
      end
    end
    
    desc "compute rank for posts and comments"
    task :all, :needs => %w(posts comments)
  end
end
