Given(/^a valid knotebook exists?(?: with #{capture_fields})?$/) do |fields|
  make_valid_knotebook(parse_fields fields)
end