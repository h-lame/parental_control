require(File.join(File.dirname(__FILE__), 'test_helper'))

class ParentalControlHasOneTests < Test::Unit::TestCase
  
  def test_parent_instance_should_be_shared_with_child_on_find
    m = Man.find(:first)
    f = m.face
    assert_equal m.name, f.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to parent instance"
    f.man.name = 'Mungo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to child-owned instance"
  end
  
  def test_parent_instance_should_be_shared_with_newly_built_child
    m = Man.find(:first)
    f = m.build_face(:description => 'haunted')
    assert_not_nil f.man
    assert_equal m.name, f.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to parent instance"
    f.man.name = 'Mungo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to just-built-child-owned instance"
  end
  
  def test_parent_instance_should_be_shared_with_newly_created_child
    m = Man.find(:first)
    f = m.create_face(:description => 'haunted')
    assert_not_nil f.man
    assert_equal m.name, f.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to parent instance"
    f.man.name = 'Mungo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to newly-created-child-owned instance"
  end

  def test_parent_instance_should_be_shared_with_newly_created_child_via_bang_method
    m = Man.find(:first)
    f = m.face.create!(:description => 'haunted')
    assert_not_nil f.man
    assert_equal m.name, f.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to parent instance"
    f.man.name = 'Mungo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to newly-created-child-owned instance"
  end

  def test_parent_instance_should_be_shared_with_newly_built_child_when_we_dont_replace_existing
    m = Man.find(:first)
    f = m.build_face({:description => 'haunted'}, false)
    assert_not_nil f.man
    assert_equal m.name, f.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to parent instance"
    f.man.name = 'Mungo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to just-built-child-owned instance"
  end
  
  def test_parent_instance_should_be_shared_with_newly_created_child_when_we_dont_replace_existing
    m = Man.find(:first)
    f = m.create_face({:description => 'haunted'}, false)
    assert_not_nil f.man
    assert_equal m.name, f.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to parent instance"
    f.man.name = 'Mungo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to newly-created-child-owned instance"
  end

  def test_parent_instance_should_be_shared_with_newly_created_child_via_bang_method_when_we_dont_replace_existing
    m = Man.find(:first)
    f = m.face.create!({:description => 'haunted'}, false)
    assert_not_nil f.man
    assert_equal m.name, f.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to parent instance"
    f.man.name = 'Mungo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to newly-created-child-owned instance"
  end

  def test_parent_instance_should_be_shared_with_replaced_via_accessor_child
    m = Man.find(:first)
    f = Face.new(:description => 'haunted')
    m.face = f
    assert_not_nil f.man
    assert_equal m.name, f.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to parent instance"
    f.man.name = 'Mungo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to replaced-child-owned instance"
  end

  def test_parent_instance_should_be_shared_with_replaced_via_method_child
    m = Man.find(:first)
    f = Face.new(:description => 'haunted')
    m.face.replace(f)
    assert_not_nil f.man
    assert_equal m.name, f.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to parent instance"
    f.man.name = 'Mungo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to replaced-child-owned instance"
  end

  def test_parent_instance_should_be_shared_with_replaced_via_method_child_when_we_dont_replace_existing
    m = Man.find(:first)
    f = Face.new(:description => 'haunted')
    m.face.replace(f, false)
    assert_not_nil f.man
    assert_equal m.name, f.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to parent instance"
    f.man.name = 'Mungo'
    assert_equal m.name, f.man.name, "Name of man should be the same after changes to replaced-child-owned instance"
  end
  
  def test_should_still_raise_type_mismatch_when_assigning_something_thats_not_an_active_record_object
    m = Man.find(:first)
    assert_raise(ActiveRecord::AssociationTypeMismatch) do
      m.face = 1
    end

    assert_raise(ActiveRecord::AssociationTypeMismatch) do
      m.face.replace(1)
    end
  end
end

class ParentalControlHasManyTests < Test::Unit::TestCase

  def test_parent_instance_should_be_shared_with_every_child_on_find
    m = Man.find(:first)
    is = m.interests
    is.each do |i|
      assert_equal m.name, i.man.name, "Name of man should be the same before changes to parent instance"
      m.name = 'Bongo'
      assert_equal m.name, i.man.name, "Name of man should be the same after changes to parent instance"
      i.man.name = 'Mungo'
      assert_equal m.name, i.man.name, "Name of man should be the same after changes to child-owned instance"
    end
  end
  
  def test_parent_instance_should_be_shared_with_newly_built_child
    m = Man.find(:first)
    i = m.interests.build(:topic => 'Industrial Revolution Re-enactment')
    assert_not_nil i.man
    assert_equal m.name, i.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to parent instance"
    i.man.name = 'Mungo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to just-built-child-owned instance"
  end
  
  def test_parent_instance_should_be_shared_with_newly_block_style_built_child
    m = Man.find(:first)
    i = m.interests.build {|ii| ii.topic = 'Industrial Revolution Re-enactment'}
    assert_not_nil i.topic, "Child attributes supplied to build via blocks should be populated"
    assert_not_nil i.man
    assert_equal m.name, i.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to parent instance"
    i.man.name = 'Mungo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to just-built-child-owned instance"
  end
  
  def test_parent_instance_should_be_shared_with_newly_created_child
    m = Man.find(:first)
    i = m.interests.create(:topic => 'Industrial Revolution Re-enactment')
    assert_not_nil i.man
    assert_equal m.name, i.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to parent instance"
    i.man.name = 'Mungo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to newly-created-child-owned instance"
  end

  def test_parent_instance_should_be_shared_with_newly_created_via_bang_method_child
    m = Man.find(:first)
    i = m.interests.create!(:topic => 'Industrial Revolution Re-enactment')
    assert_not_nil i.man
    assert_equal m.name, i.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to parent instance"
    i.man.name = 'Mungo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to newly-created-child-owned instance"
  end

  def test_parent_instance_should_be_shared_with_newly_block_style_created_child
    m = Man.find(:first)
    i = m.interests.create {|ii| ii.topic = 'Industrial Revolution Re-enactment'}
    assert_not_nil i.topic, "Child attributes supplied to create via blocks should be populated"
    assert_not_nil i.man
    assert_equal m.name, i.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to parent instance"
    i.man.name = 'Mungo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to newly-created-child-owned instance"
  end
  
  def test_parent_instance_should_be_shared_with_pushed_on_child
    m = Man.find(:first)
    i = Interest.new(:topic => 'Industrial Revolution Re-enactment')
    m.interests << i
    assert_not_nil i.man
    assert_equal m.name, i.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to parent instance"
    i.man.name = 'Mungo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to pushed-on-child-owned instance"
  end

  def test_parent_instance_should_be_shared_with_replaced_via_accessor_children
    m = Man.find(:first)
    i = Interest.new(:topic => 'Industrial Revolution Re-enactment')
    m.interests = [i]
    assert_not_nil i.man
    assert_equal m.name, i.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to parent instance"
    i.man.name = 'Mungo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to replaced-child-owned instance"
  end

  def test_parent_instance_should_be_shared_with_replaced_via_method_children
    m = Man.find(:first)
    i = Interest.new(:topic => 'Industrial Revolution Re-enactment')
    m.interests.replace([i])
    assert_not_nil i.man
    assert_equal m.name, i.man.name, "Name of man should be the same before changes to parent instance"
    m.name = 'Bongo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to parent instance"
    i.man.name = 'Mungo'
    assert_equal m.name, i.man.name, "Name of man should be the same after changes to replaced-child-owned instance"
  end
  
  def test_should_still_raise_type_mismatch_when_assigning_something_thats_not_an_active_record_object
    m = Man.find(:first)
    assert_raise(ActiveRecord::AssociationTypeMismatch) do
      m.interests << 1
    end

    assert_raise(ActiveRecord::AssociationTypeMismatch) do
      m.interests = [1]
    end

    assert_raise(ActiveRecord::AssociationTypeMismatch) do
      m.interests.replace([1])
    end
  end
  
end

class ParentalControlBelongsToTests < Test::Unit::TestCase

  def test_child_instance_should_be_shared_with_parent_on_find
    f = Face.find(:first)
    m = f.man
    assert_equal f.description, m.face.description, "Description of face should be the same before changes to child instance"
    f.description = 'gormless'
    assert_equal f.description, m.face.description, "Description of face should be the same after changes to child instance"
    m.face.description = 'pleasing'
    assert_equal f.description, m.face.description, "Description of face should be the same after changes to parent-owned instance"
  end
  
  def test_child_instance_should_be_shared_with_newly_built_parent
    f = Face.find(:first)
    m = f.build_man(:name => 'Charles')
    assert_not_nil m.face
    assert_equal f.description, m.face.description, "Description of face should be the same before changes to child instance"
    f.description = 'gormless'
    assert_equal f.description, m.face.description, "Description of face should be the same after changes to child instance"
    m.face.description = 'pleasing'
    assert_equal f.description, m.face.description, "Description of face should be the same after changes to just-built-parent-owned instance"
  end
  
  def test_child_instance_should_be_shared_with_newly_created_parent
    f = Face.find(:first)
    m = f.build_man(:name => 'Charles')
    assert_not_nil m.face
    assert_equal f.description, m.face.description, "Description of face should be the same before changes to child instance"
    f.description = 'gormless'
    assert_equal f.description, m.face.description, "Description of face should be the same after changes to child instance"
    m.face.description = 'pleasing'
    assert_equal f.description, m.face.description, "Description of face should be the same after changes to newly-created-parent-owned instance"
  end

  def test_child_instance_should_be_shared_with_replaced_via_accessor_parent
    f = Face.find(:first)
    m = Man.new(:name => 'Charles')
    f.man = m
    assert_not_nil m.face
    assert_equal f.description, m.face.description, "Description of face should be the same before changes to child instance"
    f.description = 'gormless'
    assert_equal f.description, m.face.description, "Description of face should be the same after changes to child instance"
    m.face.description = 'pleasing'
    assert_equal f.description, m.face.description, "Description of face should be the same after changes to replaced-parent-owned instance"
  end
  
  def test_child_instance_should_be_shared_with_replaced_via_method_parent
    f = Face.find(:first)
    m = Man.new(:name => 'Charles')
    f.man.replace(m)
    assert_not_nil m.face
    assert_equal f.description, m.face.description, "Description of face should be the same before changes to child instance"
    f.description = 'gormless'
    assert_equal f.description, m.face.description, "Description of face should be the same after changes to child instance"
    m.face.description = 'pleasing'
    assert_equal f.description, m.face.description, "Description of face should be the same after changes to replaced-parent-owned instance"
  end
  
  def test_should_not_try_to_set_reciprocal_instances_when_the_inverse_is_a_has_many
    i = Interest.find(:first)
    m = i.man
    assert_not_nil m.interests
    iz = m.interests.detect {|iz| iz.id == i.id}
    assert_not_nil iz
    assert_equal i.topic, iz.topic, "Interest topics should be the same before changes to child"
    i.topic = 'Eating cheese with a spoon'
    assert_not_equal i.topic, iz.topic, "Interest topics should not be the same after changes to child"
    iz.topic = 'Cow tipping'
    assert_not_equal i.topic, iz.topic, "Interest topics should not be the same after changes to parent-owned instance"
  end
  
  def test_should_still_raise_type_mismatch_when_assigning_something_thats_not_an_active_record_object
    f = Face.find(:first)
    assert_raise(ActiveRecord::AssociationTypeMismatch) do
      f.man = 1
    end

    assert_raise(ActiveRecord::AssociationTypeMismatch) do
      f.man.replace(1)
    end
  end
end

class ParentalControlMultipleHasManyReciprocalsForSameModel < Test::Unit::TestCase
  def test_that_we_can_load_associations_that_have_the_same_reciprocal_name_from_different_models
    assert_nothing_raised(ActiveRecord::AssociationTypeMismatch) do
      i = Interest.find(:first)
      z = i.zine
      m = i.man
    end
  end
  
  def test_that_we_can_create_associations_that_have_the_same_reciprocal_name_from_different_models
    assert_nothing_raised(ActiveRecord::AssociationTypeMismatch) do
      i = Interest.find(:first)
      i.build_zine(:title => 'Get Some in Winter! 2008')
      i.build_man(:name => 'Gordon')
      i.save!
    end
  end
end

class ParentalControlShouldntBreakWithPolymorphics < Test::Unit::TestCase
  def test_trying_to_create_new_polymorphics_directly_shouldnt_cause_name_errors
    f = Face.first(:first)
    assert_nothing_raised(NameError) do
      mt = MagicTrick.new(:magic_word => 'Shazam!', :revealable => f)
      mt.save!
      f.magic_trick
      mt.revealable
    end
  end

  def test_trying_to_build_new_polymorphics_via_association_shouldnt_cause_name_errors
    f = Face.first(:first)
    assert_nothing_raised(NameError) do
      mt = f.build_magic_trick(:magic_word => 'Shazam!')
      mt.save!
      f.magic_trick
      mt.revealable
    end
  end

  def test_trying_to_create_new_polymorphics_via_association_shouldnt_cause_name_errors
    f = Face.first(:first)
    assert_nothing_raised(NameError) do
      mt = f.create_magic_trick(:magic_word => 'Shazam!')
      f.magic_trick
      mt.revealable
    end
  end
  
  def test_trying_to_assign_to_polymoprhic_via_association_shouldnt_cause_name_errors
    mt = MagicTrick.create(:magic_word => 'Shazam!')
    f = Face.first
    assert_nothing_raised(NameError) do
      mt.revealable = f
      mt.save!
      mt.revealable
      f.magic_trick
    end
  end
end

class ParentalControlBelongsToPolymorphicTests < Test::Unit::TestCase

  def test_child_instance_should_be_shared_with_parent_on_find
    mt = MagicTrick.find(:first, :conditions => "revealable_type = 'Face'")
    f = mt.revealable
    assert_not_nil f.magic_trick
    assert_equal f.description, mt.revealable.description, "Description of face should be the same before changes to child instance"
    f.description = 'gormless'
    assert_equal f.description, mt.revealable.description, "Description of face should be the same after changes to child instance"
    mt.revealable.description = 'pleasing'
    assert_equal f.description, mt.revealable.description, "Description of face should be the same after changes to parent-owned instance"
  end
  
  def test_child_instance_should_be_shared_with_replaced_via_accessor_parent
    mt = MagicTrick.find(:first, :conditions => "revealable_type = 'Face'")
    f = Face.new(:description => 'happy')
    mt.revealable = f
    assert_not_nil mt.revealable
    assert_not_nil f.magic_trick
    assert_equal f.description, mt.revealable.description, "Description of face should be the same before changes to child instance"
    f.description = 'gormless'
    assert_equal f.description, mt.revealable.description, "Description of face should be the same after changes to child instance"
    mt.revealable.description = 'pleasing'
    assert_equal f.description, mt.revealable.description, "Description of face should be the same after changes to replaced-parent-owned instance"
  end
  
  def test_child_instance_should_be_shared_with_replaced_via_method_parent
    mt = MagicTrick.find(:first, :conditions => "revealable_type = 'Face'")
    f = Face.new(:description => 'happy')
    mt.revealable.replace(f)
    assert_not_nil mt.revealable
    assert_not_nil f.magic_trick
    assert_equal f.description, mt.revealable.description, "Description of face should be the same before changes to child instance"
    f.description = 'gormless'
    assert_equal f.description, mt.revealable.description, "Description of face should be the same after changes to child instance"
    mt.revealable.description = 'pleasing'
    assert_equal f.description, mt.revealable.description, "Description of face should be the same after changes to replaced-parent-owned instance"
  end
  
  # NOTE - AR doesn't throw Mismatch errors when assigning non AR polymorphics it will throw a NoMethodError
  # complaining about a lack of base_class.  We need to check that this is still the case and it's not something
  # PC is doing that causes the error. (Assumes 2.2.x or 2.3.x behaviour).
  def test_should_still_provide_default_active_record_behaviour_when_assigning_something_thats_not_an_active_record_object
    mt = MagicTrick.find(:first)
    begin
      mt.revealable = 1
      flunk 'Should have raised an error while assigning a non AR object'
    rescue NoMethodError => e
      assert_match /base_class/, e.message, "Should have raised default AR error about base_class"
    end

    mt.reload

    begin
      mt.revealable.replace(1)
      flunk 'Should have raised an error while assigning a non AR object'
    rescue NoMethodError => e
      assert_match /base_class/, e.message, "Should have raised default AR error about base_class"
    end
  end
  
end
