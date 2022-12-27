# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_12_26_175444) do
  create_table "alineamientos", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "challenges"
    t.integer "min"
    t.integer "max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "aspiracions", force: :cascade do |t|
    t.float "maturity_score"
    t.float "alignment_score"
    t.integer "empresa_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "estrategico"
    t.integer "estructural"
    t.integer "humano"
    t.integer "relacional"
    t.integer "natural"
    t.integer "estrategia"
    t.integer "modelonegocio"
    t.integer "governance"
    t.integer "procesos"
    t.integer "tecnologia"
    t.integer "datosyanalitica"
    t.integer "modelooperativo"
    t.integer "propiedadintelectual"
    t.integer "personas"
    t.integer "ciclodevida"
    t.integer "estructura"
    t.integer "stakeholders"
    t.integer "marca"
    t.integer "clientes"
    t.integer "sustentabilidad"
    t.index ["empresa_id"], name: "index_aspiracions_on_empresa_id"
  end

  create_table "brechas", force: :cascade do |t|
    t.integer "empresa_id"
    t.integer "iniciativa_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["empresa_id"], name: "index_brechas_on_empresa_id"
    t.index ["iniciativa_id"], name: "index_brechas_on_iniciativa_id"
  end

  create_table "dats", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.float "ponderador"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.integer "elemento_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "min_description"
    t.string "max_description"
    t.string "identifier"
    t.string "verifier"
    t.index ["elemento_id"], name: "index_drivers_on_elemento_id"
  end

  create_table "elementos", force: :cascade do |t|
    t.string "name"
    t.integer "habilitador_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["habilitador_id"], name: "index_elementos_on_habilitador_id"
  end

  create_table "empresas", force: :cascade do |t|
    t.string "name"
    t.string "rut"
    t.string "sector"
    t.integer "income"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "habilitadors", force: :cascade do |t|
    t.string "name"
    t.integer "dat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["dat_id"], name: "index_habilitadors_on_dat_id"
  end

  create_table "iniciativas", force: :cascade do |t|
    t.string "name"
    t.integer "madurez_id"
    t.text "description"
    t.text "effort"
    t.text "benefict"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "driver_id"
    t.index ["driver_id"], name: "index_iniciativas_on_driver_id"
    t.index ["madurez_id"], name: "index_iniciativas_on_madurez_id"
  end

  create_table "itdcons", force: :cascade do |t|
    t.integer "empresa_id"
    t.integer "madurez_id"
    t.integer "alineamiento_id"
    t.integer "p1"
    t.integer "p2"
    t.integer "p3"
    t.integer "p4"
    t.integer "p5"
    t.integer "p6"
    t.integer "p7"
    t.integer "p8"
    t.integer "p9"
    t.integer "p10"
    t.integer "p11"
    t.integer "p12"
    t.integer "p13"
    t.integer "p14"
    t.integer "p15"
    t.integer "p16"
    t.integer "p17"
    t.integer "p18"
    t.integer "p19"
    t.integer "p20"
    t.integer "p21"
    t.integer "p22"
    t.integer "p23"
    t.integer "p24"
    t.integer "p25"
    t.integer "p26"
    t.integer "p27"
    t.integer "p28"
    t.integer "p29"
    t.integer "p30"
    t.integer "p31"
    t.integer "p32"
    t.integer "p33"
    t.integer "p34"
    t.integer "p35"
    t.integer "p36"
    t.integer "p37"
    t.integer "p38"
    t.integer "p39"
    t.integer "p40"
    t.integer "p41"
    t.integer "p42"
    t.integer "p43"
    t.integer "p44"
    t.integer "p45"
    t.integer "p46"
    t.integer "p47"
    t.integer "p48"
    t.integer "p49"
    t.integer "p50"
    t.integer "p51"
    t.integer "p52"
    t.integer "p53"
    t.integer "p54"
    t.integer "p55"
    t.integer "p56"
    t.integer "p57"
    t.integer "p58"
    t.integer "p59"
    t.integer "p60"
    t.integer "p61"
    t.integer "p62"
    t.integer "p63"
    t.integer "p64"
    t.integer "p65"
    t.integer "p66"
    t.integer "p67"
    t.integer "p68"
    t.integer "p69"
    t.integer "p70"
    t.integer "p71"
    t.integer "p72"
    t.integer "p73"
    t.integer "p74"
    t.integer "p75"
    t.integer "p76"
    t.integer "p77"
    t.integer "p78"
    t.integer "p79"
    t.integer "p80"
    t.integer "p81"
    t.integer "p82"
    t.integer "p83"
    t.integer "p84"
    t.integer "p85"
    t.integer "p86"
    t.integer "p87"
    t.integer "p88"
    t.integer "p89"
    t.integer "p90"
    t.integer "p91"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "maturity"
    t.float "alignment"
    t.index ["alineamiento_id"], name: "index_itdcons_on_alineamiento_id"
    t.index ["empresa_id"], name: "index_itdcons_on_empresa_id"
    t.index ["madurez_id"], name: "index_itdcons_on_madurez_id"
  end

  create_table "itdinds", force: :cascade do |t|
    t.integer "user_id"
    t.integer "madurez_id"
    t.integer "alineamiento_id"
    t.integer "p1"
    t.integer "p2"
    t.integer "p3"
    t.integer "p4"
    t.integer "p5"
    t.integer "p6"
    t.integer "p7"
    t.integer "p8"
    t.integer "p9"
    t.integer "p10"
    t.integer "p11"
    t.integer "p12"
    t.integer "p13"
    t.integer "p14"
    t.integer "p15"
    t.integer "p16"
    t.integer "p17"
    t.integer "p18"
    t.integer "p19"
    t.integer "p20"
    t.integer "p21"
    t.integer "p22"
    t.integer "p23"
    t.integer "p24"
    t.integer "p25"
    t.integer "p26"
    t.integer "p27"
    t.integer "p28"
    t.integer "p29"
    t.integer "p30"
    t.integer "p31"
    t.integer "p32"
    t.integer "p33"
    t.integer "p34"
    t.integer "p35"
    t.integer "p36"
    t.integer "p37"
    t.integer "p38"
    t.integer "p39"
    t.integer "p40"
    t.integer "p41"
    t.integer "p42"
    t.integer "p43"
    t.integer "p44"
    t.integer "p45"
    t.integer "p46"
    t.integer "p47"
    t.integer "p48"
    t.integer "p49"
    t.integer "p50"
    t.integer "p51"
    t.integer "p52"
    t.integer "p53"
    t.integer "p54"
    t.integer "p55"
    t.integer "p56"
    t.integer "p57"
    t.integer "p58"
    t.integer "p59"
    t.integer "p60"
    t.integer "p61"
    t.integer "p62"
    t.integer "p63"
    t.integer "p64"
    t.integer "p65"
    t.integer "p66"
    t.integer "p67"
    t.integer "p68"
    t.integer "p69"
    t.integer "p70"
    t.integer "p71"
    t.integer "p72"
    t.integer "p73"
    t.integer "p74"
    t.integer "p75"
    t.integer "p76"
    t.integer "p77"
    t.integer "p78"
    t.integer "p79"
    t.integer "p80"
    t.integer "p81"
    t.integer "p82"
    t.integer "p83"
    t.integer "p84"
    t.integer "p85"
    t.integer "p86"
    t.integer "p87"
    t.integer "p88"
    t.integer "p89"
    t.integer "p90"
    t.integer "p91"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "itdcon_id"
    t.index ["alineamiento_id"], name: "index_itdinds_on_alineamiento_id"
    t.index ["itdcon_id"], name: "index_itdinds_on_itdcon_id"
    t.index ["madurez_id"], name: "index_itdinds_on_madurez_id"
    t.index ["user_id"], name: "index_itdinds_on_user_id"
  end

  create_table "madurezs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "challenges"
    t.integer "min"
    t.integer "max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "lastname"
    t.binary "is_admin"
    t.integer "empresa_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["empresa_id"], name: "index_users_on_empresa_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "aspiracions", "empresas"
  add_foreign_key "brechas", "empresas"
  add_foreign_key "brechas", "iniciativas"
  add_foreign_key "drivers", "elementos"
  add_foreign_key "elementos", "habilitadors"
  add_foreign_key "habilitadors", "dats"
  add_foreign_key "iniciativas", "drivers"
  add_foreign_key "iniciativas", "madurezs"
  add_foreign_key "itdcons", "alineamientos"
  add_foreign_key "itdcons", "empresas"
  add_foreign_key "itdcons", "madurezs"
  add_foreign_key "itdinds", "alineamientos"
  add_foreign_key "itdinds", "itdcons"
  add_foreign_key "itdinds", "madurezs"
  add_foreign_key "itdinds", "users"
  add_foreign_key "users", "empresas"
end
