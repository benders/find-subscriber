module ClassFamily
  def new( *args )
    new_logic_class( *args ) || super(*args)
  end

  def new_logic_class( *args )
    return false if args.empty?
    args.each do |arg|
      return false if (arg.nil? || arg.empty?)
    end

    class_name = self.class_name( *args )
    klass = self.find_constant( class_name )
    if klass && klass != self && klass.respond_to?('new_logic_class')
      klass.new( *args )
    end
  end

  def class_name( *args )
    name = args.map{|x| x.capitalize}.join('::')
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