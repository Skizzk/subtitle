#!/usr/bin/ruby

sousTitres=Synchronizer.new(ARGV[0], ARGV[1])
sousTitre.checkFiles
puts ">> #{sousTitres.fichier} ==> resynchronisation (#{sousTitres.decalage} secondes) ==> #{sousTitres.nouveauFichier}" 
sousTitres.synchronize
puts ">>> resynchronisation terminee"


