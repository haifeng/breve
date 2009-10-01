module ActiveRecord
  module ActsAsPost
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_post 
        class_eval <<-EOV
          include ActiveRecord::ActsAsPost::InstanceMethods

          named_scope :latest, lambda { |*args| {
            :conditions => ['created_at > ?', 90.days.ago ], 
            :order => 'created_at desc', 
            :limit => args.first || 250 } }

          named_scope :top_ranked, lambda { |*args| {
            :order => 'rank desc', 
            :limit => args.first || 250 } }
            
          named_scope :authored_by, lambda { |author_id| { 
            :conditions => ['user_id = ?', author_id] } }
            
          named_scope :voted_by, lambda { |author_id| { 
            :include => :votes, 
            :conditions => ['votes.user_id = ?', author_id] } }
        EOV
      end


      #def method_missing(name, *args)
      #  super(name, args) unless name.to_s =~ /_by$/
      #
      #  name = name.to_s.sub(/_by$/, '')
      #  source = self.to_s.downcase.pluralize
      #  author = User.find(args.first)
      #  page   = args.last
      #  #author.send("#{name}_#{source}").paginate(:page => page)
      #end
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
