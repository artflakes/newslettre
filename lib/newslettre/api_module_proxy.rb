require 'forwardable'

class Newslettre::APIModuleProxy
  extend ::Forwardable

  attr_reader :owner, :target
  def initialize owner, target
    @owner = owner
    @target = target
  end

  def_delegator :@target, :get
  def_delegator :@target, :edit
  def_delegator :@target, :delete
  def_delegator :@target, :add

  def to_a
    target.list
  end

  def == other
    target == other
  end
end
