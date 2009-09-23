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
  
      def submitted_by(user, page)
        paginate_by_user_id user, :page => page, :order => 'created_at desc', :include => [ :author ]
      end
  
      # TODO: Need to fix query for most discussed posts
      def most_discussed(page)
        paginate :page => page, :order => 'points desc', :include => [ :author ]
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::ActsAsPost
