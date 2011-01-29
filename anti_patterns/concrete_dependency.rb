# The Dependency Inversion Principle:
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Depend upon abstractions. Do not depend upon concretions.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# This example violates Dependency Inversion because it uses a StoryPrinter
# object within a public method rather than defining the StoryPrinter
# object in the initialize method (see:
# solid_principles/dependency_inversion_principle.rb)
#

class Story
  attr_reader :description, :size

  def initialize(options = {})
    @description = options[:description] || "No description"
    @size        = options[:size]        || 0
  end

  def print
    StoryPrinter.new.print(self)
  end
end

class StoryPrinter
  def print(story)
    "#{story.description} (#{t_shirt_size(story.size)})"
  end

  private

  def t_shirt_size(size)
    case size
    when 1 then "XS"
    when 2 then "S"
    when 4 then "M"
    when 8 then "L"
    end
  end
end

describe Story do
  it "prints a story" do
    story = Story.new(:description => "alpha", :size => 4)
    story.print.should == "alpha (M)"
  end
end