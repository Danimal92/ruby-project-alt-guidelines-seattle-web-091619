# The ActiveRecord model class for Patients.
# Allows basic CRUD operations and anything defined by ActiveRecord.
class Patient < ActiveRecord::Base
    has_many :appointments
    has_many :physicians, through: :appointments
end