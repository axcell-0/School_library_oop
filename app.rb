require_relative 'person'
require_relative 'student'
require_relative 'teacher'
require_relative 'book'
require_relative 'rental'
require_relative 'classroom'
require 'json'

class App
  def initialize
    @books = []
    @people = []
    @rentals = []
    load_data_if_needed
  end

  def load_data_if_needed
    return if @loaded_data

    load_books_from_json
    @loaded_data = true
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

  def create_student
    print 'Age: '
    age = gets.chomp.to_i
    print 'Name: '
    name = gets.chomp
    print 'Has parent permission? [Y/N]: '
    parent_permission = gets.chomp.downcase == 'y'
    id = Random.rand(1...1000)
    person = Student.new(name, age, parent_permission: parent_permission, id: id)
    @people.push(person)
    puts "Student '#{name}' created successfully"
    save_people_to_json
  end

  def create_teacher
    print 'Age: '
    age = gets.chomp.to_i
    print 'Name: '
    name = gets.chomp
    print 'Specialization: '
    specialization = gets.chomp
    id = Random.rand(1...1000)
    person = Teacher.new(name: name, age: age, specialization: specialization, id: id)
    @people.push(person)
    puts "Teacher '#{name}' created successfully"
    save_people_to_json
  end

  def create_book
    print 'Title: '
    title = gets.chomp
    print 'Author: '
    author = gets.chomp
    id = Random.rand(1...1000)
    book = Book.new(title, author, id: id)
    @books.push(book)
    puts "Book '#{title}' created successfully with ID: #{book.id}"
    save_books_to_json
  end

  def create_rental
    return puts 'There are no books yet.' if @books.empty?

    puts 'Select a book from the following list by number'
    list_books

    book_choice = gets.chomp.to_i

    if book_choice <= 0 || book_choice > @books.length
      puts 'Invalid input! Please enter a number within the range.'
      return
    end

    puts 'Select a person from the following list by number (not id)'
    list_people

    people_choice = gets.chomp.to_i - 1

    if people_choice.negative? || people_choice >= @people.length
      puts 'Invalid input! Please enter a number within the range.'
      return
    end

    puts 'Date: '
    date = gets.chomp

    @rentals << Rental.new(date, @books[book_choice - 1], @people[people_choice])

    puts 'Rental created successfully!'
    save_rentals
  end

  def list_books
    puts 'List of Books:'
    @books.each_with_index do |book, index|
      puts "#{index + 1}. Title: #{book.title}, Author: #{book.author}"
    end
  end

  def list_people
    puts '----- People loaded successfully -----'
    if File.exist?('people.json')
      begin
        people_json = File.read('people.json')
        people_data = JSON.parse(people_json)

        @people = people_data.map.with_index(1) do |person_data, index|
          if person_data['type'] == 'student'
            Student.new(
              person_data['name'],
              person_data['age'],
              parent_permission: person_data['parent_permission'],
              id: person_data['id']
            )
          elsif person_data['type'] == 'teacher'
            Teacher.new(
              name: person_data['name'],
              age: person_data['age'],
              specialization: person_data['specialization'],
              id: person_data['id']
            )
          else
            puts "Unknown person type: #{person_data['type']}"
            nil
          end.tap do |person|
            type = person.is_a?(Student) ? 'Student' : 'Teacher'
            puts "#{index} - [#{type}] Name: #{person.name}, ID: #{person.id}, Age: #{person.age}"
          end
        end.compact
      rescue JSON::ParserError => e
        puts "Error parsing JSON data: #{e.message}"
      rescue StandardError => e
        puts "Error loading data from JSON: #{e.message}"
      end
    else
      puts 'No person data found in people.json'
    end
  end

  def list_rentals
    puts 'ID of person: '
    person_id = gets.chomp.to_i
    found_rentals = @rentals.select { |rental| rental.person.id == person_id }

    if found_rentals.empty?
      puts "There are no rentals for the person with ID #{person_id}"
    else
      puts 'Rentals:'
      found_rentals.each do |rental|
        puts "Date: #{rental.date}, Book '#{rental.book.title}' by #{rental.book.author}"
      end
    end
  end

  def load_books_from_json
    if File.exist?('books.json')
      books_json = File.read('books.json')
      books_data = JSON.parse(books_json)

      @books = books_data.map do |book_data|
        Book.new(book_data['title'], book_data['author'], id: book_data['book.id'])
      end
    else
      puts 'No book data found in books.json'
    end
  end

  def display_rentals_by_person_id
    if File.exist?('rentals.json')
      rentals_json = File.read('rentals.json')
      rentals_data = JSON.parse(rentals_json)
      list_people
      puts "Enter a person's ID to see if they have rented books:"
      id = gets.chomp.to_i

      found_rentals = []
      found_name = nil

      @people.each do |person|
        if person.id == id
          found_name = person.name
          break
        end
      end

      rentals_data.each do |rental_data|
        person_id = rental_data['person']['id']
        next unless person_id == id

        book_title = rental_data['book']['title']
        book_author = rental_data['book']['author']
        rental_date = rental_data['date']
        found_rentals << { title: book_title, author: book_author, date: rental_date }
      end

      if found_rentals.empty?
        puts "No rentals found for person ID #{id}."
      else
        puts "#{found_name}'s rented books:"
        found_rentals.each do |rental|
          puts "Date: #{rental[:date]}, Book '#{rental[:title]}' by #{rental[:author]}"
        end
      end
    else
      puts 'No rental data found in rentals.json'
    end
  end

  def save_people_to_json
    people_data = @people.map do |person|
      if person.is_a?(Student)
        {
          type: 'student',
          id: person.id,
          name: person.name,
          age: person.age,
          parent_permission: person.parent_permission,
          classroom: person.classroom
        }
      elsif person.is_a?(Teacher)
        {
          type: 'teacher',
          id: person.id,
          name: person.name,
          age: person.age,
          specialization: person.specialization
        }
      else
        puts "Unknown person type: #{person.class}"
        nil
      end
    end.compact

    File.open('people.json', 'w') do |file|
      file.puts JSON.pretty_generate(people_data)
    end
  rescue JSON::GeneratorError => e
    puts "Error al generar JSON de personas: #{e.message}"
  rescue StandardError => e
    puts "Error desconocido al guardar datos en JSON de personas: #{e.message}"
  end

  def save_books_to_json
    File.open('books.json', 'w') do |file|
      books_json = @books.map do |book|
        {
          'book.id': book.id,
          title: book.title,
          author: book.author
        }
      end
      file.puts books_json.to_json
    end
  rescue JSON::GeneratorError => e
    puts "Error al generar JSON de libros: #{e.message}"
  rescue StandardError => e
    puts "Error desconocido al guardar datos en JSON de libros: #{e.message}"
  end

  def save_rentals
    rentals_data = @rentals.map do |rental|
      {

        date: rental.date,
        book: {
          title: rental.book.title,
          author: rental.book.author,
          rentals: rental.book.rentals.map(&:to_json)
        },
        person: {
          id: rental.person.id,
          name: rental.person.name,
          age: rental.person.age,
          parent_permission: rental.person.parent_permission,
          type: rental.person.class.to_s,
          rentals: rental.person.rentals.map(&:to_json)
        }
      }
    end

    File.open('rentals.json', 'w') do |file|
      file.puts JSON.pretty_generate(rentals_data)
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
      display_rentals_by_person_id
    else

      puts 'Thank you for using App.'
    end
  end
end
7
