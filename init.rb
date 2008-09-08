require 'parental_control'

ActiveRecord::Associations::AssociationProxy.send(:include, ParentalControl::AssociationProxyMethods)
ActiveRecord::Associations::BelongsToAssociation.send(:include, ParentalControl::BelongsToAssociationMethods)
ActiveRecord::Associations::HasOneAssociation.send(:include, ParentalControl::HasOneAssociationMethods)
ActiveRecord::Associations::HasManyAssociation.send(:include, ParentalControl::HasManyAssociationMethods)
