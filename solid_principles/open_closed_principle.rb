# The Open Closed Principle:
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# A module should be open for extension but closed for modification.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# It is open for extension in the ordering of stories in an iteration. You
# can change how stories are ordered simply by overriding the <=> method
# in the Story class.
#
# It is closed for modification in that you should not need to modify how
# a Story determines its icon (see anti_patterns/closed_for_extension.rb
# for a violation of the closed for modification principle).

require "date"

module Agile
  class Iteration
    def initialize(stories = [])
      @stories = stories
    end

    def stories
      @stories.sort
    end
  end

  class Story
    attr_reader :description, :icon

    def initialize(options = {})
      @description = options[:description]
      @icon = options[:icon] || "star.png"
      on_story_create(options)
    end

    def on_story_create(options)
    end

    def <=>(b)
      0
    end
  end

  class Release < Story
    attr_reader :deadline

    def on_story_create(options)
      @deadline = options[:deadline]
    end

    def deadline
      @deadline unless @deadline.nil?
    end
  end
end


describe Agile::Story do
  context "default story" do
    it "has a description" do
      expected_description = "Write an example of Open Closed"
      story = Agile::Story.new(:description => expected_description)
      story.description.should == expected_description
    end

    it "has a star icon" do
      story = Agile::Story.new
      story.icon.should == "star.png"
    end
  end

  context "chore" do
    it "has a gear icon" do
      chore = Agile::Story.new(:icon => "gear.png")
      chore.icon.should == "gear.png"
    end
  end

  context "release" do
    it "has a release icon" do
      release = Agile::Release.new(
        :icon => "release.png",
        :deadline => Date.parse('2011-01-31')
      )
      release.icon.should == "release.png"
    end

    it "can have a deadline" do
      expected_deadline = Date.parse('2011-01-31')
      release = Agile::Release.new(
        :icon => "release.png",
        :deadline => expected_deadline
      )
      release.deadline.should == expected_deadline
    end
  end
end

describe Agile::Iteration do
  it "returns a list of stories in the order they were added" do
    upcoming = Agile::Iteration.new([
      Agile::Story.new(:description => "alpha"),
      Agile::Story.new(:description => "theta"),
      Agile::Story.new(:description => "beta")
    ])
    stories = upcoming.stories
    stories[0].description.should == "alpha"
    stories[1].description.should == "theta"
    stories[2].description.should == "beta"
  end
end
