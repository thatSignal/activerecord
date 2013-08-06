require_relative './associatable'
require_relative './db_connection'
require_relative './mass_object'
require_relative './searchable'
require 'active_support/inflector'

class SQLObject < MassObject
  def self.set_table_name(table_name)
    if table_name.nil?
      @table_name = "#{self.class}".underscore.pluralize
    else
      @table_name = table_name
    end
  end

  def self.table_name
    @table_name
  end

  def self.all
    DBConnection.execute(<<-SQL)
      SELECT *
      FROM #{@table_name}
    SQL
  end

  def self.find(id)
    DBConnection.execute(<<-SQL, id)
      SELECT *
      FROM #{@table_name}
      WHERE id = ?
    SQL
  end

  def create
    attrs = self.class.attributes
    attrs.shift
    num_attrs = attrs.count

    attr_vals = self.class.attributes.map { |attr| self.instance_variable_get("@#{attr}".to_sym) }

    question_marks = (["?"]*num_attrs).join(", ")
    attr_string = attrs.join(", ")

    sql_string = <<-SQL
    INSERT INTO #{self.class.table_name} (#{attr_string})
    VALUES (#{question_marks})
    SQL

    DBConnection.execute(sql_string, *attr_vals)

  end

  def update
    attributes_and_vals = {}

    attrs = self.class.attributes[1..-1]
    attr_vals = attribute_values[1..-1]

    attrs.each_with_index do |attr, i|
      attributes_and_vals[att] = attr_vals[i]
    end

    puts attributes_and_vals

    sql_string = <<-SQL
      UPDATE #{self.class.table_name}
      SET
    SQL

  end

  def save

  end

  def attribute_values
    self.class.attributes.map { |attr| self.instance_variable_get("@#{attr}".to_sym) }
  end
end

cats_db_file_name =
  File.expand_path(File.join(File.dirname(__FILE__), "../../test/cats.db"))

DBConnection.open(cats_db_file_name)


class Cat < SQLObject
  set_table_name("cats")
  set_attrs(:id, :name, :owner_id)
end



c = Cat.new(:name => "lion", :owner_id => 1)
#c.create
c.update



