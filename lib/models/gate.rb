# frozen_string_literal: true
module Models
  class Gate
    attr_accessor :name

    def initialize(name:)
      @name = name&.upcase
    end

    def to_h; { name: @name }; end
    def self.from_h(h); new(name: h["name"]); end
    def to_s; "Gate(#{@name})"; end
  end
end
