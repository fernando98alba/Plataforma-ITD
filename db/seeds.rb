# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'spreadsheet'

Cuestionario.delete_all
Driver.delete_all
Elemento.delete_all
Habilitador.delete_all
Dat.delete_all
Alineamiento.delete_all
Madurez.delete_all

Spreadsheet.client_encoding = 'UTF-8'
book_ali = Spreadsheet.open("db/docs_seed/Alineamiento.xls")
alineamiento = book_ali.worksheet(0)
alineamiento.each 1 do |row|
  if row[0].nil?
    break
  end
  Alineamiento.create(name: row[0], description: row[1], min: row[2], max: row[3])
end
book_niv = Spreadsheet.open("db/docs_seed/Niveles.xls")
niveles = book_niv.worksheet(0)
niveles.each 1 do |row|
  if row[0].nil?
    break
  end
  Madurez.create(name: row[0], description: row[1], min: row[2], max: row[3])
end
book_des = Spreadsheet.open("db/docs_seed/Descripciones.xls")
des = book_des.worksheet(0)
descripciones = {}
des.each 1 do |row|
  if row[0].nil?
    break
  end
  descripciones[row[0]] = row[1]
end
book_mod = Spreadsheet.open("db/docs_seed/Modelo_ITD.xls")
modelo = book_mod.worksheet(0)
modelo.each 1 do |row|
  if row[0].nil?
    break
  end
  cap = Dat.find_by(name: row[0])
  if cap
    hab = Habilitador.find_by(name: row[1])
    if hab
      ele = Elemento.find_by(name: row[2])
      if ele
        dri = Driver.create(name: row[3], elemento_id: ele.id)
        pre = Cuestionario.create(driver_id: dri.id, verifier: row[6], min_description: row[4], max_description: row[5])
      else
        ele = Elemento.create(name: row[2], habilitador_id: hab.id)
        dri = Driver.create(name: row[3], elemento_id: ele.id)
        pre = Cuestionario.create(driver_id: dri.id, verifier: row[6], min_description: row[4], max_description: row[5])
      end
    else
      hab = Habilitador.create(name: row[1], dat_id: cap.id, description: descripciones[row[1]])
      ele = Elemento.create(name: row[2], habilitador_id: hab.id)
      dri = Driver.create(name: row[3], elemento_id: ele.id)
      pre = Cuestionario.create(driver_id: dri.id, verifier: row[6], min_description: row[4], max_description: row[5])
    end
  else
    cap = Dat.create(name: row[0], description: descripciones[row[1]])
    hab = Habilitador.create(name: row[1], dat_id: cap.id, description: descripciones[row[1]])
    ele = Elemento.create(name: row[2], habilitador_id: hab.id)
    dri = Driver.create(name: row[3], elemento_id: ele.id)
    pre = Cuestionario.create(driver_id: dri.id, verifier: row[6], min_description: row[4], max_description: row[5])
  end
end