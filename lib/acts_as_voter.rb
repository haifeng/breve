module ActionController
  module ActsAsVoter
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_voter
        class_eval <<-EOV
          include ActionController::ActsAsVoter::InstanceMethods
        EOV
      end
    end

    module InstanceMethods
      def vote
        if session[:user].nil?
          flash[:notice]    = 'ERROR: You need to be logged-in to vote.'
          session[:referer] = request.referer
          render :text => '403 Forbidden', :status => '403 Forbidden'
          return
        end

        user   = User.find current_user
        source = self.class.name.demodulize.sub(/Controller$/, '').classify.constantize

        post   = source.find(params[:id])
        post   = user.vote_for post
          
        render :text => post.points
      end
    end
  end
end

ActionController::Base.send :include, ActionController::ActsAsVoter
