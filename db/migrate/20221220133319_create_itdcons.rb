class CreateItdcons < ActiveRecord::Migration[7.0]
  def change
    create_table :itdcons do |t|
      t.references :empresa, null: true, foreign_key: true
      t.references :madurez, null: true, foreign_key: true
      t.references :alineamiento, null: true, foreign_key: true
      t.integer :p1
      t.integer :p2
      t.integer :p3
      t.integer :p4
      t.integer :p5
      t.integer :p6
      t.integer :p7
      t.integer :p8
      t.integer :p9
      t.integer :p10
      t.integer :p11
      t.integer :p12
      t.integer :p13
      t.integer :p14
      t.integer :p15
      t.integer :p16
      t.integer :p17
      t.integer :p18
      t.integer :p19
      t.integer :p20
      t.integer :p21
      t.integer :p22
      t.integer :p23
      t.integer :p24
      t.integer :p25
      t.integer :p26
      t.integer :p27
      t.integer :p28
      t.integer :p29
      t.integer :p30
      t.integer :p31
      t.integer :p32
      t.integer :p33
      t.integer :p34
      t.integer :p35
      t.integer :p36
      t.integer :p37
      t.integer :p38
      t.integer :p39
      t.integer :p40
      t.integer :p41
      t.integer :p42
      t.integer :p43
      t.integer :p44
      t.integer :p45
      t.integer :p46
      t.integer :p47
      t.integer :p48
      t.integer :p49
      t.integer :p50
      t.integer :p51
      t.integer :p52
      t.integer :p53
      t.integer :p54
      t.integer :p55
      t.integer :p56
      t.integer :p57
      t.integer :p58
      t.integer :p59
      t.integer :p60
      t.integer :p61
      t.integer :p62
      t.integer :p63
      t.integer :p64
      t.integer :p65
      t.integer :p66
      t.integer :p67
      t.integer :p68
      t.integer :p69
      t.integer :p70
      t.integer :p71
      t.integer :p72
      t.integer :p73
      t.integer :p74
      t.integer :p75
      t.integer :p76
      t.integer :p77
      t.integer :p78
      t.integer :p79
      t.integer :p80
      t.integer :p81
      t.integer :p82
      t.integer :p83
      t.integer :p84
      t.integer :p85
      t.integer :p86
      t.integer :p87
      t.integer :p88
      t.integer :p89
      t.integer :p90
      t.integer :p91

      t.timestamps
    end
  end
end
