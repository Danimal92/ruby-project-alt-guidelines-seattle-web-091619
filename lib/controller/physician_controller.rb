class PhysicianController

    # create
    def create(input_params)
        Physician.create(input_params)
    end

    # read
    def read(input_params)
        Physician.find_by(name: input_params[:name])
    end

    def id_read(input_params)
        Physician.find(input_params)

    end

    # update
    def update(input_params)
    end

    # delete
    def delete(input_params)
        Physician.delete(input_params)

    end

end