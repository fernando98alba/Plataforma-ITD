# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'spreadsheet'

Spreadsheet.client_encoding = 'UTF-8'
book_ali = Spreadsheet.open("db/docs_seed/Alineamiento.xls")
alineamiento = book_ali.worksheet(0)
alineamiento.each 1 do |row|
  if row[0].nil?
    break
  end
  alineamiento = Alineamiento.find_by(name: row[0])
  if alineamiento
    if alineamiento.description != row[1]
      alineamiento.update({description: row[1]})
    end
    if alineamiento.min != row[2]
      alineamiento.update({min: row[3]})
    end
    if alineamiento.max != row[3]
      alineamiento.update({max: row[3]})
    end
  else
    Alineamiento.create(name: row[0], description: row[1], min: row[2], max: row[3])
  end
end
book_niv = Spreadsheet.open("db/docs_seed/Niveles.xls")
niveles = book_niv.worksheet(0)
niveles.each 1 do |row|
  if row[0].nil?
    break
  end
  madurez = Madurez.find_by(name: row[0])
  if madurez
    if madurez.description != row[1]
      madurez.update({description: row[1]})
    end
    if madurez.min != row[2]
      madurez.update({min: row[3]})
    end
    if madurez.max != row[3]
      madurez.update({max: row[3]})
    end
  else
    Madurez.create(name: row[0], description: row[1], min: row[2], max: row[3])
  end
end
book_des = Spreadsheet.open("db/docs_seed/Descripciones.xls")
des = book_des.worksheet(0)
descripciones = {}
ponderadores = {}
des.each 1 do |row|
  if row[0].nil?
    break
  end
  descripciones[row[0]] = row[1]
  ponderadores[row[0]] = row[2]
end
book_mod = Spreadsheet.open("db/docs_seed/Modelo_ITD.xls")
modelo = book_mod.worksheet(0)
index = 1
modelo.each 1 do |row|
  if row[0].nil?
    break
  end
  cap = Dat.find_by(name: row[0])
  if cap
    hab = Habilitador.find_by(name: row[1])
    if hab
      ele = Elemento.find_by(name: row[2], habilitador_id: hab.id)
      if ele
        dri = Driver.find_by(name: row[3], elemento_id: ele.id)
        if dri
          if dri.min_description != row[4]
            dri.update({min_description: row[4]})
          end
          if dri.max_description != row[5]
            dri.update({max_description: row[5]})
          end
        else
          dri = Driver.create(name: row[3], elemento_id: ele.id, min_description: row[4], max_description: row[5], identifier: "p" + index.to_s)
        end
      else
        ele = Elemento.create(name: row[2], habilitador_id: hab.id)
        dri = Driver.create(name: row[3], elemento_id: ele.id, min_description: row[4], max_description: row[5], identifier: "p" + index.to_s)
      end
    else
      hab = Habilitador.create(name: row[1], dat_id: cap.id, description: descripciones[row[1]])
      ele = Elemento.create(name: row[2], habilitador_id: hab.id)
      dri = Driver.create(name: row[3], elemento_id: ele.id, min_description: row[4], max_description: row[5], identifier: "p" + index.to_s)
    end
  else
    cap = Dat.create(name: row[0], description: descripciones[row[0]], ponderador: ponderadores[row[0]])
    hab = Habilitador.create(name: row[1], dat_id: cap.id, description: descripciones[row[1]])
    ele = Elemento.create(name: row[2], habilitador_id: hab.id)
    dri = Driver.create(name: row[3], elemento_id: ele.id, min_description: row[4], max_description: row[5], identifier: "p" + index.to_s)
  end
  index +=1
end
book_mod = Spreadsheet.open("db/docs_seed/Verificadores.xls")
verificadores = book_mod.worksheet(0)
index = 1
verificadores.each 1 do |row|
  hab = Habilitador.find_by(name: row[1])
  if hab
    ele = Elemento.find_by(name: row[2], habilitador_id: hab.id)
    if ele
      dri = Driver.find_by(name: row[3], elemento_id: ele.id)
      if !dri
        puts "dri"
        puts row
        puts "\n"
      else
        ver = Verificador.find_by(name: row[4], driver_id: dri.id)
        if !ver
          ver = Verificador.create(name: row[4], driver_id: dri.id)
        end
      end
    else
      puts "ele"
      puts row
      puts "\n"
    end
  else
    puts "hab"
    puts row
    puts "\n"
  end
end