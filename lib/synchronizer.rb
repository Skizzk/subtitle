#!/usr/bin/ruby


class Synchronizer

  attr_reader :fichier, :nouveau_fichier, :decalage

  def initialize(fichier, decalage)
    @fichier = fichier
    @nouveau_fichier = fichier.slice(0..(fichier.length-5)) +".resynchronise.srt"
    @decalage = decalage.to_f
  end

  def checkFiles
    #verification de @fichier
    puts "> #{@fichier} disponible a la lecture"
    #creation de @nouveau_fichier vide, efface le précédent s'il existe
    puts "> initialisation de #{@nouveau_fichier} terminee"
  end

  def read_and_write(fichier, nouveau_fichier)
    fichier.each do |line|    
      if line =~ /\d\d:\d\d:\d\d,\d\d\d --> \d\d:\d\d:\d\d,\d\d\d/
        new_line = sync(line)
      else
        new_line = line
      end
      puts "#{line} ==> #{new_line}"
      nouveau_fichier.write(new_line)
    end
  end

  def sync(line)
    cuted_line=line.split(" --> ")      # converti line, un string, en un array de type [balise tempo, balise tempo]
    cuted_line[0]=decal(cuted_line[0])   # decalage de la premiere balise temporelle
    cuted_line[1]=decal(cuted_line[1])   # decalage de la deuxieme balise temporelle
    new_line="#{cuted_line[0]} --> #{cuted_line[1]}\n"
  end

  def decal(balise)
    balise[","]="."
    time = balise.split(":")
    time[0] = time[0].to_i
    time[1] = time[1].to_i
    time[2] = time[2].to_f.round(3)
    time[2] += @decalage
    if @decalage >= 0
      then
      while time[2]>= 60
        time[1]+=1
        time[2]-=60
      end
    else
      while time[2]<0
        time[1]-=1
        time[2]+=60
      end
      balise= "#{time[0]}:#{time[1]}:#{time[2].round(3)}"    # /!\ produit quelque chose comme 1:2:3,456 et non 01:02:03,456
      balise["."]=","
      balise  
    end
  end

  def synchronize
    f=File.open(@fichier)
    nf=File.open(@nouveau_fichier, "a")
    read_and_write(f, nf)
    f.close
    nf.close
  end

end
