# The Single Responsibility Principle states that there should never be more
# than one reason for a class to change.
#
# This module separates Story into 2 classes:
#
# Story: handles storing details like description and size.
# StoryPrinter: handles displaying a story (in this case, just in text)
#
# The Story class needs to have size as an Integer so it can add up the
# sizes of multiple stories. The display, on the other hand, needs to be
# able to conver the numeric sizes to T-shirt sizes.
#

module Agile
  class Story
    attr_reader :description, :size

    def initialize(options = {})
      @description = options[:description]
      @size        = options[:size]
    end
  end

  class StoryPrinter
    def initialize(story)
      @story = story
    end

    def t_shirt_size
      case @story.size
      when 1 then "XS"
      when 2 then "S"
      when 4 then "M"
      when 8 then "L"
      end
    end

    def print
      "#{@story.description} (#{t_shirt_size})"
    end
  end
end

describe Agile do
  include Agile

  let(:story) { Story.new(:description => "Example story", :size => 4) }

  describe Agile::Story do
    it "has a description and size" do
      story.description.should == "Example story"
      story.size.should == 4
    end
  end

  describe Agile::StoryPrinter do
    it "prints description with size as a T-shirt" do
      printer = StoryPrinter.new(story)
      printer.print.should == "Example story (M)"
    end
  end
end