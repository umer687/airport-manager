# frozen_string_literal: true
module Models
  class Staff
    ROLES = %w[pilot copilot crew ground].freeze
    attr_accessor :id, :name, :role

    def initialize(id:, name:, role:)
      @id = id
      @name = name
      @role = role
    end

    def to_h; { id: @id, name: @name, role: @role }; end
    def self.from_h(h); new(id: h["id"], name: h["name"], role: h["role"]); end
    def to_s; "Staff #{@id} #{@name} (#{@role})"; end
  end
end
