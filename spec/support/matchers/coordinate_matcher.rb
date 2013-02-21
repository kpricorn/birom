RSpec::Matchers.define :have_same_coordinates do |expected|
  match do |actual|
    actual.u == expected[:u] and 
      actual.v == expected[:v] and
      actual.w == expected[:w]
  end

  failure_message_for_should do |actual|
    "expected #{actual} to be #{expected}"
  end

  failure_message_for_should_not do |actual|
    "expected #{actual} to be #{expected}"
  end

  description do
    "to have same coordinates as #{expected}"
  end
end

RSpec::Matchers.define :be_matching_coordinates do |expected|
  match do |actual|
    expected & actual == expected
  end
end
