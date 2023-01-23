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

ActiveRecord::Schema[7.0].define(version: 2023_01_13_210029) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "empresa_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "estrategico"
    t.integer "estructural"
    t.integer "humano"
    t.integer "relacional"
    t.integer "natural"
    t.integer "estrategia"
    t.integer "modelosdenegocios"
    t.integer "governance"
    t.integer "procesos"
    t.integer "tecnología"
    t.integer "datosyanalítica"
    t.integer "modelooperativo"
    t.integer "propiedadintelectual"
    t.integer "personas"
    t.integer "ciclodevidadelcolaborador"
    t.integer "estructuraorganizacional"
    t.integer "stakeholders"
    t.integer "marca"
    t.integer "clientes"
    t.integer "sustentabilidad"
    t.index ["empresa_id"], name: "index_aspiracions_on_empresa_id"
  end

  create_table "brechas", force: :cascade do |t|
    t.bigint "empresa_id"
    t.bigint "iniciativa_id"
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
    t.bigint "elemento_id"
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
    t.bigint "habilitador_id"
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
    t.bigint "dat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["dat_id"], name: "index_habilitadors_on_dat_id"
  end

  create_table "iniciativas", force: :cascade do |t|
    t.string "name"
    t.bigint "madurez_id"
    t.text "description"
    t.text "effort"
    t.text "benefict"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "driver_id"
    t.index ["driver_id"], name: "index_iniciativas_on_driver_id"
    t.index ["madurez_id"], name: "index_iniciativas_on_madurez_id"
  end

  create_table "itdcons", force: :cascade do |t|
    t.bigint "empresa_id"
    t.bigint "madurez_id"
    t.bigint "alineamiento_id"
    t.float "p1"
    t.float "p2"
    t.float "p3"
    t.float "p4"
    t.float "p5"
    t.float "p6"
    t.float "p7"
    t.float "p8"
    t.float "p9"
    t.float "p10"
    t.float "p11"
    t.float "p12"
    t.float "p13"
    t.float "p14"
    t.float "p15"
    t.float "p16"
    t.float "p17"
    t.float "p18"
    t.float "p19"
    t.float "p20"
    t.float "p21"
    t.float "p22"
    t.float "p23"
    t.float "p24"
    t.float "p25"
    t.float "p26"
    t.float "p27"
    t.float "p28"
    t.float "p29"
    t.float "p30"
    t.float "p31"
    t.float "p32"
    t.float "p33"
    t.float "p34"
    t.float "p35"
    t.float "p36"
    t.float "p37"
    t.float "p38"
    t.float "p39"
    t.float "p40"
    t.float "p41"
    t.float "p42"
    t.float "p43"
    t.float "p44"
    t.float "p45"
    t.float "p46"
    t.float "p47"
    t.float "p48"
    t.float "p49"
    t.float "p50"
    t.float "p51"
    t.float "p52"
    t.float "p53"
    t.float "p54"
    t.float "p55"
    t.float "p56"
    t.float "p57"
    t.float "p58"
    t.float "p59"
    t.float "p60"
    t.float "p61"
    t.float "p62"
    t.float "p63"
    t.float "p64"
    t.float "p65"
    t.float "p66"
    t.float "p67"
    t.float "p68"
    t.float "p69"
    t.float "p70"
    t.float "p71"
    t.float "p72"
    t.float "p73"
    t.float "p74"
    t.float "p75"
    t.float "p76"
    t.float "p77"
    t.float "p78"
    t.float "p79"
    t.float "p80"
    t.float "p81"
    t.float "p82"
    t.float "p83"
    t.float "p84"
    t.float "p85"
    t.float "p86"
    t.float "p87"
    t.float "p88"
    t.float "p89"
    t.float "p90"
    t.float "p91"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "maturity_score"
    t.float "alignment_score"
    t.boolean "completed", default: false
    t.index ["alineamiento_id"], name: "index_itdcons_on_alineamiento_id"
    t.index ["empresa_id"], name: "index_itdcons_on_empresa_id"
    t.index ["madurez_id"], name: "index_itdcons_on_madurez_id"
  end

  create_table "itdinds", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "madurez_id"
    t.bigint "alineamiento_id"
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
    t.bigint "itdcon_id"
    t.float "maturity_score"
    t.float "alignment_score"
    t.boolean "completed", default: false
    t.index ["alineamiento_id"], name: "index_itdinds_on_alineamiento_id"
    t.index ["itdcon_id"], name: "index_itdinds_on_itdcon_id"
    t.index ["madurez_id"], name: "index_itdinds_on_madurez_id"
    t.index ["user_id"], name: "index_itdinds_on_user_id"
  end

  create_table "itdsins", force: :cascade do |t|
    t.bigint "madurez_id"
    t.bigint "alineamiento_id"
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
    t.float "maturity_score"
    t.float "alignment_score"
    t.index ["alineamiento_id"], name: "index_itdsins_on_alineamiento_id"
    t.index ["madurez_id"], name: "index_itdsins_on_madurez_id"
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
    t.bigint "empresa_id"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["empresa_id"], name: "index_users_on_empresa_id"
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "verificadors", force: :cascade do |t|
    t.text "p1"
    t.text "p2"
    t.text "p3"
    t.text "p4"
    t.text "p5"
    t.text "p6"
    t.text "p7"
    t.text "p8"
    t.text "p9"
    t.text "p10"
    t.text "p11"
    t.text "p12"
    t.text "p13"
    t.text "p14"
    t.text "p15"
    t.text "p16"
    t.text "p17"
    t.text "p18"
    t.text "p19"
    t.text "p20"
    t.text "p21"
    t.text "p22"
    t.text "p23"
    t.text "p24"
    t.text "p25"
    t.text "p26"
    t.text "p27"
    t.text "p28"
    t.text "p29"
    t.text "p30"
    t.text "p31"
    t.text "p32"
    t.text "p33"
    t.text "p34"
    t.text "p35"
    t.text "p36"
    t.text "p37"
    t.text "p38"
    t.text "p39"
    t.text "p40"
    t.text "p41"
    t.text "p42"
    t.text "p43"
    t.text "p44"
    t.text "p45"
    t.text "p46"
    t.text "p47"
    t.text "p48"
    t.text "p49"
    t.text "p50"
    t.text "p51"
    t.text "p52"
    t.text "p53"
    t.text "p54"
    t.text "p55"
    t.text "p56"
    t.text "p57"
    t.text "p58"
    t.text "p59"
    t.text "p60"
    t.text "p61"
    t.text "p62"
    t.text "p63"
    t.text "p64"
    t.text "p65"
    t.text "p66"
    t.text "p67"
    t.text "p68"
    t.text "p69"
    t.text "p70"
    t.text "p71"
    t.text "p72"
    t.text "p73"
    t.text "p74"
    t.text "p75"
    t.text "p76"
    t.text "p77"
    t.text "p78"
    t.text "p79"
    t.text "p80"
    t.text "p81"
    t.text "p82"
    t.text "p83"
    t.text "p84"
    t.text "p85"
    t.text "p86"
    t.text "p87"
    t.text "p88"
    t.text "p89"
    t.text "p90"
    t.text "p91"
    t.bigint "itdind_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["itdind_id"], name: "index_verificadors_on_itdind_id"
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
  add_foreign_key "itdsins", "alineamientos"
  add_foreign_key "itdsins", "madurezs"
  add_foreign_key "users", "empresas"
  add_foreign_key "verificadors", "itdinds"
end
