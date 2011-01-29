# The Interface Segregation Principle:
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Clients should not be forced to depend on interfaces that they do not use.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Since Ruby is a dynamic language, you rely on duck typing to determine
# what you can do with an object. In this example, the StoryPrinter object
# is able to print a story or release with or without a deadline.
#
# StoryPrinter knows to print the deadline only if the object has that method.
#

module Agile
  require "date"

  class Story
    attr_reader :description

    def initialize(options = {})
      @description = options[:description]
      on_story_create(options)
    end

    def on_story_create(options)
    end
  end

  class Release < Story
    attr_reader :deadline

    def on_story_create(options)
      @deadline = options[:deadline]
    end
  end

  class StoryPrinter
    def print(story)
      formatted_deadline = ""
      if story.respond_to?(:deadline) && !story.deadline.nil?
        formatted_deadline = " (#{story.deadline.strftime('%b %d, %Y')})"
      end
      "#{story.description}" + formatted_deadline
    end
  end
end

describe Agile do
  let (:printer) { Agile::StoryPrinter.new }

  describe Agile::Story do
    it "prints a story" do
      description = "RMU Session 4"
      story = Agile::Story.new(:description => description)
      printer.print(story).should == "#{description}"
    end
  end

  describe Agile::Release do
    it "prints a story without a deadline" do
      description = "RMU Session 4"
      story = Agile::Release.new(
        :description => description
      )
      printer.print(story).should == description
    end

    it "prints a story with a deadline" do
      description = "RMU Session 4"
      jan_31 = Date.parse("2011-01-31")
      story = Agile::Release.new(
        :description => description,
        :deadline => jan_31
      )
      printer.print(story).should == "#{description} (Jan 31, 2011)"
    end
  end
end