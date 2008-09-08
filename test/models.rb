ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => File.join(File.dirname(__FILE__), 'test.db')
)

class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :men, :force => true do |t|
      t.string  :name
    end

    create_table :faces, :force => true do |t|
      t.string  :description
      t.integer :man_id
    end
    
    create_table :interests, :force => true do |t|
      t.string :topic
      t.integer :man_id
    end
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }

class Man < ActiveRecord::Base
  has_one :face
  has_many :interests
end

class Face < ActiveRecord::Base
  belongs_to :man
end

class Interest < ActiveRecord::Base
  belongs_to :man
end

dave = Man.new(:name => 'Dave')
dave.build_face(:description => 'trusting')
dave.interests.build(:topic => 'Trainspotting')
dave.interests.build(:topic => 'Birdwatching')
dave.interests.build(:topic => 'Stamp Collecting')
dave.save!

steve = Man.new(:name => 'Steve')
steve.build_face(:description => 'weather beaten')
steve.interests.build(:topic => 'Hunting')
steve.interests.build(:topic => 'Woodsmanship')
steve.interests.build(:topic => 'Survival')
steve.save!