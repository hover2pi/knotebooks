require File.join(RAILS_ROOT, 'spec', 'blueprints')

Concept.delete_all
%w{physics mathematics introduction definition conclusion}.each do |c|
  Concept.find_or_create_by_name(c)
end

User.delete_all
tom = User.make(:tom)
joe = User.make(:joe)

Knotebook.delete_all
Knote.delete_all

# Lesson.all.each do |lesson|
#   knotes = []
#   lesson.sections.each do |section|
#     knotes << Knote.make(:user => joe, :concepts_list => "physics", :title => section.title, :content => section.content )
#   end
#   abstract = lesson.abstract.length > 10 ? lesson.abstract : "Lorem Ipsum Dolor Sit Amet"
#   Knotebook.make(:user => joe, :knotes => knotes, :title => lesson.title, :abstract => abstract)
# end

# 25.times do
#   knotes = []
#   4.times { knotes << Knote.make(:user => tom, :concepts => [Concept.all.rand]) }
#   kb = Knotebook.make(:user => tom, :knotes => knotes)
# 
#   4.times { knotes << Knote.make(:user => joe, :concepts => [Concept.all.rand]) }
#   kb = Knotebook.make(:user => joe, :knotes => knotes)
#   
#   user = User.make
#   4.times { knotes << Knote.make(:user => user, :concepts => [Concept.all.rand]) }
#   kb = Knotebook.make(:user => user, :knotes => knotes)
# end
# 
# 200.times do
#   Comment.make(:user => User.all.rand, :commentable => User.all.rand)
#   Comment.make(:user => User.all.rand, :commentable => Knotebook.all.rand)
# end

# kb = Knotebook.create(:user => tom, :title => "Easy Knotebook", :abstract => "This is an easy knotebook")
# kb.add_topics "Mathematics, Physics"
# 
# k = kb.knotes.create(:user => tom, :title => "Easy Knote Introduction", :content => "This is an easy knote", :difficulty => 0, :media_type => "html", :content_type => "explanation", :source => "Wikipedia")
# k.add_concepts "Introduction"
# k = Knote.create(:user => tom, :title => "Medium Knote Introduction", :content => "This is a medium knote", :difficulty => 1, :media_type => "html", :content_type => "explanation", :source => "Wikipedia")
# k.add_concepts "Introduction"
# k = Knote.create(:user => tom, :title => "Hard Knote Introduction", :content => "This is a hard knote", :difficulty => 2, :media_type => "html", :content_type => "explanation", :source => "Wikipedia")
# k.add_concepts "Introduction"
# 
# k = kb.knotes.create(:user => tom, :title => "Easy Knote Definition", :content => "This is an easy knote", :difficulty => 0, :media_type => "html", :content_type => "explanation", :source => "Wikipedia")
# k.add_concepts "Definition"
# k = Knote.create(:user => tom, :title => "Medium Knote Definition", :content => "This is a medium knote", :difficulty => 1, :media_type => "html", :content_type => "explanation", :source => "Wikipedia")
# k.add_concepts "Definition"
# k = Knote.create(:user => tom, :title => "Hard Knote Definition", :content => "This is a hard knote", :difficulty => 2, :media_type => "html", :content_type => "explanation", :source => "Wikipedia")
# k.add_concepts "Definition"
# 
# k = kb.knotes.create(:user => tom, :title => "Easy Knote Conclusion", :content => "This is an easy knote", :difficulty => 0, :media_type => "html", :content_type => "explanation", :source => "Wikipedia")
# k.add_concepts "Conclusion"
# k = Knote.create(:user => tom, :title => "Medium Knote Conclusion", :content => "This is a medium knote", :difficulty => 1, :media_type => "html", :content_type => "explanation", :source => "Wikipedia")
# k.add_concepts "Conclusion"
# k = Knote.create(:user => tom, :title => "Hard Knote Conclusion", :content => "This is a hard knote", :difficulty => 2, :media_type => "html", :content_type => "explanation", :source => "Wikipedia")
# k.add_concepts "Conclusion"
# 
