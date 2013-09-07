#!/usr/bin/ruby

require_relative '../lib/synchronizer.rb'


sousTitres=Synchronizer.new(ARGV[0], ARGV[1])
sousTitres.checkFiles
puts ">> #{sousTitres.fichier} ==> resynchronisation (#{sousTitres.decalage} secondes) ==> #{sousTitres.nouveau_fichier}" 
sousTitres.synchronize
puts ">>> resynchronisation terminee"


