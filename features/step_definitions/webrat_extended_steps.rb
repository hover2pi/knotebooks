When /^I click(?: on)? "([^\"]*)"$/ do |link|
  click_link(link)
end

# Then /^I should be on the ([\w_]+) page$/ do |page_name|
#   URI.parse(current_url).path.should == path_to(page_name)
# end