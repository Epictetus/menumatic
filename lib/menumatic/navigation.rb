module Menumatic
  module Navigation
    class Base
      include ActionView::Helpers
      @@navigations = {}
      attr_accessor :id, :root

      class << self
        def navigate_to(label, destination, options = {}, html_options = {})
          if block_given?
            item = self.get_instance.root.navigate_to(label, destination, options, html_options, &Proc.new)
          else
            item = self.get_instance.root.navigate_to(label, destination, options, html_options)
          end
        end

        def get_instance
          id = self.name.split("Navigation").first.underscore.to_sym 
          @@navigations[id] = self.new(id) unless @@navigations.has_key?(id)
          @@navigations[id]
        end

        def get(id)
          unless @@navigations.has_key?(id)
            Module.const_get("#{id.to_s.camelize}Navigation").get_instance
          end
          @@navigations[id]
        end

        def destroy_all
          @@navigations = {}
        end
      end

      def initialize(id)
        self.id = id
        self.root = Menumatic::Navigation::Item.new("Root", "javascript:void(0)", {:root => true})
      end

      def items
        self.root.items
      end

    end
  end
end
