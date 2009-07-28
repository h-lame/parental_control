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
                       begin
                         assoc.primary_key_name == @reflection.primary_key_name &&
                         assoc.macro == look_for &&
                         instance.is_a?(assoc.klass)
                       rescue NameError => e
                         false
                       end
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
      unless reciprocal_relationship.nil?
        ivar = "@#{reciprocal_relationship.name}"
        the_proxy_class = association_proxy_class(reciprocal_relationship)
        record.instance_eval do
          assoc = instance_variable_get(ivar)
          if assoc.nil?
            assoc = the_proxy_class.new(record, reciprocal_relationship)
            instance_variable_set(ivar, assoc)
          end
          assoc.target= instance
        end
      end
    end

    def association_proxy_class(reflection)
      case reflection.macro
      when :belongs_to
        if reflection.options[:polymorphic]
          ActiveRecord::Associations::BelongsToPolymorphicAssociation
        else
          ActiveRecord::Associations::BelongsToAssociation
        end
      when :has_one
        if reflection.through_reflection
          ActiveRecord::Associations::HasOneThroughAssociation
        else
          ActiveRecord::Associations::HasOneAssociation
        end
      when :has_many
        if reflection.through_reflection
          ActiveRecord::Associations::HasManyThroughAssociation
        else
          ActiveRecord::Associations::HasManyAssociation
        end
      when :has_and_belongs_to_many
        ActiveRecord::Associations::HasAndBelongsToManyAssociation
      end
    end
  end
  
  module AssociationCollectionMethods
  end
  
  module BelongsToAssociationMethods
    def self.included(base)
      base.class_eval do
        def create_with_parental_control(attributes = {})
          record = create_without_parental_control(attributes)
          set_reciprocal_instance(record, @owner)
          record
        end
        alias_method_chain :create, :parental_control
    
        def build_with_parental_control(attributes = {})
          record = build_without_parental_control(attributes)
          set_reciprocal_instance(record, @owner)
          record
        end
        alias_method_chain :build, :parental_control
    
        def find_target_with_parental_control
          record = find_target_without_parental_control
          set_reciprocal_instance(record, @owner)
          record
        end
        alias_method_chain :find_target, :parental_control
      end
    end
  end
  
  module HasOneAssociationMethods
    def self.included(base)
      base.class_eval do
        def new_record_with_parental_control(replace_existing, &block)
          new_record_without_parental_control(replace_existing) do |reflection|
            record = block.call(reflection)
            set_reciprocal_instance(record, @owner)
            record
          end
        end
        alias_method_chain :new_record, :parental_control
                
        # def create_with_parental_control(attributes = {}, replace_existing = true)
        #   record = create_without_parental_control(attributes, replace_existing)
        #   set_reciprocal_instance(record, @owner)
        #   record
        # end
        # alias_method_chain :create, :parental_control
        #     
        # def build_with_parental_control(attributes = {}, replace_existing = true)
        #   record = build_without_parental_control(attributes, replace_existing)
        #   set_reciprocal_instance(record, @owner)
        #   record
        # end
        # alias_method_chain :build, :parental_control
    
        def find_target_with_parental_control
          record = find_target_without_parental_control
          set_reciprocal_instance(record, @owner)
          record
        end
        alias_method_chain :find_target, :parental_control
      end
    end
  end
  
  module HasManyAssociationMethods
    def self.included(base)
      base.class_eval do
        
        def add_record_to_target_with_callbacks_with_parental_control(record, &block)
          set_reciprocal_instance(record, @owner)
          add_record_to_target_with_callbacks_without_parental_control(record, &block)
        end
        alias_method_chain :add_record_to_target_with_callbacks, :parental_control
        
        # def create_with_parental_control(attributes = {}, &block)
        #   record = create_without_parental_control(attributes, &block)
        #   set_reciprocal_instance(record, @owner)
        #   record
        # end
        # alias_method_chain :create, :parental_control
        # 
        # def build_with_parental_control(attributes = {}, &block)
        #   record = build_without_parental_control(attributes, &block)
        #   set_reciprocal_instance(record, @owner)
        #   record
        # end
        # alias_method_chain :build, :parental_control
        
        def find_target_with_parental_control
          records = find_target_without_parental_control
          records.each do |record|
            set_reciprocal_instance(record, @owner)
          end
          records
        end
        alias_method_chain :find_target, :parental_control
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
