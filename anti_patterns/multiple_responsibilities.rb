# The Single Responsibility Principle:
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# There should never be more than one reason for a class to change.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# In this case, the Story class is both handling storing details about a Story
# as well as printing it. We may want to change the output of the Story class
# to write HTML inside a Rails app. We shouldn't have to modify the base Story
# class to do so.
#

class Story
  attr_reader :description, :size

  def initialize(options = {})
    @description = options[:description]
    @size        = options[:size]
  end

  def t_shirt_size
    case size
    when 1 then "XS"
    when 2 then "S"
    when 4 then "M"
    when 8 then "L"
    end
  end

  def print
    "#{description} (#{t_shirt_size})"
  end
end

describe Story do
  let(:story) { Story.new(:description => "Example story", :size => 4) }

  it "has a description and size" do
    story.description.should == "Example story"
    story.size.should == 4
  end

  it "prints description with size as a T-shirt" do
    story.print.should == "Example story (M)"
  end
end