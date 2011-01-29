# The Interface Segregation Principle:
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Clients should not be forced to depend on interfaces that they do not use.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# The Interface Segregation Principle does not apply to Ruby. You depend on the
# signature of the method and otherwise, the object is a "duck".

class Story
  def initialize(options = {})
    @description = options[:description]
  end

  def description
    @description
  end
end

describe Story do
  it "should have a description" do
    story = Story.new(:description => "alpha")
    story.description.should == "alpha"
  end
end