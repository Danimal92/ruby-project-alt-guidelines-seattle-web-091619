
class Cli
    # Menu option inputs
    VALID_MENU_INPUTS = ['1', '2', '3', '4', '5', 'backdoor'].freeze
    # Confirm option inputs
    YES_CONFIRM_INPUT = '1'.freeze
    NO_CONFIRM_INPUT = '2'.freeze
    VALID_CONFIRM_INPUT = [YES_CONFIRM_INPUT, NO_CONFIRM_INPUT].freeze
    # Backdoor option inputs
    VALID_BACKDOOR_INPUTS = ['A','R','U','L','E'].freeze
    

    def initialize()
        puts "\n\n=======================================================".green
        puts "\n\n\nPlease type your name:"
        puts "----------------------------".green
        @username = get_username
        @appointment_controller = AppointmentController.new
        @patient_controller = PatientController.new
        @physician_controller = PhysicianController.new
    end

    

    def white_space_checker(input)
        if !input.match(/\D\s\D/) && input.match(/^[a-z ,.'-]+$/i) 
            return true
        else
            return false
        end
    end

    def get_first_name
        puts "First name: "
        first_input = gets.chomp.capitalize.strip
        if white_space_checker(first_input) == false
            puts "Invalid input"
            get_first_name
        else
            return first_input
        end
    end

    def get_username
        first_name = get_first_name
        puts "Last name: "
        last_name = gets.chomp.capitalize.strip
        if white_space_checker(last_name) == false
            puts "Invalid input"
            get_username
        else
            return "#{first_name}" + " " + "#{last_name}"
        end
    end

    def physician_list
        Physician.all.map do |instance|
            puts "ID: #{instance.id}, NAME: #{instance.name}, SPECIALTY: #{instance.specialty}|"
            puts "----------------------------------------------------------------------------".green.green
            
        end
    end

    def menu
        input = get_menu_option
        istrue = true
        while istrue
            case input
            when "1"
                make_an_appointment
                istrue = false
            when "2" 
                update_appointment              
                istrue = false
            when "3"
                cancel_appointment
                istrue = false
            when "4"
                get_all_appointments
                istrue = false
            when "5"
                puts "Goodbye!"
                exit
            when "backdoor"
                puts "Hello Admin"
                puts "Something need doing?"
                backdoor_menu_choice
                istrue = false
                backdoor_menu_choice
            else
                puts "Invalid input, must put number " 
                puts "------------------------------".green
                istrue = false
                menu
            end
        end
    end

    def have_appointments
    if  @patient_controller.read({name: @username}) == nil || @patient_controller.read({name: @username}).appointments == nil || @patient_controller.read({name: @username}).appointments == 0
        puts "You have no appointments"
        puts "-------------------------".green
        return false
    else
        return true
    end
end

    def update_appointment_menu
            if have_appointments == false
                menu
            else
                puts "-------------------------------------------".green
                puts "Which appointment would you like to update?"
                get_all_appointments_without_menu
                return gets.chomp.to_i
            end
    end


    def cancel_appointment_menu

        if have_appointments == false
            menu
        else
            puts "-------------------------------------------".green
            puts "Which appointment would you like to cancel?"
            puts "-------------------------------------------".green
            get_all_appointments_without_menu
            return gets.chomp.to_i
        end
        

    end

    def cancel_appointment
        id = cancel_appointment_menu
        if should_create_appointment
            @appointment_controller.delete(id)
            puts "----------------------------------".green
            puts "Your appointment has been canceled"
            puts "----------------------------------".green
            menu
        else 
            menu
        end
    end

    def update_appointment
        id = update_appointment_menu
        input_params = {}        
        input_params[:date] = get_appointment_date
        input_params[:time] = get_appointment_time
        input_params[:physician_id] = get_appointment_physician
        input_params[:patient_id] = @patient_controller.read({name: @username}).id

            if should_create_appointment
                @appointment_controller.update(id,input_params)
            else 
                menu
            end
        puts "---------------------------------".green
        puts "Your appointment has been updated"
        puts "---------------------------------".green
        menu
    end

    def get_all_appointments_without_menu
        if have_appointments == false
            menu
        else
            input_params = {}
            input_params[:name] = @username
            object_list = @patient_controller.all_appointments(input_params)
            object_list.each {|instance|
            puts "ID: #{instance.id} | PHYSICIAN ID: #{instance.physician_id} | PHYSICIAN NAME: #{doctor_name(instance.physician_id)} | PATIENT ID: #{instance.patient_id} | DATE: #{instance.date} | TIME: #{instance.time} "}
            puts "---------------------------------------------------------------------------".green
        end

    end

    def get_all_appointments
        if have_appointments == false
            menu
        else
            input_params = {}
            input_params[:name] = @username
            object_list = @patient_controller.all_appointments(input_params)
            object_list.each {|instance|
            puts "ID: #{instance.id} | PHYSICIAN ID: #{instance.physician_id} | PHYSICIAN NAME: #{doctor_name(instance.physician_id)} | PATIENT ID: #{instance.patient_id} | DATE: #{instance.date} | TIME: #{instance.time} "}
            puts "---------------------------------------------------------------------------".green
        end
        menu
    end

    

    

    def get_menu_option
        welcome_back
        puts "--------------------------------------------------------".green
        puts "Please choose a number from one of the following options"
        puts "1. Make an appointment"
        puts "2. Reschedule an appointment"
        puts "3. Cancel an appointment"
        puts "4. List all of my appointments"
        puts "5. Exit"
        puts "--------------------------------------------------------".green
        input = gets.chomp
        if VALID_MENU_INPUTS.include?(input)
            return input
        else
            puts "Please enter a valid menu option."
            puts "---------------------------------".green
            menu
        end
    end

    def make_an_appointment
        if @patient_controller.read({name: @username})
            input_params = {}
            input_params[:date] = get_appointment_date
            input_params[:time] = get_appointment_time
            input_params[:physician_id] = get_appointment_physician
            input_params[:patient_id] = @patient_controller.read({name: @username}).id        
        else
            Patient.create(name: @username)
            input_params = {}
            input_params[:date] = get_appointment_date
            input_params[:time] = get_appointment_time
            input_params[:physician_id] = get_appointment_physician
            input_params[:patient_id] = @patient_controller.read({name: @username}).id     
        end

        if should_create_appointment
            @appointment_controller.create(input_params)
            puts "Appointment has been made"
            puts "-------------------------".green
            menu
        else 
            menu
    end
end
    
    def get_appointment_date
        puts "-----------------------------------------------------".green
        puts "What day would you like to schedule your appointment?"
        puts "Enter date input DD/MM/YYYY"
        return gets.chomp
    end

    
    def get_appointment_time
        puts "------------------------------------".green
        puts "What time would you like to be seen?"
        return gets.chomp
    end

    def requested_physician
        id = gets.chomp.to_i
        my_doc = Physician.find(id)
        return my_doc
    end
    
    def get_appointment_physician
        puts "--------------------------".green
        puts "Who would you like to see?"
        puts "Please choose by id"
        puts "--------------------------".green
        physician_list
        physician = requested_physician
        return physician.id
    end

    def should_create_appointment
        puts "-------------".green
        puts "Are you sure?"
        puts "1. Yes"
        puts "2. No"
        input = gets.chomp
        if !VALID_CONFIRM_INPUT.include?(input)
            should_create_appointment        
        elsif (input == YES_CONFIRM_INPUT) 
            return true
        else 
            return false
    end
end

    def doctor_name(id)
        return @physician_controller.id_read(id).name
    end

    def welcome_back
        username = @username
        if Patient.find_by(name: username)
            puts "WELCOME BACK TO SICKLY, #{username}!"
        else
            puts "WELCOME TO SICKLY!"
            
        end
    end


    def backdoor_input
        puts "(A)dd physician to database"
        puts "(R)emove physician from database"
        puts "(U)pdate physician name or specialty"
        puts "(L)ist all physicians"
        puts "(E)xit"
        input = gets.chomp.upcase
        if VALID_BACKDOOR_INPUTS.include?(input)
            return input
        else
            puts "Please enter a valid menu option."
            puts "---------------------------------".green
            backdoor_input
        end
    end


    def backdoor_menu_choice
    input = backdoor_input
    istrue = true
        while istrue
            case input
            when "A"
                add_doctor
                istrue = false
            when "R" 
                remove_doctor         
                istrue = false
            when "U"
                update_doctor
                istrue = false
            when "L"
                get_all_doctors
                istrue = false
            when "E"
                puts "Goodbye!"
                exit
            when "backdoor"
                puts "Hello Admin"
                puts "Something need doing?"
                backdoor_input
            end
        end
    end

    def get_all_doctors
        puts "------------------------------------------------------------------------------".green
        Physician.all.each{|instance|
        
        puts "ID: #{instance.id} | NAME: #{instance.name} | SPECIALTY: #{instance.specialty}"
        puts "------------------------------------------------------------------------------".green
    
    
    
    }
    
    end


    def remove_doctor
        puts "Which doctor would you like to fire?"
        puts "------------------------------------".green
        get_all_doctors
        input = gets.chomp.to_i
        @physician_controller.delete(input)
        puts "Long live the king!"
        backdoor_input
    end

    def specialty
        puts "What is their specialty?"
        return gets.chomp

    end



    def do_they_exist
        
        input = gets.chomp
        input_params = {}
        input_params[:name] = input
        if @physician_controller.read(input_params)
            puts "This person already exists"
            puts "--------------------------".green
            backdoor_input
        else
            return input
        end
    end



    def add_doctor
            "Please give the physician's name"
            input = do_they_exist 
            input_params = {}
            input_params[:name] = input
            input_params[:specialty] = specialty
            @physician_controller.create(input_params)
            puts "------------------------------------".green
            puts "Physician has been added to database"
            puts "------------------------------------".green
        
    end

    def update_doctor



    end
















end