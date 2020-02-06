# frozen_string_literal: true
class DiscourseJsProcessor
  def self.call(input)
    if (input[:filename] || '') =~ /\.es6/
      return { data: transpile(input) }
    end

    { data: input[:data] }
  end

  def self.transpile(input)
    root_path = input[:load_path] || ''
    logical_path = (input[:filename] || '').sub(root_path, '').gsub(/\.(js|no-module|es6).*$/, '').sub(/^\//, '')
    source = input[:data]

    template = Tilt::ES6ModuleTranspilerTemplate.new {}
    template.no_module = true if input[:filename]['no-module']
    template.module_transpile(source, root_path, logical_path)
  end
end
