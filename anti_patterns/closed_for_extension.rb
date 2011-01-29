# The Open Closed principle states that a module should be open for extension
# but closed for modification.
#
# The following implementation of a Story class simply prints the icon for each
# type of story. It violates the Open Closed Principle because the icon
# method must be modified in order to add a new type of story or to change
# the icon of an existing story.
#
# In this situation, the case statement is a code smell that the method is
# not open for extension.

class Story
  def initialize(type = "story")
    @type = type
  end

  def icon
    case @type
    when "bug" then "bug.png"
    when "chore" then "gear.png"
    else "star.png"
    end
  end
end

describe Story do
  context "default story" do
    it "has a star icon" do
      story = Story.new
      story.icon.should == "star.png"
    end
  end

  context "chore" do
    it "has a gear icon" do
      chore = Story.new("chore")
      chore.icon.should == "gear.png"
    end
  end
end
