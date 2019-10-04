class PatientController

    # create
    def create(input_params)
        Patient.create(input_params)
    end

    # read
    def read(input_params)
        return Patient.find_by(name: input_params[:name])
    end

    def all_appointments(input_params)
        Patient.find_by(name: input_params[:name]).appointments
    end

    # update
    def update(input_params)
        
    end

    # delete
    def delete(input_params)

    end

end