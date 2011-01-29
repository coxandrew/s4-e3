# The Single Responsibility Principle:
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# There should never be more than one reason for a class to change.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# This module separates concerns into a Project, Iteration and Story. The
# Project has both velocity and stories, but does not need to know how to
# get either one by itself. It relies on the Iteration class to handle the
# details.
#

module Agile
  require "date"

  class Project
    attr_accessor :iterations

    def initialize
      @iterations = []
    end

    def add_iteration(iteration)
      @iterations << iteration
    end

    def stories
      @iterations.collect { |iteration| iteration.stories }.flatten
    end

    def velocity
      completed = @iterations.select { |iteration| iteration.complete? }
      total_points = completed.inject(0) do |sum, iteration|
        sum + iteration.velocity
      end
      total_points / completed.size
    end
  end

  class Iteration
    attr_reader :stories, :start_date, :end_date

    def initialize(options = {})
      @start_date = options[:start_date] || Date.today
      @end_date   = options[:end_date]   || @start_date + 7
      @stories = []
    end

    def add_stories(stories)
      @stories |= stories
    end

    def complete?
      @end_date < Date.today
    end

    def velocity
      return 0 if !complete?
      stories_done.inject(0) { |total, story| total + story.size }
    end

    private

    def stories_done
      @stories.select { |story| story.done? }
    end
  end

  class Story
    attr_reader :description, :size, :status

    STATUSES = [:new, :started, :finished, :accepted]

    def initialize(options = {})
      @description = options[:description]
      @size        = options[:size]
      @size        = options[:size] || 0
      @status      = :new
    end

    def change_status_to(status)
      raise "Invalid status" if !STATUSES.include?(status)
      @status = status
    end

    def done?
      @status == :accepted
    end
  end
end

describe Agile do
  let(:story) { Agile::Story.new(:description => "Example story", :size => 4) }

  describe Agile::Story do
    it "has a description and size" do
      story.description.should == "Example story"
      story.size.should == 4
    end

    it "starts with a status of :new" do
      story.status.should == :new
    end

    it "can be completed" do
      story.change_status_to(:accepted)
      story.done?.should be_true
    end

    it "throws exception when given an invalid status" do
      lambda {
        story.change_status_to(:done)
      }.should raise_error("Invalid status")
    end
  end

  describe Agile::Iteration do
    let(:iteration) do
      Agile::Iteration.new(
        :start_date => Date.parse("2011-01-17"),
        :end_date   => Date.parse("2011-01-23")
      )
    end

    it "starts today and ends in a week" do
      iteration.start_date.should == Date.parse("2011-01-17")
      iteration.end_date.should == Date.parse("2011-01-23")
    end

    it "returns a velocity of 0 for an iteration that isn't done" do
      unfinished = Agile::Iteration.new
      alpha = Agile::Story.new(:description => "alpha", :size => 1)
      beta  = Agile::Story.new(:description => "beta",  :size => 4)

      alpha.change_status_to(:accepted)
      beta.change_status_to(:accepted)

      unfinished.velocity.should == 0
    end

    it "calculates velocity based on completed done stories" do
      alpha = Agile::Story.new(:description => "alpha", :size => 1)
      beta  = Agile::Story.new(:description => "beta",  :size => 4)
      theta = Agile::Story.new(:description => "theta", :size => 8)
      gamma = Agile::Story.new(:description => "gamma", :size => 1)

      alpha.change_status_to(:accepted)
      theta.change_status_to(:accepted)

      stories = [alpha, beta, theta, gamma]
      iteration.add_stories(stories)

      iteration.velocity.should == 9
    end
  end

  describe Agile::Project do
    let(:alpha) { Agile::Story.new(:description => "alpha", :size => 1) }
    let(:beta)  { Agile::Story.new(:description => "beta",  :size => 4) }
    let(:theta) { Agile::Story.new(:description => "theta", :size => 8) }

    it "has stories" do
      iteration_a = Agile::Iteration.new
      iteration_a.add_stories([alpha, beta, theta])

      project = Agile::Project.new
      project.add_iteration(iteration_a)
      project.stories.size.should == 3
    end

    it "calculates velocity from completed iterations" do
      iteration_a = Agile::Iteration.new(
        :start_date => Date.parse("2011-01-03"))
      iteration_b = Agile::Iteration.new(
        :start_date => Date.parse("2011-01-09"))

      iteration_a.add_stories([alpha, beta])
      iteration_b.add_stories([theta])

      alpha.change_status_to(:accepted)
      beta.change_status_to(:accepted)
      theta.change_status_to(:accepted)

      project = Agile::Project.new
      project.add_iteration(iteration_a)
      project.add_iteration(iteration_b)

      project.velocity.should == 6
    end
  end
end