class CreateAppointments < ActiveRecord::Migration[5.2]
def change
create_table :appointments do |t|
    t.belongs_to :physician
    t.belongs_to :patient
    t.date :date
    t.time :time
    t.timestamps
    end
end
end

