require 'machinist/active_record'
require 'sham'
require 'forgery'

Sham.define do
  login   { Forgery::Internet.user_name }
  name    { Forgery::Name.full_name }
  email   { Forgery::Internet.email_address }
  title   { |index| "#{index} #{Forgery::LoremIpsum.words(4)}" }
  content(:unique => false) { Forgery::LoremIpsum.paragraphs(3, :html => true) }
end

User.blueprint do
  login
  name
  email
  pwd = Forgery::Basic.password
  password { pwd }
  password_confirmation { pwd }
  tou = true
  difficulty { rand(5) + 1 }
end

User.blueprint(:jimmy) do
  login                 { "JimmyJames" }
  name                  { "Jimmy James" }
  email                 { "jimmy@jimmyjames.net" }
  password              { "j1mmyj4m3s" }
  password_confirmation { "j1mmyj4m3s" }
  difficulty            { 0 }
end

User.blueprint(:tom) do
  login                 { "Whitespace" }
  name                  { "Tom Clark" }
  email                 { "whitespace@gmail.com" }
  password              { "sl1znut" }
  password_confirmation { "sl1znut" }
  difficulty            { 40 }
end

User.blueprint(:joe) do
  login                 { "hover2pi" }
  name                  { "Joe Filippazzo" }
  email                 { "hover2pi@gmail.com" }
  password              { "joeflip4!" }
  password_confirmation { "joeflip4!" }
  difficulty            { 60 }
end

Knotebook.blueprint do
  title
  user        { User.make }
  abstract    { Forgery::LoremIpsum.paragraphs(1) }
  original_id { nil }
  # favorite    { false }
end

Knote.blueprint do
  title
  content
  start_time    { "0" }
  source        { Forgery::LoremIpsum.paragraphs(1, :html => true) }  
  content_type  { Knote::CONTENT_TYPES.rand }
  media_type    { "html" }
  user          { User.make }
  caption       { Forgery::LoremIpsum.paragraphs(1) }
  license       { "CCBYSA" }
  difficulty    { rand(99) + 1 }
  concepts_list { "physics" }
end

Knote.blueprint(:video) do
  media_type    { "video" }
  content       { "http://www.youtube.com/watch?v=9LBKVXyrHcw" }
  start_time    { "1:00" }
  end_time      { "2:00" }
  content_type  { "explanation"}
end

Comment.blueprint do
  user             { User.make }
  body             { Faker::Lorem.paragraphs(1) }
  target = [User.all.rand, Knotebook.all.rand].rand
  commentable_id   { target.id }
  commentable_type { target.class.name }
end

def make_valid_knotebook(attributes = {})
  kb = Knotebook.create(Knotebook.plan(attributes) do |kb|
    3.times { kb.knotes << Knote.make! }
  end)
  factory, name = *parse_model("knotebook")
  store_model(factory, name, kb)
end