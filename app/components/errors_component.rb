class ErrorsComponent < ApplicationComponent
  def initialize(object:, field:)
    @object = object
    @field = field
  end

  def view_template
    return unless object.errors[field].any?

    div(class: "mt-2") do
      object.errors[field].each do |error|
        p(class: "text-sm text-red-600") { error }
      end
    end
  end

  private

  attr_reader :object, :field
end
