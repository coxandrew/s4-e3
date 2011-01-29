# The Liskov Substitution Principle:
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Subclasses should be substitutable for their base classes.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# In this example, a Release is a subclass of Story because it is a type of
# story that you can describe and prioritize within your release just like
# any other Story object. It is a subclass because it adds a "deadline", but
# simply defaults to a size of 0 since it does not affect velocity.
#
# It fulfills the Liskov Substitution Principle because it can be summed
# along with other Story objects and have no ill effects and does not produce
# unexpected behavior when used as a Story object.
#

require "date"

module Agile
  class Iteration
    include Enumerable

    def initialize(stories = [])
      @stories = stories
    end

    def stories
      @stories.sort
    end

    def velocity
      @stories.inject(0) { |sum, story| sum + story.size }
    end
  end

  class Story
    attr_reader :description, :icon, :size, :position
    attr_writer :position

    def initialize(options = {})
      @description = options[:description] || "No description"
      @icon =        options[:icon]        || "star.png"
      @size =        options[:size]        || 0
      @position =    options[:position]    || 0
      on_story_create(options)
    end

    def on_story_create(options)
    end

    def <=>(b)
      self.position <=> b.position
    end
  end

  class Release < Story
    attr_reader :deadline

    def on_story_create(options)
      @icon = "release.png"
      @size = 0
      @deadline = options[:deadline]
    end

    def deadline
      @deadline unless @deadline.nil?
    end
  end
end

describe Agile::Release do
  let(:release) {
    Agile::Release.new(
      :description => "RMU Checkpoint #3",
      :deadline => Date.parse("2011-01-31")
    )
  }

  it "has a deadline" do
    release.deadline.should == Date.parse("2011-01-31")
  end

  it "has a release icon" do
    release.icon.should == "release.png"
  end

  it "has a size of 0" do
    release.size.should == 0
  end
end

describe Agile::Iteration do
  let(:story_1) { Agile::Story.new(:description => "quatro", :size => 2) }
  let(:story_2) { Agile::Story.new(:description => "uno", :size => 1) }
  let(:story_3) { Agile::Story.new(:description => "dos", :size => 1) }
  let(:release) { Agile::Release.new(:description => "RMU Core Skills") }
  let(:iteration) { Agile::Iteration.new([story_1, story_2, story_3, release]) }

  it "lists stories and releases sorted by position" do
    story_1.position = 4
    story_2.position = 1
    story_3.position = 2
    release.position = 3

    iteration.stories[0].should == story_2
    iteration.stories[1].should == story_3
    iteration.stories[2].should == release
    iteration.stories[3].should == story_1
  end

  it "calculates velocity from a list of stories" do
    iteration.velocity.should == 4
  end
end
