FactoryGirl.define do
  sequence :uid do |n|
    "#{n}"
  end

  factory :mission do
    name        "Test mission"
    description "It is description of this mission."
    deadline    "It is deadline of this mission."
    keyword     "It is keyword of this mission."
  end

  factory :clam do
    uid
    date Time.now
    summary "It is summary of this clam."
  end

  factory :resource do
    source "It is a source of this resource."
    type   "Mail"
  end
end
