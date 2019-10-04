# The ActiveRecord model class for Appointments.
# Allows basic CRUD operations and anything defined by ActiveRecord.
class Appointment < ActiveRecord::Base
    belongs_to :physician
    belongs_to :patient
end
