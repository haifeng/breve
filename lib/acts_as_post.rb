module ActiveRecord
  module ActsAsPost
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_post; end

      def latest(page)
        paginate :page => page, :order => 'created_at desc', :include => [ :author ]
      end
  
      def top_ranked(page)
        paginate :page => page, :order => 'rank desc', :include => [ :author ]
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
  end
end

ActiveRecord::Base.send :include, ActiveRecord::ActsAsPost
