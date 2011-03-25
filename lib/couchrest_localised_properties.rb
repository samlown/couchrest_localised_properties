#
# CouchRest Localised Properties
#

require 'couchrest_model'

module CouchRest
  module LocalisedProperties

    extend ActiveSupport::Concern

    def read_localised_attribute(property)
      attr = (self[find_property!(property).to_s] || {})
      attr[I18n.locale.to_s] || attr[I18n.default_locale.to_s]
    end

    def write_localised_attribute(property, value)
      prop = find_property!(property)
      key = prop.to_s
      if value.is_a?(Hash) # from mass-asign
        self[key] = value
        self[key].each do |k,v|
          self[key][k] = prop.cast(self, v)
        end
      else
        self[key] ||= { }
        self[key][I18n.locale.to_s] = prop.is_a?(String) ? value : prop.cast(self, value)
      end
    end

    module ClassMethods

      def localised_property(name, *options, &block)
        # Create a normal property
        p = property(name, *options, &block)
        raise "Localised properties cannot be used with Hashes!" if p.type == Hash
        # Override the normal methods with special accessors
        create_localised_property_getter(p)
        create_localised_property_setter(p)
      end

      protected

      # defines the getter for the property (and optional aliases)
      def create_localised_property_getter(property)
        # meth = property.name
        class_eval <<-EOS, __FILE__, __LINE__ + 1
          def #{property.name}
            read_localised_attribute('#{property.name}')
          end
        EOS
        if ['boolean', TrueClass.to_s.downcase].include?(property.type.to_s.downcase)
          class_eval <<-EOS, __FILE__, __LINE__
            def #{property.name}?
              value = read_localised_attribute('#{property.name}')
              !(value.nil? || value == false)
            end
          EOS
        end
      end

      # defines the setter for the property (and optional aliases)
      def create_localised_property_setter(property)
        property_name = property.name
        class_eval <<-EOS
          def #{property_name}=(value)
            write_localised_attribute('#{property_name}', value)
          end
        EOS
      end

    end

  end
end

# Add self to the CouchRest Model Base
CouchRest::Model::Base.class_eval do
  include CouchRest::LocalisedProperties
end

