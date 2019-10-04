class AppointmentController
    def create(input_params)
        Appointment.create(input_params)
    end

    def read(input_params)
        Appointment.find_by(name: input_params[:name])
    end

    def update(id,input_params)
       Appointment.update(id,input_params)
    end

    def delete(input_params)
        Appointment.delete(input_params)

    end
end