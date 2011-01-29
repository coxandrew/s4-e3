# The Dependency Inversion Principle:
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Depend upon abstractions. Do not depend upon concretions.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Restated, the Dependency Inversion Principle means 2 things:
#
# A) High level modules should not depend on low level modules. Both should
#    depend upon abstractions.
#
# B) Abstractions should not depend upon details. Details should depend upon
#    abstractions.
#
# This example uses Dependency Inversion to define the printer in the
# initialize method. That allows us to be flexible with the mechanism
# used for printing a story.
#

class Story
  attr_reader :description, :size

  def initialize(options = {})
    @printer     = options[:printer]     || StoryPrinter.new
    @description = options[:description] || "No description"
    @size        = options[:size]        || 0
  end

  def print
    @printer.print(self)
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