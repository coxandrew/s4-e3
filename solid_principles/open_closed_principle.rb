# The Open Closed principle states that a module should be open for extension
# but closed for modification.

class Story
  def icon
    "star.png"
  end
end

class Chore < Story
  def icon
    "gear.png"
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
      chore = Chore.new
      chore.icon.should == "gear.png"
    end
  end
end
