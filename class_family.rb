module ClassFamily
  def new( schema = nil, table = nil, column = nil)
    new_logic_class( schema, table, column ) || super()
  end

  def new_logic_class( schema, table, column )
    [schema, table, column].each do |arg|
      return false if arg.nil?
    end

    class_name = self.class_name( schema, table, column )
    klass = self.find_constant( class_name )
    if klass && klass.respond_to?('new_logic_class')
      klass.new
    end
  end

  def class_name( schema, table, column )
    name = "#{schema.capitalize}::#{table.capitalize}::#{column.capitalize}"
    name.gsub(/_(\w)/) { $1.capitalize }
  end

  def find_constant( name )
    parts = name.chomp.split('::')
    context = Module
    begin
      parts.each do |part|
        context = context.const_get(part)
      end
    rescue NameError
      false
    else
      context
    end
  end
end