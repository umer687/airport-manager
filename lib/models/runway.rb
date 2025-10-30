# frozen_string_literal: true
module Models
  class Runway
    attr_accessor :name

    def initialize(name:)
      @name = name&.upcase
    end

    def to_h; { name: @name }; end
    def self.from_h(h); new(name: h["name"]); end
    def to_s; "Runway(#{@name})"; end
  end
end
