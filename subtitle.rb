#!/usr/bin/ruby

#########################################################################################################################
#															#
#															#
#	Subtitle : 	Un super script home made pour resynchroniser les fichiers de sous titres 			#
#															#
#	Synopsis : 	subtitle.rb fichier decalage	      								#	
#												        		#
#       Principe :    	Cree un fichier.resynchronise dont les balises sont modifiees comme specifie par l'utilisateur	#
#			Le fichier originel n'est pas modifie								#
#															#
#########################################################################################################################



class Synchronizer
  
  attr_reader :fichier, :nouveauFichier, :decalage

  def initialize(fichier, decalage)
    @fichier = fichier
    @nouveauFichier = fichier.slice(0..(fichier.length-5)) +".resynchronise.srt"
    @decalage = decalage.to_f
  end

  def checkFiles
    #verification de @fichier
    puts "> #{@fichier} disponible a la lecture"
    #creation de @nouveauFichier vide, efface le précédent s'il existe
    puts "> initialisation de #{@nouveauFichier} terminee"
  end

  def readAndWrite(f, nf)
    f.each do |line|    
      if line =~ /\d\d:\d\d:\d\d,\d\d\d --> \d\d:\d\d:\d\d,\d\d\d/
        newLine = sync(line)
      else
        newLine = line
      end
     # puts "#{line} ==> #{newLine}"
      nf.write(newLine)
    end
  end

  def sync(line)
    cutedLine=line.split(" --> ")      # converti line, un string, en un array de type [balise tempo, balise tempo]
    cutedLine[0]=decal(cutedLine[0])   # decalage de la premiere balise temporelle
    cutedLine[1]=decal(cutedLine[1])   # decalage de la deuxieme balise temporelle
    newLine="#{cutedLine[0]} --> #{cutedLine[1]}\n"
  end
  
  def decal(balise)
    balise[","]="."
    a = balise.split(":")
    a[0] = a[0].to_i
    a[1] = a[1].to_i
    a[2] = a[2].to_f.round(3)
    a[2] += @decalage
    if @decalage >= 0
      while a[2]>= 60
        a[1]+=1
        a[2]-=60
      end
      else
        while a[2] < 0
          a[1]-=1
          a[2]+=60
        end
     end
    balise= "#{a[0]}:#{a[1]}:#{a[2].round(3)}"    # /!\ produit quelque chose comme 1:2:3,456 et non 01:02:03,456
    balise["."]=","                                           # Mais c'est pas genant \O/
    balise  
  end

  def synchronize
    f=File.open(@fichier)
    nf=File.open(@nouveauFichier, "a")
    readAndWrite(f, nf)
    f.close
    nf.close
  end

end




f=Synchronizer.new(ARGV[0], ARGV[1])
f.checkFiles
puts ">> #{f.fichier} ==> resynchronisation (#{f.decalage} secondes) ==> #{f.nouveauFichier}" 
f.synchronize
puts ">>> resynchronisation terminee"

