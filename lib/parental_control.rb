module ParentalControl
  
  module AssociationProxyMethods
    def cached_reciprocal_assocation_method_name(record, instance)
      :"best_guess_reciprocal_association_for_#{@reflection.name}_from_#{instance.class.name.underscore}"
    end
    
    def set_reciprocal_instance(record, instance)
      return if record.nil?
      # NOTE: Right now it only really makes sense to cope with a has_one 
      # reciprocal association for belongs_to.      
      reciprocal_relationship = nil
      reciprocal_method_name = cached_reciprocal_assocation_method_name(record, instance)
      if record.class.respond_to?(reciprocal_method_name)
        reciprocal_relationship = record.class.send(reciprocal_method_name)
      else
        look_for = if @reflection.macro == :belongs_to
                     :has_one
                   else
                     :belongs_to
                   end 
        candidates = record.class.reflect_on_all_associations.select do |assoc|
                       assoc.primary_key_name == @reflection.primary_key_name &&
                       assoc.macro == look_for &&
                       assoc.klass == instance.class
                     end
        if candidates.size == 1
          record.class.class_eval %Q{
            def self.#{reciprocal_method_name}
              return reflect_on_association(:#{candidates.first.name})
            end
          }
          reciprocal_relationship = candidates.first
        end
      end
      record.send("#{reciprocal_relationship.name}=", instance) unless reciprocal_relationship.nil?
    end
  end
  
  module AssociationCollectionMethods
  end
  
  module BelongsToAssociationMethods
    def self.included(base)
      base.class_eval do
        def create_with_self_control(attributes = {})
          record = create_without_self_control(attributes)
          set_reciprocal_instance(record, @owner)
          record
        end
        alias_method_chain :create, :self_control
    
        def build_with_self_control(attributes = {})
          record = build_without_self_control(attributes)
          set_reciprocal_instance(record, @owner)
          record
        end
        alias_method_chain :build, :self_control
    
        def find_target_with_self_control
          record = find_target_without_self_control
          set_reciprocal_instance(record, @owner)
          record
        end
        alias_method_chain :find_target, :self_control
      end
    end
  end
  
  module HasOneAssociationMethods
    def self.included(base)
      base.class_eval do
        def create_with_self_control(attributes = {}, replace_existing = true)
          record = create_without_self_control(attributes, replace_existing)
          set_reciprocal_instance(record, @owner)
          record
        end
        alias_method_chain :create, :self_control
    
        def build_with_self_control(attributes = {}, replace_existing = true)
          record = build_without_self_control(attributes, replace_existing)
          set_reciprocal_instance(record, @owner)
          record
        end
        alias_method_chain :build, :self_control
    
        def find_target_with_self_control
          record = find_target_without_self_control
          set_reciprocal_instance(record, @owner)
          record
        end
        alias_method_chain :find_target, :self_control
      end
    end
  end
  
  module HasManyAssociationMethods
    def self.included(base)
      base.class_eval do
        def create_with_self_control(attributes = {})
          record = create_without_self_control(attributes)
          set_reciprocal_instance(record, @owner)
          record
        end
        alias_method_chain :create, :self_control
        
        def build_with_self_control(attributes = {})
          record = build_without_self_control(attributes)
          set_reciprocal_instance(record, @owner)
          record
        end
        alias_method_chain :build, :self_control
        
        def find_target_with_self_control
          records = find_target_without_self_control
          records.each do |record|
            set_reciprocal_instance(record, @owner)
          end
          records
        end
        alias_method_chain :find_target, :self_control
      end
    end
  end
    
  # Not yet... :(
  
  module BelongsToPolymorphicAssociationMethods
  end
  
  module HasAndBelongsToManyAssociationMethods
  end
  
  module HasManyThroughAssociationMethods
  end
  
  module HasOneThroughAssociationMethods
  end
  
end
