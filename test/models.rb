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
      t.integer :almanac_id
    end
    
    create_table :zines, :force => true do |t|
      t.string :title
    end

    create_table :magic_tricks, :force => true do |t|
      t.string :magic_word
      t.integer :revealable_id
      t.string :revealable_type
    end
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }

class Man < ActiveRecord::Base
  has_one :face
  has_many :interests
  has_one :magic_trick, :as => :revealable
end

class Face < ActiveRecord::Base
  belongs_to :man
  has_one :magic_trick, :as => :revealable
end

class Interest < ActiveRecord::Base
  belongs_to :man
  belongs_to :zine
end

class Zine < ActiveRecord::Base
  has_many :interests
  has_one :magic_trick, :as => :revealable
end

class MagicTrick < ActiveRecord::Base
  belongs_to :revealable, :polymorphic => true
end

compendia_one = Zine.create(:title => 'Staying in \'08')

compendia_two = Zine.create(:title => 'Outdoor Pursuits 2k+8')

dave = Man.new(:name => 'Dave')
dave.build_face(:description => 'trusting')
dave.interests.build(:topic => 'Trainspotting', :zine => compendia_one)
dave.interests.build(:topic => 'Birdwatching', :zine => compendia_one)
dave.interests.build(:topic => 'Stamp Collecting', :zine => compendia_one)
dave.save!

steve = Man.new(:name => 'Steve')
steve.build_face(:description => 'weather beaten')
steve.interests.build(:topic => 'Hunting', :zine => compendia_two)
steve.interests.build(:topic => 'Woodsmanship', :zine => compendia_two)
steve.interests.build(:topic => 'Survival', :zine => compendia_two)
steve.save!