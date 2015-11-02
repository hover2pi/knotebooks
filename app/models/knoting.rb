class Knoting < ActiveRecord::Base
  belongs_to :knotebook
  belongs_to :knote
  acts_as_list :scope => :knotebook
  
  def self.to_fixture
    File.open(File.expand_path("test/fixtures/#{table_name}.yml", RAILS_ROOT), "w") do |file|
      file << self.find(:all).inject("---\n") do |s, record|
        self.columns.inject(s+"#{record.id}:\n") do |s, c|
          s+"  #{{c.name => record.attributes[c.name]}.to_yaml[5..-1]}"
        end
      end
    end
  end
end
