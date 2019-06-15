# frozen_string_literal: true

# Parses commands converting them to recognisable method names and arguments
class CommandParser
  class UnrecognizedError < RuntimeError; end

  def parse(full_command)
    command_character, *args = full_command.split(' ')
    [method_from(command_character), *type_cast_arguments(args)]
  end

  private

  COMMAND_METHODS = {
    'I' => :new_image,
    'C' => :clear_image,
    'L' => :draw_single_pixel,
    'V' => :draw_vertical_line,
    'H' => :draw_horizontal_line,
    'S' => :show_image
  }.freeze

  def type_cast_arguments(args)
    args.map { |arg| arg.match(/\A\d+\z/) ? arg.to_i : arg }
  end

  def method_from(command_character)
    COMMAND_METHODS.fetch(command_character) do
      raise UnrecognizedError, "Unrecognized command: #{command_character}"
    end
  end
end
