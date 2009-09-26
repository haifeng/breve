namespace :debug do
  task :list => :environment do 
    
    puts "BAD"
    Post.find(:all).each do |post|
      puts "#{post.id}\t#{post.title.truncate(50)}" if post.author.nil?
    end

    puts "GOOD"
    Post.find(:all).each do |post|
      puts "#{post.id}\t#{post.title.truncate(50)}" unless post.author.nil?
    end
  end
end
