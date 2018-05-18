require 'pincers'

pincers = Pincers.for_webdriver :chrome

  pincers.goto 'https://chileautos.cl/autos/busqueda?q=%28And.Tipo.Usado._.TipoVeh%C3%ADculo.Autos%2C%20camionetas%20y%204x4._.Regi%C3%B3n.Metropolitana%20de%20Santiago._.%28C.Marca.Toyota._.Modelo.YARIS.%29_.Ano.range%282011..2018%29._.Precio.range%284000000..12000000%29._.Carroceria.sed%C3%A1n.%29'

  arr_price = []
  pincers.search('.listing-item__price').map do |div|
    arr_price.push(div.search(tag: 'p').text) # div is also a contex!
  end

  arr_title = []
  pincers.search('.listing-item__header').map do |div|
    arr_title.push(div.search(tag: 'a').search('.listing-item__title').text.split(' ')[0])
  end


  average_prices_per_year = {}
  (2011..2018).each do |i|
    puts("Haciendo el arreglo con los indices que contien el año #{i}")

    arr_index=[]
    arr_title.each_with_index do |title, index|

      if title == i.to_s
        arr_index.push(index)
      end

    end

    puts("Calculado el promedio del año #{i}")
    sum = 0
    arr_index.each do |i|
      puts("El arreglo es #{arr_index} y el indice es #{i}")
      sum = sum + arr_price[i.to_i].gsub("$ ","").gsub(".","").to_f
      puts("la suma va en #{sum} ")
    end

    puts("Agregando el resultado al hash")
    prom = 0
    if not arr_index.size == 0
      prom=sum/arr_index.size
      average_prices_per_year[i] = prom
    end

  end


  puts("Completó el proceso")
  # arr_price.size.times do |i|
  #   puts(arr_price[i].gsub("$ ","").gsub(".","").to_i)
  # end
  # arr_title.size.times do |i|
  #   puts(arr_title[i])
  # end

  average_prices_per_year.each { |year, value| puts("El precio promedio del toyota Yaris de #{year} es: $#{value}")}

pincers.close # release webdriver resources
