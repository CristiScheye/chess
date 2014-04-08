
class Employee
  attr_accessor :name, :title, :salary, :boss

  def initialize(name, title, salary = 40_000)
    @name, @title, @salary = name, title, salary
  end

  def bonus(multiplier)
    salary * multiplier
  end

end

class Manager < Employee
  attr_reader :employees

  def initialize(name, title, salary = 60_000)
    super(name, title, salary)
    @employees = []
  end

  def add_employees(*employees)
    employees.each {|employee| add_employee(employee)}
  end

  def add_employee(employee)
    employees << employee
    employee.boss = self
  end

  def bonus(multiplier)
    employees.inject(0) { |sum, employee| sum + employee.salary } * multiplier
  end

end


steve = Employee.new("Jack", "peon", 39_000)

steve1 = Employee.new("Jack1", "peon", 39_000)

steve2 = Employee.new("Jack2", "peon", 39_000)

p steve.bonus(3)

jack = Manager.new("steve", "slave driver", 600_000)
jack.add_employees(steve, steve1, steve2)
p jack.employees
p steve1.boss

p jack.bonus(3)