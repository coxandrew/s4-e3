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
  class Story
    attr_reader :description, :icon, :size

    def initialize(options = {})
      @description = options[:description]
      @icon = options[:icon] || "star.png"
      @size = options[:size] || 0
    end
  end

  class Release < Story
    attr_reader :deadline

    def initialize(options = {})
      super(options.merge(:icon => "release.png", :size => 0))
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