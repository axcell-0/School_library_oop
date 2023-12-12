require_relative 'person'
require_relative 'student'
require_relative 'teacher'
require_relative 'book'
require_relative 'rental'
require_relative 'classroom'

class App
  def initialize
    @books = []
    @people = []
    @rentals = []
  end

  def create_person
    print 'Do you want to create a student (1) or a teacher (2)? [Input the number]: '
    type = gets.chomp.to_i
    case type
    when 1
      create_student
    when 2
      create_teacher
    else
      puts 'Invalid input. Please enter 1 for a student or 2 for a teacher.'
    end
  end

  class StudentCreator
    def self.fetch_student_details
      print 'Age: '
      age = gets.chomp.to_i
      print 'Name: '
      name = gets.chomp
      print 'Has parent permission? [Y/N]: '
      parent_permission = gets.chomp
      { age: age, name: name, parent_permission: parent_permission }
    end
  end

  def create_student
    student_details = StudentCreator.fetch_student_details
    person = Student.new(student_details[:name], student_details[:age], student_details[:parent_permission])
    @people.push(person)
    puts "Student '#{student_details[:name]}' created successfully"
  end

  class TeacherCreator
    def self.fetch_teacher_details
      print 'Age: '
      age = gets.chomp.to_i
      print 'Name: '
      name = gets.chomp
      print 'Specialization: '
      specialization = gets.chomp
      { age: age, name: name, specialization: specialization }
    end
  end

  def create_teacher
    teacher_details = TeacherCreator.fetch_teacher_details
    person = Teacher.new(teacher_details[:age], teacher_details[:specialization], name: teacher_details[:name])
    @people.push(person)
    puts "Teacher '#{teacher_details[:name]}' created successfully"
  end

  class BookCreator
    def self.fetch_book_details
      print 'Title: '
      title = gets.chomp
      print 'Author: '
      author = gets.chomp
      { title: title, author: author }
    end
  end

  def create_book
    book_details = BookCreator.fetch_book_details
    book = Book.new(book_details[:title], book_details[:author])
    @books.push(book)
    puts "Book '#{book_details[:title]}' created successfully"
  end

  class RentalCreator
    def self.fetch_book_selection(books)
      puts 'Select a book from the following list by number'
      books.each_with_index do |book, index|
        puts "#{index}) Title: \"#{book.title}\", Author: #{book.author}"
      end
      book_index = gets.chomp.to_i
      books[book_index]
    end

    def self.fetch_person_selection(people)
      puts 'Select a person from the following list by number (not id)'
      people.each_with_index do |person, index|
        type = person.instance_of?(Student) ? 'Student' : 'Teacher'
        puts "#{index}) [#{type}] Name: #{person.name}, ID: #{person.id}, Age: #{person.age}"
      end
      person_index = gets.chomp.to_i
      people[person_index]
    end

    def self.fetch_date
      print 'Date: '
      gets.chomp
    end
  end

  def create_rental
    book = RentalCreator.fetch_book_selection(@books)
    person = RentalCreator.fetch_person_selection(@people)
    date = RentalCreator.fetch_date
    @rentals.push(Rental.new(date, book, person))
    puts 'Rental created successfully'
  end

  def list_books
    @books.each_with_index do |book, index|
      puts "#{index} - Title: #{book.title}, Author: #{book.author}"
    end
  end

  def list_people
    @people.each_with_index do |person, index|
      type = person.instance_of?(Student) ? 'Student' : 'Teacher'
      puts "#{index} - [#{type}] Name: #{person.name}, ID: #{person.id}, Age: #{person.age}"
    end
  end

  def list_rentals
    if @rentals.empty?
      puts 'There are no rentals to show'
    else
      puts 'ID of person: '
      person_id = gets.chomp.to_i
      puts 'Rentals: '
      @rentals.each do |rental|
        if person_id == rental.person.id
          puts "Date: #{rental.date}, Book '#{rental.book.title}' by #{rental.book.author}"
        end
      end
    end
  end

  def run
    loop do
      display_menu
      choice = gets.chomp.to_i
      process_choice(choice)
      break if choice == 7
    end
  end

  private

  def display_menu
    puts 'Choose an option:'
    puts '1. Create a person'
    puts '2. Create a book'
    puts '3. Create a rental'
    puts '4. List all books'
    puts '5. List all people'
    puts '6. List rentals for a person'
    puts '7. Quit'
  end

  def process_choice(choice)
    case choice
    when 1
      create_person
    when 2
      create_book
    when 3
      create_rental
    when 4
      list_books
    when 5
      list_people
    when 6
      list_rentals
    else
      puts 'Thank you for using the app.'
    end
  end
end
