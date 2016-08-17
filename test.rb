module Test
  def module_method
    puts "module method"
  end
end

class MyClass
  extend Test

  def self.class_method
    self.module_method
  end
end

MyClass.class_method
