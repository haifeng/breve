module ActiveRecord
  module ActsAsPost
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_post 
        class_eval <<-EOV
          include ActiveRecord::ActsAsPost::InstanceMethods
        EOV
      end

      def latest(page)
        paginate :page => page, :order => 'created_at desc', :limit => 250
      end
  
      def top_ranked(page)
        paginate :page => page, :order => 'rank desc', :limit => 250
      end
      
      def method_missing(name, *args)
        super(name, args) unless name.to_s =~ /_by$/

        name = name.to_s.sub(/_by$/, '')
        source = self.to_s.downcase.pluralize
        author = User.find(args.first)
        page   = args.last
        author.send("#{name}_#{source}").paginate(:page => page)
      end
    end
    
    module InstanceMethods
      def owned_by?(author)
        if author.instance_of? Fixnum 
          self.author.id == author 
        else
          self.author == author
        end
      end
      
      def headline(mode = :full, maxlen = -1)
        @headline = (self[:title].blank? ? self[:text] : self[:title])
        @headline = @headline.truncate(maxlen) if mode == :truncate
        @headline
      end
      
      protected
      def ensure_it_has_no_comments
        self.comments.empty?
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::ActsAsPost
