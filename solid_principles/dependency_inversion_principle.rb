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
# used for printing a story and print a story as either text or HTML.
#

module Agile
  class Story
    attr_reader :description, :size

    def initialize(options = {})
      @printer     = options[:printer]     || StoryPrinter.new
      @description = options[:description] || "No description"
      @size        = options[:size]        || 0
    end

    def t_shirt_size
      case size
      when 1 then :XS
      when 2 then :S
      when 4 then :M
      when 8 then :L
      end
    end

    def print
      @printer.print(self)
    end
  end

  class StoryPrinter
    def print(story)
      "#{story.description} (#{story.t_shirt_size})"
    end
  end

  class StoryHTMLPrinter
    def print(story)
      "<div class='story'>#{story.description} <em>(#{story.t_shirt_size})</em></div>"
    end
  end
end

describe Agile::Story do
  it "prints a story as a string by default" do
    story = Agile::Story.new(:description => "alpha", :size => 4)
    story.print.should == "alpha (M)"
  end

  context "StoryHTMLPrinter" do
    it "prints a story as HTML" do
      story = Agile::Story.new(
        :description => "alpha",
        :size => 8,
        :printer => Agile::StoryHTMLPrinter.new
      )
      story.print.should == "<div class='story'>alpha <em>(L)</em></div>"
    end
  end
end