class MassObject


  def self.set_attrs(*attributes)
    @attributes = attributes
    attributes.each do |attr|
      attr_accessor(attr)
    end

  end

  def self.attributes
    @attributes
  end

  def self.parse_all(results)
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      if self.class.attributes.include?(attr_name)
        instance_variable_set("@#{attr_name}", value)
      else
        raise "mass assignment to unregistered attribute #{attr_name}"
      end
    end

  end #end init

end

class MyClass < MassObject
  set_attrs :x, :y
end

# mo = MyClass.new
# mo.x = :xval
# #mo.y = :yval
#
# #puts mo.class.attributes
#
#
# no = MyClass.new(:x => :xval, :y => :yval)
#
# no.class.attributes.each do |attr|
#   p no.instance_variable_get("@#{attr}".to_sym)
# end
#

