# The Open Closed Principle
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# A module should be open for extension but closed for modification.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# The following implementation of a Story class simply prints the icon for each
# type of story.
#
# It violates the "closed for modification" principle because the icon
# method must be modified in order to add a new type of story or to change
# the icon of an existing story.
#
# It violates the "open for extension" principle because you must override
# the stories method in order to change the order the stories are returned.
#
# In this situation, the case statement is a code smell that the method is
# not open for extension.

module Agile
  class Iteration
    def initialize(options = {})
      @stories = stories
    end

    def stories
      @stories.sort {|a, b| a.description <=> b.description }
    end
  end

  class Story
    def initialize(options = {})
      @type = options[:type] || "story"
    end

    def icon
      case @type
      when "bug" then "bug.png"
      when "chore" then "gear.png"
      else "star.png"
      end
    end
  end
end

describe Agile do
  include Agile

  describe Agile::Story do
    context "default story" do
      it "has a star icon" do
        story = Story.new
        story.icon.should == "star.png"
      end
    end

    context "chore" do
      it "has a gear icon" do
        chore = Story.new(:type => "chore")
        chore.icon.should == "gear.png"
      end
    end
  end
end