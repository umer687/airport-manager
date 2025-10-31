module Models
  class Bag
    attr_accessor :id, :weight
    def initialize(id:, weight:)
      @id, @weight = id, weight.to_f
    end
  end
end
