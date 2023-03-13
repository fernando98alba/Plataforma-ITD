class CreateItdcons < ActiveRecord::Migration[7.0]
  def change
    create_table :itdcons do |t|
      t.references :empresa, null: true, foreign_key: {on_delete: :cascade}
      t.references :madurez, null: true, foreign_key: true
      t.references :alineamiento, null: true, foreign_key: true
      t.float :p1
      t.float :p2
      t.float :p3
      t.float :p4
      t.float :p5
      t.float :p6
      t.float :p7
      t.float :p8
      t.float :p9
      t.float :p10
      t.float :p11
      t.float :p12
      t.float :p13
      t.float :p14
      t.float :p15
      t.float :p16
      t.float :p17
      t.float :p18
      t.float :p19
      t.float :p20
      t.float :p21
      t.float :p22
      t.float :p23
      t.float :p24
      t.float :p25
      t.float :p26
      t.float :p27
      t.float :p28
      t.float :p29
      t.float :p30
      t.float :p31
      t.float :p32
      t.float :p33
      t.float :p34
      t.float :p35
      t.float :p36
      t.float :p37
      t.float :p38
      t.float :p39
      t.float :p40
      t.float :p41
      t.float :p42
      t.float :p43
      t.float :p44
      t.float :p45
      t.float :p46
      t.float :p47
      t.float :p48
      t.float :p49
      t.float :p50
      t.float :p51
      t.float :p52
      t.float :p53
      t.float :p54
      t.float :p55
      t.float :p56
      t.float :p57
      t.float :p58
      t.float :p59
      t.float :p60
      t.float :p61
      t.float :p62
      t.float :p63
      t.float :p64
      t.float :p65
      t.float :p66
      t.float :p67
      t.float :p68
      t.float :p69
      t.float :p70
      t.float :p71
      t.float :p72
      t.float :p73
      t.float :p74
      t.float :p75
      t.float :p76
      t.float :p77
      t.float :p78
      t.float :p79
      t.float :p80
      t.float :p81
      t.float :p82
      t.float :p83
      t.float :p84
      t.float :p85
      t.float :p86
      t.float :p87
      t.float :p88
      t.float :p89
      t.float :p90
      t.float :p91

      t.timestamps
    end
  end
end
